//
//  SettingsViewController.h
//  Run
//
//  Created by Albert Pascual on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "RunProtocol.h"
#import "SettingsItemViewController.h"
#import "playListFeedback.h"

#import "FlatUIKit.h"
#import "UIColor+FlatUI.h"
#import "UISlider+FlatUI.h"
#import "UIStepper+FlatUI.h"
#import "UITabBar+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "FUIButton.h"
#import "FUISwitch.h"
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UIProgressView+FlatUI.h"
#import "FUISegmentedControl.h"
#import "UIPopoverController+FlatUI.h"

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <ItemProtocol>

@property (nonatomic, strong) id <RunProtocol> delegate;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *settingList;
@property (nonatomic) NSInteger lastMenuSelected;



@end
