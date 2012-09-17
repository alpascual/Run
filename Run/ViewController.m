//
//  ViewController.m
//  Run
//
//  Created by Al Pascual on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize tableView = _tableView;
@synthesize menuArray = _menuArray;
@synthesize sparkLineViewOverview = _sparkLineViewOverview;
@synthesize totalTime = _totalTime;
@synthesize backGroundImageChart = _backGroundImageChart;
@synthesize timer = _timer;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.menuArray = [[NSMutableArray alloc] init];
    [self.menuArray addObject:@"Run"];
    [self.menuArray addObject:@"History"];
    [self.menuArray addObject:@"Settings"];
    [self.menuArray addObject:@"Progress"];
    [self.menuArray addObject:@"About"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:
                  @selector(buildGraph:) userInfo:nil repeats:NO];
    
    // Send them to the map if default exist
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ( [defaults objectForKey:@"endItem"] != nil )
        [self performSegueWithIdentifier:@"segueMap" sender:self];
    
}

- (void) buildGraph:(NSTimer *)timer {
    
    //call database manager and create the chart if data
    GpsDatabaseManager *database = [[GpsDatabaseManager alloc] init];
    NSArray *allSessions = [database getAllSessions];
    if ( allSessions.count > 0)
    {
        self.totalTime = [[NSMutableArray alloc] init];
        for (NSManagedObject *info in allSessions) {
            //TODO get each objects and added to a list?
            NSNumber *dTotalDistance = [info valueForKey:@"totalDistance"];
            NSLog(@"total distance: %@", dTotalDistance);
            
            [self.totalTime addObject:dTotalDistance];
        }  
        
        self.sparkLineViewOverview.dataValues = self.totalTime;
        self.sparkLineViewOverview.labelText = @"Progress";
        self.sparkLineViewOverview.currentValueColor = [UIColor redColor];
        self.sparkLineViewOverview.penColor = [UIColor whiteColor];
        self.sparkLineViewOverview.penWidth = 3.0f;
        self.sparkLineViewOverview.rangeOverlayLowerLimit = nil;
        self.sparkLineViewOverview.rangeOverlayUpperLimit = nil;
        self.sparkLineViewOverview.showCurrentValue = NO;
        
        
    }
    else {
        self.sparkLineViewOverview.hidden = YES;
        self.backGroundImageChart.hidden = YES;
    }
    
    // Init the user defaults if none exist
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    if ( [userDefaults objectForKey:@"setting1"] == nil &&
        [userDefaults objectForKey:@"setting2"] == nil)
    {
        [userDefaults setObject:@"0" forKey:@"setting1"];
        [userDefaults setObject:@"0" forKey:@"setting2"];
        [userDefaults setObject:@"0" forKey:@"setting3"];
        [userDefaults setObject:@"0" forKey:@"setting4"];
        [userDefaults setObject:@"0" forKey:@"setting5"];
        [userDefaults setObject:@"0" forKey:@"setting6"];
        [userDefaults setObject:@"0" forKey:@"setting7"];
        [userDefaults synchronize];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    // Configure the cell.
    cell.textLabel.text = [self.menuArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"selectedMenu"])
    {
        RunViewController *controller=[segue destinationViewController];
        controller.delegate=self;
    }
    else if ([[segue identifier] isEqualToString:@"selectedMenu2"])
    {
        HistoryViewController *controller=[segue destinationViewController];
        controller.delegate=self;
    }
    else if ([[segue identifier] isEqualToString:@"segueSettings"])
    {
        SettingsViewController *controller =[segue destinationViewController];
        controller.delegate=self;
    }
    else if ([[segue identifier] isEqualToString:@"segueProgress"])
    {
        ProgressViewController *controller =[segue destinationViewController];
        controller.delegate=self;
    }
    else if ([[segue identifier] isEqualToString:@"segueAbout"])
    {
        AboutViewController *controller =[segue destinationViewController];
        controller.delegate=self;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    NSString *menuString = [self.menuArray objectAtIndex:selectedPath.row];
    
    if ( [menuString isEqualToString:@"Run"] )    
        [self performSegueWithIdentifier:@"selectedMenu" sender:self];
        
    else if ( [menuString isEqualToString:@"History"] )
        [self performSegueWithIdentifier:@"selectedMenu2" sender:self];
        
    else if ( [menuString isEqualToString:@"Settings"] )
        [self performSegueWithIdentifier:@"segueSettings" sender:self];
    
    else if ( [menuString isEqualToString:@"Progress"])
        [self performSegueWithIdentifier:@"segueProgress" sender:self];
    
    else if ( [menuString isEqualToString:@"About"] )
        [self performSegueWithIdentifier:@"segueAbout" sender:self];
        
}

- (void) FinishHistory {
    [self dismissModalViewControllerAnimated:YES];
    
    [self.tableView reloadData];
}

- (void) FinishRun {
    [self dismissModalViewControllerAnimated:YES];
    
    [self.tableView reloadData];
}

-(void) FinishSettings {
    [self dismissModalViewControllerAnimated:YES];
    
    [self.tableView reloadData];
}

-(void) FinishAbout {
    [self dismissModalViewControllerAnimated:YES];
    
    [self.tableView reloadData];
}

@end
