//
//  DDValenciaFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter14.h"

NSString *const kShaderString14 = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 mat3 pa1 = mat3(
                            1.1402,
                            -0.0598,
                            -0.061,
                            -0.1174,
                            1.0826,
                            -0.1186,
                            -0.0228,
                            -0.0228,
                            1.1772);
 
 vec3 pa2 = vec3(.3, .59, .11);
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .1666666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .8333333)).b
                  );
     
     texel = pa1 * texel;
     float pa3 = dot(pa2, texel);
     texel = vec3(
                  texture2D(inputImageTexture3, vec2(pa3, texel.r)).r,
                  texture2D(inputImageTexture3, vec2(pa3, texel.g)).g,
                  texture2D(inputImageTexture3, vec2(pa3, texel.b)).b);
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation DDFilter14

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString14 sources:@[[DDImageFilter filterImageNamed:@"fp37"],[DDImageFilter filterImageNamed:@"fp38"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
