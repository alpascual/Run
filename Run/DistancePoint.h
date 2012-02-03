//
//  DistancePoint.h
//  Run
//
//  Created by Albert Pascual on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DistancePoint : NSObject

@property (nonatomic,strong) CLLocation *point;
@property (nonatomic) double distanceFrom;
@property (nonatomic) double altitude;

@end
