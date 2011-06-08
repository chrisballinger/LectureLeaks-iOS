//
//  LectureLeaksViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011. All rights reserved.
//

#import "LectureLeaksViewController.h"
#import "RecordingViewController.h"
#import "LearnViewController.h"
#import "AboutViewController.h"
#import "ScheduleViewController.h"

@implementation LectureLeaksViewController

@synthesize navigationController;

- (void)dealloc
{
    [navigationController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)recordPressed:(id)sender 
{
    RecordingViewController *recordController = [[RecordingViewController alloc] init];
    
    [self.navigationController pushViewController:recordController animated:YES];
}

- (IBAction)learnPressed:(id)sender 
{
    LearnViewController *learnController = [[LearnViewController alloc] init];
    [self.navigationController pushViewController:learnController animated:YES];
}

- (IBAction)schedulePressed:(id)sender 
{
    ScheduleViewController *scheduleController = [[ScheduleViewController alloc] init];
    [self.navigationController pushViewController:scheduleController animated:YES];
}

- (IBAction)aboutPressed:(id)sender 
{
    AboutViewController *aboutController = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutController animated:YES];
}
@end
