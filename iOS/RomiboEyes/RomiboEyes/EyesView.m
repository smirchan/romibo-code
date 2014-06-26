//
//  EyesView.m
//  RomiboEyes
//
//  Created by Suvir Mirchandani on 6/26/14.
//  Copyright (c) 2014 Suvir Mirchandani. All rights reserved.
//

#import "EyesView.h"

@implementation EyesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    
}

- (void)blink
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1.0, 0);
                     } completion:^(BOOL finished) {
                         self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGRect eyeballRect1 = CGRectMake(90, 10, 120, height - 20);
    CGContextFillEllipseInRect(context, eyeballRect1);
    
    CGRect eyeballRect2 = CGRectMake(width - 210, 10, 120, height - 20);
    CGContextFillEllipseInRect(context, eyeballRect2);
}


@end
