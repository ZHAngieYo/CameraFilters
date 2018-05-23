//
//  DDImageFilter.h
//  filters
//
//  Created by zhaohang on 2018/5/16.
//  Copyright © 2018年 HangZhao. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "GPUImageSixInputFilter.h"

@interface DDImageFilter : GPUImageFilterGroup

+(GPUImagePicture*)filterImageNamed:(NSString*)name;


- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString sources:(NSArray<GPUImagePicture*>*)sources;
- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;

- (NSString*)name;
@end
