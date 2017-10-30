//
//  LLRecordViewController.m
//  AudioVideoLearn
//
//  Created by lin zoup on 2/24/17.
//  Copyright © 2017 cDuozi. All rights reserved.
//

#import "LLRecordViewController.h"
#import <AVFoundation/AVFoundation.h>

#define VIDEOPATH @"video"

@interface LLRecordViewController () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundIdentifier;
@property (nonatomic, assign) BOOL recording;

@property (nonatomic, strong) AVCaptureSession *capSession;
@property (nonatomic, strong) AVCaptureDeviceInput *audioCapInput;
@property (nonatomic, strong) AVCaptureDeviceInput *videoCapInput;

@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;//拍摄视频
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;//拍照

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *capVideoPreviewLayer;//视频预览层


@end

@implementation LLRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"录制视频";
    self.view.backgroundColor = [UIColor orangeColor];
    
    // set right navigation item
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Start"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self action:@selector(recordVideo)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
//    [self.navigationItem.rightBarButtonItem setTitle:@"Start"];
//    [self.navigationItem.rightBarButtonItem setTarget:self];
//    [self.navigationItem.rightBarButtonItem setAction:@selector(recordVideo)];
//    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
//    [self.navigationItem.rightBarButtonItem setWidth:80.0];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blueColor]];
    
    [self initCaptureVideo];
    
    [self initSubViews];
    
    [self startMonitor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@">> %@ dealloc", NSStringFromClass([self class]));
}

- (void)initSubViews {
    
    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    flashBtn.frame = CGRectMake(100, 200, 120, 40);
    [flashBtn setTitle:@"Flash On/Off" forState:UIControlStateNormal];
//    [flashBtn addTarget:self action:@selector(flashObClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
}

/* 
 
 相关函数介绍说明：
 
 AVCaptureSession 音视频捕获回话
 AVCaptureDevice  输入设备，包括麦克风，摄像头，可设置物理设备的一些属性
 AVCaptureDeviceInput 设备输入数据管理对象，将该对象添加到AVCaptureSession中管理
 AVCaptureVideoPreviewLayer 相机拍摄预览图层，是CALayer的子类，使用此对象可实时查看拍照或视频录制效果
 AVCaptureOutput  输出数据管理对象，用于接收各类输出数据，通常使用该类的子类
       (AVCaptureAudioDataOutput、AVCaptureStillImageOutput、AVCaptureVideoDataOutput、AVCaptureFileOutput)
 
 AVCaptureConnection  当把一个输入或输出添加到 AVCaptureSession 之后，AVCaptureSession就会在所有响应的输入、输出设备之间建立AVCaptureConnection
 
 */

- (void) initCaptureVideo {

    NSError *error = nil;

    // init audio session
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&error];
    if (error) {
        return;
    }
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (error) {
        return;
    }
    
    
    // init session
    _capSession = [AVCaptureSession new];
    if ([_capSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        [_capSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    // init device
    AVCaptureDevice *audioCapDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];//why first
    AVCaptureDevice *videoCapDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] firstObject];
    
    // init device input
    _audioCapInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCapDevice error:&error];
    if (error) {
        return;
    }
    _videoCapInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoCapDevice error:&error];
    if (error) {
        return;
    }
    
    // init output
    _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    [_capSession beginConfiguration];
    
    // add output to session
    if ([_capSession canAddOutput:_movieFileOutput]) {
        [_capSession addOutput:_movieFileOutput];
    }
    // add input to sesion
    if ([_capSession canAddInput:_audioCapInput]) {
        [_capSession addInput:_audioCapInput];
        AVCaptureConnection *capConnection = [_movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        // 表示视频录入时稳定音频流的接受，我们这里设置为自动
        if ([capConnection isVideoStabilizationSupported]) {
            capConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    if ([_capSession canAddInput:_videoCapInput]) {
        [_capSession addInput:_videoCapInput];
    }
    
    [_capSession commitConfiguration];
    
    // init previe layer
    _capVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_capSession];
    CALayer *layer = self.view.layer;
    _capVideoPreviewLayer.frame = layer.bounds;
    _capVideoPreviewLayer.masksToBounds = YES;
    _capVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充整个视图
    [layer addSublayer:_capVideoPreviewLayer];
    
    // 视图渲染到预览层上
//    [_capSession startRunning];
}

- (void)recordVideo {
    if (_recording) {
        [self endRecordVideo];
        [self.navigationItem.rightBarButtonItem setTitle:@"Start"];
    } else {
        [self startRecordVideo];
        [self.navigationItem.rightBarButtonItem setTitle:@"End"];
    }
    _recording = !_recording;
}

- (void)startRecordVideo {
    
    AVCaptureConnection *capConnection = [_movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    // 开启视频防抖模式
    AVCaptureVideoStabilizationMode stabMode = AVCaptureVideoStabilizationModeCinematic;
    if ([_audioCapInput.device.activeFormat  isVideoStabilizationModeSupported:stabMode]) {
        [capConnection setPreferredVideoStabilizationMode:stabMode];
    }
    // 如果支持多任务则开始多任务
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        _backgroundIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    }
    
    // 预览图层与视频方向保持一致
    capConnection.videoOrientation = [_capVideoPreviewLayer connection].videoOrientation;
    
    // 设置视频输出的文件路径，设置为temp
    NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingString:VIDEOPATH];
    NSURL *fileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    // 视图渲染到预览层上
    [_capSession startRunning];
    
    //往路径的URL开始写入录像Buffer，边录边写
    [_movieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
}

- (void)endRecordVideo {
    [_movieFileOutput stopRecording];
    [_capSession stopRunning];
}

- (void)startMonitor {
    __weak LLRecordViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        while (1) {
            sleep(1);
            if (weakSelf.recording) {
                [weakSelf getRecordFileSize];
            }
        }
    });
}

- (CGFloat)getRecordFileSize {
    NSError *error = nil;
    NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingString:VIDEOPATH];
    NSDictionary *outputFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:outputFilePath error:&error];
    NSLog (@">>>> file size: %.2fM", (unsigned long long)[outputFileAttributes fileSize]/1024.00/1024.0);
    return (CGFloat)[outputFileAttributes fileSize]/1024.00 /1024.00;
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    NSLog(@">>>>>>>>>>>>>>>>>>>  Start to Record");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@">>>>>>>>>>>>>>>>>>>  End to Record");
}


@end
