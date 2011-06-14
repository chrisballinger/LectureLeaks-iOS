//
//  Lecture.m
//  CopRecorder
//
//  Created by Christopher Ballinger on 6/9/11.
//  Copyright 2011. All rights reserved.
//

#import "Lecture.h"


@implementation Lecture

@synthesize name;
@synthesize course;
@synthesize professor;
@synthesize school;
@synthesize subject;
@synthesize tags;
@synthesize url;
@synthesize date;
@synthesize submitDate;
@synthesize approved;
@synthesize isRemoteFile;

+ (id)lectureWithName:(NSString*)name course:(NSString*)course professor:(NSString*)professor school:(NSString*)school subject:(NSString*)subject tags:(NSString*)tags url:(NSURL*)url approved:(NSNumber*)approved date:(NSDate*)date submitDate:(NSDate*)submitDate
{
    Lecture *newLecture = [[[self alloc] init] autorelease];
    newLecture.name = name;
    newLecture.course = course;
    newLecture.professor = professor;
    newLecture.school = school;
    newLecture.subject = subject;
    newLecture.tags = tags;
    newLecture.url = url;
    newLecture.date = date;
    newLecture.submitDate = submitDate;
    newLecture.approved = approved;
    return newLecture;
}

+ (id)lectureWithFile:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];        
    NSString* path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSString* cafPath = [path stringByReplacingOccurrencesOfString:@".plist" withString:@".caf"];
    NSURL *url = [NSURL fileURLWithPath:cafPath];
    
    NSDictionary *metadata = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
    Lecture *newLecture = [[[self alloc] init] autorelease];
    NSString *prefix = [[fileName componentsSeparatedByString:@"."] objectAtIndex:0];

    
    newLecture.name = [metadata objectForKey:@"name"];
    newLecture.course = [metadata objectForKey:@"course"];
    newLecture.professor = [metadata objectForKey:@"professor"];
    newLecture.school = [metadata objectForKey:@"school"];
    newLecture.subject = [metadata objectForKey:@"subject"];
    newLecture.tags = [metadata objectForKey:@"tags"];
    newLecture.url = url;
    newLecture.date = [[NSDate alloc] initWithTimeIntervalSince1970:[prefix doubleValue]];
    newLecture.submitDate = [metadata objectForKey:@"submitDate"];
    newLecture.isRemoteFile = NO;
    
    return newLecture;
}

-(void)saveMetadata
{
    NSString *fileName = [NSString stringWithFormat:@"%d.plist", (int)[date timeIntervalSince1970]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *metadataPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
    NSMutableDictionary *metadata = [[[NSMutableDictionary alloc] init] autorelease];
    [metadata setObject:name forKey:@"name"];
    [metadata setObject:course forKey:@"course"];
    [metadata setObject:school forKey:@"school"];
    if(submitDate)
        [metadata setObject:submitDate forKey:@"submitDate"];
    else
        [metadata setObject:@"nil" forKey:@"submitDate"];
    [metadata writeToFile:metadataPath atomically:YES];
}

-(void)deleteFiles
{
    NSString *fileName = [NSString stringWithFormat:@"%f.plist", [date timeIntervalSince1970]];
    NSString *metadataFileName = [fileName stringByReplacingOccurrencesOfString:@"caf" withString:@"plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *cafPath = [documentsDirectoryPath stringByAppendingPathComponent: fileName];
    NSString *plistPath = [documentsDirectoryPath stringByAppendingPathComponent: metadataFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:cafPath error:nil];
    [fileManager removeItemAtPath:plistPath error:nil];
}

-(void)dealloc
{
    [name release];
    [course release];
    [professor release];
    [school release];
    [subject release];
    [tags release];
    [url release];
    [date release];
    [submitDate release];
    [super dealloc];
}


@end
