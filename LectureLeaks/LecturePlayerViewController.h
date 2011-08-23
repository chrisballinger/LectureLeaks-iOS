//
//  LecturePlayerViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Lecture.h"


@interface LecturePlayerViewController : UIViewController {
    Lecture* lecture;
    int duration;
    BOOL isPlaying;
    AVPlayer* player;
    UILabel *titleLabel;
    UILabel *classLabel;
    UILabel *schoolLabel;
    UILabel *durationLabel;
    UILabel *currentTimeLabel;
    UILabel *dateLabel;
    UILabel *submitLabel;
    NSTimer *playerUpdateTimer;
    UISlider *playerSlider;
    UIBarButtonItem *playButton;
    UIBarButtonItem *stopButton;
    UIBarButtonItem *submitButton;
    
    UIProgressView *progressView;
    UILabel *submitProgressLabel;
}
@property (nonatomic, retain) IBOutlet UILabel *submitProgressLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) Lecture* lecture;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *classLabel;
@property (nonatomic, retain) IBOutlet UILabel *schoolLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *submitLabel;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, retain)     NSTimer *playerUpdateTimer;
@property (nonatomic, retain) IBOutlet UISlider *playerSlider;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *stopButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *submitButton;
@property (nonatomic, retain)     AVPlayer* player;
@property (retain, nonatomic) IBOutlet UISwitch *permissionSwitch;
@property (retain, nonatomic) IBOutlet UILabel *permissionLabel;

- (IBAction)submitPressed:(id)sender;
- (IBAction)playPressed:(id)sender;
- (IBAction)stopPressed:(id)sender;
- (void) updateElapsedTime:(NSTimer *) timer;
- (void) updateLabel:(UILabel*)label withTime:(NSTimeInterval)time;
- (IBAction)seek:(id)sender;

@end
