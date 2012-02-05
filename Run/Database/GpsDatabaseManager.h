//
//  GpsDatabaseManager.h
//  PolioTraker
//
//  Created by Al Pascual on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>

#import "DistancePoint.h"
#import "GpsTotals.h"
#import "Points.h"
#import "SessionRun.h"

@interface GpsDatabaseManager : NSObject

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//- (NSManagedObjectContext *)getManagedObjectContext;
- (void) addPoint:(CLLocation*) newLocation : (NSString *)uniqueID :(DistancePoint*) distanceP :
                (GpsTotals *) totals;
- (void) saveSession:(GpsTotals *)totals;

- (NSString *)applicationDocumentsDirectory;


@end
