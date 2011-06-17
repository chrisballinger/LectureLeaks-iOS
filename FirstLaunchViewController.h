//
//  FirstLaunchViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstLaunchViewController : UIViewController {
    
    UITextField *schoolTextField;
}
@property (nonatomic, retain) IBOutlet UITextField *schoolTextField;
- (IBAction)continuePressed:(id)sender;
- (IBAction)notStudentPressed:(id)sender;

- (void) saveSchoolInfo:(NSString*)schoolName;

@end
