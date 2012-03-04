//
//  DistanceVoiceFeedback.m
//  Run
//
//  Created by Albert Pascual on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DistanceVoiceFeedback.h"

@implementation DistanceVoiceFeedback

@synthesize nextDistanceMark = _nextDistanceMark;
@synthesize soundManager = _soundManager;

- (void) needToProvideFeedback:(NSString *)setting:(double)distance {

    // Check if enable on settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ( [defaults objectForKey:setting] == nil )
        return;
    
    NSString *settingsValue = [defaults objectForKey:setting];
    NSLog(@"settings value %@", settingsValue);
    
    if ( settingsValue == @"0")
        return;
   
    // Init sound
    if ( self.soundManager == nil )
        self.soundManager = [[SoundManager alloc] init];
    
    // TODO
    //@"every 1 mile"
    //@"every 5K";
    //@"every 5 miles"
    
    if ( [settingsValue isEqualToString:@"every 1 mile"] == YES ) {
        [self setUpMark:1 :NO];
        
        // Need to talk 
        if ( distance > self.nextDistanceMark ) {
            // Send the correct audio file 
            [self.soundManager addSoundToQueue:[[NSString alloc] initWithFormat:@"%d",self.nextDistanceMark ]];
            [self.soundManager addSoundToQueue:@"miles"];
            [self.soundManager playQueue];
            
            //set the new mark
            [self setUpMark:self.nextDistanceMark+1 :YES];
        }
    }
    else if ( [settingsValue isEqualToString:@"every 5 miles"] == YES ) {
        [self setUpMark:5 :NO];
        
        if ( distance > self.nextDistanceMark ) {
            // Send the correct audio file 
            [self.soundManager addSoundToQueue:[[NSString alloc] initWithFormat:@"%d",self.nextDistanceMark ]];
            [self.soundManager addSoundToQueue:@"miles"];
            [self.soundManager playQueue];
            
            //set the new mark
            [self setUpMark:self.nextDistanceMark+5 :YES];
        }
    }
    
}


- (void) setUpMark:(double)newMark:(BOOL)force {
    if ( self.nextDistanceMark == 0 )
        self.nextDistanceMark = newMark;
    
    if ( force == YES )
        self.nextDistanceMark = newMark;
}

@end
