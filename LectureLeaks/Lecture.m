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
@synthesize submitDate;

+ (id)lectureWithTitle:(NSString*)title className:(NSString*)className school:(NSString*)school fileName:(NSString*)fileName date:(NSDate*)date submitDate:(NSDate*)submitDate
{
    Lecture *newLecture = [[[self alloc] init] autorelease];
    newLecture.title = title;
    newLecture.className = className;
    newLecture.school = school;
    newLecture.fileName = fileName;
    newLecture.date = date;
    newLecture.submitDate = submitDate;
    return newLecture;
}

+ (id)lectureWithFile:(NSString*)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];        
    NSString* path = [documentsDirectory stringByAppendingPathComponent:filename];

    
    NSDictionary *metadata = [[NSDictionary alloc] initWithContentsOfFile:path];
    Lecture *newLecture = [[[self alloc] init] autorelease];
    NSString *prefix = [[filename componentsSeparatedByString:@"."] objectAtIndex:0];
    
    newLecture.title = [metadata objectForKey:@"title"];
    newLecture.className = [metadata objectForKey:@"className"];
    newLecture.school = [metadata objectForKey:@"school"];
    newLecture.fileName = [prefix stringByAppendingString:@".caf"];
    newLecture.date = [[NSDate alloc] initWithTimeIntervalSince1970:[prefix doubleValue]];
    
    return newLecture;
}

-(void)saveMetadata
{
    NSString *metadataFileName = [fileName stringByReplacingOccurrencesOfString:@"caf" withString:@"plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *metadataPath = [documentsDirectory stringByAppendingPathComponent:metadataFileName];
    
    
    NSMutableDictionary *metadata = [[NSMutableDictionary alloc] init];
    [metadata setObject:title forKey:@"title"];
    [metadata setObject:className forKey:@"className"];
    [metadata setObject:school forKey:@"school"];
    if(submitDate)
        [metadata setObject:submitDate forKey:@"submitDate"];
    else
        [metadata setObject:@"nil" forKey:@"submitDate"];
    [metadata writeToFile:metadataPath atomically:YES];
}

-(void)dealloc
{
    [title release];
    [className release];
    [school release];
    [fileName release];
    [date release];
    [submitDate release];
    [super dealloc];
}


@end
