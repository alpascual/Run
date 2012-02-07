//
//  DetailsMenuViewController.m
//  Run
//
//  Created by Al Pascual on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsMenuViewController.h"

@implementation DetailsMenuViewController

@synthesize delegate = _delegate;
@synthesize uniqueID = _uniqueID;
@synthesize menuArray = _menuArray;
@synthesize tableView = _tableView;

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
    
    self.title = @"Details Menu";
    
    self.menuArray = [[NSMutableArray alloc] init];
    [self.menuArray addObject:@"View Map"];
    [self.menuArray addObject:@"Analyze"];
    [self.menuArray addObject:@"Share"];    
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
    [self.delegate Finish];
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
    /*if([[segue identifier] isEqualToString:@"selectedMenu"])
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
    else if ([[segue identifier] isEqualToString:@"segueAbout"])
    {
        AboutViewController *controller =[segue destinationViewController];
        controller.delegate=self;
    }*/
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    NSString *menuString = [self.menuArray objectAtIndex:selectedPath.row];
    
    if ( [menuString isEqualToString:@"Run"] )    
        [self performSegueWithIdentifier:@"selectedMenu" sender:self];
    
    else if ( [menuString isEqualToString:@"History"] )
        [self performSegueWithIdentifier:@"selectedMenu2" sender:self];
    
    else if ( [menuString isEqualToString:@"Settings"] )
        [self performSegueWithIdentifier:@"segueSettings" sender:self];
    
    else if ( [menuString isEqualToString:@"About"] )
        [self performSegueWithIdentifier:@"segueAbout" sender:self];
    */
}

@end
