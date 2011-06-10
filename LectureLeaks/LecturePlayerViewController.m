//
//  LecturePlayerViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LecturePlayerViewController.h"


@implementation LecturePlayerViewController
@synthesize titleLabel;
@synthesize classLabel;
@synthesize schoolLabel;
@synthesize playButton;
@synthesize dateLabel;
@synthesize lecture;

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
    [titleLabel release];
    [classLabel release];
    [schoolLabel release];
    [playButton release];
    [dateLabel release];
    [player release];
    [lecture release];
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
    titleLabel.text = lecture.title;
    classLabel.text = lecture.className;
    schoolLabel.text = lecture.school;
    dateLabel.text = [lecture.date description];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];     
    
    NSString* path = [documentsDirectory stringByAppendingPathComponent:lecture.fileName];
    NSURL *url = [NSURL fileURLWithPath:path];
    
	NSError *error;
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
	if (player == nil)
		NSLog(@"%@",[error description]);

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_background.png"]];

}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setClassLabel:nil];
    [self setSchoolLabel:nil];
    [self setPlayButton:nil];
    [self setDateLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)playPressed:(id)sender 
{
    if(![player isPlaying])
    {
        [player play];
    }
    else
    {
        [player pause];
    }
}

- (IBAction)stopPressed:(id)sender 
{
    [player stop];
}
@end
