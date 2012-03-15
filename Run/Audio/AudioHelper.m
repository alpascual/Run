//
//  AudioHelper.m
//  Run
//
//  Created by Albert Pascual on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AudioHelper.h"

@implementation AudioHelper

@synthesize soundManager = _soundManager;

- (void) playIntervalWithDistance:(double)distance interval:(NSTimeInterval)timeInterval timeType:(BOOL)isTime {
    
    // Init sound
    if ( self.soundManager == nil )
        self.soundManager = [[SoundManager alloc] init];
    
    
    [self setUpMark:minutes :NO];
    
    if ( distance > self.nextDistanceMark ) {
        // Send the correct audio file 
        // TODO pass each number char by char
        // Convert to string and get characters
        NSString *distanceString = [[NSString alloc] initWithFormat:@"%d", self.nextDistanceMark];
        for (int i=0; i < distanceString.length; i++) {
            unichar uChar;            
            [distanceString getCharacters:&uChar range:NSMakeRange(i, 1)];
            
            NSString *toPlay = [[NSString alloc] initWithFormat:@"%c", uChar];
            NSLog(@"character to play %@", toPlay);
            [self.soundManager addSoundToQueue:toPlay];            
        }
        [self.soundManager addSoundToQueue:[[NSString alloc] initWithFormat:@"%d",self.nextDistanceMark ]];
        [self.soundManager addSoundToQueue:@"miles"];
        [self.soundManager playQueue];
        
        //set the new mark
        [self setUpMark:self.nextDistanceMark+minutes :YES];
    }
}

- (void) setUpMark:(NSTimeInterval)newMark:(BOOL)force {
    if ( self.nextTimeMark == 0 )
        self.nextTimeMark = newMark;
    
    if ( force == YES )
        self.nextTimeMark = newMark;
}
@end
