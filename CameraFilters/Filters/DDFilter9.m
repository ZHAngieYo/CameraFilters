//
//  DDEarlybirdFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter9.h"

NSString *const kShaderString9 = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 uniform sampler2D inputImageTexture4;
 uniform sampler2D inputImageTexture5;
 uniform sampler2D inputImageTexture6;
 
 const mat3 saturate = mat3(
                            1.210300,
                            -0.089700,
                            -0.091000,
                            -0.176100,
                            1.123900,
                            -0.177400,
                            -0.034200,
                            -0.034200,
                            1.265800);
 const vec3 rgbPrime = vec3(0.25098, 0.14640522, 0.0);
 const vec3 desaturate = vec3(.3, .59, .11);
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     
     vec2 papa1;
     papa1.y = 0.5;
     
     papa1.x = texel.r;
     texel.r = texture2D(inputImageTexture2, papa1).r;
     
     papa1.x = texel.g;
     texel.g = texture2D(inputImageTexture2, papa1).g;
     
     papa1.x = texel.b;
     texel.b = texture2D(inputImageTexture2, papa1).b;
     
     float papa2;
     vec3 result;
     papa2 = dot(desaturate, texel);
     
     
     papa1.x = papa2;
     result.r = texture2D(inputImageTexture3, papa1).r;
     papa1.x = papa2;
     result.g = texture2D(inputImageTexture3, papa1).g;
     papa1.x = papa2;
     result.b = texture2D(inputImageTexture3, papa1).b;
     
     texel = saturate * mix(texel, result, .5);
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     
     vec3 sampled;
     papa1.y = .5;
     
     papa1 = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture4, papa1).r;
     papa1.y = texel.g;
     texel.g = texture2D(inputImageTexture4, papa1).g;
     papa1.y = texel.b;
     texel.b = texture2D(inputImageTexture4, papa1).b;
     float value = smoothstep(0.0, 1.25, pow(d, 1.35)/1.65);
     
     papa1.x = texel.r;
     sampled.r = texture2D(inputImageTexture5, papa1).r;
     papa1.x = texel.g;
     sampled.g = texture2D(inputImageTexture5, papa1).g;
     papa1.x = texel.b;
     sampled.b = texture2D(inputImageTexture5, papa1).b;
     texel = mix(sampled, texel, value);
     
     
     papa1.x = texel.r;
     texel.r = texture2D(inputImageTexture6, papa1).r;
     papa1.x = texel.g;
     texel.g = texture2D(inputImageTexture6, papa1).g;
     papa1.x = texel.b;
     texel.b = texture2D(inputImageTexture6, papa1).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation DDFilter9

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString9 sources:@[[DDImageFilter filterImageNamed:@"fp22"],[DDImageFilter filterImageNamed:@"fp23"],[DDImageFilter filterImageNamed:@"fp5"],[DDImageFilter filterImageNamed:@"fp24"],[DDImageFilter filterImageNamed:@"fp25"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
