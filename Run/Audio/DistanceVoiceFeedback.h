//
//  DistanceVoiceFeedback.h
//  Run
//
//  Created by Albert Pascual on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundManager.h"
#import "PlayInternetSound.h"

@interface DistanceVoiceFeedback : NSObject

@property (nonatomic) double nextDistanceMark;
@property (nonatomic,strong) SoundManager *soundManager;
@property (nonatomic,strong) PlayInternetSound *playInternetSound;

- (void) needToProvideFeedback:(NSString *)setting totalDistance:(double)distance totalTime:(NSTimeInterval)mytime;
- (void) setUpMark:(double)newMark:(BOOL)force;
- (void) playInternal:(int)minutes newDistance:(double)distance;

@end
