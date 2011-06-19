//
//  SettingsViewController.h
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController {
    
    UITextField *schoolTextField;
    NSMutableDictionary *metadata;
    NSString *metadataPath;
}
@property (nonatomic, retain) IBOutlet UITextField *schoolTextField;
@property (nonatomic, retain) NSMutableDictionary *metadata;
@property (nonatomic, retain) NSString *metadataPath;

- (IBAction)savePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end
