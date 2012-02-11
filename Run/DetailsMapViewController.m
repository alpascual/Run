//
//  DetailsMapViewController.m
//  Run
//
//  Created by Al Pascual on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsMapViewController.h"

@implementation DetailsMapViewController

@synthesize uniqueID = _uniqueID;
@synthesize delegate = _delegate;
@synthesize mapView = _mapView;
@synthesize database = _database;

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
    // Add the points to the map
    self.mapView.mapType = MKMapTypeStandard;
    
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    
    //Open database
    self.database = [[GpsDatabaseManager alloc] init];
    SessionRunWithPoints *sessionWithChildren = [self.database getOneSessionRunWithChildren:self.uniqueID];
    
    //NSMutableArray *pointArr = [[NSMutableArray alloc] init];
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * sessionWithChildren.points.count);
    NSLog(@"How many points %d", sessionWithChildren.points.count);
    int i=0;
    for ( Points *point in sessionWithChildren.points)
    { 
        CLLocationCoordinate2D location;
        location.latitude = [point.y doubleValue];
        location.longitude = [point.x doubleValue];
        NSLog(@"Coordinates %f %f at %d", location.latitude, location.longitude, i);
        
        MKMapPoint pointSimple = MKMapPointForCoordinate(location);
        pointArr[i] = pointSimple;
        
        if ( i == 0 )
        {
            region.center.latitude = location.latitude;
            region.center.longitude = location.longitude;
            region.span.latitudeDelta = 0;
            region.span.longitudeDelta = 0;	
            
            [self.mapView setRegion:region];
            //self.mapView.showsUserLocation = YES;   
        }
        
        i++;
        
        // Set annotation to the map
        /*MyAnnotation *addAnnotation = [[MyAnnotation alloc] init];
         
         [addAnnotation setCoordinate:location];
         [addAnnotation setSpeed:[[NSString alloc] initWithFormat:@"%@", point.speed]];
         [addAnnotation setElevation:[[NSString alloc] initWithFormat:@"%@", point.altitude]];*/    
        
        
    }
    
    MKPolyline *line = [MKPolyline polylineWithPoints:pointArr count:sessionWithChildren.points.count];
	[self.mapView addOverlay:line];
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
    [self.delegate FinishDetailsMap];
}

@end
