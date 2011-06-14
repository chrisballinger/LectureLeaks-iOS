//
//  CourseViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectViewController.h"

@interface CourseViewController : SubjectViewController {
    NSString* courseName;
}

@property (nonatomic, retain) NSString* courseName;


@end
