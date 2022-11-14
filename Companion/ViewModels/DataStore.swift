//
//  DataStore.swift
//  Companion
//
//  Created by Anmol Jain on 10/7/22.
//

import Foundation
import HealthKit
import SwiftUI

final class DataStore: ObservableObject {
    static let healthStore: HKHealthStore = HKHealthStore()
    
    // MARK: - Data Types
    
    static var readDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    static var shareDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    private static var allHealthDataTypes: [HKSampleType] {
        let typeIdentifiers: [String] = [
            HKQuantityTypeIdentifier.stepCount.rawValue,
            HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue,
            HKQuantityTypeIdentifier.sixMinuteWalkTestDistance.rawValue
        ]
        
        return typeIdentifiers.compactMap { getSampleType(for: $0) }
    }
    
    @Published var tab: Int = 0
    
    @Published var age: String = ""
    @Published var sex: String = ""
    @Published var bp: String = ""
    @Published var chol: String = ""
    
    @Published var name: String = ""
    
    @Published var presentAlert: Bool = false
    @Published var recommendation: String = ""
    
    func authorizeHealthKit() {
        
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            self.readData()
            
        }
    }
        
    func readData() {
        var age : Int?
        var sex : HKBiologicalSex?
        var sexData : String = "Not Retrived"
        
        do {
            let birthDay = try DataStore.healthStore.dateOfBirthComponents()
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date() )
            age = currentYear - birthDay.year!
        } catch {
            
        }
        
        do {
            let getSex = try DataStore.healthStore.biologicalSex()
            sex = getSex.biologicalSex
            if let data = sex {
                sexData = getReadableBiologicalSex(biologicalSex: data)
            }
        } catch {
            
        }
        
        DispatchQueue.main.async {
            self.age = String(age ?? 0)
            self.sex = sexData
            
            self.tab = 1
//            print("Age: \(self.age)")
//            print("Sex: \(self.sex)")
        }
    }
        
    func getReadableBiologicalSex(biologicalSex: HKBiologicalSex?) -> String {
        var biologicalSexTest = "Not Retrived"
        
        if biologicalSex != nil {
            switch biologicalSex!.rawValue {
            case 0:
                biologicalSexTest = ""
            case 1:
                biologicalSexTest = "Female"
            case 2:
                biologicalSexTest = "Male"
            case 3:
                biologicalSexTest = "Other"
            default:
                biologicalSexTest = ""
            }
        }
        
        return biologicalSexTest
    }
        
    func giveRecommendation() {
        let model = heartModel()
        
        do {
            let prediction = try model.prediction(
                age: NumberFormatter().number(from: self.age)?.doubleValue ?? 0,
                sex: self.getBinaryG(),
                BP: NumberFormatter().number(from: self.bp)?.doubleValue ?? 0,
                cholestrol: NumberFormatter().number(from: self.chol)?.doubleValue ?? 0
            )
        
            self.recommendation = prediction.heart_disease == 0 ? "Everything is ok" : "Visit the doctor"
        } catch {
            self.recommendation = "Error"
        }
        
        self.presentAlert = true
    }
    
    func getBinaryG() -> Double {
        let s = self.sex.lowercased().trimmingCharacters(in: .whitespaces)
        
        switch s {
        case "female":
            return 0.0
        case "male":
            return 1.0
        default:
            return 2.0
        }
    }
        
    //    func printStepCount() {
    //
    //        getStepCount { [self] stepCount in
    //            self.steps = stepCount
    //            print(stepCount)
    //        }
    //    }
        
        
    func getStepCount(completion: @escaping (Double) -> Void) {
        
        let healthStore = HKHealthStore()
        
        guard let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount)
        else {
            print("Step count is not available")
            return
        }
        
        let now = Date()
        //        guard let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        //        else {
        //            print("date error")
        //            return
        //        }
        
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepCount,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            DispatchQueue.main.async {
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(0.0)
                    return
                }
                completion(sum.doubleValue(for: HKUnit.count()))
            }
        }
        
        healthStore.execute(query)
    }
    
    func readHealthKitData() {
        
        guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
              let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
              let height = HKObjectType.quantityType(forIdentifier: .height),
              let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
              let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
              let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
              let restingHeartRate = HKObjectType.quantityType(forIdentifier: .restingHeartRate),
              let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
        else {
            print("Health data is no longer available.")
            return
        }
        
        getHealthDataSample(for: stepCount) { (sample, error) in
            
            guard let sample = sample
            else {
                
                if let error = error {
                    print(error)
                }
                
                return
            }
            
            let steps = sample.quantity.doubleValue(for: HKUnit.count())
            print(steps)
        }
    }
    
    func getHealthDataSample(for sampleType: HKSampleType, completion: @escaping (HKQuantitySample?, Error?) -> Void) {
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        
        let limit = 1
        
        let sampleQuery = HKSampleQuery(
            sampleType: sampleType,
            predicate: mostRecentPredicate,
            limit: limit,
            sortDescriptors: [sortDescriptor]
        ) { (query, samples, error) in
            
            DispatchQueue.main.async {
                guard let samples = samples,
                      let latestSample = samples.first as? HKQuantitySample
                else {
                    completion(nil, error)
                    return
                }
                
                completion(latestSample, nil)
            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
}
