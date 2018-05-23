//
//  DDRiseImageFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter1.h"

NSString *const kShaderString1 = SHADER_STRING
(
 precision lowp float;
 // image 像素
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 uniform sampler2D inputImageTexture4;
 
 void main()
 {
     
    vec4 texel = texture2D(inputImageTexture, textureCoordinate);
    vec3 papa1 = texture2D(inputImageTexture2, textureCoordinate).rgb;
     
     texel.r = texture2D(inputImageTexture3, vec2(papa1.r, texel.r)).r;
     texel.g = texture2D(inputImageTexture3, vec2(papa1.g, texel.g)).g;
     texel.b = texture2D(inputImageTexture3, vec2(papa1.b, texel.b)).b;
     //像素点颜色  r g b a
     vec4 mapped;
     mapped.r = texture2D(inputImageTexture4, vec2(texel.r, .16666)).r;
     mapped.g = texture2D(inputImageTexture4, vec2(texel.g, .5)).g;
     mapped.b = texture2D(inputImageTexture4, vec2(texel.b, .83333)).b;
     mapped.a = 1.0;
     
     gl_FragColor = mapped;
 }
 );

@implementation DDFilter1

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString1 sources:@[[DDImageFilter filterImageNamed:@"fp2.jpg"],[DDImageFilter filterImageNamed:@"fp3"],
                                                                                  [DDImageFilter filterImageNamed:@"fp4"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
