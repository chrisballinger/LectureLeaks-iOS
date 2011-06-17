//
//  RecordingsListViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011. All rights reserved.
//

#import "RecordingsListViewController.h"
#import "LecturePlayerViewController.h"
#import "Lecture.h"

@implementation RecordingsListViewController

@synthesize listContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];        
        NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:documentsDirectory];
        NSMutableArray *lectureList = [[NSMutableArray alloc] init];
        Lecture *newLecture;
        
        NSString *filename;
        
        while ((filename = [direnum nextObject] )) 
        {
            if ([filename hasSuffix:@".audio.plist"]) 
            {                                   
                newLecture = [Lecture lectureWithFile:filename];
                [lectureList addObject:newLecture];
            }
        }
        listContent = lectureList;
    }
    return self;
}

#pragma mark -
#pragma mark UITableView data source and delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listContent count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	Lecture *lecture = nil;
    
    lecture = [self.listContent objectAtIndex:indexPath.row];
    
	cell.textLabel.text = lecture.name;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LecturePlayerViewController *lecturePlayerController = [[LecturePlayerViewController alloc] init];
    

	Lecture *lecture = nil;
    lecture = [self.listContent objectAtIndex:indexPath.row];
    
	lecturePlayerController.title = lecture.name;
    lecturePlayerController.lecture = lecture;
    
    [[self navigationController] pushViewController:lecturePlayerController animated:YES];
    [lecturePlayerController release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        [[listContent objectAtIndex:indexPath.row] deleteFiles];
        
        [listContent removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
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
    // Do any additional setup after loading the view from its nib.    
    
    self.editButtonItem.target = self;
    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];    
    self.title = @"My Recordings";

}

- (void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
