//
//  SubjectViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubjectViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@implementation SubjectViewController

@synthesize subjectName;

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
    
    NSString *urlString = [NSString stringWithFormat:@"http://lectureleaks.pagekite.me/api4/school/%@/subject/%@/",schoolName,subjectName];
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
    NSData *jsonData = [request responseData];
    
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSArray *items = [[jsonKitDecoder objectWithData:jsonData] retain];
    
    for(int i = 0; i < [items count]; i++)
    {
        NSDictionary *tmp = [items objectAtIndex:i];
        NSDictionary *fields = [tmp objectForKey:@"fields"];
        NSString *course = [fields objectForKey:@"course"];
        if(course)
            [contentList addObject:course];
    }
    
    [items release];
    
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
