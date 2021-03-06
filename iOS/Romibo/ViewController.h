//
//  ViewController.h
//  Romibo
//
//  Created by HCII on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Romibo.h"
#import "ConfigViewController.h"
#import <Foundation/Foundation.h>

#import "EmotionNubView.h"
#import "DrivingNubView.h"
#import "HeadTiltNubView.h"
#import "CommandPickerController.h"
#import "DrawPatternLockViewController.h"
#import "DrawPatternLockView.h"

@class ChildBaseView;

@interface ViewController : UIViewController <UIPopoverControllerDelegate, DismissPopoverDelegate>

{
    IBOutlet UILabel *connectionLabel;
    IBOutlet UIButton *tiltButton;
    
    UIPopoverController* configPopover;

    
    NSTimer* connectionStatusTimer;
    
    HeadTiltNubView* tNub;
    DrivingNubView* dNub;
    EmotionNubView* eNub;

    id appDelegate;
    
    UILongPressGestureRecognizer* longPressRecognizer;
    
    DrawPatternLockViewController *lockVC;
    ChildBaseView* childView;

}

@property (nonatomic, assign) id appDelegate;

//handles accelerometer button
-(IBAction)tiltClicked:(id)sender;
-(IBAction)tiltRaised:(id)sender;

//gear button
- (IBAction)configClicked:(id)sender;
- (void)closePopup;
- (void)connectClicked:(NSString*) ipaddr;
- (void)disconnectClicked;
- (void)setConnectionStatus;

//silhouette button
- (IBAction)changeShell:(id)sender;

//component views (drive, tilt, buttons)
- (void)setupHeadTiltSubview;
- (void)setupDrivingSubview;
- (void)setupEmotionSubview;
- (void)setupButtonScrollView;

//unwind segue
- (IBAction)unwind:(UIStoryboardSegue *)unwindSegue;


@end
