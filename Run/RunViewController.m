//
//  RunViewController.m
//  Run
//
//  Created by Al Pascual on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RunViewController.h"


@implementation RunViewController

@synthesize sparkLineViewAltitude = _sparkLineViewAltitude;
@synthesize sparkLineViewSpeed = _sparkLineViewSpeed;
@synthesize trackingManager = _trackingManager;
@synthesize speed = _speed;
@synthesize time = _time;
@synthesize gpsAccuracy = _gpsAccuracy;
@synthesize altitude = _altitude;
@synthesize gpsTimer = _gpsTimer;
@synthesize miles = _miles;
@synthesize start = _start;
@synthesize altitudeArray = _altitudeArray;
@synthesize speedArray = _speedArray;
@synthesize saveButton = _saveButton;
@synthesize delegate = _delegate;
@synthesize database = _database;
@synthesize acceleration = _acceleration;
@synthesize accelerationArray = _accelerationArray;
@synthesize sparkLineViewAcceleration = _sparkLineViewAcceleration;
@synthesize walkLabel = _walkLabel;
@synthesize avgSpeed = _avgSpeed;
@synthesize distancePerTime = _distancePerTime;
@synthesize myToolbar = _myToolbar;
@synthesize voiceFeedback = _voiceFeedback;
@synthesize timeFeedback = _timeFeedback;
@synthesize playlistFeedback = _playlistFeedback;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.saveButton.hidden = YES;
    self.database = [[GpsDatabaseManager alloc] init];
    
    self.trackingManager = [[TrackingManager alloc] init];
    self.trackingManager.bStarted = NO;
    [self.trackingManager startUpTracking];
    
    // add region if needed
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CLRegion *myRegion = [defaults objectForKey:@"endPoint"];
    if ( myRegion != nil) {        
        CLLocationAccuracy accuracy = 1.0;
        [self.trackingManager.locMgr startMonitoringForRegion:myRegion desiredAccuracy:accuracy];
        
        [defaults removeObjectForKey:@"endPoint"];
        [defaults synchronize];
    }
    
    self.pebbleSupported = NO;
    // Set up pebble
    // We'd like to get called when Pebbles connect and disconnect, so become the delegate of PBPebbleCentral:
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    
    // Initialize with the last connected watch:
    [self setTargetWatch:[[PBPebbleCentral defaultCentral] lastConnectedWatch]];
    
}


- (void)setTargetWatch:(PBWatch*)watch {
    _targetWatch = watch;
    
    // NOTE:
    // For demonstration purposes, we start communicating with the watch immediately upon connection,
    // because we are calling -appMessagesGetIsSupported: here, which implicitely opens the communication session.
    // Real world apps should communicate only if the user is actively using the app, because there
    // is one communication session that is shared between all 3rd party iOS apps.
    
    if ( self.pebbleSupported == YES) {
        [watch sportsAppAddReceiveUpdateHandler:^BOOL(PBWatch *watch, SportsAppActivityState state) {
            NSString *newStateString = nil;
            NSInteger index = 0;
            switch (state) {
                case SportsAppActivityStateInit:
                    newStateString = @"Init";
                    break;
                case SportsAppActivityStateRunning:
                    newStateString = @"Running";
                    index = 1;
                    break;
                case SportsAppActivityStatePaused:
                    newStateString = @"Paused";
                    break;
                case SportsAppActivityStateEnd:
                    newStateString = @"End";
                    break;
            }
            
            NSLog(@"Pebble Activity state: %@\n", newStateString);
            
            return YES;
        }];
    }
    
    // Test if the Pebble's firmware supports AppMessages / Sports:
    [watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if (isAppMessagesSupported) {
            // Configure our communications channel to target the sports app:
            [watch appMessagesSetUUID:PBSportsUUID];
            
            NSLog(@"Yay! %@ supports AppMessages :D", [watch name]);
            self.pebbleSupported = YES;
            
        } else {
            
            NSLog(@"Blegh... %@ does NOT support AppMessages :'(", [watch name]);
            self.pebbleSupported = YES;
            
        }
    }];
    
}


