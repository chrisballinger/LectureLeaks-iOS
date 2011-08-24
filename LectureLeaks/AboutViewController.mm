//
//  AboutViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController
@synthesize aboutLabel;
@synthesize aboutScrollView;

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
    [aboutLabel release];
    [aboutScrollView release];
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
    self.title = @"About";
    
    CGFloat width = aboutLabel.frame.size.width;
    CGFloat height = aboutLabel.frame.size.height;
    
    [aboutScrollView setContentSize:(CGSizeMake(width, height))];
}

- (void)viewDidUnload
{
    [self setAboutLabel:nil];
    [self setAboutScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSURL *url = [NSURL URLWithString:@"http://www.openwatch.net"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (IBAction)openwatchPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open Link" message:@"Open www.openwatch.net in Safari?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}
@end
