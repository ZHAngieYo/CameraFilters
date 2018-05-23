//
//  DDLomofiFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter8.h"

NSString *const kShaderString8 = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 r = vec2(texel.r, 0.16666);
     vec2 g = vec2(texel.g, 0.5);
     vec2 b = vec2(texel.b, 0.83333);
     
     texel.rgb = vec3(texture2D(inputImageTexture2, r).r,
                      texture2D(inputImageTexture2, g).g,
                      texture2D(inputImageTexture2, b).b);
     
     vec2 pa1 = (2.0 * textureCoordinate) - 1.0;
     vec2 pa2 = vec2(dot(pa1, pa1), texel.r);
     texel.r = texture2D(inputImageTexture3, pa2).r;
     pa2.y = texel.g;
     texel.g = texture2D(inputImageTexture3, pa2).g;
     pa2.y = texel.b;
     texel.b = texture2D(inputImageTexture3, pa2).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation DDFilter8

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString8 sources:@[[DDImageFilter filterImageNamed:@"fp21"],[DDImageFilter filterImageNamed:@"fp5"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
