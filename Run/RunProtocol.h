//
//  RunProtocol.h
//  Run
//
//  Created by Albert Pascual on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RunProtocol <NSObject>

- (void) FinishHistory;
- (void) FinishRun;
- (void) FinishSettings;
- (void) FinishAbout;

@end
