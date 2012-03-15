//
//  PlayInternetSound.m
//  SpellingBee
//
//  Created by Albert Pascual on 4/11/11.
//  Copyright 2011 Al. All rights reserved.
//

#import "PlayInternetSound.h"


@implementation PlayInternetSound

@synthesize player;


- (void) playOneSound:(NSString *)pathSound
{ 
       
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pathSound]];
    NSData *soundData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error;
    
    self.player = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
       
    // Set the volume (range is 0 to 1)
    self.player.volume = 0.6f;
    
    // To minimize lag time before start of output, preload buffers      
    [self.player prepareToPlay];
    
    // Play the sound once (set negative to loop)
    [self.player setNumberOfLoops:0];
    
    [self.player play];  
}



@end
