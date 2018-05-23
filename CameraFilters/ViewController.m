//
//  ViewController.m
//  filters
//
//  Created by zhaohang on 2018/5/15.
//  Copyright © 2018年 HangZhao. All rights reserved.
//
//相机，image和录像其实都一样，都可以使用自定的组合滤镜进行处理
#import "ViewController.h"
#import "UIView+Tools.h"
#import "UIDevice+Tools.h"
#import "DDFilterListView.h"
#import "DDFilterItem.h"
#import "DDFilters.h"
#import "MKGPUImageFilterPipeline.h"
#import  <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()<DDFilterListViewDelegate>
@property (nonatomic, strong) GPUImageStillCamera *camera;

//filters
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DDFilterListView *filterListView;
@property (nonatomic, strong) DDFilterItem *lastActicityFilter;
@property (nonatomic, strong) NSArray *cameraFilters;
@property (nonatomic, strong) MKGPUImageFilterPipeline *filterSet;
@property (nonatomic, strong) GPUImageView *outputView;
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, copy)   NSString *filterName;

@property (nonatomic, strong) UIButton *button;
@end

@implementation ViewController

-  (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.camera startCameraCapture];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"image"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.hidden = YES;
        _imageView.frame = [self getImageViewFrame];
    }
    return _imageView;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_button setTitle:@"拍照" forState:(UIControlStateNormal)];
        _button.frame = CGRectMake(self.view.width/2-40, self.filterListView.bottom + 40, 80, 40);
        [_button setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        [_button addTarget:self action:@selector(onTakePhoto) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}

- (CGRect)getImageViewFrame{
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (@available(iOS 11, *)) {
        inset = self.view.safeAreaInsets;
    }
    CGFloat flag = 300+64+10+10;
    CGFloat w = [UIDevice screenWidth]-20-inset.left-inset.right;
    CGFloat maxH = [UIDevice screenHeight]-flag-inset.bottom-inset.top-50;
    CGFloat imgW = 612  ;
    CGFloat imgH = 408;
    CGFloat h = w * imgH / imgW;
    if (h > maxH) {
        h = maxH;
        w = h * imgW / imgH;
    }
    return CGRectMake(([UIDevice screenWidth]-w)/2, 64, w, h);
}

- (GPUImageStillCamera *)camera{
    if (!_camera) {
        _camera = [[GPUImageStillCamera alloc] init];
        _camera.captureSessionPreset = AVCaptureSessionPreset640x480;
        _camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
    return _camera;
}

-(GPUImageView *)outputView{
    if (!_outputView) {
        _outputView = [[GPUImageView alloc] init];
        _outputView.backgroundColor = [UIColor clearColor];
        _outputView.frame = self.imageView.frame;
        _outputView.fillMode = 0;
    }
    return _outputView;
}

-(GPUImagePicture *)picture{
    if (!_picture) {
        _picture = [[GPUImagePicture alloc] initWithImage:self.imageView.image];
    }
    return _picture;
}

- (void)initFilterSet{
    _filterSet = [[MKGPUImageFilterPipeline alloc] initWithName:self.filterName input:self.camera output:self.outputView];
    [self.view addSubview:self.outputView];
}

- (NSArray *)cameraFilters{
    if (!_cameraFilters) {
        NSArray *filterArray = @[@"Origin",@"Film",@"Forest",@"Lake",@"Lomo",@"NYC",@"Tea",@"Vintage",@"Moment",@"aqua",@"02",@"06",@"17",@"crossprocess",@"purple-green",@"yellow-red",@"Filter18",@"Filter1",@"Filter5",@"Filter6",@"Filter16",@"Filter7",@"Filter9",@"Filter11",@"Filter8",@"Filter12",@"Filter15",@"Filter17",@"Filter4",@"Filter3",@"Filter2",@"Filter10",@"Filter13",@"Filter14"];
        NSMutableArray *filters = [NSMutableArray array];
        for (NSString *filterName in filterArray) {
            if ([filterName isKindOfClass:[NSString class]]) {
                [filters addObject:[[DDFilterItem alloc] initWithFilterName:filterName
                                                                      image:self.imageView.image
                                                             selectionStyle:DDFilterItemSelectionStyle_Singleton]];
            }
        }
        _cameraFilters = filters;
        
    }
    return _cameraFilters;
}



- (void)prepareFilterListView {
    if (!self.filterListView) {
        
        self.filterListView = [[DDFilterListView alloc] initWithFrame:ccr(0, 400,self.view.width, 150)
                                                          filterItems:self.cameraFilters
                                                       filterDelegate:self
                                                    initialFilterItem:[self.cameraFilters firstObject]];
        [self.filterListView setBackgroundColor:[UIColor blackColor]];
    }
}

- (BOOL)filterListViewSelectedFilter:(DDFilterItem *)filterItem withFilterSwitchView:(DDFilterSwitchView *)filterSwitchView{
    if ([self.filterSet.name isEqualToString:filterItem.btnText]) {
        return NO;
    }
  
    [self.filterSet changeMainFilterWithName:filterItem.btnText];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareFilterListView];
    self.filterName = @"Origin";
    [self initFilterSet];
    [self.view addSubview:self.button];
    [self.view addSubview:self.filterListView];
}
//相机输出的照片默认是向右反转的，需要修正，懒，不想写了，这里也要版本适配，方法9.0舍弃了
- (void)onTakePhoto{
    [self.camera capturePhotoAsJPEGProcessedUpToFilter:self.filterSet.mainFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:self.camera.currentCaptureMetadata completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                //失败
            }else{
                //成功
            }
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}




@end
