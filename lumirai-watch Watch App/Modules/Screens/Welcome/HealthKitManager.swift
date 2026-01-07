//
//  HealthKitManager.swift
//  lumirai-watch Watch App
//
//  Created by dana nur fiqi on 06/01/26.
//

import Foundation
import HealthKit

final class HealthKitManager {

    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()

    private let hrvType =
        HKQuantityType.quantityType(
            forIdentifier: .heartRateVariabilitySDNN
        )!

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

        healthStore.requestAuthorization(
            toShare: [],
            read: [hrvType]
        ) { success, _ in
            completion(success)
        }
    }

    func fetchLatestHRV(completion: @escaping (Double?) -> Void) {
        let end = Date()
        let start = Calendar.current.date(byAdding: .hour, value: -12, to: end)!

        let predicate = HKQuery.predicateForSamples(
            withStart: start,
            end: end,
            options: .strictEndDate
        )

        let sort = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: false
        )

        let query = HKSampleQuery(
            sampleType: hrvType,
            predicate: predicate,
            limit: 1,
            sortDescriptors: [sort]
        ) { _, samples, error in

            guard
                error == nil,
                let sample = samples?.first as? HKQuantitySample
            else {
                completion(nil)
                return
            }

            let value = sample.quantity.doubleValue(
                for: .secondUnit(with: .milli)
            )

            completion(value)
        }

        healthStore.execute(query)
    }
}
