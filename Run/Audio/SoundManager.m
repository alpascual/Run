//
//  SoundManager.m
//  Geography Tutor
//
//  Created by Al Pascual on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"


@implementation SoundManager

@synthesize sndQueue;
@synthesize overlay;
@synthesize soundDelegate;

- (void) LoadSound:(NSString*)pathSound:(NSString*)ofType
{
	NSLog(@"Playing sound %@", pathSound);
	[self addSoundToQueue:pathSound];
	
	if ( bPlaying == NO )
	{
		bPlaying = YES;
		[self playQueue];
	}
	
}

- (void)LoadRandomSound:(NSString*)pathSound:(NSString*)ofType
{
	int ran = 0;
	ran = arc4random() % 4;
	
	NSString *path2 = [[NSString alloc] initWithFormat:@"%@%d", pathSound, ran];
		
	[self LoadSound:path2 :ofType];
	
}

-(id)init
{
	bPlaying = NO;
	if (self = [super init])
	{
		sndQueue = [[NSMutableArray alloc] init];
	}
	return self;
}

-(id)initWithArray:(NSMutableArray *)arraySound
{	
	self = [self init];
	if (self!=nil){
		[sndQueue addObjectsFromArray:arraySound];
	}
	
	return self;
}


-(void)addSoundToQueue:(NSString*)snd
{
	[sndQueue addObject:snd];
}

-(NSString*)getSoundFromQueue
{
	NSLog(@"entered getSoundFromQueue");
	if ( [sndQueue count] > 0 )
	{
		if ( self.overlay.hidden == YES)
			self.overlay.hidden = NO;
		
		NSLog(@"%d sounds to play", [sndQueue count]);
		NSString* snd;
		snd = [sndQueue objectAtIndex:0]; //1st sound
		[sndQueue removeObjectAtIndex:0]; 
		NSLog(@"returning sound from queue");
		return snd;
	}
	else
	{
		NSLog(@"count is 0 returning Null");
		return NULL;
	}
}

void MyAudioServicesSystemSoundCompletionProc(SystemSoundID ssID, void *clientData)
{
	NSLog(@"Finished playing sounds");
	//cleanup
	//AudioServicesDisposeSystemSoundID(ssID);
	SoundManager *pSoundQueue = (__bridge SoundManager*)clientData;
	[pSoundQueue playQueue]; //it crashes here: EXC_BAD_ACCESS
}

-(void)playQueue
{
	NSLog(@"Getting new sound from the queue");
    NSString *nextSound = [self getSoundFromQueue];
	NSLog(@"returned from getSoundFromQueue");
	if (nextSound != nil) { 
		NSLog(@"before playing sound %@", nextSound);
		@try {
			nextSound = [nextSound stringByReplacingOccurrencesOfString:@" " withString:@""];
			NSString *path = [[NSBundle mainBundle] pathForResource:[nextSound lowercaseString] ofType:@"wav"];
			SystemSoundID soundID;
			AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
			
			AudioServicesAddSystemSoundCompletion (soundID,NULL,NULL,MyAudioServicesSystemSoundCompletionProc, (__bridge void*)self);
			AudioServicesPlaySystemSound (soundID);	
			
			NSLog(@"Playing sound from the queue %@", path);			
		}
		@catch (NSException * e) {
			NSLog(@"Exception looking for sound");
		}
			
		
	}
	else
	{
		NSLog(@"Nothing to play");
		bPlaying = NO;
		self.overlay.hidden = YES; 
		
		// Call the delegate
		[self.soundDelegate finish];
	}
}



@end
