//
//  DDHudsonFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter5.h"

NSString *const kShaderString5 = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 uniform sampler2D inputImageTexture4;
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     
     vec3 pa1 = texture2D(inputImageTexture2, textureCoordinate).rgb;
     
     texel.r = texture2D(inputImageTexture3, vec2(pa1.r, texel.r)).r;
     texel.g = texture2D(inputImageTexture3, vec2(pa1.g, texel.g)).g;
     texel.b = texture2D(inputImageTexture3, vec2(pa1.b, texel.b)).b;
     
     vec4 pa2;
     pa2.r = texture2D(inputImageTexture4, vec2(texel.r, .16666)).r;
     pa2.g = texture2D(inputImageTexture4, vec2(texel.g, .5)).g;
     pa2.b = texture2D(inputImageTexture4, vec2(texel.b, .83333)).b;
     pa2.a = 1.0;
     gl_FragColor = pa2;
 }
 );

@implementation DDFilter5

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString5 sources:@[[DDImageFilter filterImageNamed:@"fp16.jpg"],[DDImageFilter filterImageNamed:@"fp3"],[DDImageFilter filterImageNamed:@"fp17"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
