//
//  DDHefeFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter13.h"

NSString *const kShaderString13 = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 uniform sampler2D inputImageTexture4;
 uniform sampler2D inputImageTexture5;
 uniform sampler2D inputImageTexture6;
 
 void main()
{
	vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
	vec3 pa1 = texture2D(inputImageTexture2, textureCoordinate).rgb;
	texel = texel * pa1;
	
	texel = vec3(
                 texture2D(inputImageTexture3, vec2(texel.r, .16666)).r,
                 texture2D(inputImageTexture3, vec2(texel.g, .5)).g,
                 texture2D(inputImageTexture3, vec2(texel.b, .83333)).b);
	
	vec3 pa2 = vec3(.30, .59, .11);
	vec3 pa3 = texture2D(inputImageTexture4, vec2(dot(pa2, texel), .5)).rgb;
    
    vec3 pa4 = texture2D(inputImageTexture6, textureCoordinate).rgb;
    vec3 pa5 = vec3(
                        texture2D(inputImageTexture5, vec2(pa4.r, texel.r)).r,
                        texture2D(inputImageTexture5, vec2(pa4.g, texel.g)).g,
                        texture2D(inputImageTexture5, vec2(pa4.b, texel.b)).b
                        );
	
	gl_FragColor = vec4(pa5, 1.0);
}
 );

@implementation DDFilter13

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString13 sources:@[[DDImageFilter filterImageNamed:@"fp32.jpg"],[DDImageFilter filterImageNamed:@"fp33"],[DDImageFilter filterImageNamed:@"fp34"],[DDImageFilter filterImageNamed:@"fp35"],[DDImageFilter filterImageNamed:@"fp36.jpg"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
