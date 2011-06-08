//
//  LectureLeaksViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LectureLeaksViewController : UIViewController {
    
}

@property (nonatomic, retain) UINavigationController *navigationController;

- (IBAction)recordPressed:(id)sender;
- (IBAction)learnPressed:(id)sender;
- (IBAction)schedulePressed:(id)sender;
- (IBAction)aboutPressed:(id)sender;

@end
