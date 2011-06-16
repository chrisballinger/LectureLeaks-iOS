//
//  LectureLeaksAppDelegate.m
//  LectureLeaks
//
//  Created by Christopher Ballinger on 6/6/11.
//  Copyright 2011. All rights reserved.
//

#import "LectureLeaksAppDelegate.h"

#import "LectureLeaksViewController.h"
#import "RecordingViewController.h"

@implementation LectureLeaksAppDelegate


@synthesize window=_window;
@synthesize viewController=_viewController;
@synthesize navigationController;

#pragma mark AudioSession listeners

void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState)
{
	RecordingViewController *THIS = (RecordingViewController*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		if (THIS->recorder->IsRunning()) 
        {
			THIS->recorder->StopRecord();
		}
    }
}

void propListener(	void *                  inClientData,
                  AudioSessionPropertyID	inID,
                  UInt32                  inDataSize,
                  const void *            inData)
{
	RecordingViewController *THIS = (RecordingViewController*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;			
		//CFShow(routeDictionary);
		CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 reasonVal;
		CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
		if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
		{		
			// stop the queue if we had a non-policy route change
			if (THIS->recorder->IsRunning()) 
            {
                THIS->recorder->StopRecord();
			}
		}	
	}
	else if (inID == kAudioSessionProperty_AudioInputAvailable)
	{
		if (inDataSize == sizeof(UInt32)) {
			UInt32 isAvailable = *(UInt32*)inData;
			// disable recording if input is not available
            if(isAvailable > 0)
            {
                //THIS->btn_record.enabled =  YES;
                AudioSessionSetActive(true);
            }
            else
            {
                //THIS->btn_record.enabled =  NO;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Microphone Error" message:@"If you are trying to record on an iPod Touch, headphones with a microphone must be plugged in before you can record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
		}
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    OSStatus error = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
    if (error) NSLog(@"ERROR INITIALIZING AUDIO SESSION! %ld\n", error);
    else 
    {
        UInt32 category = kAudioSessionCategory_PlayAndRecord;	
        error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        if (error) NSLog(@"couldn't set audio category!");
        
        error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
        if (error) NSLog(@"ERROR ADDING AUDIO SESSION PROP LISTENER! %ld\n", error);
        UInt32 inputAvailable = 0;
        UInt32 size = sizeof(inputAvailable);
        
        // we do not want to allow recording if input is not available
        error = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &inputAvailable);
        if (error) NSLog(@"ERROR GETTING INPUT AVAILABILITY! %ld\n", error);
        //btn_record.enabled = (inputAvailable) ? YES : NO;
        
        // we also need to listen to see if input availability changes
        error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, propListener, self);
        if (error) NSLog(@"ERROR ADDING AUDIO SESSION PROP LISTENER! %ld\n", error);
    }

    
    navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.viewController.navigationController = self.navigationController;
        
    //self.window.rootViewController = self.navigationController;                // for iOS 4.0+
    [self.window addSubview:[self.navigationController view]];                   // works on iOS 3.x

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [navigationController release];
    [super dealloc];
}

@end
