//
//  ViewController.m
//  AVAssetExportSessionDemo
//
//  Created by 向洪 on 2017/6/20.
//  Copyright © 2017年 向洪. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"av.mp4" ofType:nil];
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    [self exportAsynchronouslyWithAVAsset:asset];
}

- (void)exportAsynchronouslyWithAVAsset:(AVAsset *)asset {
    
    // AVAssetExportSession - 转码
    
    /*
     初始化
     
     presetName 说明：
     
     AVAssetExportPresetLowQuality  AVAssetExportPresetMediumQuality  AVAssetExportPresetHighestQuality
     
     AVAssetExportPreset640x480 AVAssetExportPreset960x540 AVAssetExportPreset1280x720 AVAssetExportPreset1920x1080 AVAssetExportPreset3840x2160
     
     AVAssetExportSessionStatusCancelled
     
     AVAssetExportPresetAppleM4A
     
     AVAssetExportPresetPassthrough
     */
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    
    // 输出地址
    NSString *outputPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"av1.mp4"];
    exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
    
    // 文件类型, 目前只支持 AVFileTypeMPEG4 AVFileTypeQuickTimeMovie
    NSLog(@"supportedFileTypes：%@", exportSession.supportedFileTypes);
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    // 文件大小限制
//    exportSession.fileLengthLimit = 1024 * 1024 * 1024;
    // 时间限制
    exportSession.timeRange = CMTimeRangeMake(CMTimeMake(0, 0), CMTimeMake(1, 1));
    
    // AVMetadataItem 元数据
    exportSession.metadata = nil;
    // AVMetadataItemFilter 过滤器
    exportSession.metadataItemFilter = nil;
    
    // AVAudioMix 音频处理
    exportSession.audioMix = nil;
    // 时间距算法
    exportSession.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmSpectral;
    // 网络优化？,默认为no
    exportSession.shouldOptimizeForNetworkUse = YES;
    // 视频处理 AVVideoComposition AVMutableVideoComposition
    exportSession.videoComposition = nil;
    // AVVideoCompositing 协议和相关类，让你可以自定义视频的合成排版
    NSLog(@"%@", exportSession.customVideoCompositor);
    
    // 默认为no ， 设置为yes 的时候，质量更高,
    exportSession.canPerformMultiplePassesOverSourceMediaData = NO;
    // 缓存地址， canPerformMultiplePassesOverSourceMediaData为yes需要用到
    exportSession.directoryForTemporaryFiles = nil;

    
    // 启动,
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        // 完成回调
        NSLog(@"%ld", exportSession.status);
        
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            
            NSLog(@"%@", exportSession.outputURL);
        }

    }];
    
    // 取消
    //    [exportSession cancelExport];
    
    // 最大时间
    CMTimeShow(exportSession.maxDuration);
    // AVAssetExportSessionStatusFailed or AVAssetExportSessionStatusCancelled.    exportSession.error;
    
    // 进度
    NSLog(@"%lf", exportSession.progress);
    // 状态 AVAssetExportSessionStatus
    NSLog(@"%ld", exportSession.status);
    
    // exportSession.asset 资源
    
    // 所有的 presetName
    NSLog(@"presetName：%@", [AVAssetExportSession allExportPresets]);
    // 可以使用的 presetName
    NSLog(@"presetName：%@", [AVAssetExportSession exportPresetsCompatibleWithAsset:asset]);
    // 判断兼容性,用户判断AVAssetExportSession是否能够成功输出转换的视音频文件
    [AVAssetExportSession determineCompatibilityOfExportPreset:AVAssetExportPresetMediumQuality withAsset:asset outputFileType:AVFileTypeMPEG4 completionHandler:^(BOOL compatible) {
        
        NSLog(@"compatible：%d", compatible);
    }];
    // 确定可以使用的文件类型
    [exportSession determineCompatibleFileTypesWithCompletionHandler:^(NSArray<NSString *> * _Nonnull compatibleFileTypes) {
        
        NSLog(@"compatible：%@", compatibleFileTypes);
    }];
}



- (IBAction)right_item_action:(id)sender {
    
//    TZImagePickerController *imagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
//    imagePickerController.allowPickingOriginalPhoto = NO;
//    imagePickerController.allowPickingVideo = YES;
//    imagePickerController.allowPickingPhoto = NO;
//    
//    // 相册
//    [imagePickerController setDidFinishPickingVideoWithInfoHandle:^(UIImage *coverImage, id asset, NSURL *fileURL) {
//    
//        NSLog(@"asdsad = %ld", [NSData dataWithContentsOfURL:fileURL].length);
//        [self exportAsynchronouslyWithAVAsset:[AVURLAsset assetWithURL:fileURL]];
//    }];
//    
//    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
