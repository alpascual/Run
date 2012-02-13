//
//  DetailsAnalyzeViewController.m
//  Run
//
//  Created by Al Pascual on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsAnalyzeViewController.h"

@implementation DetailsAnalyzeViewController

@synthesize uniqueID = _uniqueID;
@synthesize delegate = _delegate;
@synthesize sparkLineViewAltitude = _sparkLineViewAltitude;
@synthesize sparkLineViewShake = _sparkLineViewShake;
@synthesize sparkLineViewSpeed = _sparkLineViewSpeed;
@synthesize database = _database;
@synthesize summaryLabel = _summaryLabel;
@synthesize uiTimer = _uiTimer;
@synthesize activity = _activity;

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
    
    [self.activity startAnimating];
    
    self.uiTimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:
                     @selector(refreshTimer:) userInfo:nil repeats:NO];
    
    
}

- (void)refreshTimer:(NSTimer *)timer { 
    // load data and show it
    self.database = [[GpsDatabaseManager alloc] init];
    SessionRunWithPoints *sessionWithChildren = [self.database getOneSessionRunWithChildren:self.uniqueID];
    
    // TODO add it into the charts
    NSMutableArray *speedArray = [[NSMutableArray alloc] init];
    NSMutableArray *accelerationArray = [[NSMutableArray alloc] init];
    NSMutableArray *altitudeArray = [[NSMutableArray alloc] init];
    
    int iLimit = 0;
    for ( Acceleration *acc in sessionWithChildren.acceleration)
    {
        [accelerationArray addObject:[[NSNumber alloc] initWithDouble:[acc.x doubleValue] + [acc.y doubleValue] + [acc.z doubleValue]]];
        iLimit++;
        if ( iLimit > 500 )
            break;
    }
    for ( Points *point in sessionWithChildren.points)
    {
        [speedArray addObject:point.speed];
        [altitudeArray addObject:point.altitude];
    }
    
    //Load the graphics
    self.sparkLineViewAltitude.dataValues = altitudeArray;
    self.sparkLineViewAltitude.labelText = @"Altitude";
    self.sparkLineViewAltitude.currentValueColor = [UIColor redColor];
    self.sparkLineViewAltitude.penColor = [UIColor whiteColor];
    self.sparkLineViewAltitude.penWidth = 4.0f;
    self.sparkLineViewAltitude.rangeOverlayLowerLimit = nil;
    self.sparkLineViewAltitude.rangeOverlayUpperLimit = nil;
    
    self.sparkLineViewSpeed.dataValues = speedArray;
    self.sparkLineViewSpeed.labelText = @"Speed";
    self.sparkLineViewSpeed.currentValueColor = [UIColor greenColor];
    self.sparkLineViewSpeed.currentValueFormat = @"%.0f";
    self.sparkLineViewSpeed.penColor = [UIColor redColor];
    self.sparkLineViewSpeed.penWidth = 4.0f;
    self.sparkLineViewSpeed.rangeOverlayLowerLimit = [[NSNumber alloc] initWithInt:0];
    self.sparkLineViewSpeed.rangeOverlayUpperLimit = [[NSNumber alloc] initWithInt:10];
    
    self.sparkLineViewShake.dataValues = accelerationArray;
    self.sparkLineViewShake.labelText = @"Movement";
    self.sparkLineViewShake.currentValueColor = [UIColor yellowColor];
    self.sparkLineViewShake.penColor = [UIColor whiteColor];
    self.sparkLineViewShake.penWidth = 4.0f;
    self.sparkLineViewShake.rangeOverlayLowerLimit = nil;
    self.sparkLineViewShake.rangeOverlayUpperLimit = nil;
    
    self.summaryLabel.text = [[NSString alloc] initWithFormat:@"Miles: %l.2f Time %@:%@:%@", [sessionWithChildren.sessionRun.totalDistance doubleValue] , 
                              sessionWithChildren.sessionRun.totalTimeHours,
                              sessionWithChildren.sessionRun.totalTimeMinutes,
                              sessionWithChildren.sessionRun.totalTimeSeconds];
    
    [self.activity stopAnimating];
    self.activity.hidden = YES;
    
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
    [self.delegate FinishDetailsAnalyze];
}

@end
