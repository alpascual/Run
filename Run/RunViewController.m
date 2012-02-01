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
    
    self.trackingManager = [[TrackingManager alloc] init];
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

#pragma Start and Actions

- (IBAction)switchChanged:(id)sender {
    
    UISegmentedControl *segment = sender;
    
    if ( segment.selectedSegmentIndex == 0 )
        [self startRun];
    else
        [self stopRun];
}

- (void) startRun {
    [self.trackingManager startUpTracking];
    
    //TODO UI change and reset counter
    
    //TODO start timer to update UI
}

- (void) stopRun {
    [self.trackingManager stopTracking];
}

@end
