//
//  LearnViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LearnViewController : UIViewController {
    
    UITableView *tableView;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
