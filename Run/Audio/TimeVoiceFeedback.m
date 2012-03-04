//
//  TimeVoiceFeedback.m
//  Run
//
//  Created by Albert Pascual on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeVoiceFeedback.h"

@implementation TimeVoiceFeedback

@synthesize nextTimeMark = _nextTimeMark;
@synthesize soundManager = _soundManager;


- (void) needToProvideFeedback:(NSString *)setting:(NSTimeInterval)distance {
    //TODO
}

- (void) setUpMark:(NSTimeInterval)newMark:(BOOL)force {
    if ( self.nextTimeMark == 0 )
        self.nextTimeMark = newMark;
    
    if ( force == YES )
        self.nextTimeMark = newMark;
}

@end
