//
//  DrivingNubView.m
//  
//
//  Created by HCII on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrivingNubView.h"
#import "AppDelegate.h"

@implementation DrivingNubView

@synthesize motionManager;


- (id)init
{   
    if (self = [super initWithFrame:CGRectMake(0, 0, 90, 90)])
    {
        self.image = [UIImage imageNamed:@"movement-nub-03.png"];
        self.userInteractionEnabled = YES;
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        motionManager = [[CMMotionManager alloc] init];
    }
    
    return self;
}


- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*) event
{
    currentPt = [[touches anyObject] locationInView:self];
}


- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*) event
{
    CGPoint activePt = [[touches anyObject] locationInView:self];
    
    CGPoint newPt = CGPointMake(self.center.x + (activePt.x - currentPt.x), 
                                self.center.y + (activePt.y - currentPt.y));
    
    newPt = [self clipPoint:newPt];
    
    self.center = newPt;
    
    [self calcDriveCoordinates:newPt.x:newPt.y];
    
}


-(void)calcDriveCoordinates :(int)x :(int)y
{
    float fx = x;
    float fy = y;
    
    fx = (fx - 169);
    fy = - (fy - 169); //iOS origin is upper left
    
    fx = fx / 108;
    fy = fy / 108;
    
    float driveX = (fx * 100) + (fy * 100);
    float driveY = (fx * -100) + (fy * 100);
    
    
    float larger = [self getLarger:driveX:driveY];
    if (larger >= 99)
    {
        float q = 99/larger;
        driveX = driveX * q;
        driveY = driveY * q;
    }
    
    float smaller = [self getSmaller:driveX:driveY];
    if (smaller <= -99)
    {
        float q = -99/smaller;
        driveX = driveX * q;
        driveY = driveY * q;
    }
        
    [[appDelegate romibo] sendDriveCmd:roundf(driveX):roundf(driveY)];
    
}


-(int)getLarger :(int)i :(int)j
{
    if (i > j) return i;
    else return j;
}


-(int)getSmaller :(int)i :(int)j
{
    if (i < j) return i;
    else return j;
}


- (void)startAccelerometer
{
    __block CGPoint newCenter = [self center];

    if(self.motionManager.accelerometerAvailable) {
        [self.motionManager setAccelerometerUpdateInterval:0.05];
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            //accelerometer data is smoothed and mapped to point
            newCenter.x = CGRectGetMidX(self.superview.bounds) + self.superview.bounds.size.width * 30 * powf(accelerometerData.acceleration.x, 3);
            newCenter.y = CGRectGetMidY(self.superview.bounds) - self.superview.bounds.size.height * 30 * powf(accelerometerData.acceleration.y, 3);
            
            newCenter = [self clipPoint:newCenter];
            
            [UIView animateWithDuration:0.05
                             animations:^{
                                 [self setCenter:newCenter];
                             }];
            [self calcDriveCoordinates:self.center.x:self.center.y];

        }];
    } else NSLog(@"Accelerometer Unavailable");
    
}

- (void)stopAccelerometer
{
    [self.motionManager stopAccelerometerUpdates];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
                     }];
    [[appDelegate romibo] sendDriveCmd:0:0];
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self animateToCenter];
    
    [[appDelegate romibo] sendDriveCmd:0:0];
}


- (void)dealloc
{
    [super dealloc];
}

@end