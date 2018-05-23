//
//  MKGPUImageFilterPipeline.m
//  filters
//
//  Created by zhaohang on 2018/5/15.
//  Copyright © 2018年 HangZhao. All rights reserved.
//

#import "MKGPUImageFilterPipeline.h"


@interface MKGPUImageFilterPipeline()
{
    BOOL isFromStillImage;
}

@property (nonatomic, strong) GPUImageCropFilter *cropFilter;
@property (nonatomic, strong) GPUImageTransformFilter *mirrorFilter;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) GPUImageOutput *input;

@property (nonatomic, assign) BOOL realMirror;
//对比度
@property (nonatomic, strong) GPUImageContrastFilter *contrastFilter;
//饱和度
@property (nonatomic, strong) GPUImageSaturationFilter *saturationFilter;
@end

@implementation MKGPUImageFilterPipeline

- (id)initWithName:(NSString *)name input:(GPUImageOutput *)input output:(id<GPUImageInput>)output
{
    self = [super init];
    if (self) {
        self.input = input;
        self.output = output;
        
        isFromStillImage = [self.input isKindOfClass:[GPUImagePicture class]];
        
        if (!isFromStillImage) {
            self.cropFilter = [[GPUImageCropFilter alloc] init];
            self.cropFilter.cropRegion = CGRectMake(0, 0.125, 1, 0.75); // iPhone 4s: 0.75, iPhone 4: 0.747
        }
        
        self.name = name;
        [self _resetMainFilter];

        self.realMirror = YES;
        [self _setMirror:NO];
        
        [self _connectFilterChain];
        [self refreshInput];
    }
    return self;
}

// filters: input -> crop -> tiltshift -> contrast -> saturation -> main -> mirror -> output
- (void)_disconnectFilterChain
{
    [self.input removeAllTargets];
    [self.cropFilter removeAllTargets];
    [self.tiltShiftCircleFilter removeAllTargets];
    [self.tiltShiftHorizonFilter removeAllTargets];
    [self.contrastFilter removeAllTargets];
    [self.saturationFilter removeAllTargets];
    [self.mainFilter removeAllTargets];
    [self.mirrorFilter removeAllTargets];
}

- (void)_connectFilterChain
{
    NSMutableArray *filters = [NSMutableArray array];
    
    if (self.cropFilter) [filters addObject:self.cropFilter];
    if (self.tiltShiftCircleFilter) [filters addObject:self.tiltShiftCircleFilter];
    if (self.tiltShiftHorizonFilter) [filters addObject:self.tiltShiftHorizonFilter];
    if (self.contrastFilter) [filters addObject:self.contrastFilter];
    if (self.saturationFilter) [filters addObject:self.saturationFilter];
    if (self.mainFilter) [filters addObject:self.mainFilter];
    //暂时没有用到
    if (self.mirrorFilter) [filters addObject:self.mirrorFilter];
    
    id filter = self.input;
    for (uint i=0; i<filters.count; i++) {
        [filter addTarget:filters[i]];
        filter = filters[i];
    }
    [filter addTarget:self.output];
    
}

- (void)_setMirror:(BOOL)mirror
{
    if (self.realMirror == mirror) {
        return;
    }
    if (mirror) {
        self.mirrorFilter = [[GPUImageTransformFilter alloc] init];
        CATransform3D perspectiveTransform = CATransform3DIdentity;
        perspectiveTransform.m34 = 0.4;
        perspectiveTransform.m33 = 0.4;
        perspectiveTransform = CATransform3DRotate(perspectiveTransform, M_PI, 0.0, 1.0, 0.0);
        self.mirrorFilter.transform3D = perspectiveTransform;
    } else {
        self.mirrorFilter = nil;
    }
    
    self.realMirror = mirror;
}

- (void)setMirror:(BOOL)mirror
{
    [self _disconnectFilterChain];
    _mirror = mirror;
    
    [self _setMirror:self.mirror];
    
    [self _connectFilterChain];
    [self refreshInput];
}

- (void)_resetMainFilter
{
    self.mainFilter = [MKGPUImageFilterPipeline filterWithName:self.name];
}

- (UIImage *)currentOutputFrameWithImageOrientation:(UIImageOrientation)imageOrientataion
{
    if ([self.input isKindOfClass:[GPUImagePicture class]]) {
        return [UIImage imageWithCGImage:[self.mainFilter imageFromCurrentFramebuffer].CGImage scale:1.0f orientation:imageOrientataion];
    } else {
        return nil;
    }
}

- (void)refreshInput
{
    if (isFromStillImage) {
        [self.mainFilter useNextFrameForImageCapture];
        [((GPUImagePicture *)self.input) processImage];
    }
}

- (void)changeMainFilterWithName:(NSString *)name
{
    [self _disconnectFilterChain];
    self.name = name;
    [self _resetMainFilter];
    [self _connectFilterChain];
    [self refreshInput];
}

- (void)changeInput:(GPUImageOutput *)input
{
    [self _disconnectFilterChain];

    self.input = input;
    isFromStillImage = [self.input isKindOfClass:[GPUImagePicture class]];
    if (isFromStillImage) {
        self.cropFilter = nil;
        [self _setMirror:NO];
        _mirror = NO;
    } else {
        self.cropFilter = [[GPUImageCropFilter alloc] init];
        self.cropFilter.cropRegion = CGRectMake(0, 0.125, 1, 0.75); // iPhone 4s: 0.75, iPhone 4: 0.747
        [self _setMirror:self.mirror];
    }

    [self _connectFilterChain];
    [self refreshInput];
}

- (void)setTiltShiftType:(TiltShiftType)tiltType
{
    if (tiltType == TiltShiftType_Cycle) {
        [((GPUImagePicture *)self.input) removeAllTargets];
        [self _disconnectFilterChain];
        self.tiltShiftHorizonFilter = nil;
        if (!self.tiltShiftCircleFilter) {
            self.tiltShiftCircleFilter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
        }
        [self _connectFilterChain];
    } else if (tiltType == TiltShiftType_Rect) {
        [self _disconnectFilterChain];
        self.tiltShiftCircleFilter = nil;
        if (!self.tiltShiftHorizonFilter) {
            self.tiltShiftHorizonFilter = [[GPUImageTiltShiftFilter alloc] init];
        }
        [self _connectFilterChain];
    } else {
        if (self.tiltShiftCircleFilter || self.tiltShiftHorizonFilter) {
            [self _disconnectFilterChain];
            self.tiltShiftHorizonFilter = nil;
            self.tiltShiftCircleFilter = nil;
            [self _connectFilterChain];
        }
    }
    
    //    [self refreshInput];
}

- (BOOL)toggleAutoOptimize
{
    [self _disconnectFilterChain];
    if (self.contrastFilter) {
        self.contrastFilter = nil;
        self.saturationFilter = nil;
        [self _connectFilterChain];
        
        return NO;
    } else {
        self.contrastFilter = [[GPUImageContrastFilter alloc] init];
        self.saturationFilter = [[GPUImageSaturationFilter alloc] init];
        [self _connectFilterChain];
        
        return YES;
    }
}

+ (GPUImageOutput<GPUImageInput> *)filterWithName:(NSString *)name
{
    if ([name hasPrefix:@"Filter"]) {
        return [[NSClassFromString([NSString stringWithFormat:@"DD%@", name]) alloc] init];
    } else {
        GPUImageToneCurveFilter *filter = [[GPUImageToneCurveFilter alloc] init];
        [filter setPointsWithACV:[NSString stringWithFormat:@"%@", name]];
        return filter;
    }
    return nil;
}



@end
