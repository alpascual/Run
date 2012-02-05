//
//  Points.h
//  Run
//
//  Created by Albert Pascual on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Points : NSManagedObject

@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSNumber * altitude;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSNumber * attribute;
@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSDate * when;

@end
