//
//  MyAccelerometer.h
//  Recovery
//
//  Created by Al Pascual on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MyAccelerometer : NSObject <UIAccelerometerDelegate>{

	UIAccelerometer *accelerometerManager;
	

}

@property (nonatomic, retain) UIAccelerometer *accelerometerManager;  

@end
