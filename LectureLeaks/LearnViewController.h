//
//  LearnViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LearnViewController : UITableViewController 
{
    NSMutableArray *contentArray;
}

@property (nonatomic, retain) NSMutableArray *contentArray;

@end
