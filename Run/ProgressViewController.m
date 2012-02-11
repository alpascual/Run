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
    
    //self.historyRaw = [self reversedArray:self.historyRaw];
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
