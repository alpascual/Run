//
//  ViewController.h
//  Run
//
//  Created by Al Pascual on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RunViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *menuArray;

@end
