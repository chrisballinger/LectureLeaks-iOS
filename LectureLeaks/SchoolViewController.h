//
//  SchoolViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SchoolViewController : UITableViewController {
    NSMutableArray *contentList;
    NSString *schoolName;
}

@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) NSString *schoolName;

@end
