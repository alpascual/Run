//
//  SettingsViewController.m
//  Run
//
//  Created by Albert Pascual on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize delegate = _delegate;
@synthesize tableView = _tableView;
@synthesize settingList = _settingList;
@synthesize lastMenuSelected = _lastMenuSelected;

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
    
    self.title = @"Settings";
    
    self.settingList = [[NSMutableArray alloc] init];
    [self.settingList addObject:@"Music Playlist"];
    // TODO create In-App for this
    [self.settingList addObject:@"Voice Feedback by Distance"];
    [self.settingList addObject:@"Voice Feedback by Time"];
    [self.settingList addObject:@"Enable Pebble Watch"];
    
    //[self.settingList addObject:@"Distance Units"];
    //[self.settingList addObject:@"Alert if I am too slow"];
    //[self.settingList addObject:@"Stop music if I stop"];
    
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
    [self.delegate FinishSettings];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingList.count;
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
    cell.textLabel.text = [self.settingList objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont fontWithName: @"Arial" size: 14.0 ];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{   
    NSMutableArray *subMenu = [[NSMutableArray alloc] init];
    
    SettingsItemViewController  *item = [segue destinationViewController];
    @try {
        item.delegate = self;
    }
    @catch (NSException *exception) {
        return;
    }
    
    if ( self.lastMenuSelected == 0 ) {
        [subMenu addObject:@"none"];
        //playlist
        playListFeedback *playlist = [[playListFeedback alloc] init];
        [subMenu addObjectsFromArray:[playlist rerieveList]];
        item.list = subMenu;
        item.mydescription = @"Select the playlist of music you want to play while running";
        item.menuNumber = self.lastMenuSelected;
    }
    else if (self.lastMenuSelected == 1 ) {
        [subMenu addObject:@"none"];
        [subMenu addObject:@"every 1 mile"];
        //[subMenu addObject:@"every 5K"];
        [subMenu addObject:@"every 5 miles"];
        item.list = subMenu;
        item.mydescription = @"Select when you want an status of your run";
        item.menuNumber = self.lastMenuSelected;
    }
    else if (self.lastMenuSelected == 2 ) {
        [subMenu addObject:@"none"];
        [subMenu addObject:@"every 10 minutes"];
        [subMenu addObject:@"every 20 minutes"];
        [subMenu addObject:@"every 30 minutes"];
        [subMenu addObject:@"every 1 hour"];
        item.list = subMenu;
        item.mydescription = @"Select when you want an status of your run";
        item.menuNumber = self.lastMenuSelected;
    }
    else if ( self.lastMenuSelected == 3 ) {
        [subMenu addObject:@"Enabled"];
        [subMenu addObject:@"Disabled"];
        item.list = subMenu;
        item.mydescription = @"Enabled to connect to your pebble";
        item.menuNumber = self.lastMenuSelected;
    }
    else if (self.lastMenuSelected == 4 ) {
        [subMenu addObject:@"miles"];
        [subMenu addObject:@"kilometers"];
        item.list = subMenu;
        item.mydescription = @"Select if you like miles or kilometers";
        item.menuNumber = self.lastMenuSelected;
    }
    else if (self.lastMenuSelected == 4 ) {
        [subMenu addObject:@"no"];
        [subMenu addObject:@"yes"];
        item.list = subMenu;
        item.mydescription = @"If you are just walking or jogging instead of running, your iphone will vibrate";
        item.menuNumber = self.lastMenuSelected;
    }
    else if (self.lastMenuSelected == 5 ) {
        [subMenu addObject:@"no"];
        [subMenu addObject:@"yes"];
        item.list = subMenu;
        item.mydescription = @"If you stop running or jogging, the music will pause until you resume";
        item.menuNumber = self.lastMenuSelected;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    self.lastMenuSelected = selectedPath.row;
    
    [self performSegueWithIdentifier:@"segueSettingsItems" sender:self];
    
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{   
    return 100;
}*/


-(void)SelectedDone {
    [self dismissModalViewControllerAnimated:YES];
    
    [self.tableView reloadData];
}

@end
