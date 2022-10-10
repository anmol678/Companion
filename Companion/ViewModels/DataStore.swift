//
//  DataStore.swift
//  Companion
//
//  Created by Anmol Jain on 10/7/22.
//

import Foundation
import HealthKit

final class DataStore: ObservableObject {
    
    @Published var steps: Double = 0.0
    
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
        
        print("HealthKit Successfully Authorized.")
      }
      
    }
    
    func printStepCount() {
        
        getStepCount { [self] stepCount in
            self.steps = stepCount
            print(stepCount)
        }
    }
        
    
    private func getStepCount(completion: @escaping (Double) -> Void) {
        
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
        
//        let startOfDay = Calendar.current.startOfDay(for: lastWeek)
        
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
    
    private func getHealthDataSample(for sampleType: HKSampleType, completion: @escaping (HKQuantitySample?, Error?) -> Void) {
      
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
