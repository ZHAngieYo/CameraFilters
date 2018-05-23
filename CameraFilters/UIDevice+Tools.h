//
//  UIDevice+Tools.h
//  PMP
//
//  Created by Tong on 12/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, YYScreenMode) {
    YYScreenMode320 = 0,
    YYScreenMode375,
    YYScreenMode414,
};

@interface UIDevice (Tools)

+ (CGFloat)screenScale;
+ (BOOL)is35InchesScreen;
+ (BOOL)is4InchesScreen;
+ (BOOL)is47InchesScreen;
+ (BOOL)is55InchesScreen;
+ (BOOL)is58InchesScreen;
+ (BOOL)isRetina;
+ (CGFloat)screenHeight;
+ (CGFloat)screenWidth;
+ (BOOL)isInCallStatusBar;
+ (YYScreenMode )screenMode;

+ (BOOL)isJailBreak;

+ (BOOL)systemVersionLessThanOrEqualTo:(CGFloat)version;

+ (BOOL)below5;
+ (BOOL)below6;
+ (BOOL)below7;
+ (BOOL)below8;
+ (BOOL)below9;
+ (BOOL)below10;
+ (BOOL)below11;
+ (BOOL)below11_2;
+ (BOOL)isSimulator;

/** Platform */
+ (NSString *)platform;
+ (NSString *)stringForPlatform;

+ (NSString *)deviceIdentifier;


+ (NSInteger) maxPixelsCanProcess;
+ (NSInteger) screenShotPixels;

+ (BOOL)isLowMemory;

/** Push Enabled */
+ (BOOL)pushEnabled;

+ (float) cropHeight;

@end
