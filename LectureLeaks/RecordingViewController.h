//
//  RecordingViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/7/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQRecorder.h"
#import "AQPlayer.h"

@interface RecordingViewController : UIViewController <UITextFieldDelegate>
{
    AQRecorder *recorder;
    AQPlayer *player;
    BOOL playbackWasInterrupted;
    BOOL playbackWasPaused;
    UILabel *recordingLabel;
    UIBarButtonItem *recordButton;
    UIBarButtonItem *playButton;
    UIBarButtonItem *submitButton;
    UITextField *titleTextField;
    UITextField *classTextField;
    UITextField *schoolTextField;
    NSString *currentFileName;
}
@property (nonatomic, retain) IBOutlet UILabel *recordingLabel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *recordButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *submitButton;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextField *classTextField;
@property (nonatomic, retain) IBOutlet UITextField *schoolTextField;

@property (nonatomic, retain) NSString *currentFileName;

@property (readonly) AQRecorder *recorder;
@property (readonly) AQPlayer *player;
@property BOOL playbackWasInterrupted;
@property BOOL playbackWasPaused;

- (void)pausePlayQueue;
- (void)stopPlayQueue;
- (void)playbackQueueStopped:(NSNotification *)note;
- (void)playbackQueueResumed:(NSNotification *)note;

- (IBAction)record:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)submit:(id)sender;

@end
