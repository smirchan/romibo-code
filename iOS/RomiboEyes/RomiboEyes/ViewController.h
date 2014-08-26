//
//  ViewController.h
//  RomiboEyes
//
//  Created by Suvir Mirchandani on 6/25/14.
//  Copyright (c) 2014 Suvir Mirchandani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EyesView.h"
#import <opencv2/highgui/cap_ios.h>     // Import OpenCV header file


@interface ViewController : UIViewController <CvVideoCameraDelegate>
{
    EyesView *eyesView;
    Eye *eye1, *eye2;
    UIButton *cameraButton;

}

@property CvVideoCamera *camera;
@property UIImageView *imageView;
- (void)setupEyes;
- (void)addCameraButton;
- (void)startCamera:(UIButton *)button;
@end
