//
//  UIDevice+Tools.m
//  PMP
//
//  Created by Tong on 12/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import "UIDevice+Tools.h"
#include <sys/sysctl.h>
#import <AdSupport/AdSupport.h>


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface UIDevice ()

@end

@implementation UIDevice (Tools)

+ (CGFloat)screenScale
{
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        return [[UIScreen mainScreen] scale];
    }
    return 1.0f;
}

+ (BOOL)is35InchesScreen {
    static int is35Inch = 0;
    if (is35Inch == 0)
        is35Inch = ([[UIScreen mainScreen] bounds].size.height == 480) ? 1 : -1;
    return is35Inch > 0;
}

+ (BOOL)is4InchesScreen {
    static int is4Inch = 0;
    if (is4Inch == 0)
        is4Inch = ([[UIScreen mainScreen] bounds].size.height == 568) ? 1 : -1;
    return is4Inch > 0;
}

+ (BOOL)is47InchesScreen {
    static int is47Inch = 0;
    if (is47Inch == 0)
        is47Inch = ([[UIScreen mainScreen] bounds].size.height == 667) ? 1 : -1;
    return is47Inch > 0;
}

+ (BOOL)is55InchesScreen {
    static int is55Inch = 0;
    if (is55Inch == 0)
        is55Inch = ([[UIScreen mainScreen] bounds].size.height == 736) ? 1 : -1;
    return is55Inch > 0;
}

+(BOOL)is58InchesScreen {
    static int is58Inch = 0;
    if (is58Inch == 0)
        is58Inch = ([[UIScreen mainScreen] bounds].size.height == 812) ? 1 : -1;
    return is58Inch > 0;
}

+ (BOOL)isRetina {
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if (scale > 1.0) {
            return YES;
        }
    }
    return NO;
}


+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (BOOL)isInCallStatusBar {
    return [[UIApplication sharedApplication] statusBarFrame].size.height == 40;
}

+ (YYScreenMode)screenMode{
    if ([UIDevice screenWidth] > 375) {
        return YYScreenMode414;
    }
    else if([UIDevice screenWidth] > 320){
        return YYScreenMode375;
    }
    return YYScreenMode320;
}

/*
 *  判断方法根据 apt和Cydia.app的path来判断
 */
+ (BOOL)isJailBreak {
    BOOL jailbroken = NO;
    
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    
    return jailbroken;
}

+ (BOOL)systemVersionLessThanOrEqualTo:(CGFloat)version {
    NSString *str = [NSString stringWithFormat:@"%f", version];
    return SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(str);
}

+ (BOOL)below5 {
    return SYSTEM_VERSION_LESS_THAN(@"5.0");
}

+ (BOOL)below6 {
    return SYSTEM_VERSION_LESS_THAN(@"6.0");
}

+ (BOOL)below7 {
    return SYSTEM_VERSION_LESS_THAN(@"7.0");
}

+ (BOOL)below8 {
    return SYSTEM_VERSION_LESS_THAN(@"8.0");
}

+ (BOOL)below9 {
    return SYSTEM_VERSION_LESS_THAN(@"9.0");
}

+ (BOOL)below10 {
    return SYSTEM_VERSION_LESS_THAN(@"10.0");
}

+ (BOOL)below11 {
    return SYSTEM_VERSION_LESS_THAN(@"11.0");
}

+ (BOOL)below11_2 {
    return SYSTEM_VERSION_LESS_THAN(@"11.2");
}

+ (BOOL)isSimulator {
    return TARGET_IPHONE_SIMULATOR;
}

