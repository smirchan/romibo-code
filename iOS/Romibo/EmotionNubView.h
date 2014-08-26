//
//  EmotionNubView.h
//  
//
//  Created by HCII on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NubViewBase.h"

@interface EmotionNubView : NubViewBase

- (UIColor*)getColorForPoint:(CGPoint)point;
-(void)calcEmoteCoordinates:(UIColor*)color;

@end
