//
//  playListFeedback.m
//  Run
//
//  Created by Albert Pascual on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "playListFeedback.h"

@implementation playListFeedback

- (void) needToStartMusic:(NSString *)setting
{
    //TODO play the playlist if needed
}

- (void) playIfNeeded {
    
    NSString *playListToPlay = [self whatPlaylist];
    if ( playListToPlay != nil )
        [self needToStartMusic:playListToPlay];
}

- (void) stopIfNeeded {
    NSString *playListToPlay = [self whatPlaylist];
    if ( playListToPlay != nil )
    {
        // TODO stop playlist
    }
}

- (NSString *) whatPlaylist {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ( [defaults objectForKey:@"setting0"] == nil )
        return nil;
    
    NSString *playListToPlay = [defaults objectForKey:@"setting0"];
    
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
