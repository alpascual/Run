//
//  GpsDatabaseManager.m
//  PolioTraker
//
//  Created by Al Pascual on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GpsDatabaseManager.h"


@implementation GpsDatabaseManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


/*- (NSManagedObjectContext *)getManagedObjectContext {
    
    if ( self.managedObjectContext == nil ) {        
        NSArray *bundlesToSearch = [NSArray arrayWithObject:[NSBundle mainBundle]];    
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:bundlesToSearch]];
        
        NSPersistentStoreCoordinator *coordinator = persistentStoreCoordinator;
        if (coordinator != nil) {
            self.managedObjectContext = [[NSManagedObjectContext alloc] init];
            [self.managedObjectContext setPersistentStoreCoordinator:coordinator];
            [self.managedObjectContext setUndoManager:nil];
        }
    }
    
    return self.managedObjectContext;
}*/


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
	
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        _managedObjectContext = [NSManagedObjectContext new];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
    return _managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"History.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"History" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here includ e:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
    
    return _persistentStoreCoordinator;
}

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


- (void) addPoint:(CLLocation*) newLocation : 
            (NSString *)uniqueID :
(DistancePoint*) distanceP  :
(GpsTotals *) totals
{
       
    Points *dbPoints = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Points" 
                                       inManagedObjectContext:self.managedObjectContext];    
    
    dbPoints.when = newLocation.timestamp;
    // TODO check longintude and latitude
    dbPoints.x = [[NSNumber alloc] initWithDouble:newLocation.coordinate.longitude];
    dbPoints.y = [[NSNumber alloc] initWithDouble:newLocation.coordinate.latitude];
    
    dbPoints.distance = [[NSNumber alloc] initWithDouble:distanceP.distanceFrom]; 
    dbPoints.speed = [[NSNumber alloc] initWithDouble:totals.speed];
    dbPoints.attribute =  [[NSNumber alloc] initWithDouble:0];
    dbPoints.uniqueId = totals.uniqueID;
    dbPoints.altitude = [[NSNumber alloc] initWithDouble:totals.altitude];   
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save poin: %@", [error localizedDescription]);
    }
}

- (void) saveSession:(GpsTotals *)totals {
    
    SessionRun *mySession = [NSEntityDescription
                        insertNewObjectForEntityForName:@"SessionRun" 
                        inManagedObjectContext:self.managedObjectContext]; 
   
    [mySession setSpeedMax:[[NSNumber alloc] initWithDouble:totals.speedMax ]];
    [mySession setTotalDistance:[[NSNumber alloc] initWithDouble:totals.distanceTotal ]];
    [mySession setAltitudeMax:[[NSNumber alloc] initWithDouble:totals.altitudeMax ]];
    [mySession setAltitudeMin:[[NSNumber alloc] initWithDouble:totals.altitudeMin ]];
    [mySession setUniqueID:totals.uniqueID];
    [mySession setCalories:[[NSNumber alloc] initWithDouble:totals.calories ]];
    [mySession setWhen:[NSDate date]];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save session: %@", [error localizedDescription]);
    }
}

- (NSArray *) getAllSessions {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"SessionRun" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
    
    /*for (NSManagedObject *info in fetchedObjects) {
        //TODO get each objects and added to a list?
        
        NSLog(@"Name: %@", [info valueForKey:@"name"]);
        NSManagedObject *details = [info valueForKey:@"details"];
        NSLog(@"Zip: %@", [details valueForKey:@"zip"]);
    }  */      
}


@end
