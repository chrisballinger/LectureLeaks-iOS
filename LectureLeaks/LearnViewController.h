//
//  LearnViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LearnViewController : UIViewController <MBProgressHUDDelegate>
{
    NSMutableArray *contentArray;
    BOOL isDataLoaded;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSMutableArray *contentArray;
@property (retain, nonatomic) IBOutlet UITableView *learnTableView;

@end
