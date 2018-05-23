//
//  DDImageFilter.m
//  filters
//
//  Created by zhaohang on 2018/5/16.
//  Copyright © 2018年 HangZhao. All rights reserved.
//

#import "DDImageFilter.h"

@implementation DDImageFilter
{
    NSArray<GPUImagePicture*>* _sources;
    NSString* _name;
}


+(GPUImagePicture*)filterImageNamed:(NSString*)name {
    
    UIImage* image = [UIImage imageNamed:name];
    
    return [[GPUImagePicture alloc] initWithImage:image];
}

- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString {
    self = [self initWithFragmentShaderFromString:fragmentShaderString sources:nil];
    
    return self;
}

- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString sources:(NSArray<GPUImagePicture*>*)sources
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    
    _sources = sources;
    
    Class filterClass;
    switch (sources.count) {
        case 1:
            filterClass = [GPUImageTwoInputFilter class];
            break;
        case 2:
            filterClass = [GPUImageThreeInputFilter class];
            break;
        case 3:
            filterClass = [GPUImageFourInputFilter class];
            break;
        case 4:
            filterClass = [GPUImageFiveInputFilter class];
            break;
        case 5:
            filterClass = [GPUImageSixInputFilter class];
            break;
        default:
            filterClass = [GPUImageFilter class];
            break;
    }
    
    GPUImageFilter* filter = [[filterClass alloc] initWithFragmentShaderFromString:fragmentShaderString];
    
    [self addFilter:filter];
    
    int sourceIndex = 1;
    for (GPUImagePicture* source in sources) {
        [source addTarget:filter atTextureLocation:sourceIndex++];
        [source processImage];
    }
    
    //初始滤镜
    self.initialFilters = [NSArray arrayWithObjects:filter, nil];
    //末尾滤镜
    self.terminalFilter = filter;
    
    return self;
}

- (NSString*)name {
    
    if(!_name) {
        _name = NSStringFromClass([self class]);
    }
    
    return _name;
}


@end
