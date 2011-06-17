//
//  FirstLaunchViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstLaunchViewController.h"
#import "LectureLeaksViewController.h"


@implementation FirstLaunchViewController
@synthesize schoolTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [schoolTextField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_background.png"]];
}

- (void)viewDidUnload
{
    [self setSchoolTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)continuePressed:(id)sender 
{
    if([schoolTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"More Info Please!" message:@"Please fill in your school and try again. If you're not affiliated with a school press the 'Not a student?' button." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else
    {
        [self saveSchoolInfo:schoolTextField.text];
        LectureLeaksViewController *lectureLeaksViewController = [[LectureLeaksViewController alloc] init];
        [self.navigationController pushViewController:lectureLeaksViewController animated:YES];
    }

}

- (void) saveSchoolInfo:(NSString*)schoolName
{
    NSString *fileName = @"data.plist";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *metadataPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
    NSMutableDictionary *metadata = [[[NSMutableDictionary alloc] init] autorelease];
    [metadata setObject:schoolName forKey:@"school"];
    [metadata writeToFile:metadataPath atomically:YES];

}

- (IBAction)notStudentPressed:(id)sender {
    [self saveSchoolInfo:@""];
    LectureLeaksViewController *lectureLeaksViewController = [[LectureLeaksViewController alloc] init];
    [self.navigationController pushViewController:lectureLeaksViewController animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
