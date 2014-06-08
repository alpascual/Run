//
//  HealthKitManager.h
//  Run
//
//  Created by Albert Pascual on 6/7/14.
//
//

#import <Foundation/Foundation.h>

#import <HealthKit/HealthKit.h>

@interface HealthKitManager : NSObject

@property (nonatomic) HKHealthStore *healthStore;

- (void) save:(double) activityValue;

@end