+ (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString *) platformString{
    NSString *platform = [UIDevice platform];
    if ([platform isEqualToString:@"iPhone1"])  return @"iPhone 1G";
    if ([platform hasPrefix:@"iPhone1"])        return @"iPhone 3G";
    if ([platform hasPrefix:@"iPhone2"])        return @"iPhone 3GS";
    if ([platform hasPrefix:@"iPhone3"])        return @"iPhone 4";
    if ([platform hasPrefix:@"iPhone4"])        return @"iPhone 4S";
    if ([platform hasPrefix:@"iPhone5,1"])      return @"iPhone 5";
    if ([platform hasPrefix:@"iPhone5,2"])      return @"iPhone 5";
    if ([platform hasPrefix:@"iPhone5,3"])      return @"iPhone 5C";
    if ([platform hasPrefix:@"iPhone5,4"])      return @"iPhone 5C";
    if ([platform hasPrefix:@"iPhone6"])        return @"iPhone 5S";
    if ([platform hasPrefix:@"iPod1"])          return @"iPod Touch 1G";
    if ([platform hasPrefix:@"iPod2"])          return @"iPod Touch 2G";
    if ([platform hasPrefix:@"iPod3"])          return @"iPod Touch 3G";
    if ([platform hasPrefix:@"iPod4"])          return @"iPod Touch 4G";
    if ([platform hasPrefix:@"iPod5"])          return @"iPod Touch 5G";
    if ([platform hasPrefix:@"iPad1"])          return @"iPad";
    if ([platform hasPrefix:@"iPad2,1"])        return @"iPad 2";
    if ([platform hasPrefix:@"iPad2,2"])        return @"iPad 2";
    if ([platform hasPrefix:@"iPad2,3"])        return @"iPad 2";
    if ([platform hasPrefix:@"iPad2,4"])        return @"iPad 2";
    if ([platform hasPrefix:@"iPad2,5"])        return @"iPad mini";
    if ([platform hasPrefix:@"iPad2,6"])        return @"iPad mini";
    if ([platform hasPrefix:@"iPad2,7"])        return @"iPad mini";
    if ([platform hasPrefix:@"iPad3"])          return @"iPad 3";
    if ([platform hasPrefix:@"iPad4"])          return @"iPad 4";
    if ([platform hasPrefix:@"i386"])           return @"Simulator";
    if ([platform hasPrefix:@"x86_64"])         return @"Simulator";
    return platform;
}

+ (float) cropHeight
{
    NSString *platform = [UIDevice platformString];
    if ([platform hasSuffix:@"iPhone 4"]) { // iPhone 4
        return 0.747f;
    }
    return 0.75f;
}

+ (NSDictionary*)deviceModelDataForMachineIDs
{
    return @{
             
         //iPad.
         @"iPad1,1" : @[ @"iPad 1G", @"Wi-Fi / GSM", @"A1219 / A1337" ],
         @"iPad2,1" : @[ @"iPad 2", @"Wi-Fi", @"A1395" ],
         @"iPad2,2" : @[ @"iPad 2", @"GSM", @"A1396" ],
         @"iPad2,3" : @[ @"iPad 2", @"CDMA", @"A1397" ],
         @"iPad2,4" : @[ @"iPad 2", @"Wi-Fi Rev A", @"A1395" ],
         @"iPad2,5" : @[ @"iPad mini 1G", @"Wi-Fi", @"A1432" ],
         @"iPad2,6" : @[ @"iPad mini 1G", @"GSM", @"A1454" ],
         @"iPad2,7" : @[ @"iPad mini 1G", @"GSM+CDMA", @"A1455" ],
         @"iPad3,1" : @[ @"iPad 3", @"Wi-Fi", @"A1416" ],
         @"iPad3,2" : @[ @"iPad 3", @"GSM+CDMA", @"A1403" ],
         @"iPad3,3" : @[ @"iPad 3", @"GSM", @"A1430" ],
         @"iPad3,4" : @[ @"iPad 4", @"Wi-Fi", @"A1458" ],
         @"iPad3,5" : @[ @"iPad 4", @"GSM", @"A1459" ],
         @"iPad3,6" : @[ @"iPad 4", @"GSM+CDMA", @"A1460" ],
         @"iPad4,1" : @[ @"iPad Air", @"Wi‑Fi", @"A1474" ],
         @"iPad4,2" : @[ @"iPad Air", @"Cellular", @"A1475" ],
         @"iPad4,4" : @[ @"iPad mini 2G", @"Wi‑Fi", @"A1489" ],
         @"iPad4,5" : @[ @"iPad mini 2G", @"Cellular", @"A1517" ],
         
         //iPhone.
         @"iPhone1,1" : @[ @"iPhone 2G", @"GSM", @"A1203" ],
         @"iPhone1,2" : @[ @"iPhone 3G", @"GSM", @"A1241 / A13241" ],
         @"iPhone2,1" : @[ @"iPhone 3GS", @"GSM", @"A1303 / A13251" ],
         @"iPhone3,1" : @[ @"iPhone 4", @"GSM", @"A1332" ],
         @"iPhone3,2" : @[ @"iPhone 4", @"GSM Rev A", @"-" ],
         @"iPhone3,3" : @[ @"iPhone 4", @"CDMA", @"A1349" ],
         @"iPhone4,1" : @[ @"iPhone 4S", @"GSM+CDMA", @"A1387 / A14311" ],
         @"iPhone5,1" : @[ @"iPhone 5", @"GSM", @"A1428" ],
         @"iPhone5,2" : @[ @"iPhone 5", @"GSM+CDMA", @"A1429 / A14421" ],
         @"iPhone5,3" : @[ @"iPhone 5C", @"GSM", @"A1456 / A1532" ],
         @"iPhone5,4" : @[ @"iPhone 5C", @"Global", @"A1507 / A1516 / A1526 / A1529" ],
         @"iPhone6,1" : @[ @"iPhone 5S", @"GSM", @"A1433 / A1533" ],
         @"iPhone6,2" : @[ @"iPhone 5S", @"Global", @"A1457 / A1518 / A1528 / A1530" ],
         @"iPhone7,1" : @[ @"iPhone 6 Plus", @"Global", @"" ],
         @"iPhone7,2" : @[ @"iPhone 6", @"Global", @"" ],
         @"iPhone8,1" : @[ @"iPhone 6s", @"Global", @"" ],
         @"iPhone8,2" : @[ @"iPhone 6s Plus", @"Global", @"" ],

         //iPod.
         @"iPod1,1" : @[ @"iPod touch 1G", @"-", @"A1213" ],
         @"iPod2,1" : @[ @"iPod touch 2G", @"-", @"A1288" ],
         @"iPod3,1" : @[ @"iPod touch 3G", @"-", @"A1318" ],
         @"iPod4,1" : @[ @"iPod touch 4G", @"-", @"A1367" ],
         @"iPod5,1" : @[ @"iPod touch 5G", @"-", @"A1421 / A1509" ],
         
         //Similuator
         @"x86_64" : @[ @"模拟器", @"x64" ]
             
     };
}

