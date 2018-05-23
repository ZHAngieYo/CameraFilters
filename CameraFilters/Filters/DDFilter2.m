//
//  DDInkwellFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter2.h"

NSString *const kShaderString2 = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     texel = vec3(dot(vec3(0.3, 0.6, 0.1), texel));
     texel = vec3(texture2D(inputImageTexture2, vec2(texel.r, .16666)).r);
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation DDFilter2

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString2 sources:@[[DDImageFilter filterImageNamed:@"fp1"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
