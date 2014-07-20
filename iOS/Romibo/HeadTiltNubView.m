//
//  HeadTiltNubView.m
//  Romibo
//
//  Created by QoLT on 5/28/13.
//
//

#import "HeadTiltNubView.h"

@implementation HeadTiltNubView


- (id)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 90, 90)])
    {
        self.image = [UIImage imageNamed:@"movement-nub-03.png"];
        self.userInteractionEnabled = YES;
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    }
    
    return self;
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*) event
{
    CGPoint activePt = [[touches anyObject] locationInView:self];
    
    CGPoint newPt = CGPointMake(self.center.x + (activePt.x - currentPt.x),
                                self.center.y + (activePt.y - currentPt.y));
    
     
//     float distance = sqrtf( pow(newPt.x - CGRectGetMidX(self.bounds), 2) + pow(newPt.y - CGRectGetMidX(self.bounds),2) );
//     
//     NSLog(@"Radius: %f", distance);
//     
//     if (distance > 130)
//     {
//         newPt = currentPt;
//     }
    
    
    newPt = [self clipPoint:newPt];
    
    self.center = newPt;
    
    [self calcTiltCoordinates:newPt.x:newPt.y];
    
}


-(void)calcTiltCoordinates :(int)x :(int)y
{
    float fx = x;
    float fy = y;
    
    float span = 277 - 61;
    
    float tiltX = 100 * ((fx - 61)/span);
    float tiltY = 100 * ((fy - 61)/span);
    
    
    [[appDelegate romibo] sendHeadTiltCmd:roundf(tiltX):roundf(tiltY)];
    
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self animateToCenter];

    [[appDelegate romibo] sendHeadTiltCmd:50:50];
}


- (void)dealloc
{
    [super dealloc];
}

@end
