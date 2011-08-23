//
//  SettingsViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

@synthesize schoolTextField;
@synthesize metadata;
@synthesize metadataPath;

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
    [metadata release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_background.png"]];
    self.title = @"Settings";
    
    NSString* fileName = @"data.plist";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];        
    self.metadataPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    self.metadata = [[[NSMutableDictionary alloc] initWithContentsOfFile:metadataPath] autorelease];
    
    schoolTextField.text = [metadata objectForKey:@"school"];
}

- (void)viewDidUnload
{
    [self setSchoolTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)savePressed:(id)sender 
{
    [self.metadata setObject:schoolTextField.text forKey:@"school"];
    [self.metadata writeToFile:metadataPath atomically:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelPressed:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
