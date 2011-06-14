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
@synthesize durationLabel;
@synthesize currentTimeLabel;
@synthesize dateLabel;
@synthesize submitLabel;
@synthesize lecture;
@synthesize playerUpdateTimer;
@synthesize playerSlider;
@synthesize playButton;
@synthesize stopButton;

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
    [dateLabel release];
    [player release];
    [lecture release];
    [durationLabel release];
    [currentTimeLabel release];
    [playerUpdateTimer release];
    [playerSlider release];
    [submitLabel release];
    [playButton release];
    [stopButton release];
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
    titleLabel.text = lecture.name;
    classLabel.text = lecture.course;
    schoolLabel.text = lecture.school;
    dateLabel.text = [lecture.date description];
        
	NSError *error;
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:lecture.url error:&error];
    
	if (player == nil)
		NSLog(@"%@",[error description]);

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_background.png"]];

    playerUpdateTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                selector:@selector(updateElapsedTime:) userInfo:nil repeats:YES] retain];
    int hour, minute, second;
	NSTimeInterval elapsedTime = player.duration;
	hour = elapsedTime / 3600;
	minute = (elapsedTime - hour * 3600) / 60;
	second = (elapsedTime - hour * 3600 - minute * 60);
	durationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    
    self.title = @"Lecture";

}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setClassLabel:nil];
    [self setSchoolLabel:nil];
    [self setDateLabel:nil];
    [self setDurationLabel:nil];
    [self setCurrentTimeLabel:nil];
    [self setPlayerSlider:nil];
    [self setSubmitLabel:nil];
    [self setPlayButton:nil];
    [self setStopButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// Update the call timer once a second.
- (void) updateElapsedTime:(NSTimer *) timer
{
	int hour, minute, second;
	NSTimeInterval elapsedTime = player.currentTime;
	hour = elapsedTime / 3600;
	minute = (elapsedTime - hour * 3600) / 60;
	second = (elapsedTime - hour * 3600 - minute * 60);
	currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    
    if(player.duration != 0)
        self.playerSlider.value = player.currentTime / player.duration;
    if(player.currentTime == 0)
    {
        stopButton.enabled = NO;
        playButton.title = @"Play";
    }
}

- (IBAction)seek:(id)sender 
{
    player.currentTime = self.playerSlider.value * player.duration;
    [self updateElapsedTime:nil];
    [player play];
}


- (IBAction)submitPressed:(id)sender {
}

- (IBAction)playPressed:(id)sender 
{
    if(![player isPlaying])
    {
        [player play];
        playButton.title = @"Pause";
        stopButton.enabled = YES;
    }
    else
    {
        [player pause];
        playButton.title = @"Play";
    }
}

- (IBAction)stopPressed:(id)sender 
{
    [player stop];
    player.currentTime = 0;
    [self updateElapsedTime:nil];
    stopButton.enabled = NO;
    playButton.title = @"Play";
}
@end
