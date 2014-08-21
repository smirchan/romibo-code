//
//  ViewController.m
//  RomiboEyes
//
//  Created by Suvir Mirchandani on 6/25/14.
//  Copyright (c) 2014 Suvir Mirchandani. All rights reserved.
//

#import "ViewController.h"
#import "EyesView.h"
#import <opencv2/highgui/highgui_c.h>
#import <opencv2/highgui/cap_ios.h>

using namespace cv;

NSString * const faceCascadeName = @"haarcascade_mcs_eyepair_big";
NSString * const faceCascadePath = [[NSBundle mainBundle] pathForResource:faceCascadeName ofType:@"xml"];

CascadeClassifier faceCascade;

@protocol CvVideoCameraDelegate;

@interface ViewController ()


@end


@implementation ViewController

@synthesize camera;
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    self.view.clipsToBounds = YES;
    self.view.autoresizesSubviews = NO;
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0];
    
    NSLog(@"Did Load");
    
    [self setupEyes];
    
    [self addCameraButtons];
    
    camera = [[CvVideoCamera alloc] initWithParentView:imageView];
    camera.delegate = self;
    camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    camera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    else {
        camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
    
    camera.defaultFPS = 5;
    camera.grayscaleMode = NO;
    
}

- (void)setupEyes
{
    CGFloat height = self.view.bounds.size.width;  // In landscape
    CGFloat width = self.view.bounds.size.height;
    
    eyesView = [[EyesView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.view addSubview:eyesView];

    CGFloat eyeHeight = 0.6 * height;
    CGFloat eyeWidth = 0.125 * width;
    
    CGFloat eyeMarginVertical = 60;
    CGFloat eyeMarginHorizontal  = (width - 2 * eyeWidth) / 3;
    
    
    eye1 = [[Eye alloc] initWithFrame:CGRectMake( eyeMarginHorizontal, (height - eyeHeight) / 2, eyeWidth, eyeHeight )];
    [eyesView addSubview:eye1];
    
    eye2 = [[Eye alloc] initWithFrame:CGRectMake( 2 * eyeMarginHorizontal + eyeWidth, (height - eyeHeight) / 2, eyeWidth, eyeHeight )];
    [eyesView addSubview:eye2];
}

- (void)addCameraButtons
{
    cameraButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cameraButton addTarget:self action:@selector(startCamera:) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton setTitle:@"Start" forState:UIControlStateNormal];
    cameraButton.frame = CGRectMake(10, 10, 100, 100);
    [self.view addSubview:cameraButton];
    cameraButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cameraButton addTarget:self action:@selector(moveEyes) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton setTitle:@"Start" forState:UIControlStateNormal];
    cameraButton.frame = CGRectMake(10, 30, 100, 100);
    [self.view addSubview:cameraButton];

}

- (void)startCamera:(UIButton *)button
{
    [button setTitle:@"Stop" forState:UIControlStateApplication];
    NSLog(@"Blink");
    [eyesView blink];
    faceCascade.load([faceCascadePath UTF8String]);
    [camera start];
}


- (void)moveEyes
{
    if (camera.running) {
        [eye1 setFrame:eye1.newFrame];
    }
}

- (void)processImage:(Mat&)colorFrame;
{
    NSLog(@"Process");
    vector<Mat> bgrPlanes;
    split(colorFrame, bgrPlanes);
    Mat grayFrame = bgrPlanes[2]; // R channel
    vector<cv::Rect> faceRects;
    
    faceCascade.detectMultiScale(grayFrame, faceRects, 1.1, 3, 0, cv::Size(25,25));
    
    for(unsigned int r = 0; r < faceRects.size(); ++r) {
        cv::rectangle(colorFrame, faceRects[r], cv::Scalar(255,255,0));
        [eye1 moveX:10 Y:0];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
