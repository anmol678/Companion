//
//  HealthKitSetupAssistant.swift
//  Companion
//
//  Created by Anmol Jain on 10/7/22.
//

import Foundation
import HealthKit

class HealthKitSetupAssistant {
  
  private enum HealthKitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
      
      guard HKHealthStore.isHealthDataAvailable() else {
        completion(false, HealthKitSetupError.notAvailableOnDevice)
        return
      }
      
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
          
              completion(false, HealthKitSetupError.dataTypeNotAvailable)
              return
      }
      
      let toWrite: Set<HKSampleType> = [bodyMass]
      
      let toRead: Set<HKObjectType> = [dateOfBirth,
                                       biologicalSex,
                                       bodyMassIndex,
                                       height,
                                       bodyMass,
                                       stepCount,
                                       distanceWalkingRunning,
                                       heartRate,
                                       restingHeartRate,
                                       sleepAnalysis
                                      ]
      
      //4. Request Authorization
      HKHealthStore().requestAuthorization(toShare: toWrite, read: toRead, completion: {
          (success, error) in
        completion(success, error)
      })
    }
}
