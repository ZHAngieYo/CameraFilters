//
//  DDWaldenFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter12.h"

NSString *const kShaderString12 = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .83333)).b);
     
     vec2 pa1 = (2.0 * textureCoordinate) - 1.0;
     float d = dot(pa1, pa1);
     vec2 pa2 = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture3, pa2).r;
     pa2.y = texel.g;
     texel.g = texture2D(inputImageTexture3, pa2).g;
     pa2.y = texel.b;
     texel.b = texture2D(inputImageTexture3, pa2).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation DDFilter12

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString12 sources:@[[DDImageFilter filterImageNamed:@"fp31"],[DDImageFilter filterImageNamed:@"fp5"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
