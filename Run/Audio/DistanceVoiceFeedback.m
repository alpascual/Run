//
//  DistanceVoiceFeedback.m
//  Run
//
//  Created by Albert Pascual on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DistanceVoiceFeedback.h"

@implementation DistanceVoiceFeedback

@synthesize distanceTimeArray = _distanceTimeArray;

- (void) needToProvideFeedback:(NSString *)setting:(double)distance {

    // Check if enable on settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ( [defaults objectForKey:setting] == nil )
        return;
    
    NSString *settingsValue = [defaults objectForKey:setting];
    NSLog(@"settings value %@", settingsValue);
    
    if ( settingsValue == @"0")
        return;
    
    // Init array
    if ( self.distanceTimeArray == nil )
        self.distanceTimeArray = [[NSMutableArray alloc] init];
    
    // TODO
    
}


@end
