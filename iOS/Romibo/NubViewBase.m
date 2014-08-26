//
//  NubViewBase.m
//  Romibo
//
//  Created by Suvir Mirchandani on 7/15/14.
//
//

#import "NubViewBase.h"

@implementation NubViewBase

@synthesize appDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*) event
{
    currentPt = [[touches anyObject] locationInView:self];
}


- (void)animateToCenter
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
                     }];
}

- (CGPoint)clipPoint:(CGPoint)point
{
    point.x = [self clipX:point.x inside:YES];
    point.y = [self clipY:point.y insideTop:YES insideBottom:YES];
    
    return point;
}

- (CGFloat)clipX:(CGFloat)x inside:(BOOL)inside
{
    float xBorder;
    
    if (inside) xBorder = CGRectGetMidX(self.bounds);
    else xBorder = 0;
    
    if (x > self.superview.bounds.size.width - xBorder)
        x = self.superview.bounds.size.width - xBorder;
    else if (x < xBorder)
        x = xBorder;
    
    return x;
}


-(CGFloat)clipY:(CGFloat)y insideTop:(BOOL)insideTop insideBottom:(BOOL)insideBottom
{
    float yBorderTop;
    float yBorderBottom;

    if (insideTop) yBorderTop = CGRectGetMidY(self.bounds);
    else yBorderTop = 0;
    
    if (insideBottom) yBorderBottom = CGRectGetMidY(self.bounds);
    else yBorderBottom = 0;

    
    if (y > self.superview.bounds.size.height - yBorderBottom)
        y = self.superview.bounds.size.height - yBorderBottom;
    else if (y < yBorderTop)
        y = yBorderTop;
    
    return y;
}

@end
