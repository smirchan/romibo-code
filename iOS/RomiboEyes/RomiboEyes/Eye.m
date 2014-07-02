//
//  Eye.m
//  RomiboEyes
//
//  Created by Suvir Mirchandani on 6/27/14.
//  Copyright (c) 2014 Suvir Mirchandani. All rights reserved.
//

#import "Eye.h"

@implementation Eye

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect eyeRect = self.bounds;
    CGContextFillEllipseInRect(context, eyeRect);
}


@end
