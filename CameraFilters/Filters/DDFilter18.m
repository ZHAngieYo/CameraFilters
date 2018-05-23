//
//  IFInkwellFilter.m
//  InstaFilters
//
//  Created by Di Wu on 2/28/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#import "DDFilter18.h"

NSString *const kIFInkWellShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     float luminance = dot(texture2D(inputImageTexture, textureCoordinate).rgb, W);
     
     lowp vec4 desat = vec4(vec3(luminance), 1.0);
     
     // scale pixel value away from 0.5 by a factor of intensity
     lowp vec4 outputColor = vec4(
                                  (desat.r < 0.5 ? (0.5 - 1.5 * (0.5 - desat.r)) : (0.5 + 1.5 * (desat.r - 0.5))),
                                  (desat.g < 0.5 ? (0.5 - 1.5 * (0.5 - desat.g)) : (0.5 + 1.5 * (desat.g - 0.5))),
                                  (desat.b < 0.5 ? (0.5 - 1.5 * (0.5 - desat.b)) : (0.5 + 1.5 * (desat.b - 0.5))),
                                  1.0
                                  );
     
     gl_FragColor = outputColor;
 }
);

@implementation DDFilter18

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFInkWellShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
