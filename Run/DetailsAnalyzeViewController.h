//
//  DetailsAnalyzeViewController.h
//  Run
//
//  Created by Al Pascual on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailsProtocol.h"
#import "ASBSparkLineView.h"

@interface DetailsAnalyzeViewController : UIViewController

@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, strong) id <DetailsProtocol> delegate;

@property (nonatomic, strong) IBOutlet ASBSparkLineView *sparkLineViewAltitude;
@property (nonatomic, strong) IBOutlet ASBSparkLineView *sparkLineViewSpeed;
@property (nonatomic, strong) IBOutlet ASBSparkLineView *sparkLineViewShake;

@end
