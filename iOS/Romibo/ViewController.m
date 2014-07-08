//
//  ViewController.m
//  Romibo
//
//  Created by HCII on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "EmotionNubView.h"
#import "DrivingNubView.h"
#import "ConfigViewController.h"
#import "Romibo.h"
#import "CmdDelegate.h"
#import "DrawPatternLockView.h"
#import "DrawPatternLockViewController.h"
#import "ChildBaseView.h"
#import "ButtonScrollView.h"
#import "AppDelegate.h"

@implementation ViewController 

@synthesize appDelegate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.992 green:0.69 blue:0.168 alpha:1.0];
    
    [self closePopup];
    
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!childView)
    {
        childView = [[ChildBaseView alloc] initWithNibName:@"ChildBaseView" bundle:nil];
        childView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
       
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setBool:YES forKey:@"ALLOW_DRIVING"];
    
    [self setupButtonScrollView];
   
    [self setupHeadTiltSubview];
    
    [self setupDrivingSubview];
    
}

-(void)setupButtonScrollView
{
    
    ButtonScrollView* buttonScrollController = [[ButtonScrollView alloc] initWithNibName:@"ButtonScrollView" bundle:[NSBundle mainBundle]];
    
    buttonScrollController.view.frame = CGRectMake(0, 577, self.view.frame.size.width, self.view.frame.size.height);
    
    [buttonScrollController loadButtonPages:@"screens"];
    
    [self addChildViewController:buttonScrollController];
    
    [self.view addSubview:buttonScrollController.view];
    
}




-(IBAction)changeShell:(UILongPressGestureRecognizer*)gesture
{
    NSLog(@"Changing shell...");
    
    if (![childView isBeingPresented])
        [self presentModalViewController:childView animated:YES];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
     } else {
     return YES;
     }*/
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setupHeadTiltSubview
{
    UIImageView* headTiltView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tiltBackground.png"]];
    
    tNub = [[HeadTiltNubView alloc] init];
    
    headTiltView.frame = CGRectMake(400, 250, 338, 338);
    
    tNub.center = CGPointMake(CGRectGetMidX(headTiltView.bounds), CGRectGetMidY(headTiltView.bounds));
    
    tNub.userInteractionEnabled = YES;
    headTiltView.userInteractionEnabled = YES;
    
    [headTiltView addSubview:tNub];
    [tNub release];
    
    [self.view addSubview:headTiltView ];
    [headTiltView release];
}

-(void)setupDrivingSubview
{
    UIImageView* drivingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"driveBackground.png"]];
    
    dNub = [[DrivingNubView alloc] init];
    
    drivingView.frame = CGRectMake(28, 250, 338, 338);
    
    dNub.center = CGPointMake(CGRectGetMidX(drivingView.bounds), CGRectGetMidY(drivingView.bounds));
    
    dNub.userInteractionEnabled = YES;
    drivingView.userInteractionEnabled = YES;
    
    [drivingView addSubview:dNub];
    [dNub release];
    
    [self.view addSubview:drivingView ];
    [drivingView release];
}

- (void)tiltClicked:(id)sender
{
    [dNub startAccelerometer];

}

- (void)tiltRaised:(id)sender
{
    [dNub stopAccelerometer];
}

-(IBAction)configClicked:(id)sender
{
    ConfigViewController* configVC = [[ConfigViewController alloc] initWithNibName:@"ConfigViewController" bundle:nil];
    [configVC view];
    [configVC setPopDelegate:self];
    [configVC configureButtonState:[[appDelegate romibo] isConnected]];
    
    if ([[appDelegate romibo] isConnected])
        [configVC setTextBoxText:[[appDelegate romibo] ipAddress]];
    else [configVC setTextBoxText:@"169.254.1.1"];      
    
    
    configPopover = [[UIPopoverController alloc] initWithContentViewController:configVC];
    [configVC release];
    
    configPopover.delegate = self;
    
    CGRect popoverRect = [self.view convertRect:[sender frame] toView:[sender superview]];
    
    [configPopover presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated: YES];

}

-(void)connectClicked:(NSString*)ipaddr
{
    [[appDelegate romibo] connectToIP:ipaddr];
    [self closePopup];
}

-(void)disconnectClicked
{
    [[appDelegate romibo] disconnect];
    [self closePopup];
}

-(void)setConnectionStatus
{
    if ([[appDelegate romibo] isConnected])
        [connectionLabel setText:@"Connected"];
    else
        [connectionLabel setText:@"Not connected"];
}

-(void)closePopup
{    
    if ([configPopover isPopoverVisible])
        [configPopover dismissPopoverAnimated:YES];
    
    [configPopover release];
}



-(IBAction)happyClicked:(id)sender
{
    
    NSString* emotion = @"emote 100 100\r";
    NSLog(@"Full command: %@", emotion);
    
    [[appDelegate romibo] sendString:emotion];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.507 green:0.729 blue:0.187 alpha:1.0];
}



-(IBAction)surprisedClicked:(id)sender
{
    
    NSString* emotion = @"emote 100 -100\r";
    NSLog(@"Full command: %@", emotion);
    
    [[appDelegate romibo] sendString:emotion];

    self.view.backgroundColor = [UIColor colorWithRed:0.992 green:0.69 blue:0.168 alpha:1.0];
}


-(IBAction)angryClicked:(id)sender
{
    
    NSString* emotion = @"emote -100 100\r";
    NSLog(@"Full command: %@", emotion);
    
    [[appDelegate romibo] sendString:emotion];

    self.view.backgroundColor = [UIColor colorWithRed:0.89 green:0.08 blue:0.188 alpha:1.0];
}


-(IBAction)sadClicked:(id)sender
{
    
    NSString* emotion = @"emote -100 -100\r";
    NSLog(@"Full command: %@", emotion);
    
    [[appDelegate romibo] sendString:emotion];

    self.view.backgroundColor = [UIColor colorWithRed:0.24 green:0.65 blue:0.80 alpha:1.0];
}

- (void)dealloc {
    
    [connectionLabel release];
    connectionLabel = nil;
    
    [tNub release];
    tNub = nil;
    
    [dNub release];
    dNub = nil;
    
    [super dealloc];
}
@end
