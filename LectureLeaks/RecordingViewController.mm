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

#pragma mark AudioSession listeners
void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState)
{
	RecordingViewController *THIS = (RecordingViewController*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		if (THIS->recorder->IsRunning()) 
        {
			THIS->recorder->StopRecord();
		}
    }
}

void propListener(	void *                  inClientData,
                  AudioSessionPropertyID	inID,
                  UInt32                  inDataSize,
                  const void *            inData)
{
	RecordingViewController *THIS = (RecordingViewController*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;			
		//CFShow(routeDictionary);
		CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 reasonVal;
		CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
		if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
		{		
			// stop the queue if we had a non-policy route change
			if (THIS->recorder->IsRunning()) 
            {
                THIS->recorder->StopRecord();
			}
		}	
	}
	else if (inID == kAudioSessionProperty_AudioInputAvailable)
	{
		if (inDataSize == sizeof(UInt32)) {
			UInt32 isAvailable = *(UInt32*)inData;
			// disable recording if input is not available
            if(isAvailable > 0)
            {
                //THIS->btn_record.enabled =  YES;
                AudioSessionSetActive(true);
            }
            else
            {
                //THIS->btn_record.enabled =  NO;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Microphone Error" message:@"If you are trying to record on an iPod Touch, headphones with a microphone must be plugged in before you can record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
		}
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        recorder = new AQRecorder();
        
        OSStatus error = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
        if (error) printf("ERROR INITIALIZING AUDIO SESSION! %ld\n", error);
        else 
        {
            UInt32 category = kAudioSessionCategory_PlayAndRecord;	
            error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
            if (error) printf("couldn't set audio category!");
            
            error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
            if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %ld\n", error);
            UInt32 inputAvailable = 0;
            UInt32 size = sizeof(inputAvailable);
            
            // we do not want to allow recording if input is not available
            error = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &inputAvailable);
            if (error) printf("ERROR GETTING INPUT AVAILABILITY! %ld\n", error);
            //btn_record.enabled = (inputAvailable) ? YES : NO;
            
            // we also need to listen to see if input availability changes
            error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, propListener, self);
            if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %ld\n", error);
            
            error = AudioSessionSetActive(true); 
            if (error) 
            {
                printf("AudioSessionSetActive (true) failed");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Microphone Error" message:@"If you are trying to record on an iPod Touch, headphones with a microphone must be plugged in before you can record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
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
            
            lecture = [Lecture lectureWithTitle:titleTextField.text className:classTextField.text school:schoolTextField.text fileName:currentFileName date:date submitDate:nil];
            [lecture saveMetadata];
            [lecture retain];
            
            startTime = [NSDate timeIntervalSinceReferenceDate];
            recordingTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                            selector:@selector(updateElapsedTime:) userInfo:nil repeats:YES] retain];
             
            recorder->StartRecord((CFStringRef)currentFileName);
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
