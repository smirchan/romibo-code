//
//  DrivingNubView.h
//  
//
//  Created by HCII on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "NubViewBase.h"

@interface DrivingNubView : NubViewBase

@property (nonatomic, strong) CMMotionManager *motionManager;

- (void)startAccelerometer;
- (void)stopAccelerometer;
- (int)getLarger :(int)i :(int)j;
- (int)getSmaller :(int)i :(int)j;

@end

