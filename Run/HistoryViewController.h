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
#import "DetailsMenuViewController.h"

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DetailsMenuViewControllerProtocol>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) id <RunProtocol> delegate;
@property (nonatomic, strong) GpsDatabaseManager *database;
@property (nonatomic, strong) NSArray *historyRaw;
@property (nonatomic, strong) NSString *uniqueIDForSegue;

- (NSArray *)reversedArray:(NSArray*)origin;
- (void) loadData;


@end
