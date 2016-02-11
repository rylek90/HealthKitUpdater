//
//  HealthKitEntitlementsProvider.swift
//  HealthKitUpdater
//
//  Created by Maciek Rylko on 16.01.2016.
//  Copyright © 2016 Maciek Rylko. All rights reserved.
//

import HealthKit

class HealthKitEntitlementsProvider {
    
    
//    @available(iOS 8.0, *)
//    public let HKQuantityTypeIdentifierBodyMassIndex: String // Scalar(Count),               Discrete
//    @available(iOS 8.0, *)
//    public let HKQuantityTypeIdentifierBodyFatPercentage: String // Scalar(Percent, 0.0 - 1.0),  Discrete
//    @available(iOS 8.0, *)
//    public let HKQuantityTypeIdentifierBodyMass: String // Mass,                        Discrete
//    @available(iOS 8.0, *)
//    public let HKQuantityTypeIdentifierLeanBodyMass: String // Mass,                        Discrete`
    
    private let healthKitStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        let healthKitTypesToWrite : [AnyObject?] = [ HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierLeanBodyMass),
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyFatPercentage),
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass),
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)]
        
        let typesToWrite = Set(healthKitTypesToWrite.flatMap  { $0 as? HKSampleType })
        
        healthKitStore.requestAuthorizationToShareTypes(typesToWrite, readTypes: typesToWrite, completion: { (success, error) -> Void in
            if (completion != nil)
            {
                completion(success: success, error: error)
            }
        })
    }
    
    private func getHKQuantitySample(identifier: String, hkUnit : HKUnit, value: Double, date : NSDate) -> HKQuantitySample {
        let type = HKQuantityType.quantityTypeForIdentifier(identifier)
        let quantity = HKQuantity(unit: hkUnit, doubleValue: value)
        return HKQuantitySample(type: type!, quantity:  quantity, startDate: date, endDate: date)
    }
    
    private func getSamples(weight: Double, fat: Double, muscle: Double, bmi : Double) -> [HKQuantitySample] {
        let date = NSDate()
        
        let muscleSample = getHKQuantitySample(HKQuantityTypeIdentifierLeanBodyMass, hkUnit: HKUnit.gramUnit(), value: muscle, date: date)
        let bmiSample = getHKQuantitySample(HKQuantityTypeIdentifierBodyMassIndex, hkUnit: HKUnit.countUnit(), value: bmi, date: date)
        let weightSample = getHKQuantitySample(HKQuantityTypeIdentifierBodyMass, hkUnit: HKUnit.gramUnit(), value: weight, date: date)
        let fatSample = getHKQuantitySample(HKQuantityTypeIdentifierBodyFatPercentage, hkUnit: HKUnit.percentUnit(), value: fat, date: date)
        
        return [muscleSample, bmiSample, weightSample, fatSample]
    }
    
    func update(weight: Double, fat: Double, muscle: Double, bmi : Double, completion: ((success: Bool, error: NSError!) -> Void)!) {
        
        
        
        let samples = getSamples(weight, fat: fat, muscle: muscle, bmi: bmi)
        
        
        healthKitStore.saveObjects(samples) { (success, error) -> Void in
            if (completion != nil) {
                completion(success: success, error: error)
            }
        }
    }
}

