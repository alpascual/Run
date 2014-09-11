//
//  HealthKitManager.m
//  Run
//
//  Created by Albert Pascual on 6/7/14.
//
//

#import "HealthKitManager.h"

@implementation HealthKitManager


- (void) save:(double) activityValue
{
    
   // Save the user's height into HealthKit.
    
    HKQuantityType *activityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    HKQuantity *quantity = [HKQuantity quantityWithUnit:[HKUnit mileUnit] doubleValue:activityValue];
    HKQuantitySample *sleepSample = [HKQuantitySample quantitySampleWithType:activityType quantity:quantity startDate:[NSDate date] endDate:[NSDate date]];
    
    self.healthStore = [[HKHealthStore alloc] init];
    [self.healthStore saveObject:sleepSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured saving the height sample %@. In your app, try to handle this gracefully. The error was: %@.", sleepSample, error);
            abort();
        }
        
    }];
    
    
}
@end
