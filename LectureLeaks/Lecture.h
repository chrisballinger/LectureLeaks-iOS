//
//  Lecture.h
//  CopRecorder
//
//  Created by Christopher Ballinger on 6/9/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Lecture : NSObject 
{
    NSString *name;
    NSString *professor;
    NSString *course;
    NSString *school;
    NSString *subject;
    NSString *tags;
    NSURL *url;
    NSDate *date;
    NSDate *submitDate;
} 

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *course;
@property (nonatomic, retain) NSString *professor;
@property (nonatomic, retain) NSString *school;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *tags;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *submitDate;

+ (id)lectureWithName:(NSString*)name course:(NSString*)course professor:(NSString*)professor school:(NSString*)school subject:(NSString*)subject tags:(NSString*)tags url:(NSURL*)url date:(NSDate*)date submitDate:(NSDate*)submitDate;
+ (id)lectureWithFile:(NSString*)fileName;

- (void)saveMetadata;
- (void)deleteFiles;

@end
