//
//  TimeVoiceFeedback.h
//  Run
//
//  Created by Albert Pascual on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundManager.h"
#import "PlayInternetSound.h"

@interface TimeVoiceFeedback : NSObject

@property (nonatomic) NSTimeInterval nextTimeMark;
@property (nonatomic,strong) SoundManager *soundManager;
@property (nonatomic,strong) PlayInternetSound *playInternetSound;

- (void) needToProvideFeedback:(NSString *)setting totalDistance:(double)distance totalTime:(NSTimeInterval)timeInterval;
- (void) setUpMark:(NSTimeInterval)newMark:(BOOL)force;
- (void) checkInternal:(double)mark newInterval:(NSTimeInterval)interval distance:(double)dis;

@end
