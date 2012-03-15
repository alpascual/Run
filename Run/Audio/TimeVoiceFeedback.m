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
@synthesize playInternetSound = _playInternetSound;


- (void) needToProvideFeedback:(NSString *)setting totalDistance:(double)distance totalTime:(NSTimeInterval)timeInterval {
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
    
    //@"every 10 minutes"
    //@"every 20 minutes"
    //@"every 30 minutes"
    //@"every 1 hour"
   
    if ( [settingsValue isEqualToString:@"every 10 minutes"] == YES ) {
        [self checkInternal:10 newInterval:timeInterval distance:distance];
    }
    else if ( [settingsValue isEqualToString:@"every 20 minutes"] == YES ) {
        [self checkInternal:20 newInterval:timeInterval distance:distance];
    }
    else if ( [settingsValue isEqualToString:@"every 30 minutes"] == YES ) {
        [self checkInternal:30 newInterval:timeInterval distance:distance];
    }
    else if ( [settingsValue isEqualToString:@"every 60 minutes"] == YES ) {
        [self checkInternal:60 newInterval:timeInterval distance:distance];
    }
}

- (void) checkInternal:(double)mark newInterval:(NSTimeInterval)interval distance:(double)dis
{
    [self setUpMark:mark :NO];
    
    // Need to talk 
    if ( interval > self.nextTimeMark ) {
        
        if ( self.playInternetSound == nil ) {
            self.playInternetSound = [[PlayInternetSound alloc] init];
        }
        
        unsigned long seconds = interval;
        unsigned long minutes = seconds / 60;
        [self.playInternetSound playOneSound:[[NSString alloc] initWithFormat:@"http://translate.google.com/translate_tts?q=You runned %d miles with the time of %d minutes", dis, minutes ]];
        return;
        
        // Send the correct audio file 
        [self.soundManager addSoundToQueue:[[NSString alloc] initWithFormat:@"%d",self.nextTimeMark ]];
        [self.soundManager addSoundToQueue:@"minutes"];
        [self.soundManager playQueue];
        
        //set the new mark
        [self setUpMark:self.nextTimeMark+mark :YES];
    }
}

- (void) setUpMark:(NSTimeInterval)newMark:(BOOL)force {
    if ( self.nextTimeMark == 0 )
        self.nextTimeMark = newMark;
    
    if ( force == YES )
        self.nextTimeMark = newMark;
}

@end
