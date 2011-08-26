//
//  LearnViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LearnViewController.h"
#import "RecordingsListViewController.h"
#import "SchoolViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

#define kCellIdentifier @"Cell"

@implementation LearnViewController

@synthesize contentArray;
@synthesize learnTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [learnTableView release];
    [super dealloc];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if(!isDataLoaded)
    {
        NSURL *url = [NSURL URLWithString:@"http://lectureleaks.com/api4/schools/"];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request startAsynchronous];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        
        [HUD show:YES];
    }
        
    contentArray = [[NSMutableArray alloc] init];
    NSMutableArray *myRecordings = [[NSMutableArray alloc] init];
    [myRecordings addObject:@"My Recordings"];
        
    [contentArray addObject:myRecordings];
    
    self.title = @"Learn";

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    NSData *jsonData = [request responseData];
    NSLog(@"%@",[request responseString]);
    
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSArray *items = [[jsonKitDecoder objectWithData:jsonData] retain];
    
    NSMutableArray *featuredSchools = [[NSMutableArray alloc] init];
    NSMutableArray *allSchools = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [items count]; i++)
    {
        NSDictionary *tmp = [items objectAtIndex:i];
        NSDictionary *fields = [tmp objectForKey:@"fields"];
        NSString *name = [fields objectForKey:@"name"];
        //NSNumber *featured = [fields objectForKey:@"featured"];
        if([name isEqualToString:@"Harvard University"] || [name isEqualToString:@"Yale University"] || [name isEqualToString:@"Massachusetts Institute Of Technology"])
        {
            [featuredSchools addObject:name];
        }
        else
        {
            [allSchools addObject:name];
        }
            
    }
    
    [contentArray addObject:featuredSchools];
    [contentArray addObject:allSchools];
    [items release];
    
    [self.learnTableView reloadData];
    isDataLoaded = YES;
    
    [HUD hide:YES afterDelay:0.5];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    [HUD hide:YES afterDelay:0.5];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [contentArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[contentArray objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
    {
        return @"My Recordings";
    }
    else if(section == 1)
    {
        return @"Featured";
    }
    else
    {
        return @"All Schools";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
	NSArray *section = [contentArray objectAtIndex:indexPath.section];
	cell.textLabel.text = [section objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0 && indexPath.row == 0)
    {
        RecordingsListViewController *recordingListController = [[RecordingsListViewController alloc] init];
        [self.navigationController pushViewController:recordingListController animated:YES];
    }
    else
    {
        SchoolViewController *schoolController = [[SchoolViewController alloc] init];
        schoolController.schoolName = [((NSArray*)[contentArray objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:schoolController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

- (void)viewDidUnload {
    [self setLearnTableView:nil];
    [super viewDidUnload];
}
@end
