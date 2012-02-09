//
//  ViewController.h
//  Run
//
//  Created by Al Pascual on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RunViewController.h"
#import "RunProtocol.h"
#import "HistoryViewController.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"
#import "ASBSparkLineView.h"
#import "GpsDatabaseManager.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RunProtocol>

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *menuArray;
@property (nonatomic, strong) IBOutlet ASBSparkLineView *sparkLineViewOverview;
@property (nonatomic, strong) NSMutableArray *totalTime;
@property (nonatomic, strong) IBOutlet UIImageView *backGroundImageChart;

@end
