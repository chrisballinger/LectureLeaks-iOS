//
//  RecordViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecordViewController : UIViewController 
{
    
    UIButton *submitButton;
}
@property (nonatomic, retain) IBOutlet UIButton *submitButton;

@property (nonatomic)   BOOL recordingHasBeenMade;
- (IBAction)recordPressed:(id)sender;

@end
