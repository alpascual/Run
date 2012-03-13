//
//  TimeVoiceFeedback.h
//  Run
//
//  Created by Albert Pascual on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundManager.h"

@interface TimeVoiceFeedback : NSObject

@property (nonatomic) NSTimeInterval nextTimeMark;
@property (nonatomic,strong) SoundManager *soundManager;

- (void) needToProvideFeedback:(NSString *)setting:(NSTimeInterval)timeInterval;
- (void) setUpMark:(NSTimeInterval)newMark:(BOOL)force;
- (void) checkInternal:(double)mark newInterval:(NSTimeInterval)interval;

@end
