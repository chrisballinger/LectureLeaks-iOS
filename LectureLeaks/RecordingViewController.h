//
//  RecordingViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/7/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQRecorder.h"
#import "Lecture.h"

@interface RecordingViewController : UIViewController <UITextFieldDelegate>
{
    AQRecorder *recorder;
    BOOL playbackWasInterrupted;
    BOOL playbackWasPaused;
    UILabel *recordingLabel;
    UIBarButtonItem *recordButton;
    UITextField *titleTextField;
    UITextField *classTextField;
    UITextField *schoolTextField;
    NSTimer *recordingTimer;
    NSTimeInterval startTime;
    Lecture *lecture;
}
@property (nonatomic, retain) IBOutlet UILabel *recordingLabel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *recordButton;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextField *classTextField;
@property (nonatomic, retain) IBOutlet UITextField *schoolTextField;

@property (nonatomic, retain) NSTimer *recordingTimer;
@property (nonatomic, retain) Lecture *lecture;
@property NSTimeInterval startTime;

@property (readonly) AQRecorder *recorder;

- (void) updateElapsedTime:(NSTimer *) timer;

- (IBAction)record:(id)sender;

@end
