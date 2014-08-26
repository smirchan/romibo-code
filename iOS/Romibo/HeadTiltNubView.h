//
//  HeadTiltNubView.h
//  Romibo
//
//  Created by QoLT on 5/28/13.
//
//

#import <UIKit/UIKit.h>
#import "NubViewBase.h"

@interface HeadTiltNubView : NubViewBase

- (void)calcTiltCoordinates :(int)x :(int)y;

@end
