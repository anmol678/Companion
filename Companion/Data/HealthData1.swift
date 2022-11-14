//
//  HealthData1.swift
//  Companion
//
//  Created by Shikha Charadva on 11/10/22.
//

import Foundation
import HealthKit

private let healthStore1 = HKHealthStore()
private let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

func importStepsHistory() {

    
    let now = Date()
    let startDate = Calendar.current.date(byAdding: .day, value: -30, to: now)!

    var interval = DateComponents()
    interval.day = 1

    var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: now)
    anchorComponents.hour = 0
    let anchorDate = Calendar.current.date(from: anchorComponents)!

    let query = HKStatisticsCollectionQuery(
        quantityType: stepsQuantityType,
        quantitySamplePredicate: nil,
        options: [.cumulativeSum],
        anchorDate: anchorDate,
        intervalComponents: interval
    )
    query.initialResultsHandler = { _, results, error in
        guard let results = results else {
            //log.error("Error returned form resultHandler = \(String(describing: error?.localizedDescription))")
            return
        }
    
        results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
            if let sum = statistics.sumQuantity() {
                let steps = sum.doubleValue(for: HKUnit.count())
                print("Amount of steps: \(steps), date: \(statistics.startDate)")
            }
        }
    }

    healthStore1.execute(query)
}
