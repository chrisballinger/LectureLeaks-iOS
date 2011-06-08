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

@interface RecordingViewController : UIViewController 
{
    AQRecorder *recorder;
    AQPlayer *player;
    BOOL playbackWasInterrupted;
    BOOL playbackWasPaused;
    UILabel *recordingLabel;
    UIBarButtonItem *recordButton;
    UIBarButtonItem *playButton;
    UIBarButtonItem *submitButton;
}
@property (nonatomic, retain) IBOutlet UILabel *recordingLabel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *recordButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *submitButton;

@property (readonly) AQRecorder *recorder;
@property (readonly) AQPlayer *player;
@property BOOL playbackWasInterrupted;
@property BOOL playbackWasPaused;

- (IBAction)record:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)submit:(id)sender;

@end
