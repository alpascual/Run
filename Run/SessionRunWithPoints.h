//
//  SessionRunWithPoints.h
//  Run
//
//  Created by Albert Pascual on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionRun.h"
#import "Points.h"

@interface SessionRunWithPoints : NSObject

@property (nonatomic, strong) SessionRun *sessionRun;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSMutableArray *acceleration;

@end
