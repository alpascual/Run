//
//  SettingsItemViewController.h
//  Run
//
//  Created by Albert Pascual on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemProtocol <NSObject>

-(void)SelectedDone;

@end

@interface SettingsItemViewController : UIViewController

@property (nonatomic,strong) NSArray *list;
@property (nonatomic,strong) IBOutlet UILabel *showLabel;
@property (nonatomic) NSInteger menuNumber;
@property (nonatomic,strong) id <ItemProtocol> delegate;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *selectedString;
@property (nonatomic, strong) NSString *mydescription;

@end
