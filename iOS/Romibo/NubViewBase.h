//
//  NubViewBase.h
//  Romibo
//
//  Created by Suvir Mirchandani on 7/15/14.
//
//

#import <UIKit/UIKit.h>
#import "CmdDelegate.h"
#import "AppDelegate.h"

@interface NubViewBase : UIImageView
{
    CGPoint currentPt;
    
    id appDelegate;
    
}

@property (nonatomic, assign) id appDelegate;
@property (nonatomic, retain) id <CmdDelegate> cmdDelegate;

- (void)animateToCenter;
- (CGPoint)clipPoint:(CGPoint)point;
- (CGFloat)clipX:(CGFloat)x inside:(BOOL)inside;
- (CGFloat)clipY:(CGFloat)y insideTop:(BOOL)insideTop insideBottom:(BOOL)insideBottom;

@end
