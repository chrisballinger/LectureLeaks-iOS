//
//  RecordingViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordViewController.h"
#import "AQRecorder.h"
#import "AQPlayer.h"

@interface RecordingViewController : UIViewController 
{
    AQRecorder *recorder;
    AQPlayer *player;
    BOOL playbackWasInterrupted;
    BOOL playbackWasPaused;
    UILabel *recordingLabel;
    UIButton *playButton;
    UIButton *recordButton;
}
@property (nonatomic, retain) IBOutlet UILabel *recordingLabel;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;

@property (readonly) AQRecorder *recorder;
@property (readonly) AQPlayer *player;
@property BOOL playbackWasInterrupted;
@property BOOL playbackWasPaused;
@property (nonatomic, retain) RecordViewController *recordController;
- (IBAction)stopPressed:(id)sender;
- (IBAction)playPressed:(id)sender;

@end
