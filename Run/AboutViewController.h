//
//  AboutViewController.h
//  Run
//
//  Created by Albert Pascual on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "RunProtocol.h"

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate>
    
@property (nonatomic, strong) id <RunProtocol> delegate;
@property (nonatomic, strong) MFMailComposeViewController *picker;

@end
