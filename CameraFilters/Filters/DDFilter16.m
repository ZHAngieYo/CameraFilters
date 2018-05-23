//
//  DDLordKelvinFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter16.h"

NSString *const kShaderString16 = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 pa1;
     pa1.y = .5;
     
     pa1.x = texel.r;
     texel.r = texture2D(inputImageTexture2, pa1).r;
     
     pa1.x = texel.g;
     texel.g = texture2D(inputImageTexture2, pa1).g;
     
     pa1.x = texel.b;
     texel.b = texture2D(inputImageTexture2, pa1).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation DDFilter16

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString16 sources:@[[DDImageFilter filterImageNamed:@"fp40"],[DDImageFilter filterImageNamed:@"fp41"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
