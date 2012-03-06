//
//  SettingsViewController.h
//  Run
//
//  Created by Albert Pascual on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMediaQuery.h>
#import <MediaPlayer/MPMediaPlaylist.h>

#import "RunProtocol.h"
#import "SettingsItemViewController.h"


@interface SettingsViewController : UIViewController <ItemProtocol>

@property (nonatomic, strong) id <RunProtocol> delegate;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *settingList;
@property (nonatomic) NSInteger lastMenuSelected;


@end
