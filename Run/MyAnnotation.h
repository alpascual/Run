//
//  MyAnnotation.h
//  Geography Tutor
//
//  Created by Al Pascual on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MyAnnotation : NSObject <MKAnnotation>{

	CLLocationCoordinate2D coordinate;
	
	NSString *title;
    NSString *speed;
	NSString *elevation;	
}


- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (void) setTitle:(NSString*)newString;
- (void) setSpeed:(NSString*)newSpeed;
- (void) setElevation:(NSString *)newElevation;
- (NSString *)title;

@end
