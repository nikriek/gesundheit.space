//
//  HealthService.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 25.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import HealthKit
import RxSwift

class HealthService {
    static let shared = HealthService(healthKitStore: HKHealthStore())
    
    let healthKitStore: HKHealthStore

    let healthKitTypesToRead = Set(arrayLiteral:
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    )
    
    init(healthKitStore: HKHealthStore) {
        self.healthKitStore = healthKitStore
    }
    
    func authorize() -> Observable<Void> {
        return Observable.create { observer in
            guard HKHealthStore.isHealthDataAvailable() else {
                let error = NSError(domain: AppDomain, code: 2, userInfo: [NSLocalizedDescriptionKey:"The Health app is not available on this Device"])
                observer.onError(error)
                observer.onCompleted()
                
                return Disposables.create()
            }
            
            self.healthKitStore.requestAuthorization(toShare: nil, read: self.healthKitTypesToRead, completion: { success, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext()
                }
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
    
    var dateOfBirthComponents: Observable<DateComponents> {
        do {
            let dateOfBirthComponents = try healthKitStore.dateOfBirthComponents()
            return Observable.just(dateOfBirthComponents)
        } catch let error {
            return Observable.error(error)
        }
    }
    
    var bloodType: Observable<HKBloodType> {
        do {
            let bloodType = try healthKitStore.bloodType()
            return Observable.just(bloodType.bloodType)
        } catch let error {
            return Observable.error(error)
        }
    }
    
    var biologicalSex: Observable<HKBiologicalSex> {
        do {
            let sex = try healthKitStore.biologicalSex()
            return Observable.just(sex.biologicalSex)
        } catch let error {
            return Observable.error(error)
        }
    }
    
    func fetchHeartRate(from startDate: Date, to endDate: Date, ascending: Bool) -> Observable<[HKQuantitySample]> {
        //let unit = HKUnit(from: "count/min")
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let heartSampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: ascending)]
        
        return Observable.create { [weak self] observer in
            let query = HKSampleQuery(sampleType: heartSampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: sortDescriptors) { (query, samples, error) in
                if let error = error {
                    observer.on(.error(error))
                } else if let samples = samples as? [HKQuantitySample]  {
                    observer.on(.next(samples))
                    // TODO: Interpret empty list as authorization error?
                }
                observer.on(.completed)
            }
            
            self?.healthKitStore.execute(query)
            
            // TODO: Retain cycle possible?
            return Disposables.create { [weak self] in
                self?.healthKitStore.stop(query)
            }
        }
    }
}
