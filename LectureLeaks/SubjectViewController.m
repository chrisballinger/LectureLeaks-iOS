//
//  SubjectViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubjectViewController.h"
#import "CourseViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@implementation SubjectViewController

@synthesize subjectName;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *urlString = [NSString stringWithFormat:@"http://lectureleaks.com/api4/school/%@/subject/%@/",schoolName,subjectName];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous]; 
        
    contentList = [[NSMutableArray alloc] init];
    
    self.title = subjectName;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    //NSData *jsonData = [request responseData];
    NSLog(@"%@",[request responseString]);

    NSString *fix = [[request responseString] stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    fix = [fix stringByReplacingOccurrencesOfString:@"\": u\""withString:@"\": \""];
    NSLog(@"%@",fix);
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    //NSArray *items = [[jsonKitDecoder objectWithData:jsonData] retain];
    NSArray *items = [[jsonKitDecoder objectWithUTF8String:(const unsigned char*)[fix UTF8String] length:[fix length]] retain];

    //JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    //NSArray *items = [[jsonKitDecoder objectWithData:jsonData] retain];
    
    for(int i = 0; i < [items count]; i++)
    {
        NSDictionary *tmp = [items objectAtIndex:i];
        //NSDictionary *fields = [tmp objectForKey:@"fields"];
        NSString *course = [tmp objectForKey:@"course__name"];
        if(course)
            [contentList addObject:course];
    }
    
    [items release];
    
    [self.mainTableView reloadData];
    
    [HUD hide:YES afterDelay:1.0];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseViewController *courseController = [[CourseViewController alloc] init];
    courseController.courseName = [contentList objectAtIndex:indexPath.row];
    courseController.schoolName = self.schoolName;
    courseController.subjectName = self.subjectName;
    [self.navigationController pushViewController:courseController animated:YES];
    [courseController release];
}

@end
