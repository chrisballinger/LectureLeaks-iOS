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
#import "LectureLeaksViewController.h"
#import <EventKit/EventKit.h>
#import <CoreAudio/CoreAudioTypes.h>

static Boolean IsAACHardwareEncoderAvailable(void)
{
    Boolean isAvailable = false;
	
    // get an array of AudioClassDescriptions for all installed encoders for the given format 
    // the specifier is the format that we are interested in - this is 'aac ' in our case
    UInt32 encoderSpecifier = kAudioFormatMPEG4AAC;
    UInt32 size;
	
    OSStatus result = AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size);
    if (result) { printf("AudioFormatGetPropertyInfo kAudioFormatProperty_Encoders result %lu %4.4s\n", result, (char*)&result); return false; }
	
    UInt32 numEncoders = size / sizeof(AudioClassDescription);
    AudioClassDescription encoderDescriptions[numEncoders];
    
    result = AudioFormatGetProperty(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size, encoderDescriptions);
    if (result) { printf("AudioFormatGetProperty kAudioFormatProperty_Encoders result %lu %4.4s\n", result, (char*)&result); return false; }
    
    for (UInt32 i=0; i < numEncoders; ++i) {
        if (encoderDescriptions[i].mSubType == kAudioFormatMPEG4AAC && encoderDescriptions[i].mManufacturer == kAppleHardwareAudioCodecManufacturer) isAvailable = true;
    }
	
    return isAvailable;
}

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
        date = [[NSDate date] retain];
        time_t unixTime = (time_t) [date timeIntervalSince1970];
        NSString* currentFileName = [NSString stringWithFormat:@"%d.caf",unixTime];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];        
        NSString* path = [documentsDirectory stringByAppendingPathComponent:currentFileName];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error;
        
        int kAudioFormat;
        
        if(IsAACHardwareEncoderAvailable())
        {
            kAudioFormat = kAudioFormatMPEG4AAC;
        }
        else
        {
            kAudioFormat = kAudioFormatAppleIMA4;
        }
        
        NSDictionary *recordSettings =
        
        [[NSDictionary alloc] initWithObjectsAndKeys:
         
         [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
         [NSNumber numberWithInt: kAudioFormat], AVFormatIDKey,
         [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
         [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
         
         nil];
        
        recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
        
        if(error)
            NSLog(@"%@",[error description]);
        
        [recorder prepareToRecord];
        
        /*OSStatus error = AudioSessionSetActive(true); 
        if (error) 
        {
            NSLog(@"AudioSessionSetActive (true) failed");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Microphone Error" message:@"If you are trying to record on an iPod Touch, headphones with a microphone must be plugged in before you can record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }*/
    }
    return self;
}

- (void)dealloc
{
    [recorder release];
    [recordingLabel release];
    [recordButton release];
    [titleTextField release];
    [classTextField release];
    [schoolTextField release];
    [date release];
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

    NSString* fileName = @"data.plist";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];        
    NSString *metadataPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSDictionary *metadata = [[[NSDictionary alloc] initWithContentsOfFile:metadataPath] autorelease];
    
    schoolTextField.text = [metadata objectForKey:@"school"];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    int secondsBefore = 15*60;
    int secondsAfter = 60*60;
    
    NSArray *matchingEvents = [eventStore eventsMatchingPredicate:[eventStore predicateForEventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:secondsBefore] endDate:[NSDate dateWithTimeIntervalSinceNow:secondsAfter] calendars:nil]];
    if(matchingEvents)
        classTextField.text = [[matchingEvents objectAtIndex:0] title];
    
    [eventStore release];
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
    if(recorder.recording)
    {
        [recorder stop];
        //AudioSessionSetActive(false);
        
        [recordingTimer invalidate];
        
        LearnViewController *learnController = [[LearnViewController alloc] init];
        RecordingsListViewController *recordingListController = [[RecordingsListViewController alloc] init];
        LecturePlayerViewController *lecturePlayerController = [[LecturePlayerViewController alloc] init];
        LectureLeaksViewController *dashboardController  = [[LectureLeaksViewController alloc] init];
        
        lecturePlayerController.lecture = self.lecture;
                
        NSArray *controllers = [NSArray arrayWithObjects:dashboardController,learnController,recordingListController,lecturePlayerController,nil];
        [self.navigationController setViewControllers:controllers animated:YES];
         
        [lecture release];
        [learnController release];
        [recordingListController release];
        [lecturePlayerController release];
        [dashboardController release];
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
            
                         
            //recorder->StartRecord((CFStringRef)currentFileName);
            [recorder record];
            
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
