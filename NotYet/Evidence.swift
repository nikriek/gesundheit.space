//
//  Evidence.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import Foundation

final class Evidence: ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: Int
    var measurementName: String
    var measurementValue: Double
    var cohortMeasurementValue: Double
    var url: String?
    
    required init?(response: HTTPURLResponse, representation: Any) {
        guard let representation = representation as? [String: Any],
            let id = representation["id"] as? Int,
            let measurementName = representation["measurement_name"] as? String,
            let measurementValue = representation["measurement_value"] as? Double,
            let cohortMeasurementValue = representation["cohort_measurement_value"] as? Double else {
                return nil
        }
        self.id = id
        self.measurementName = measurementName
        self.measurementValue = measurementValue
        self.cohortMeasurementValue = cohortMeasurementValue
        self.url = representation["url"] as? String
    }
}
