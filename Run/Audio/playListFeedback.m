//
//  playListFeedback.m
//  Run
//
//  Created by Albert Pascual on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "playListFeedback.h"

@implementation playListFeedback

@synthesize appPlayer = _appPlayer;

- (void) needToStartMusicPrivate:(NSString *)setting
{
    if ( setting != nil ) {
        if ( self.appPlayer == nil ) {
            // Instantiate a music player
            self.appPlayer = [MPMusicPlayerController applicationMusicPlayer];
            
            // Get a collection of all playlists on the device
            MPMediaQuery *playlistsQuery = [MPMediaQuery playlistsQuery];
            NSArray *playlists = [playlistsQuery collections];
            
            // Check each playlist to see if it is the right one
            for (MPMediaPlaylist *playlist in playlists) {
                NSString *playlistName = [playlist valueForProperty: MPMediaPlaylistPropertyName];
                if ([playlistName isEqualToString:setting]) {
                    // Add the playlist to the player's queue and get out of here
                    [self.appPlayer setQueueWithItemCollection:playlist];
                    
                    break;
                }
            }
        }
        
        // Start playing from the beginning of the queue
        [self.appPlayer play];
    }
}

- (void) playIfNeeded {
    
    NSString *playListToPlay = [self whatPlaylist];
    if ( playListToPlay != nil )
        [self needToStartMusicPrivate:playListToPlay];
}

- (void) stopIfNeeded {
    NSString *playListToPlay = [self whatPlaylist];
    if ( playListToPlay != nil )
    {
        if ( self.appPlayer != nil )
            [self.appPlayer stop];
    }
}

- (NSString *) whatPlaylist {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ( [defaults objectForKey:@"setting0"] == nil )
        return nil;
    
    NSString *playListToPlay = [defaults objectForKey:@"setting0"];
    
    if ( [playListToPlay isEqualToString:@"none"] == YES)
        return nil;
    
    return playListToPlay;
}

- (NSArray *) rerieveList 
{
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    NSArray *playlists = [myPlaylistsQuery collections];
    
    NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:playlists.count];
    
    for (MPMediaPlaylist *temp in playlists) {
        NSString *tempName = [temp valueForProperty: MPMediaPlaylistPropertyName];
        [names addObject:tempName];
    }
    
    return names;
  /*NSArray *songs=nil;
    for (MPMediaPlaylist *tempPlayList in playlists) {
        if( [name isEqualToString:[playlist valueForProperty: MPMediaPlaylistPropertyName]] ) {
            songs = [playlist items];
            break;
        }
    }*/
}

@end
