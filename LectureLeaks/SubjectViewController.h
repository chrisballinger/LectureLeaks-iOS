//
//  SubjectViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolViewController.h"

@interface SubjectViewController : SchoolViewController 
{
    NSString *subjectName;
}

@property (nonatomic, retain) NSString *subjectName;

@end
