//
//  HistoryViewController.m
//  Run
//
//  Created by Albert Pascual on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"

@implementation HistoryViewController

@synthesize tableView = _tableView;
@synthesize delegate = _delegate;
@synthesize database = _database;
@synthesize historyRaw = _historyRaw;
@synthesize uniqueIDForSegue = _uniqueIDForSegue;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"History";
    
    self.database = [[GpsDatabaseManager alloc] init];
    self.historyRaw = [self.database getAllSessions];
    
    [self.tableView reloadData];
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
    
    [self.delegate FinishHistory];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ( self.historyRaw != nil )
        return self.historyRaw.count;
    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSUInteger row = [indexPath row]; 
    
    NSManagedObject *info = [self.historyRaw objectAtIndex:row];
    
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    
    NSString *weekDay = [theDateFormatter stringFromDate:[info valueForKey:@"when"]];
    NSString *theTime = [timeFormat stringFromDate:[info valueForKey:@"when"]];
    
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ %@", weekDay, theTime];
    cell.detailTextLabel.numberOfLines = 5;     
    
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"Distance: %@\nTime: %@:%@:%@\nMax. Speed %@", [info valueForKey:@"totalDistance"], 
                                 [info valueForKey:@"totalTimeHours"],
                                 [info valueForKey:@"totalTimeMinutes"],
                                 [info valueForKey:@"totalTimeSeconds"],
                                 [info valueForKey:@"speedMax"]];
    
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
        
    // add a picture or route
    cell.imageView.image = [UIImage imageNamed:@"route61logo1.jpg"];
    
    /*UIImage *backImage = [UIImage imageNamed:@"UITableSelection.png"];
     UIImageView *imageView = [[UIImageView alloc] initWithImage:backImage];    
     cell.backgroundView = imageView;*/
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{   
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row]; 
    
    NSManagedObject *info = [self.historyRaw objectAtIndex:row];
    
    self.uniqueIDForSegue = [info valueForKey:@"uniqueID"];
    
    // pass this to the new UI remember the segue.
    [self performSegueWithIdentifier:@"segueToDetailsMenu" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{   
    DetailsMenuViewController *controller=[segue destinationViewController];
    controller.delegate=self;
    controller.uniqueID = self.uniqueIDForSegue;
}

- (void) Finish {
    [self dismissModalViewControllerAnimated:YES];    
}

@end
