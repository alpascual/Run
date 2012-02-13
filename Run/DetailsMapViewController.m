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
@synthesize activity = _activity;
@synthesize uiTimer = _uiTimer;
@synthesize line = _line;
@synthesize routeLineView = _routeLineView;
@synthesize summary = _summary;
@synthesize timeSlider = _timeSlider;

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
    self.mapView.delegate = self;
    
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    
    //Open database
    self.database = [[GpsDatabaseManager alloc] init];
    SessionRunWithPoints *sessionWithChildren = [self.database getOneSessionRunWithChildren:self.uniqueID];
    
    self.summary.text = [[NSString alloc] initWithFormat:@"Distance %l.2f miles",  [sessionWithChildren.sessionRun.totalDistance doubleValue]];
    
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * sessionWithChildren.points.count);
    NSLog(@"How many points %d", sessionWithChildren.points.count);
    int i=0;
    for ( Points *point in sessionWithChildren.points)
    { 
        
        // create our coordinate and add it to the correct spot in the array 
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([point.y doubleValue], [point.x doubleValue]);
        
		MKMapPoint pointSimple = MKMapPointForCoordinate(coordinate);
        
        pointArr[i] = pointSimple;
        
        int iHalf = sessionWithChildren.points.count / 2;
        if ( i >= iHalf )
        {
            if ( region.center.latitude == 0 ) {
                region.center.latitude = coordinate.latitude;
                region.center.longitude = coordinate.longitude;
                region.span.latitudeDelta = 0.03;
                region.span.longitudeDelta = 0.03;                
                
                [self.mapView setRegion:region];
            }
            //self.mapView.showsUserLocation = YES;   
        }
        
        i++;
        
        // Set annotation to the map
        /*MyAnnotation *addAnnotation = [[MyAnnotation alloc] init];
         
         [addAnnotation setCoordinate:location];
         [addAnnotation setSpeed:[[NSString alloc] initWithFormat:@"%@", point.speed]];
         [addAnnotation setElevation:[[NSString alloc] initWithFormat:@"%@", point.altitude]];*/    
        
        
    }
    
    self.line = [MKPolyline polylineWithPoints:pointArr count:sessionWithChildren.points.count];
	[self.mapView addOverlay:self.line];
    free(pointArr);
    
    [self.activity stopAnimating];
    self.activity.hidden = YES;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay
{
    MKOverlayView* overlayView = nil;
    
    if(overlay == self.line)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.line];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 4;
        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
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
