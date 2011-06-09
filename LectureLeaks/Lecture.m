//
//  Lecture.m
//  CopRecorder
//
//  Created by Christopher Ballinger on 6/9/11.
//  Copyright 2011. All rights reserved.
//

#import "Lecture.h"


@implementation Lecture

@synthesize title;
@synthesize className;
@synthesize school;
@synthesize fileName;
@synthesize date;

+ (id)lectureWithTitle:(NSString*)title className:(NSString*)className school:(NSString*)school fileName:(NSString*)fileName date:(NSDate*)date
{
    Lecture *newLecture = [[[self alloc] init] autorelease];
    newLecture.title = title;
    newLecture.className = className;
    newLecture.school = school;
    newLecture.fileName = fileName;
    newLecture.date = date;
    return newLecture;
}

-(void)dealloc
{
    [title release];
    [className release];
    [school release];
    [fileName release];
    [date release];
    [super dealloc];
}


@end
