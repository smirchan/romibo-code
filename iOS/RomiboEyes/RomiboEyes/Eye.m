//
//  Eye.m
//  RomiboEyes
//
//  Created by Suvir Mirchandani on 6/27/14.
//  Copyright (c) 2014 Suvir Mirchandani. All rights reserved.
//

#import "Eye.h"

@implementation Eye

@synthesize originalCenter;
@synthesize newCenter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        originalCenter = self.center;
        newCenter = originalCenter;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect eyeRect = self.bounds;
    CGContextFillEllipseInRect(context, eyeRect);
}

- (void)setMoveX: (CGFloat)x Y:(CGFloat)y
{

    newCenter = CGPointMake(originalCenter.x + x, originalCenter.y + y);
}

- (void)move
{
    [UIView animateWithDuration:0.75 animations:^ {
        self.center = newCenter;
    }];
}

@end
