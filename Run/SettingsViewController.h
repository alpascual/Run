//
//  SettingsViewController.h
//  Run
//
//  Created by Albert Pascual on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RunProtocol.h"

@interface SettingsViewController : UIViewController

@property (nonatomic, strong) id <RunProtocol> delegate;

@end
