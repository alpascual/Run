//
//  DetailsShareViewController.h
//  Run
//
//  Created by Al Pascual on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsProtocol.h"

@interface DetailsShareViewController : UIViewController

@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, strong) id <DetailsProtocol> delegate;

@end
