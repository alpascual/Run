//
//  AudioHelper.h
//  Run
//
//  Created by Albert Pascual on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundManager.h"

@interface AudioHelper : NSObject

@property (nonatomic,strong) SoundManager *soundManager;

- (void) playIntervalWithDistance:(double)distance interval:(NSTimeInterval)timeInterval timeType:(BOOL)isTime;

- (void) setUpMark:(NSTimeInterval)newMark:(BOOL)force;

@end
