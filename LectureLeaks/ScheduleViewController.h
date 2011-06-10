//
//  ScheduleViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>
#import "Kal.h"
#import "EventKitDataSource.h"

@interface ScheduleViewController : UIViewController <EKEventEditViewDelegate ,UITableViewDelegate> {
    EventKitDataSource *dataSource;
    
}

@property (nonatomic, retain) EventKitDataSource *dataSource;

- (IBAction)viewCalendar:(id)sender;
- (IBAction)addClass:(id)sender;

@end
