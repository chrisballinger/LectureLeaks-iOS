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
    AVAudioPlayer* player;
    UILabel *titleLabel;
    UILabel *classLabel;
    UILabel *schoolLabel;
    UIButton *playButton;
    UILabel *durationLabel;
    UILabel *currentTimeLabel;
    UILabel *dateLabel;
    NSTimer *playerUpdateTimer;
    UISlider *playerSlider;
    
}
@property (nonatomic, retain) Lecture* lecture;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *classLabel;
@property (nonatomic, retain) IBOutlet UILabel *schoolLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, retain)     NSTimer *playerUpdateTimer;
@property (nonatomic, retain) IBOutlet UISlider *playerSlider;

- (IBAction)playPressed:(id)sender;
- (IBAction)stopPressed:(id)sender;
- (void) updateElapsedTime:(NSTimer *) timer;
- (IBAction)seek:(id)sender;

@end
