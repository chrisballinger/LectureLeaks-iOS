//
//  RecordingViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecordingViewController.h"
#import "LectureLeaksAppDelegate.h"

@implementation RecordingViewController

@synthesize recordingLabel;
@synthesize recordButton;
@synthesize playButton;
@synthesize submitButton;
@synthesize recorder;
@synthesize player;
@synthesize playbackWasInterrupted;
@synthesize playbackWasPaused;

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
    delete recorder;
    delete player;
    [recordingLabel release];
    [recordButton release];
    [playButton release];
    [submitButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)stopPlayQueue
{
	player->StopQueue();
	recordButton.enabled = YES;
}

-(void)pausePlayQueue
{
	player->PauseQueue();
	playbackWasPaused = YES;
}

# pragma mark Notification routines
- (void)playbackQueueStopped:(NSNotification *)note
{
    playButton.title = @"Play";
	recordButton.enabled = YES;
}

- (void)playbackQueueResumed:(NSNotification *)note
{
    playButton.title = @"Stop";
	recordButton.enabled = NO;
}


#pragma mark AudioSession listeners
void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState)
{
	RecordingViewController *THIS = (RecordingViewController*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		if (THIS->recorder->IsRunning()) {
			THIS->recorder->StopRecord();
		}
		else if (THIS->player->IsRunning()) {
			//the queue will stop itself on an interruption, we just need to update the UI
			[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
			THIS->playbackWasInterrupted = YES;
		}
	}
	else if ((inInterruptionState == kAudioSessionEndInterruption) && THIS->playbackWasInterrupted)
	{
		// we were playing back when we were interrupted, so reset and resume now
		THIS->player->StartQueue(true);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:THIS];
		THIS->playbackWasInterrupted = NO;
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
			if (reasonVal == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
			{			
				if (THIS->player->IsRunning()) {
					[THIS pausePlayQueue];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
				}		
			}
            
			// stop the queue if we had a non-policy route change
			if (THIS->recorder->IsRunning()) {
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



#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    recorder = new AQRecorder();
    player = new AQPlayer();
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueStopped:) name:@"playbackQueueStopped" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueResumed:) name:@"playbackQueueResumed" object:nil];

}

- (void)awakeFromNib
{
}

- (void)viewDidUnload
{
    [self setRecordingLabel:nil];
    [self setPlayButton:nil];
    [self setRecordButton:nil];
    [self setRecordButton:nil];
    [self setPlayButton:nil];
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

- (IBAction)record:(id)sender 
{
    if(recorder->IsRunning())
    {
        recorder->StopRecord();
        
        // dispose the previous playback queue
        player->DisposeQueue(true);
        
        // now create a new queue for the recorded file
        player->CreateQueueForFile((CFStringRef)@"recordedFile.caf");
        recordButton.title = @"Record";
        playButton.enabled = YES;
        submitButton.enabled = YES;
    }
    else
    {
        recordButton.title = @"Stop";
        recorder->StartRecord(CFSTR("recordedFile.caf"));
        playButton.enabled = NO;
        submitButton.enabled = NO;
    }

}

- (IBAction)play:(id)sender 
{
    if (player->IsRunning())
	{
		if (playbackWasPaused) {
			OSStatus result = player->StartQueue(true);
			if (result == noErr)
				[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
		}
		else
			[self stopPlayQueue];
	}
	else
	{		
		OSStatus result = player->StartQueue(false);
		if (result == noErr)
			[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
	}
}

- (IBAction)submit:(id)sender {
}


@end
