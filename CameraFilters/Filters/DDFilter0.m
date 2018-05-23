//
//  Origin.m
//  filters
//
//  Created by zhaohang on 2018/5/16.
//  Copyright © 2018年 HangZhao. All rights reserved.
//

#import "DDFilter0.h"


NSString *const kIFNormalShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation DDFilter0

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFNormalShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end
