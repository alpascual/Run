//
//  SessionRun.h
//  Run
//
//  Created by Albert Pascual on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SessionRun : NSManagedObject

@property (nonatomic, retain) NSNumber * altitudeMax;
@property (nonatomic, retain) NSNumber * altitudeMin;
@property (nonatomic, retain) NSNumber * avgSpeed;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSNumber * speedMax;
@property (nonatomic, retain) NSNumber * totalDistance;
@property (nonatomic, retain) NSNumber * totalTimeHours;
@property (nonatomic, retain) NSNumber * totalTimeMinutes;
@property (nonatomic, retain) NSNumber * totalTimeSeconds;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSDate * when;
@property (nonatomic, retain) NSNumber * distancePerTime;

@end
