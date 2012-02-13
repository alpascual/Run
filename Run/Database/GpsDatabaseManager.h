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
#import "Acceleration.h"
#import "SessionRunWithPoints.h"

@interface GpsDatabaseManager : NSObject

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//- (NSManagedObjectContext *)getManagedObjectContext;
- (void) addPoint:(CLLocation*) newLocation : (NSString *)uniqueID :(DistancePoint*) distanceP :
                (GpsTotals *) totals;
- (void) saveSession:(GpsTotals *)totals;
-(void) addMovement:(UIAcceleration *)acceleration : (NSString *) uniqueId;

- (NSString *)applicationDocumentsDirectory;

// Methods for getting info from the database
- (NSArray *) getAllSessions;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorNoCloud;

- ( NSManagedObject*) getOneSessionRun:(NSString *) uniqueId;
- (SessionRunWithPoints *) getOneSessionRunWithChildren:(NSString *) uniqueId;
- (NSMutableArray *) getArrayOfPoints:(NSString *) uniqueId;
- (NSMutableArray *) getArrayOfAcceleration:(NSString *)uniqueId;
//Delete methods
- (void) deletePointsFor:(NSString *) uniqueId;
- (void) deleteSessionWithChildren:(NSString *) uniqueId;
- (void) deleteAccelerationFor:(NSString *) uniqueId;

@end
