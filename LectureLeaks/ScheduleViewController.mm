//
//  ScheduleViewController.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011. All rights reserved.
//

#import "ScheduleViewController.h"
#import "KalViewController.h"

@implementation ScheduleViewController

@synthesize dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
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
    self.title = @"Schedule";
    
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    [self dismissModalViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)viewCalendar:(id)sender 
{
    KalViewController *calendar = [[[KalViewController alloc] init] autorelease];
    calendar.delegate = self;
    dataSource = [[EventKitDataSource alloc] init];
    [dataSource retain];
    calendar.dataSource = dataSource;
    [self.navigationController pushViewController:calendar animated:YES];
}

#pragma mark UITableViewDelegate protocol conformance

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Display a details screen for the selected event/row.
    EKEventViewController *vc = [[[EKEventViewController alloc] init] autorelease];
    vc.event = [dataSource eventAtIndexPath:indexPath];
    vc.allowsEditing = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)addClass:(id)sender 
{
    // iOS 4+ only
    EKEventEditViewController *eventViewController = [[EKEventEditViewController alloc] init];
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    eventViewController.eventStore = eventStore;
    eventViewController.editViewDelegate = self;
    
    EKRecurrenceRule *recur = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:nil];
    eventViewController.event.recurrenceRule = recur;
    eventViewController.event.alarms = [NSArray arrayWithObject:[EKAlarm alarmWithRelativeOffset:-5*60]];
    
    [self presentModalViewController: eventViewController animated:YES];
    [eventViewController release];
}
@end
