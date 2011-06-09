//
//  LearnViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011. All rights reserved.
//

#import "LearnViewController.h"
#import "LecturePlayerViewController.h"
#import "Lecture.h"

@implementation LearnViewController

@synthesize lectureTableView;
@synthesize listContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];        
        NSDictionary *metadata = nil;
        NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:documentsDirectory];
        NSMutableArray *lectureList = [[NSMutableArray alloc] init];
        Lecture *newLecture;
        
        NSString *filename;
        NSString *prefix;
        
        while ((filename = [direnum nextObject] )) 
        {
            if ([filename hasSuffix:@".plist"]) 
            {   
                metadata = [[NSDictionary alloc] initWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:filename]];
                newLecture = [[Lecture alloc] init];
                prefix = [[filename componentsSeparatedByString:@"."] objectAtIndex:0];
                
                newLecture.title = [metadata objectForKey:@"title"];
                newLecture.className = [metadata objectForKey:@"className"];
                newLecture.school = [metadata objectForKey:@"school"];
                newLecture.fileName = [prefix stringByAppendingString:@".caf"];
                newLecture.date = [[NSDate alloc] initWithTimeIntervalSince1970:[prefix doubleValue]];
                                
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
    
	cell.textLabel.text = lecture.title;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LecturePlayerViewController *lecturePlayerController = [[LecturePlayerViewController alloc] init];
    

	Lecture *lecture = nil;
    lecture = [self.listContent objectAtIndex:indexPath.row];
    
	lecturePlayerController.title = lecture.title;
    lecturePlayerController.lecture = lecture;
    
    [[self navigationController] pushViewController:lecturePlayerController animated:YES];
    [lecturePlayerController release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *cafPath = [documentsDirectoryPath stringByAppendingPathComponent:[[listContent objectAtIndex:indexPath.row] fileName]];
        NSString *plistPath = [cafPath stringByReplacingOccurrencesOfString:@"caf" withString:@"plist"];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:cafPath error:NULL];
        [fileManager removeItemAtPath:plistPath error:NULL];
        
        [listContent removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)dealloc
{
    [lectureTableView release];
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
}

-(void)editButtonPressed
{
    [lectureTableView setEditing:YES animated:YES];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setLectureTableView:nil];
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
