//
//  DDSutroFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter3.h"

NSString *const kShaderString3 = SHADER_STRING
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
     
     vec2 pa1 = (2.0 * textureCoordinate) - 1.0;
     float d = dot(pa1, pa1);
     vec2 pa2 = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture2, pa2).r;
     pa2.y = texel.g;
     texel.g = texture2D(inputImageTexture2, pa2).g;
     pa2.y = texel.b;
     texel.b = texture2D(inputImageTexture2, pa2).b;
     
     vec3 pa3 = vec3(0.1019, 0.0, 0.0);
     float m = dot(vec3(.3, .59, .11), texel.rgb) - 0.03058;
     texel = mix(texel, pa3 + m, 0.32);
     
     vec3 metal = texture2D(inputImageTexture3, textureCoordinate).rgb;
     texel.r = texture2D(inputImageTexture4, vec2(metal.r, texel.r)).r;
     texel.g = texture2D(inputImageTexture4, vec2(metal.g, texel.g)).g;
     texel.b = texture2D(inputImageTexture4, vec2(metal.b, texel.b)).b;
     
     texel = texel * texture2D(inputImageTexture5, textureCoordinate).rgb;
     
     texel.r = texture2D(inputImageTexture6, vec2(texel.r, .16666)).r;
     texel.g = texture2D(inputImageTexture6, vec2(texel.g, .5)).g;
     texel.b = texture2D(inputImageTexture6, vec2(texel.b, .83333)).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation DDFilter3

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString3 sources:@[[DDImageFilter filterImageNamed:@"fp5"],[DDImageFilter filterImageNamed:@"fp6.jpg"],[DDImageFilter filterImageNamed:@"fp7"],[DDImageFilter filterImageNamed:@"fp8.jpg"],[DDImageFilter filterImageNamed:@"fp9"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
