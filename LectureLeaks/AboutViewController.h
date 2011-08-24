//
//  AboutViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController <UIAlertViewDelegate> {
    
}
- (IBAction)openwatchPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *aboutLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *aboutScrollView;

@end
