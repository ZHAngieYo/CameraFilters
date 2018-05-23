//
//  DDBrannanFilter.m
//  PAPA
//
//  Created by Jason Hsu on 10/30/12.
//  Copyright (c) 2012 diandian. All rights reserved.
//

#import "DDFilter11.h"

NSString *const kShaderString11 = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 uniform sampler2D inputImageTexture4;
 uniform sampler2D inputImageTexture5;
 uniform sampler2D inputImageTexture6;
 
 mat3 pa1 = mat3(
                            1.105150,
                            -0.044850,
                            -0.046000,
                            -0.088050,
                            1.061950,
                            -0.089200,
                            -0.017100,
                            -0.017100,
                            1.132900);
 
 vec3 pa2 = vec3(.3, .59, .11);
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 pa3;
     pa3.y = 0.5;
     pa3.x = texel.r;
     texel.r = texture2D(inputImageTexture2, pa3).r;
     pa3.x = texel.g;
     texel.g = texture2D(inputImageTexture2, pa3).g;
     pa3.x = texel.b;
     texel.b = texture2D(inputImageTexture2, pa3).b;
     
     texel = pa1 * texel;
     
     
     vec2 pa4 = (2.0 * textureCoordinate) - 1.0;
     float d = dot(pa4, pa4);
     vec3 pa5;
     pa3.y = 0.5;
     pa3.x = texel.r;
     pa5.r = texture2D(inputImageTexture3, pa3).r;
     pa3.x = texel.g;
     pa5.g = texture2D(inputImageTexture3, pa3).g;
     pa3.x = texel.b;
     pa5.b = texture2D(inputImageTexture3, pa3).b;
     float pa6 = smoothstep(0.0, 1.0, d);
     texel = mix(pa5, texel, pa6);
     
     pa3.x = texel.r;
     texel.r = texture2D(inputImageTexture4, pa3).r;
     pa3.x = texel.g;
     texel.g = texture2D(inputImageTexture4, pa3).g;
     pa3.x = texel.b;
     texel.b = texture2D(inputImageTexture4, pa3).b;
     
     
     pa3.x = dot(texel, pa2);
     texel = mix(texture2D(inputImageTexture5, pa3).rgb, texel, .5);
     
     pa3.x = texel.r;
     texel.r = texture2D(inputImageTexture6, pa3).r;
     pa3.x = texel.g;
     texel.g = texture2D(inputImageTexture6, pa3).g;
     pa3.x = texel.b;
     texel.b = texture2D(inputImageTexture6, pa3).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation DDFilter11

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kShaderString11 sources:@[[DDImageFilter filterImageNamed:@"fp11"],[DDImageFilter filterImageNamed:@"fp12"],[DDImageFilter filterImageNamed:@"fp13"],[DDImageFilter filterImageNamed:@"fp14"],[DDImageFilter filterImageNamed:@"fp15"]]]))
    {
		return nil;
    }
    
    return self;
}

@end
