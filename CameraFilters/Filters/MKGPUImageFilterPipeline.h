//
//  MKGPUImageFilterPipeline.h
//  filters
//
//  Created by zhaohang on 2018/5/15.
//  Copyright © 2018年 HangZhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDFilters.h"

@interface MKGPUImageFilterPipeline : NSObject
@property (nonatomic, assign) BOOL mirror;

@property (nonatomic, strong) GPUImageGaussianSelectiveBlurFilter *tiltShiftCircleFilter;
@property (nonatomic, strong) GPUImageTiltShiftFilter *tiltShiftHorizonFilter;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *mainFilter;
@property (nonatomic, strong) id<GPUImageInput> output;


- (id)initWithName:(NSString *)name input:(GPUImageOutput *)input output:(id<GPUImageInput>)output;

- (UIImage *)currentOutputFrameWithImageOrientation:(UIImageOrientation)imageOrientataion;
- (void)changeMainFilterWithName:(NSString *)name;
- (void)changeInput:(GPUImageOutput *)input;
- (NSString *)name;
- (void)refreshInput;
- (BOOL)toggleAutoOptimize;
- (void)setTiltShiftType:(TiltShiftType)tiltType;

+ (GPUImageOutput<GPUImageInput> *)filterWithName:(NSString *)name;

@end
