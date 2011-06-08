//
//  RecordViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordingViewController.h"
#import "LectureLeaksAppDelegate.h"

@implementation RecordViewController

@synthesize recordingHasBeenMade;
@synthesize submitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        recordingHasBeenMade = NO;
        submitButton.enabled = NO;
    }
    return self;
}

- (void)dealloc
{
    [submitButton release];
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
}

- (void)viewDidUnload
{
    [self setSubmitButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)recordPressed:(id)sender 
{
    recordingHasBeenMade = YES;
    RecordingViewController *recordingController = [[RecordingViewController alloc] init];
    recordingController.recordController = self;
    UIApplication *app = [UIApplication sharedApplication];
    [((LectureLeaksAppDelegate*)(app.delegate)).navigationController pushViewController:recordingController animated:YES];
}
@end
