//
//  ProgressViewController.m
//  Run
//
//  Created by Albert Pascual on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressViewController.h"

@implementation ProgressViewController

@synthesize delegate = _delegate;
@synthesize uiTimer = _uiTimer;
@synthesize database = _database;
@synthesize historyRaw = _historyRaw;

@synthesize time = _time;
@synthesize distance = _distance;
@synthesize timePerMile = _timePerMile;
@synthesize speed = _speed;

@synthesize timeArray = _timeArray;
@synthesize distanceArray = _distanceArray;
@synthesize speedArray = _speedArray;
@synthesize timePerMileArray = _timePerMileArray;

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
    
    self.uiTimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:
                    @selector(refreshTimer:) userInfo:nil repeats:NO];
}

- (void)refreshTimer:(NSTimer *)timer { 
    self.database = [[GpsDatabaseManager alloc] init];
    self.historyRaw = [self.database getAllSessions];
    
    self.timeArray = [[NSMutableArray alloc] init]; 
    self.distanceArray = [[NSMutableArray alloc] init]; 
    self.speedArray = [[NSMutableArray alloc] init]; 
    self.timePerMileArray = [[NSMutableArray alloc] init]; 
    
    for (SessionRun *runItem in self.historyRaw)
    {
        double totalHours = 0;
        if (  [runItem.totalTimeHours doubleValue] > 0 )
            totalHours += [runItem.totalTimeHours doubleValue];
        if ( [runItem.totalTimeMinutes doubleValue] > 0 )
            totalHours += ([runItem.totalTimeMinutes doubleValue] /60);
        [self.timeArray addObject:[[NSNumber alloc] initWithDouble:totalHours]];
        [self.speedArray addObject:runItem.avgSpeed];
        [self.distanceArray addObject:runItem.totalDistance];
        [self.timePerMileArray addObject:runItem.distancePerTime];
    }
    
    //Load the graphics
    self.distance.dataValues = self.distanceArray;
    self.distance.labelText = @"Distance";
    self.distance.currentValueColor = [UIColor redColor];
    self.distance.penColor = [UIColor whiteColor];
    self.distance.penWidth = 4.0f;
    self.distance.rangeOverlayLowerLimit = nil;
    self.distance.rangeOverlayUpperLimit = nil;
    
    self.time.dataValues = self.timeArray;
    self.time.labelText = @"Time";
    self.time.currentValueColor = [UIColor greenColor];
    self.time.currentValueFormat = @"%.0f";
    self.time.penColor = [UIColor redColor];
    self.time.penWidth = 4.0f;
    self.time.rangeOverlayLowerLimit = nil;
    self.time.rangeOverlayUpperLimit = nil;
    
    self.speed.dataValues = self.speedArray;
    self.speed.labelText = @"Speed";
    self.speed.currentValueColor = [UIColor yellowColor];
    self.speed.penColor = [UIColor whiteColor];
    self.speed.penWidth = 4.0f;
    self.speed.rangeOverlayLowerLimit = nil;
    self.speed.rangeOverlayUpperLimit = nil;
    
    self.timePerMile.dataValues = self.timePerMileArray;
    self.timePerMile.labelText = @"Time Per Mile";
    self.timePerMile.currentValueColor = [UIColor whiteColor];
    self.timePerMile.penColor = [UIColor whiteColor];
    self.timePerMile.penWidth = 4.0f;
    self.timePerMile.rangeOverlayLowerLimit = nil;
    self.timePerMile.rangeOverlayUpperLimit = nil;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backPressed:(id)sender {
    [self.delegate FinishAbout];
}

@end
