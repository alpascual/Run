//
//  ProgressViewController.h
//  Run
//
//  Created by Albert Pascual on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RunProtocol.h"
#import "GpsDatabaseManager.h"

@interface ProgressViewController : UIViewController

@property (nonatomic, strong) id <RunProtocol> delegate;
@property (nonatomic, strong) NSTimer *uiTimer;
@property (nonatomic, strong) GpsDatabaseManager *database;
@property (nonatomic, strong) NSArray *historyRaw;

@end
