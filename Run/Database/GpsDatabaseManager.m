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


- (id)init
{
    self = [super init];
    if ( self != nil) {
        NSPersistentStoreCoordinator *check = [self persistentStoreCoordinator];
        NSLog(@"Async persistent check %@", check);
    }
    
    return self;
}
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
    
    // assign the PSC to our app delegate ivar before adding the persistent store in the background
    // this leverages a behavior in Core Data where you can create NSManagedObjectContext and fetch requests
    // even if the PSC has no stores.  Fetch requests return empty arrays until the persistent store is added
    // so it's possible to bring up the UI and then fill in the results later
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    
    // prep the store path and bundle stuff here since NSBundle isn't totally thread safe
    NSPersistentStoreCoordinator* psc = _persistentStoreCoordinator;
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"History.sqlite"];
    
    // do this asynchronously since if this is the first time this particular device is syncing with preexisting
    // iCloud content it may take a long long time to download
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        // this needs to match the entitlements and provisioning profile
        //@"PW6XKXEGA2.com.alpascualCloudPro.Run"
        NSURL *cloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
        if (cloudURL) {
            NSLog(@"iCloud access at %@", cloudURL);
            // TODO: Load document...
            
            NSString* coreDataCloudContent = [[cloudURL path] stringByAppendingPathComponent:@"run_v3"];
            cloudURL = [NSURL fileURLWithPath:coreDataCloudContent];
            
            //  The API to turn on Core Data iCloud support here.
            NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@"com.alpascualcloud.run.3", NSPersistentStoreUbiquitousContentNameKey, cloudURL, NSPersistentStoreUbiquitousContentURLKey, [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,nil];
            
            NSError *error = nil;
            
            //[psc lock];
            if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
                 
                 Typical reasons for an error here include:
                 * The persistent store is not accessible
                 * The schema for the persistent store is incompatible with current managed object model
                 Check the error message to determine what the actual problem was.
                 */
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }    
            //[psc unlock];
        } 
        
        else {
            NSLog(@"No iCloud access");
            
            _persistentStoreCoordinator = nil;
            _persistentStoreCoordinator = [self persistentStoreCoordinatorNoCloud];
        }
        
        
        // tell the UI on the main thread we finally added the store and then
        // post a custom notification to make your views do whatever they need to such as tell their
        // NSFetchedResultsController to -performFetch again now there is a real store
        /*dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"asynchronously added persistent store!");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefetchAllDatabaseData" object:self userInfo:nil];
        });*/
   // });
    
    return _persistentStoreCoordinator;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorNoCloud {
	
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"History.sqlite"];
	//
	// Set up the store.
	// For the sake of illustration, provide a pre-populated default store.
    //
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
		//
		// Replace this implementation with code to handle the error appropriately.
		 
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		// Typical reasons for an error here includ e:
		//  The persistent store is not accessible
		//  The schema for the persistent store is incompatible with current managed object model
		// Check the error message to determine what the actual problem was.
		 
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
    
    NSLog(@"totals %f",totals.totalTimeSeconds );
    
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
    [mySession setTotalTimeHours:[[NSNumber alloc] initWithDouble:totals.totalTimeHours]];
    [mySession setTotalTimeMinutes:[[NSNumber alloc] initWithDouble:totals.totalTimeMinutes]];
    [mySession setTotalTimeSeconds:[[NSNumber alloc] initWithDouble:totals.totalTimeSeconds]];
    [mySession setAvgSpeed:[[NSNumber alloc] initWithDouble:totals.avgSpeed]];
    [mySession setDistancePerTime:[[NSNumber alloc] initWithDouble:totals.distancePerTime]];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save session: %@", [error localizedDescription]);
    }
}

-(void) addMovement:(UIAcceleration *)acceleration : (NSString *) uniqueId {
    //NSLog(@"move x %.2f y %.2f z %.2f", acceleration.x , acceleration.y, acceleration.z );
    
    Acceleration *accel = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Acceleration" 
                             inManagedObjectContext:self.managedObjectContext]; 
    
    [accel setX:[[NSNumber alloc] initWithDouble:acceleration.x ]];
    [accel setY:[[NSNumber alloc] initWithDouble:acceleration.y ]];
    [accel setZ:[[NSNumber alloc] initWithDouble:acceleration.z ]];
    [accel setUniqueId:uniqueId];
    [accel setWhen:[NSDate date]];   
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save acceleration: %@", [error localizedDescription]);
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

- ( NSManagedObject*) getOneSessionRun:(NSString *) uniqueId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"SessionRun" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"uniqueID == %@", uniqueId]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ( fetchedObjects.count > 0 ) {
        NSManagedObject *sessionRun = [fetchedObjects objectAtIndex:0];
        return sessionRun;
    }
    
    return nil;
}

- (NSMutableArray *) getArrayOfPoints:(NSString *) uniqueId {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Points" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"uniqueId == %@", uniqueId]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return [[NSMutableArray alloc] initWithArray:fetchedObjects];
}

- (NSMutableArray *) getArrayOfAcceleration:(NSString *)uniqueId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Acceleration" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"uniqueId == %@", uniqueId]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return [[NSMutableArray alloc] initWithArray:fetchedObjects];
}

- (SessionRunWithPoints *) getOneSessionRunWithChildren:(NSString *) uniqueId {
    
    NSManagedObject *sessionRun = [self getOneSessionRun:uniqueId];
    if ( sessionRun == nil )
        return nil;
    
    SessionRunWithPoints *points = [[SessionRunWithPoints alloc] init];
    points.sessionRun = (SessionRun*) sessionRun;
    points.points = [self getArrayOfPoints:uniqueId];
    points.acceleration = [self getArrayOfAcceleration:uniqueId];
    
    return points;
}

- (void) deleteSessionWithChildren:(NSString *) uniqueId {
    [self deletePointsFor:uniqueId];
    [self deleteAccelerationFor:uniqueId];
    
    [self.managedObjectContext deleteObject:[self getOneSessionRun:uniqueId]];
     [self.managedObjectContext save:nil];
}

- (void) deletePointsFor:(NSString *) uniqueId {
    
    NSArray *alltoDelete = [self getArrayOfPoints:uniqueId];
      
    for (Points *point in alltoDelete) {
        [self.managedObjectContext deleteObject:point];
    }    
    [self.managedObjectContext save:nil];
}

- (void) deleteAccelerationFor:(NSString *) uniqueId {
    NSArray *alltoDelete =  [self getArrayOfAcceleration:uniqueId];
    
    for (Acceleration *acce in alltoDelete) {
        [self.managedObjectContext deleteObject:acce];
    } 
     [self.managedObjectContext save:nil];
}

@end