// Pebble
- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    [self setTargetWatch:watch];
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    [[[UIAlertView alloc] initWithTitle:@"Disconnected!" message:[watch name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    if (_targetWatch == watch || [watch isEqual:_targetWatch]) {
        [self setTargetWatch:nil];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Start and Actions

- (IBAction)switchChanged:(id)sender {
    
    UISegmentedControl *segment = sender;
    
    if ( segment.selectedSegmentIndex == 0 )
        [self startRun];
    else
        [self stopRun];
}

- (void) startRun {
    self.trackingManager.bStarted = YES;
    [self.trackingManager startUpTracking];
    
    [SVStatusHUD showWithoutImage:@"Starting..."];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    self.gpsTimer = [NSTimer scheduledTimerWithTimeInterval:(0.8) target:self selector:
                     @selector(refreshTimer:) userInfo:nil repeats:YES];
    
    self.start = [NSDate date];
    
    self.speedArray = [[NSMutableArray alloc] init];
    self.altitudeArray = [[NSMutableArray alloc] init];
    self.accelerationArray = [[NSMutableArray alloc] init];
    
    self.saveButton.hidden = YES;
    
    //Set the unique id for the session Run
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    self.trackingManager.uniqueID = uuidString;
    self.trackingManager.gpsTotals.uniqueID = uuidString;
    
    self.acceleration = [[MyAccelerometer alloc] init];
    self.acceleration.uniqueId = uuidString;
    
    self.myToolbar.hidden = YES;
    
    if ( self.playlistFeedback == nil)
        self.playlistFeedback = [[playListFeedback alloc] init];
    
    [self.playlistFeedback playIfNeeded];
        
    if ( _targetWatch && self.pebbleSupported == YES) {
        [_targetWatch sportsAppLaunch:^(PBWatch *watch, NSError *error) {
            if (error) {
                NSLog(@"Failed sending launch command.\n");
            } else {
                NSLog(@"Launch command sent.\n");
            }
        }];
        
        [_targetWatch sportsAppSetActivityState:SportsAppActivityStateRunning onSent:^(PBWatch *watch, NSError *error) {
            if (error) {
                NSLog(@"Pebble: Failed sending activity state: %@\n", error);
            }         
        }];
    }
}

- (void) stopRun {
    self.trackingManager.bStarted = NO;
    [self.trackingManager stopTracking];
    
    [SVStatusHUD showWithoutImage:@"Stopping..."];
    
    [self.gpsTimer invalidate];
    self.gpsTimer = nil;
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    self.saveButton.hidden = NO;
    
    [self.acceleration stop];
    self.acceleration.uniqueId = nil;
    self.acceleration = nil;
    
    self.myToolbar.hidden = NO;
    
    [self.playlistFeedback stopIfNeeded];
    
    if ( _targetWatch && self.pebbleSupported == YES) {
        [_targetWatch sportsAppSetActivityState:SportsAppActivityStatePaused onSent:^(PBWatch *watch, NSError *error) {
            if (error) {
                NSLog(@"Pebble: Failed sending activity state: %@\n", error);
            }
        }];
    }
}




- (void)refreshTimer:(NSTimer *)timer {
    
    double dSpeed = self.trackingManager.gpsTotals.speed * 0.00062137119; //* 2.2369;
    
    if ( dSpeed >= 0 ) {
        self.avgSpeed += dSpeed;
        self.speed.text = [[NSString alloc] initWithFormat:@"%.2f mph", dSpeed];
        NSNumber *tempSpeed = [[NSNumber alloc] initWithDouble:dSpeed];
        [self.speedArray addObject:tempSpeed];
        NSLog(@"Speed values is %@", tempSpeed);
    }
    else {
        dSpeed = -dSpeed;
        self.avgSpeed += dSpeed;
        NSNumber * iSpeed = [[NSNumber alloc] initWithDouble:dSpeed];
        self.speed.text = [[NSString alloc] initWithFormat:@"%.2f mph", dSpeed];
        [self.speedArray addObject:iSpeed];
        NSLog(@"Speed values is %@", iSpeed);
    }
    
    // calculate the avg speed
    self.trackingManager.gpsTotals.avgSpeed = dSpeed / self.speedArray.count;
    if ( dSpeed == 0 )
        self.walkLabel.text = @"Too slow";
    else if ( dSpeed > 0 && dSpeed <= 2.0)
        self.walkLabel.text = @"Walking";
    else if ( dSpeed > 2.0 && dSpeed <= 3.0)
        self.walkLabel.text = @"Jogging";
    else
        self.walkLabel.text = @"Running";
    
    self.altitude.text = [[NSString alloc] initWithFormat:@"%.2f alt.", self.trackingManager.gpsTotals.altitude];
    
    NSNumber *tempAltitude = [[NSNumber alloc] initWithDouble:self.trackingManager.gpsTotals.altitude];
    
    [self.altitudeArray addObject:tempAltitude];
    NSLog(@"Altitude values is %@", tempAltitude);
    
    self.miles.text = [[NSString alloc] initWithFormat:@"%.2f mi", self.trackingManager.gpsTotals.distanceTotal];
    
    self.gpsAccuracy.text = [[NSString alloc] initWithFormat:@"%.2f gps acc.", self.trackingManager.gpsTotals.accuracy];
    
    NSTimeInterval timeInterval = [self.start timeIntervalSinceNow];
    NSInteger ti = (NSInteger)timeInterval;
    NSInteger seconds = ti % 60;
    seconds = -seconds;
    NSInteger minutes = (ti / 60) % 60;
    minutes = -minutes;
    NSInteger hours = (ti / 3600);
    hours = -hours;
    
    // voice commands per distance
    if ( self.voiceFeedback == nil )
        self.voiceFeedback = [[DistanceVoiceFeedback alloc] init];
   
    [self.voiceFeedback needToProvideFeedback:@"setting1" totalDistance:self.trackingManager.gpsTotals.distanceTotal totalTime:timeInterval];
    
    // voice time feedback
    if ( self.timeFeedback == nil )
        self.timeFeedback = [[TimeVoiceFeedback alloc] init];  
    
    [self.timeFeedback needToProvideFeedback:@"setting2" totalDistance:self.trackingManager.gpsTotals.distanceTotal totalTime:timeInterval];
    
    // For saving
    self.trackingManager.gpsTotals.totalTimeHours = hours;
    self.trackingManager.gpsTotals.totalTimeMinutes = minutes;
    self.trackingManager.gpsTotals.totalTimeSeconds = seconds;
        
    // with a divisor of 10.    
    NSLog(@"%d:%d:%d", hours, minutes, seconds);
    self.time.text = [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
        
    //For line chart add accelerometer and acceleration TODO
    [self.accelerationArray addObject:[[NSNumber alloc] initWithDouble: self.acceleration.X + self.acceleration.Y + self.acceleration.Z]];
    
    //Calculate the distance per time
    if ( minutes > 0 && self.trackingManager.gpsTotals.distanceTotal > 0) {
        
        double totalMinutes = (hours * 60) + minutes;
        if ( seconds > 0 )
            totalMinutes += seconds / 60;
        
        self.trackingManager.gpsTotals.distancePerTime = totalMinutes / self.trackingManager.gpsTotals.distanceTotal;        
        NSLog(@"Distance per time %f", self.trackingManager.gpsTotals.distancePerTime);
    }
    else
        self.trackingManager.gpsTotals.distancePerTime = 0;
    
    self.distancePerTime.text = [[NSString alloc] initWithFormat:@"%l.2f per mile", self.trackingManager.gpsTotals.distancePerTime];        
    
    [self setupLineGraphics];
    
    if ( self.pebbleSupported == YES) {
        //Send metrics to the Pebble
        NSString *stringInterval = [PBSportsUpdate timeStringFromFloat:timeInterval];
        stringInterval = [stringInterval stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSDictionary *updateDict = @{ PBSportsTimeKey : stringInterval,
                                      PBSportsDataKey : [PBSportsUpdate timeStringFromFloat:self.trackingManager.gpsTotals.avgSpeed],
                                      PBSportsDistanceKey : [NSString stringWithFormat:@"%2.02f", self.trackingManager.gpsTotals.distanceTotal]};
        
        NSLog(@"Sent update: t:%2.2f, d:%2.2f, p:%2.1f\n", timeInterval, self.trackingManager.gpsTotals.avgSpeed, self.trackingManager.gpsTotals.distanceTotal);
        
        [_targetWatch sportsAppUpdate:updateDict onSent:^(PBWatch *watch, NSError *error) {
            if (error) {
                NSLog(@"Pebble Failed sending update: %@\n", error);
            } 
        }];
    }
}

- (void) setupLineGraphics {
    self.sparkLineViewAltitude.dataValues = self.altitudeArray;
    self.sparkLineViewAltitude.labelText = @"Altitude";
    self.sparkLineViewAltitude.currentValueColor = [UIColor redColor];
    self.sparkLineViewAltitude.penColor = [UIColor whiteColor];
    self.sparkLineViewAltitude.penWidth = 4.0f;
    self.sparkLineViewAltitude.rangeOverlayLowerLimit = nil;
    self.sparkLineViewAltitude.rangeOverlayUpperLimit = nil;
    self.sparkLineViewAltitude.showCurrentValue = NO;
    
    self.sparkLineViewSpeed.dataValues = self.speedArray;
    self.sparkLineViewSpeed.labelText = @"Speed";
    self.sparkLineViewSpeed.currentValueColor = [UIColor greenColor];
    self.sparkLineViewSpeed.currentValueFormat = @"%.0f";
    self.sparkLineViewSpeed.penColor = [UIColor redColor];
    self.sparkLineViewSpeed.penWidth = 4.0f;
    self.sparkLineViewSpeed.rangeOverlayLowerLimit = [[NSNumber alloc] initWithInt:0];
    self.sparkLineViewSpeed.rangeOverlayUpperLimit = [[NSNumber alloc] initWithInt:10];
    self.sparkLineViewSpeed.showCurrentValue = NO;
    
    self.sparkLineViewAcceleration.dataValues = self.accelerationArray;
    self.sparkLineViewAcceleration.labelText = @"Movement";
    self.sparkLineViewAcceleration.currentValueColor = [UIColor yellowColor];
    self.sparkLineViewAcceleration.penColor = [UIColor whiteColor];
    self.sparkLineViewAcceleration.penWidth = 4.0f;
    self.sparkLineViewAcceleration.rangeOverlayLowerLimit = nil;
    self.sparkLineViewAcceleration.rangeOverlayUpperLimit = nil;
    self.sparkLineViewAcceleration.showCurrentValue = NO;
    
    [self.sparkLineViewAltitude reloadInputViews];
    [self.sparkLineViewSpeed reloadInputViews];
    
    //reset the arrays if they are too big
//    if ( self.altitudeArray.count > 1000 )
//        [self.altitudeArray removeAllObjects];
//    
//    if ( self.speedArray.count > 1000 )
//        [self.speedArray removeAllObjects];
//    
//    if ( self.accelerationArray.count > 1000 )
//        [self.accelerationArray removeAllObjects];
}


- (IBAction)savePressed:(id)sender {
    
    if ( _targetWatch && self.pebbleSupported == YES) {
        [_targetWatch sportsAppSetActivityState:SportsAppActivityStateEnd onSent:^(PBWatch *watch, NSError *error) {
            if (error) {
                NSLog(@"Pebble: Failed sending activity state: %@\n", error);
            }
        }];
    }
    
    self.saveButton.hidden = YES;
    [SVStatusHUD showWithoutImage:@"Saving..."];
    
    // save all to the database
    [self.database saveSession:self.trackingManager.gpsTotals];
    
}

- (IBAction)returnBack:(id)sender {
    [self.delegate FinishRun];
}

@end
