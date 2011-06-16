//
//  RecordingViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/7/11.
//  Copyright 2011. All rights reserved.
//

#import "RecordingViewController.h"
#import "LecturePlayerViewController.h"
#import "LearnViewController.h"
#import "RecordingsListViewController.h"

@implementation RecordingViewController

@synthesize recordingLabel;
@synthesize recordButton;
@synthesize titleTextField;
@synthesize classTextField;
@synthesize schoolTextField;
@synthesize recorder;
@synthesize recordingTimer;
@synthesize startTime;
@synthesize lecture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        recorder = new AQRecorder();
        
        OSStatus error = AudioSessionSetActive(true); 
        if (error) 
        {
            NSLog(@"AudioSessionSetActive (true) failed");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Microphone Error" message:@"If you are trying to record on an iPod Touch, headphones with a microphone must be plugged in before you can record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
    return self;
}

- (void)dealloc
{
    delete recorder;
    [recordingLabel release];
    [recordButton release];
    [titleTextField release];
    [classTextField release];
    [schoolTextField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_background.png"]];
    self.title = @"Record";

}

- (void)viewDidUnload
{
    [self setRecordingLabel:nil];
    [self setRecordButton:nil];
    [self setRecordButton:nil];
    [self setTitleTextField:nil];
    [self setClassTextField:nil];
    [self setSchoolTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)record:(id)sender 
{
    if(recorder->IsRunning())
    {
        recorder->StopRecord();
        AudioSessionSetActive(false);
        
        [recordingTimer invalidate];
        
        UINavigationController *navController = self.navigationController;
        
        LearnViewController *learnController = [[LearnViewController alloc] init];
        RecordingsListViewController *recordingListController = [[RecordingsListViewController alloc] init];
        LecturePlayerViewController *lecturePlayerController = [[LecturePlayerViewController alloc] init];
        
        lecturePlayerController.lecture = self.lecture;
        
        [[self retain] autorelease];
        
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:learnController animated:NO];
        [navController pushViewController:recordingListController animated:NO];
        [navController pushViewController:lecturePlayerController animated:YES];
        [lecture release];
    }
    else
    {
        if([titleTextField.text isEqualToString:@""] || [classTextField.text isEqualToString:@""] || [schoolTextField.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"More Info Please!" message:@"Please fill in all the fields and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        else
        {
            recordButton.title = @"Stop";
            NSDate* date = [NSDate date];
            time_t unixTime = (time_t) [date timeIntervalSince1970];
            NSString* currentFileName = [NSString stringWithFormat:@"%d.caf",unixTime];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];        
            NSString* path = [documentsDirectory stringByAppendingPathComponent:currentFileName];
            NSURL *url = [NSURL fileURLWithPath:path];
            
            lecture = [Lecture lectureWithName:titleTextField.text course:classTextField.text professor:nil school:schoolTextField.text subject:nil tags:nil url:url approved:FALSE date:date submitDate:nil];
            [lecture saveMetadata];
            [lecture retain];
            UIColor *grey = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
            titleTextField.textColor = grey;
            classTextField.textColor = grey;
            schoolTextField.textColor = grey;
            titleTextField.enabled = NO;
            classTextField.enabled = NO;
            schoolTextField.enabled = NO;
            
                         
            recorder->StartRecord((CFStringRef)currentFileName);
            
            startTime = [NSDate timeIntervalSinceReferenceDate];
            recordingTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                             selector:@selector(updateElapsedTime:) userInfo:nil repeats:YES] retain];

        }
        
    }

}

- (void) updateElapsedTime:(NSTimer *) timer
{
	int hour, minute, second;
	NSTimeInterval elapsedTime = [NSDate timeIntervalSinceReferenceDate] - startTime;
	hour = elapsedTime / 3600;
	minute = (elapsedTime - hour * 3600) / 60;
	second = (elapsedTime - hour * 3600 - minute * 60);
	recordingLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
