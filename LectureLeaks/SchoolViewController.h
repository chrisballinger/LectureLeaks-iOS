//
//  SchoolViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface SchoolViewController : UIViewController <MBProgressHUDDelegate> {
    NSMutableArray *contentList;
    NSString *schoolName;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) NSString *schoolName;
@property (retain, nonatomic) IBOutlet UITableView *mainTableView;

-(void)showHUD;

@end
