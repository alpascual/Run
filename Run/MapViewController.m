//
//  MapViewController.m
//  Run
//
//  Created by Albert Pascual on 9/14/12.
//
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    MKMapItem *endItem = [defaults objectForKey:@"endItem"];
   
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    if ( region.center.latitude == 0 ) {
        region.center.latitude = endItem.placemark.coordinate.latitude;
        region.center.longitude = endItem.placemark.coordinate.longitude;
        region.span.latitudeDelta = 0.03;
        region.span.longitudeDelta = 0.03;
        
        [self.mapView setRegion:region];
    }
    
    CLLocationCoordinate2D annotationCoord;
    
    annotationCoord.latitude = endItem.placemark.coordinate.latitude; 
    annotationCoord.longitude = endItem.placemark.coordinate.longitude;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = @"Run end";
    annotationPoint.subtitle = @"Final destination";
    [self.mapView addAnnotation:annotationPoint];
    //TODO ask the user if this is the final destination
    
    [defaults removeObjectForKey:@"endItem"];
    [defaults synchronize];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Run to here" message:@"Is that your destination for your run today?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"endPoint"];
        [defaults synchronize];        
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
