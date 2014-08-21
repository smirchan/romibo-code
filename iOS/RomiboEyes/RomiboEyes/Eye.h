//
//  Eye.h
//  RomiboEyes
//
//  Created by Suvir Mirchandani on 6/27/14.
//  Copyright (c) 2014 Suvir Mirchandani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Eye : UIView

@property CGPoint originalCenter;
@property CGPoint newCenter;

- (void)setMoveX: (CGFloat)x Y:(CGFloat)y;
- (void)move;

@end
