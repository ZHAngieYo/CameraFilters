//
//  DDXprollFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter6.h"

NSString *const kShaderString6 = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec2 pa1 = vec2(d * 0.7, texel.r);
     texel.r = texture2D(inputImageTexture3, pa1).r;
     pa1.y = texel.g;
     texel.g = texture2D(inputImageTexture3, pa1).g;
     pa1.y = texel.b;
     texel.b	= texture2D(inputImageTexture3, pa1).b;
     
     vec2 red = vec2(texel.r, 0.16666);
     vec2 green = vec2(texel.g, 0.5);
     vec2 blue = vec2(texel.b, .83333);
     texel.r = texture2D(inputImageTexture2, red).r;
     texel.g = texture2D(inputImageTexture2, green).g;
     texel.b = texture2D(inputImageTexture2, blue).b;
     
     gl_FragColor = vec4(texel, 1.0);
     
 }
 );

@implementation DDFilter6

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString6 sources:@[[DDImageFilter filterImageNamed:@"fp18"],[DDImageFilter filterImageNamed:@"fp5"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
