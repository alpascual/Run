//
//  PlayInternetSound.h
//  SpellingBee
//
//  Created by Albert Pascual on 4/11/11.
//  Copyright 2011 Al. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVAudioPlayer.h>

#import "AudioStreamer.h"

@class AudioStreamer;

@interface PlayInternetSound : NSObject {
 
    AudioStreamer *streamer;
    AVAudioPlayer  *player;
}

@property (nonatomic,retain) AVAudioPlayer  *player;

//- (void) LoadSound:(NSString*)pathSound;
//- (void) Play;
- (void) playOneSound:(NSString *)pathSound;

@end
