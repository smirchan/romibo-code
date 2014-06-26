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

@interface ViewController ()

@end

@implementation ViewController

@synthesize camera;

using namespace cv;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0];
    
    NSLog(@"Did Load");
    
    [self setupEyesSubview];
    
    [self addCameraButton];
    
    camera = [[CvVideoCamera alloc] init];
    //camera.delegate = self;
    camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    camera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    else {
        camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
    
    camera.defaultFPS = 4;
    camera.grayscaleMode = NO;
}

- (void)setupEyesSubview
{
    eyesView = [[EyesView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
    
    [self.view addSubview:eyesView];

}

- (void)addCameraButton
{
    cameraButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cameraButton addTarget:self action:@selector(startCamera:) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton setTitle:@"Start" forState:UIControlStateNormal];
    cameraButton.frame = CGRectMake(10, 10, 100, 100);
    [self.view addSubview:cameraButton];
}

- (void)startCamera:(UIButton *)button
{
    [button setTitle:@"Stop" forState:UIControlStateApplication];
    NSLog(@"Blink");
    [eyesView blink];
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
