//
//  DistanceVoiceFeedback.h
//  Run
//
//  Created by Albert Pascual on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundManager.h"

@interface DistanceVoiceFeedback : NSObject

@property (nonatomic) double nextDistanceMark;
@property (nonatomic,strong) SoundManager *soundManager;

- (void) needToProvideFeedback:(NSString *)setting:(double)distance;
- (void) setUpMark:(double)newMark:(BOOL)force;

@end
