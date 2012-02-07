//
//  DetailsMenuViewController.h
//  Run
//
//  Created by Al Pascual on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailsMenuViewControllerProtocol <NSObject>

- (void) Finish;

@end

@interface DetailsMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id <DetailsMenuViewControllerProtocol> delegate;
@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *menuArray;

@end
