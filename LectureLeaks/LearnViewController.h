//
//  LearnViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LearnViewController : UITableViewController 
{
    NSMutableArray* listContent;
    UITableView *lectureTableView;
}
@property (nonatomic, retain) IBOutlet UITableView *lectureTableView;

@property (nonatomic, retain) NSMutableArray* listContent;

-(void)editButtonPressed;

@end
