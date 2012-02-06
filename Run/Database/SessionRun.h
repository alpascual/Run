//
//  SessionRun.h
//  Run
//
//  Created by Albert Pascual on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SessionRun : NSManagedObject

@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) NSNumber * totalDistance;
@property (nonatomic, retain) NSNumber * altitudeMax;
@property (nonatomic, retain) NSNumber * altitudeMin;
@property (nonatomic, retain) NSNumber * speedMax;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSDate * when;

@end