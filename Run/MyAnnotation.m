//
//  MyAnnotation.m
//  Geography Tutor
//
//  Created by Al Pascual on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize coordinate;


- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
	coordinate = newCoordinate;
}

- (void) setTitle:(NSString*)newString
{
	title = newString;
}


- (void) setSpeed:(NSString*)newSpeed {
    speed = newSpeed;
}
- (void) setElevation:(NSString *)newElevation {
    elevation = newElevation;
}

- (NSString *)title {
	return title;
}



@end
