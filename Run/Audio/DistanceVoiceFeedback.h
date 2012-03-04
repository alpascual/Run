//
//  DistanceVoiceFeedback.h
//  Run
//
//  Created by Albert Pascual on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistanceVoiceFeedback : NSObject

@property (nonatomic,strong) NSMutableArray *distanceTimeArray;

- (void) needToProvideFeedback:(NSString *)setting:(double)distance;

@end
