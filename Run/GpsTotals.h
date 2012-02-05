//
//  GpsTotals.h
//  Run
//
//  Created by Albert Pascual on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GpsTotals : NSObject

@property (nonatomic) double distanceTotal;
@property (nonatomic) double altitudeMax;
@property (nonatomic) double altitudeMin;
@property (nonatomic) double speed;
@property (nonatomic) double speedMax;
@property (nonatomic) double altitude;
@property (nonatomic) double accuracy;
@property (nonatomic,strong) NSString *uniqueID;

@end
