//
//  HistoryViewController.h
//  Run
//
//  Created by Albert Pascual on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunProtocol.h"
#import "GpsDatabaseManager.h"

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) id <RunProtocol> delegate;
@property (nonatomic, strong) GpsDatabaseManager *database;
@property (nonatomic, strong) NSArray *historyRaw;

@end
