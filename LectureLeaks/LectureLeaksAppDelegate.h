//
//  LectureLeaksAppDelegate.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LectureLeaksViewController;

@interface LectureLeaksAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LectureLeaksViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;


@end
