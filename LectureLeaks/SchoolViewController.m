//
//  SchoolViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SchoolViewController.h"
#import "SubjectViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@implementation SchoolViewController

@synthesize schoolName;
@synthesize contentList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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
    
    NSString *urlString = [NSString stringWithFormat:@"http://lectureleaks.com/api4/school/%@/",schoolName];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous]; 
    
    contentList = [[NSMutableArray alloc] init];

    self.title = schoolName;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    NSData *jsonData = [[request responseData] retain];
    NSLog(@"%@",[request responseString]);

    NSString *fix = [[request responseString] stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    fix = [fix stringByReplacingOccurrencesOfString:@"\": u\""withString:@"\": \""];
    NSLog(@"%@",fix);
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    //NSArray *items = [[jsonKitDecoder objectWithData:jsonData] retain];
    NSArray *items = [[jsonKitDecoder objectWithUTF8String:(const unsigned char*)[fix UTF8String] length:[fix length]] retain];
    
    NSLog(@"%d",[items count]);
    if([items count] > 0)
    {
        for(int i = 0; i < [items count]; i++)
        {
            NSDictionary *tmp = [items objectAtIndex:i];
            //NSDictionary *fields = [tmp objectForKey:@"fields"];
            NSString *subject = [tmp objectForKey:@"subject__name"];
            NSLog(@"%@",subject);
            if(subject)
                [contentList addObject:subject];
        }
    }
    else
    {
        NSDictionary *tmp = [[jsonKitDecoder objectWithData:jsonData] retain];
        NSString *subject = [tmp objectForKey:@"subject__name"];
        NSLog(@"%d %@",[tmp count], subject);
        if(subject)
            [contentList addObject:subject];
        [tmp release];
    }
    
    [items release];
    
    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [contentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [contentList objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubjectViewController *subjectController = [[SubjectViewController alloc] init];
    subjectController.subjectName = [contentList objectAtIndex:indexPath.row];
    subjectController.schoolName = self.schoolName;
    [self.navigationController pushViewController:subjectController animated:YES];
    [subjectController release];
}

@end
