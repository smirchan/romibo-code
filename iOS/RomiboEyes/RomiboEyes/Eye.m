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
@synthesize newFrame;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        originalCenter = self.center;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect eyeRect = self.bounds;
    CGContextFillEllipseInRect(context, eyeRect);
}

- (void)moveX: (CGFloat)x Y:(CGFloat)y
{
    newFrame = CGRectMake( self.frame.origin.x + x, self.frame.origin.y - y, self.frame.size.width, self.frame.size.width);
    
}

@end
