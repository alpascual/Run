//
//  SettingsItemViewController.m
//  Run
//
//  Created by Albert Pascual on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsItemViewController.h"

@implementation SettingsItemViewController

@synthesize list = _list;
@synthesize showLabel = _showLabel;
@synthesize delegate = _delegate;
@synthesize menuNumber = _menuNumber;
@synthesize tableView = _tableView;
@synthesize selectedString = _selectedString;
@synthesize mydescription = _mydescription;

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
    
    self.showLabel.text = self.mydescription;
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    if ( [userDefaults objectForKey:[[NSString alloc] initWithFormat:@"setting%d", self.menuNumber]] != nil) {
        self.selectedString = [userDefaults objectForKey:[[NSString alloc] initWithFormat:@"setting%d", self.menuNumber]];
    
        NSLog(@"Selected String %@", self.selectedString);
    }
    else
        self.selectedString = nil;
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
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
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    // Configure the cell.
    cell.textLabel.text = [self.list objectAtIndex:indexPath.row];
    
    if ( self.selectedString != nil ) {
         NSLog(@"Selected String %@ and cell %@ for menu %d", self.selectedString, cell.textLabel.text, self.menuNumber);
        
        // Store the menu and the selected item
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.selectedString forKey:[[NSString alloc] initWithFormat:@"%d", self.menuNumber]];
        [defaults synchronize];
        
        if ( [self.selectedString isEqualToString:cell.textLabel.text] ) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }  
        
        if ( [self.selectedString isEqualToString:@"0"] && indexPath.row == 0 )
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    NSString *selectedItem = [self.list objectAtIndex:selectedPath.row];
    NSLog(@"Item Selected %@", selectedItem);
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    [userDefaults setObject:selectedItem forKey:[[NSString alloc] initWithFormat:@"setting%d", self.menuNumber]];
    [userDefaults synchronize];
    
    [self.delegate SelectedDone];
    
}


@end
