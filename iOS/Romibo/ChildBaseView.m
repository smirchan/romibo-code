//
//  ChildBaseView.m
//  Romibo
//
//  Created by QoLT on 3/22/13.
//
//

#import "ChildBaseView.h"
#import "CmdDelegate.h"
#import "ButtonScrollView.h"


@implementation ChildBaseView


@synthesize appDelegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    self.view.alpha = 0.5;
    
    ButtonScrollView* buttonScrollController = [[ButtonScrollView alloc] initWithNibName:@"ButtonScrollView" bundle:[NSBundle mainBundle]];
    
    buttonScrollController.view.frame = CGRectMake(0, 552, self.view.frame.size.width, self.view.frame.size.height);
    
    [buttonScrollController loadButtonPages:@"simple_screens"];
    
    [self addChildViewController:buttonScrollController];
    
    [self.view addSubview:buttonScrollController.view];
    

}

-(void)driveForward
{
    
    [[appDelegate romibo] driveForward];
    [[appDelegate romibo] setStopDrivingTimer];
    
}
-(void)driveBackward
{
    
    [[appDelegate romibo] driveBackward];
    [[appDelegate romibo] setStopDrivingTimer];
}
-(void)driveRight
{
    
    [[appDelegate romibo] driveRight];
    [[appDelegate romibo] setStopDrivingTimer];
}
-(void)driveLeft
{
    
    [[appDelegate romibo] driveLeft];
    [[appDelegate romibo] setStopDrivingTimer];
}



- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*) event
{
    
    [[appDelegate romibo] endStopDrivingTimer];
    
    CGPoint currentPt = [[touches anyObject] locationInView:drivingView];
    
    //NSLog(@"X: %f", currentPt.x);
    //NSLog(@"Y: %f", currentPt.y);
    
    //for the kids' view, we drive by quadrant - overlay a standard grid and rotate by 45 degrees to match with the arrows
    //line A is the rotated y-axis, line B the rotated x; also note that iOS grid has the origin in the upper left
    bool leftOfA = ( (500 - 50) * (currentPt.y - 40) - (520 - 40) * (currentPt.x - 50) ) > 0;
    bool rightOfB = ( (500 - 50) * (currentPt.y - 520) - (40 - 520) * (currentPt.x - 50) ) > 0;
    
    int quadrant;
    
    if (leftOfA)
    {
        if (rightOfB)
            quadrant = 3;
        else quadrant = 2;
    }
    else
    {
        if (rightOfB)
            quadrant = 4;
        else quadrant = 1;
    }
    
    NSLog(@"Quadrant: %d", quadrant);
    
    switch (quadrant) {
        case 1:
            [[appDelegate romibo] driveForward];
            break;
        case 2:
            [[appDelegate romibo] driveLeft];
            break;
        case 3:
            [[appDelegate romibo] driveBackward];
            break;
        case 4:
            [[appDelegate romibo] driveRight];
            break;
            
        default:
            break;
    }
    
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[appDelegate romibo] setStopDrivingTimer];
}


-(IBAction)changeShell:(UILongPressGestureRecognizer*)gesture
{
    if (!lockVC)
    {
        lockVC = [[DrawPatternLockViewController alloc] init];
        [lockVC setTarget:self withAction:@selector(lockEntered:)];
        
    }
    
    if (![lockVC isBeingPresented])
    {
        [self presentViewController:lockVC animated:YES completion:nil];
        
    }
    
    
}

- (void)lockEntered:(NSString*)key {
    NSLog(@"key: %@", key);
    
    if (![key isEqualToString:@"070809"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Incorrect Key"
                                                            message:@"Incorrect pattern for exiting child view"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        //dismiss the lock view 
        [self dismissViewControllerAnimated:YES
                                 completion:^{
        
                                    //dismiss ourself
                                     UIViewController* vc = [self presentingViewController];
                                     [vc dismissViewControllerAnimated:YES completion:nil];
        
                                 }
         ];
        
    }
}


-(IBAction)buttonClicked:(id)sender
{
    
    NSString* btnText = [((UIButton *)sender).titleLabel text];
    NSLog(@"Button text: %@", btnText);
    
    NSString* btnCommand = [[appDelegate romiboCommands] objectForKey:btnText];
    NSLog(@"Button command: %@", btnCommand);
    
    NSString* command;
    if ([btnCommand hasSuffix:@".wav"] || [btnCommand hasSuffix:@".WAV"])
        command = [@"say " stringByAppendingString:btnCommand];
    else command = btnCommand;
    
    NSString* fullCommand = [NSString stringWithFormat:@"%@\r", command];
    NSLog(@"Full command: %@", fullCommand);
    
    [[appDelegate romibo] sendString:fullCommand];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [super dealloc];
    
}

@end
