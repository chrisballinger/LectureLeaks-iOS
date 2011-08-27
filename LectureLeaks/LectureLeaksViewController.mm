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
#import "SettingsViewController.h"

@implementation LectureLeaksViewController


#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_background.png"]];
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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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

- (IBAction)settingsPressed:(id)sender {
    SettingsViewController *settingsController = [[SettingsViewController alloc] init];
    //[self presentModalViewController:settingsController animated:YES];
    [self.navigationController pushViewController:settingsController animated:YES];
}
@end
