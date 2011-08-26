//
//  CourseViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CourseViewController.h"
#import "Lecture.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "LecturePlayerViewController.h"

@implementation CourseViewController

@synthesize courseName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"SchoolViewController" bundle:nibBundleOrNil];
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

    NSString *urlString = [NSString stringWithFormat:@"http://lectureleaks.com/api4/school/%@/subject/%@/course/%@/",schoolName,subjectName,courseName];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous]; 
    
    contentList = [[NSMutableArray alloc] init];
    
    self.title = courseName;
    
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    NSData *jsonData = [request responseData];
    NSLog(@"%@",[request responseString]);

    
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSArray *items = [[jsonKitDecoder objectWithData:jsonData] retain];
    Lecture *lecture;
    NSString *prefix = @"http://lectureleaks.com/uploads/";
    
    for(int i = 0; i < [items count]; i++)
    {
        NSDictionary *tmp = [items objectAtIndex:i];
        NSDictionary *fields = [tmp objectForKey:@"fields"];
        NSString *school = schoolName;
        NSString *name = [fields objectForKey:@"name"];
        if(name)
        {
            NSString *tags = [fields objectForKey:@"tags"];
            NSString *professor = [fields objectForKey:@"professor"];
            NSString *course = courseName;
            NSString *doc_file = [fields objectForKey:@"doc_file"];
            NSString *dateString = [fields objectForKey:@"date"];
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
            NSDate *date = [dateFormatter dateFromString:dateString];
            
            NSNumber *approved = [fields objectForKey:@"approved"];
            NSString *subject = subjectName;
            
            NSURL* url = [NSURL URLWithString:[prefix stringByAppendingString:doc_file]];
            
            lecture = [Lecture lectureWithName:name course:course professor:professor school:school subject:subject tags:tags url:url approved:approved date:date submitDate:nil];
            lecture.isRemoteFile = YES;
            [contentList addObject:lecture];
        }
    }
    
    [items release];
    
    [self.mainTableView reloadData];
    
    [HUD hide:YES afterDelay:1.0];
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
    cell.textLabel.text = [[contentList objectAtIndex:indexPath.row] name];
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
    LecturePlayerViewController *lecturePlayerController = [[LecturePlayerViewController alloc] init];
    lecturePlayerController.lecture = [contentList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:lecturePlayerController animated:YES];
    [lecturePlayerController release];
}

@end
