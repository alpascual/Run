//
//  DetailsMenuViewController.h
//  Run
//
//  Created by Al Pascual on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsProtocol.h"
#import "DetailsMapViewController.h"
#import "DetailsAnalyzeViewController.h"
#import "DetailsShareViewController.h"
#import "InAppManager.h"

@protocol DetailsMenuViewControllerProtocol <NSObject>

- (void) Finish;

@end

@interface DetailsMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DetailsProtocol>

@property (nonatomic, strong) id <DetailsMenuViewControllerProtocol> delegate;
@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *menuArray;
@property (nonatomic,strong) InAppManager *inApp;

@end