+ (NSString *)stringForPlatform {
    NSDictionary *models = [[self class]deviceModelDataForMachineIDs];
    NSString *rawModel = [[self class]platform];
    NSArray *thisModelArray = [models objectForKey:rawModel];
    if (thisModelArray != nil) {
        return [thisModelArray componentsJoinedByString:@" "];
    }
    return [NSString stringWithFormat:@"Unknown Model:%@", rawModel];
}



+ (NSInteger) maxPixelsCanProcess
{
    NSString *platform = [UIDevice stringForPlatform];
    int m = 1024 * 1024;
    if ([platform hasPrefix:@"iPhone 3GS"])     return 3 * m;
    if ([platform hasPrefix:@"iPhone 4"])       return 5 * m;
    if ([platform hasPrefix:@"iPhone 4S"])      return 2 * m;
    if ([platform hasPrefix:@"iPhone 5"])       return 8 * m;
    if ([platform hasPrefix:@"iPhone 5C"])      return 8 * m;
    if ([platform hasPrefix:@"iPhone 5S"])      return 8 * m;
    if ([platform hasPrefix:@"iPod Touch 3G"])  return 2 * m;
    if ([platform hasPrefix:@"iPod Touch 4G"])  return 3 * m;
    if ([platform hasPrefix:@"iPod Touch 5G"])  return 5 * m;
    if ([platform hasPrefix:@"iPad"])           return 3 * m;
    if ([platform hasPrefix:@"iPad 2"])         return 5 * m;
    if ([platform hasPrefix:@"iPad 3"])         return 8 * m;
    if ([platform hasPrefix:@"iPad 4"])         return 8 * m;
    if ([platform hasPrefix:@"iPad mini"])      return 5 * m;
    return 8 * m;
}

+ (NSInteger) screenShotPixels
{
    NSString *platform = [UIDevice stringForPlatform];
    if ([platform hasPrefix:@"iPhone 3GS"])     return 320 * 480;
    if ([platform hasPrefix:@"iPhone 4"])       return 320 * 480 * 4;
    if ([platform hasPrefix:@"iPhone 4S"])      return 320 * 480 * 4;
    if ([platform hasPrefix:@"iPhone 5"])       return 320 * 568 * 4;
    if ([platform hasPrefix:@"iPod Touch 3G"])  return 320 * 480;
    if ([platform hasPrefix:@"iPod Touch 4G"])  return 320 * 480 * 4;
    if ([platform hasPrefix:@"iPod Touch 5G"])  return 320 * 568 * 4;
    if ([platform hasPrefix:@"iPad"])           return 1024 * 768;
    if ([platform hasPrefix:@"iPad 2"])         return 1024 * 768;
    if ([platform hasPrefix:@"iPad 3"])         return 1024 * 768 * 4;
    if ([platform hasPrefix:@"iPad 4"])         return 1024 * 768 * 4;
    if ([platform hasPrefix:@"iPad mini"])      return 1024 * 768;
    return 0;
}

+ (BOOL)isLowMemory {
    return [[UIDevice stringForPlatform] hasPrefix:@"iPhone 4S"] ||
    [[UIDevice stringForPlatform] hasPrefix:@"iPod touch 5G"];
}

#pragma mark -
#pragma mark Push
+ (BOOL)pushEnabled {
    BOOL pushEnabled=NO;
    if ([UIDevice below8]) {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        pushEnabled = (types & UIRemoteNotificationTypeAlert);
        
    } else {
        pushEnabled = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    
    return pushEnabled;
}



@end
