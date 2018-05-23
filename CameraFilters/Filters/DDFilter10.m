//
//  DDToasterFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter10.h"

NSString *const kShaderString10 = SHADER_STRING
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
     lowp vec3 texel;
     mediump vec2 pa1;
     vec2 b;
     vec2 g;
     vec2 r;
     lowp vec4 pa2;
     pa2 = texture2D (inputImageTexture, textureCoordinate);
     texel = pa2.xyz;
     lowp vec4 pa3;
     pa3 = texture2D (inputImageTexture2, textureCoordinate);
     lowp vec2 pa4;
     pa4.x = pa3.x;
     pa4.y = pa2.x;
     texel.x = texture2D (inputImageTexture3, pa4).x;
     lowp vec2 pa5;
     pa5.x = pa3.y;
     pa5.y = pa2.y;
     texel.y = texture2D (inputImageTexture3, pa5).y;
     lowp vec2 pa6;
     pa6.x = pa3.z;
     pa6.y = pa2.z;
     texel.z = texture2D (inputImageTexture3, pa6).z;
     r.x = texel.x;
     r.y = 0.16666;
     g.x = texel.y;
     g.y = 0.5;
     b.x = texel.z;
     b.y = 0.833333;
     texel.x = texture2D (inputImageTexture4, r).x;
     texel.y = texture2D (inputImageTexture4, g).y;
     texel.z = texture2D (inputImageTexture4, b).z;
     mediump vec2 pa7;
     pa7 = ((2.0 * textureCoordinate) - 1.0);
     mediump vec2 pa8;
     pa8.x = dot (pa7, pa7);
     pa8.y = texel.x;
     pa1 = pa8;
     texel.x = texture2D (inputImageTexture5, pa1).x;
     pa1.y = texel.y;
     texel.y = texture2D (inputImageTexture5, pa1).y;
     pa1.y = texel.z;
     texel.z = texture2D (inputImageTexture5, pa1).z;
     r.x = texel.x;
     g.x = texel.y;
     b.x = texel.z;
     texel.x = texture2D (inputImageTexture6, r).x;
     texel.y = texture2D (inputImageTexture6, g).y;
     texel.z = texture2D (inputImageTexture6, b).z;
     lowp vec4 pa9;
     pa9.w = 1.0;
     pa9.xyz = texel;
     gl_FragColor = pa9;
 }
 );

@implementation DDFilter10

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString10 sources:@[[DDImageFilter filterImageNamed:@"fp26.jpg"],[DDImageFilter filterImageNamed:@"fp27"],[DDImageFilter filterImageNamed:@"fp28"],[DDImageFilter filterImageNamed:@"fp29"],[DDImageFilter filterImageNamed:@"fp30"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
