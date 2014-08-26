//
//  EmotionNubView.m
//  
//
//  Created by HCII on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmotionNubView.h"
#import "UIColor+RomiboColors.h"

@implementation EmotionNubView


- (id)init
{   
    if (self = [super initWithFrame:CGRectMake(0, 0, 35, 35)])
    {
        self.image = [UIImage imageNamed:@"emotion-nub-03.png"];
        self.userInteractionEnabled = YES;
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}


- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*) event
{
    CGPoint activePt = [[touches anyObject] locationInView:self];
    
    CGFloat newX = self.center.x + (activePt.x - currentPt.x);
    newX = [self clipX:newX inside:NO];
    
    CGFloat newY = powf(powf(self.superview.bounds.size.width / 2, 2) - powf(newX - CGRectGetMidX(self.superview.bounds), 2), 0.5) + CGRectGetMinY(self.superview.bounds);
    newY = [self clipY:newY insideTop:YES insideBottom:NO];
    
    CGPoint newPt = CGPointMake(newX, newY);
    self.center = newPt;
    
    UIColor *newColor = [self getColorForPoint:newPt];
    
    if (![newColor isEqual:self.superview.superview.backgroundColor]) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.superview.superview.backgroundColor = newColor;
            
        }];
    }
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self calcEmoteCoordinates:self.superview.superview.backgroundColor];
}


- (UIColor*)getColorForPoint:(CGPoint)point
{
    CGFloat midX = CGRectGetMidX(self.superview.bounds);

    if (point.x < midX) {
        if (point.x < 0.33 * midX) {
            return [UIColor romiboGreen];
        } else {
            return [UIColor romiboYellow];
        }
    } else {
        if (point.x > 1.67 * midX) {
            return [UIColor romiboBlue];
        }
        else {
            return [UIColor romiboRed];
        }
    }
/*
//reads color at pixel of UIImage
     CGImageRef cgImage = image.CGImage;
     NSUInteger width = CGImageGetWidth(cgImage);
     NSUInteger height = CGImageGetHeight(cgImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *data = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate( data, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(context);
    
    int byteIndex = (bytesPerRow * point.y) + (bytesPerPixel * point.x);
    CGFloat red = data[byteIndex];
    CGFloat green = data[byteIndex + 1];
    CGFloat blue = data[byteIndex + 2];
    CGFloat alpha = data[byteIndex + 3];
    
    NSLog(@"%f, %f, %f, %f, %i", red, green, blue, alpha, byteIndex);
    
    UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
    
    free(data);
    
    return color;
*/
    
}

- (void)calcEmoteCoordinates:(UIColor *)color
{
    NSString *emotion = @"emote 0 0\r";
    if ([color isEqual:[UIColor romiboGreen]])    emotion = @"emote -100 100\r";
    else if ([color isEqual:[UIColor romiboYellow]])   emotion = @"emote 100 -100\r";
    else if ([color isEqual:[UIColor romiboRed]])   emotion = @"emote 100 100\r";
    else if ([color isEqual:[UIColor romiboBlue]]) emotion = @"emote -100 -100\r";

    [[appDelegate romibo] sendString:emotion];
}

/*
- (void)calcEmoteCoordinates:(int)x :(int)y
{
    
    float emoteX = x;
    float emoteY = y;
    
    emoteX = emoteX * 0.59 / 2;
    emoteY = - (emoteY - 169) * 0.59;  //iOS origin is upper left instead of lower left
    
    [[appDelegate romibo] sendEmoteCmd:roundf(emoteX):roundf(emoteY)];
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end