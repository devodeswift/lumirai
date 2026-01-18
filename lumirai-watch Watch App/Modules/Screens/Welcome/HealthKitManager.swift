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

    // MARK: - Quantity Types

    private let hrvType =
        HKQuantityType.quantityType(
            forIdentifier: .heartRateVariabilitySDNN
        )!

    private let heartRateType =
        HKQuantityType.quantityType(
            forIdentifier: .heartRate
        )!

    private let breathingRateType =
        HKQuantityType.quantityType(
            forIdentifier: .respiratoryRate
        )!

    // MARK: - Authorization

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

        let readTypes: Set<HKObjectType> = [
            hrvType,
            heartRateType,
            breathingRateType
        ]

        healthStore.requestAuthorization(
            toShare: [],
            read: readTypes
        ) { success, _ in
            completion(success)
        }
    }

    // MARK: - HRV (SDNN)

    func fetchLatestHRV(completion: @escaping (Double?) -> Void) {
        fetchLatestQuantity(
            type: hrvType,
            unit: .secondUnit(with: .milli),
            hoursBack: 24,
            completion: completion
        )
    }

    // MARK: - Heart Rate (BPM)

    func fetchLatestHeartRate(completion: @escaping (Double?) -> Void) {
        fetchLatestQuantity(
            type: heartRateType,
            unit: HKUnit(from: "count/min"),
            hoursBack: 24,
            completion: completion
        )
    }

    // MARK: - Breathing Rate (Breaths / Min)

    func fetchLatestBreathingRate(completion: @escaping (Double?) -> Void) {
        fetchLatestQuantity(
            type: breathingRateType,
            unit: HKUnit.count().unitDivided(by: .minute()),
            hoursBack: 24,
            completion: completion
        )
    }

    // MARK: - Shared Fetch Helper

    private func fetchLatestQuantity(
        type: HKQuantityType,
        unit: HKUnit,
        hoursBack: Int,
        completion: @escaping (Double?) -> Void
    ) {
        let end = Date()
        let start = Calendar.current.date(
            byAdding: .hour,
            value: -hoursBack,
            to: end
        )!

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
            sampleType: type,
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

            let value = sample.quantity.doubleValue(for: unit)
            completion(value)
        }

        healthStore.execute(query)
    }
}
