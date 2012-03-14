//
//  playListFeedback.h
//  Run
//
//  Created by Albert Pascual on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMediaQuery.h>
#import <MediaPlayer/MPMediaPlaylist.h>
#import <MediaPlayer/MPMusicPlayerController.h>

@interface playListFeedback : NSObject

@property (nonatomic, strong) MPMusicPlayerController *appPlayer;

- (void) needToStartMusicPrivate:(NSString *)setting;
- (void) playIfNeeded;
- (void) stopIfNeeded;
- (NSString *) whatPlaylist;
- (NSArray *) rerieveList;

@end
