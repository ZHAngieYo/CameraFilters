//
//  NSString+Tools.m
//  PMP
//
//  Created by Tong on 05/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import "NSString+Tools.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>
#import <objc/runtime.h>

#define kNSString_Pinyin_Loop_Max_Times            (50)
static NSCharacterSet* VariationSelectors = nil;

static NSString *BASE_MASK_CHARS = @"NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm0123456789-_";

static inline CGFLOAT_TYPE CGFloat_ceil(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return ceil(cgfloat);
#else
    return ceilf(cgfloat);
#endif
}

@implementation NSString (Tools)

+ (void)load {
    VariationSelectors = [NSCharacterSet characterSetWithRange:NSMakeRange(0xFE00, 16)];
}

- (BOOL)isEmptyString {
    
    return [[self trim] length] == 0;
}

- (BOOL)phoneValiMobile{
    if ([self trimAllSpace].length != 11){
        return NO;
    }else{
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9])|(19[0-9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self];
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

-(BOOL)isFitNickNameFormat{
    NSString *match = @"^[0-9a-zA-Z\u4e00-\u9fa5-–—•/\\\\:;\\[\\]()$€£¥₩¢&§@\".…,「」〖〗《》『』#〔〕@“”。，、】！？【?¿!¡'’‘`{}#%‰^*+=_|~<>]{1,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",match];
    return [pred evaluateWithObject:self];
}

-(BOOL)isFitPassWordFormat{
    NSString *match = @"^[0-9a-zA-Z-–—•/\\\\:;\\[\\]()$€£¥₩¢&§@\".…,?¿!¡'’‘`{}#%‰^*+=_|~<>]{1,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",match];
    return [pred evaluateWithObject:self];
}


- (NSString *)firstLetterCapitalizedString {
    return [NSString stringWithFormat:@"%@%@",[[self substringToIndex:1] uppercaseString],[self substringFromIndex:1]];
}

- (NSString *)substringByRemovingLastIndex:(NSUInteger)count {
    return [self substringToIndex:[self length] - count];
}

- (const char *)cString {
    return [self cStringUsingEncoding:NSASCIIStringEncoding];
}

- (BOOL)containsSubString:(NSString *)subString {
    return [self rangeOfString:subString].location != NSNotFound;
}

- (BOOL)hasContent {
    
    //该方法用来防止语音输入时未解析完点击发布出现的特殊字符，有更好的解决方法可删除
    //限制范围参见http://www.utf8-chartable.de/unicode-utf8-table.pl?start=65408&utf8=char
    unichar firstChar = 0;
    if ([self length]) {
        firstChar =[self characterAtIndex:0];
    }
    BOOL hasLimitChar = firstChar < 0xFFFD && firstChar > 0xFFF8;
    
    return self.length > 0 && !hasLimitChar;
}

- (BOOL)isEmoji {
    if ([self rangeOfCharacterFromSet: VariationSelectors].location != NSNotFound) {
        return YES;
    }
    
    const unichar high = [self characterAtIndex: 0];
    
    // Surrogate pair (U+1D000-1F9FF)
    if (0xD800 <= high && high <= 0xDBFF) {
        const unichar low = [self characterAtIndex: 1];
        const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
        
        return (0x1D000 <= codepoint && codepoint <= 0x1F9FF);
        
        // Not surrogate pair (U+2100-27BF)
    } else {
        return ((0x2100 <= high && high<=0x2BD1));
    }
}

- (BOOL)isAllEmojiString {
    BOOL __block result = YES;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              if (![substring isEmoji]) {
                                  *stop = YES;
                                  result = NO;
                              }
                          }];
    
    return result;
}

- (BOOL)containsEmojiString {
    BOOL __block result = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              if ([substring isEmoji]) {
                                  *stop = YES;
                                  result = YES;
                              }
                          }];
    
    return result;
}

- (BOOL)allChinese{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)allNumber {
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

- (BOOL)allNumberOrEnglish{
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

- (BOOL)containsSpecialChars:(NSString *)chars{
    NSString *regex = nil;
    if(chars.length > 0){
        regex = [NSString stringWithFormat:@"[a-zA-Z0-9%@]*",chars];
    }else{
        regex =@"[a-zA-Z0-9]*";
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

- (BOOL)allPreNumberPadChinese{
    NSString *regex = @"[➋➌➍➎➏➐➑➒]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", regex];
    return [predicate evaluateWithObject:self];
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (BOOL)isEqualIgnoringCase:(NSString *)string {
    return [self caseInsensitiveCompare:string] == NSOrderedSame;
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimAllSpace {
    return  [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
}

+ (NSString *)trimAllSpaceAndLineBreakWithString:(NSString *)infoTitle {
    while ([infoTitle hasPrefix:@"\n"] || [infoTitle hasPrefix:@"\r"] || [infoTitle hasPrefix:@" "] || [infoTitle hasPrefix:@"\t"]) {
        if ([infoTitle hasPrefix:@" "]) {
            if (infoTitle.length > 1) {
                infoTitle = [infoTitle substringFromIndex:1];
            }else {
                infoTitle = nil;
                break;
            }
        }else {
            if (infoTitle.length > 2) {
                infoTitle = [infoTitle substringFromIndex:2];
            }else {
                infoTitle = nil;
                break;
            }
        }
    }
    
    return infoTitle;
}

+ (NSString *)fc_trimAllSpaceAndLineBreakWithString:(NSString *)infoTitle {
    while ([infoTitle hasPrefix:@"\n"] || [infoTitle hasPrefix:@"\r"] || [infoTitle hasPrefix:@" "] || [infoTitle hasPrefix:@"\t"]) {
        if ([infoTitle hasPrefix:@" "]) {
            if (infoTitle.length > 1) {
                infoTitle = [infoTitle substringFromIndex:1];
            }else {
                infoTitle = nil;
                break;
            }
        }else {
            if (infoTitle.length > 1) {
                infoTitle = [infoTitle substringFromIndex:1];
            }else {
                infoTitle = nil;
                break;
            }
        }
    }
    
    return infoTitle;
}

- (BOOL)moreThan:(NSString *)string {
    return [self compare:string] == NSOrderedDescending;
}

- (BOOL)noMoreThan:(NSString *)string {
    return ![self moreThan:string];
}

- (BOOL)lessThan:(NSString *)string {
    return [self compare:string] == NSOrderedAscending;
}

- (BOOL)noLessThan:(NSString *)string {
    return ![self lessThan:string];
}

+ (NSUInteger)numberOfOccurrencesOfString:(NSString *)needle inString:(NSString *)haystack {
    const char * rawNeedle = [needle UTF8String];
    NSUInteger needleLength = strlen(rawNeedle);
    
    const char * rawHaystack = [haystack UTF8String];
    NSUInteger haystackLength = strlen(rawHaystack);
    
    NSUInteger needleCount = 0;
    NSUInteger needleIndex = 0;
    for (NSUInteger index = 0; index < haystackLength; ++index) {
        const char thisCharacter = rawHaystack[index];
        if (thisCharacter != rawNeedle[needleIndex]) {
            needleIndex = 0; //they don't match; reset the needle index
        }
        
        //resetting the needle might be the beginning of another match
        if (thisCharacter == rawNeedle[needleIndex]) {
            needleIndex++; //char match
            if (needleIndex >= needleLength) {
                needleCount++; //we completed finding the needle
                needleIndex = 0;
            }
        }
    }
    
    return needleCount;
}

+ (NSDictionary*)getDicForAllPolyphoneSurnamePinYin;
{
    static NSDictionary* g_pAllPolyphoneSurnamePinYin = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^
                  {
                      g_pAllPolyphoneSurnamePinYin = [NSMutableDictionary dictionaryWithObjectsAndKeys
                                                      :@[@"po",@"fan"],@"繁"
                                                      ,@[@"jia",@"gu"],@"贾"
                                                      ,@[@"ou",@"qu"],@"区"
                                                      ,@[@"qiu",@"chou"],@"仇"
                                                      ,@[@"chong",@"zhong"],@"种"
                                                      ,@[@"shan",@"dan"],@"单"
                                                      ,@[@"xie",@"jie"],@"解"
                                                      ,@[@"zha",@"cha"],@"查"
                                                      ,@[@"zeng",@"ceng"],@"曾"
                                                      ,@[@"bi",@"mi"],@"秘"
                                                      ,@[@"yue",@"le"],@"乐"
                                                      ,@[@"chong",@"zhong"],@"重"
                                                      ,@[@"piao",@"pu"],@"朴"
                                                      ,@[@"miao",@"mou"],@"缪"
                                                      ,@[@"zhai",@"di"],@"翟"
                                                      ,@[@"she",@"zhe"],@"折"
                                                      ,@[@"he",@"hei"],@"黑"
                                                      ,@[@"ge",@"gai"],@"盖"
                                                      ,@[@"shen",@"chen"],@"沈"
                                                      ,@[@"yu",@"wei"],@"尉"
                                                      ,nil];
                  });
    return g_pAllPolyphoneSurnamePinYin;
}



- (NSString *)encodeString{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

- (NSString *)decodeString{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)self,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+ (NSString *)getDecMobileWithStrMobile:(NSString *)strMobile{
    NSInteger mobel = 0;
    
    NSInteger x = 1;
    for (NSInteger i = 0; i<strMobile.length; i++) {
        NSString *indexStr = [strMobile substringWithRange:NSMakeRange(i, 1)];
        NSInteger a = [BASE_MASK_CHARS rangeOfString:indexStr].location;
        mobel += a*x;
        x = x*64;
    }
    
    NSString *dec = [NSString stringWithFormat:@"%zd",mobel];
    return dec;
}


// quanweiz add

+ (BOOL)isNilOrNSNull:(NSString *)str {
    if (!str) {
        return YES;
    }
    if ([str isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getNoNilOrNSNullString:(NSString *)str{
    if ([NSString isNilOrNSNull:str]) {
        return @"";
    }
    else
        return str;
}

+ (BOOL)isEmptyOrWhitespace:(NSString *)str {
    
    if ([NSString isNilOrNSNull:str]) {
        return YES;
    }
    
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    // A nil or NULL string is not the same as an empty string
    return 0 == str.length ||
    ![str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

+ (BOOL)isNilOrNSNullOrEmptyOrWhitespace:(NSString *)str {
    if ([NSString isNilOrNSNull:str]) {
        return YES;
    }
    if ([NSString isEmptyOrWhitespace:str]) {
        return YES;
    }
    return NO;
}

- (BOOL)isNilOrNSNullOrEmptyOrWhitespace{
    return [[self class] isNilOrNSNullOrEmptyOrWhitespace:self];
}

- (NSString *)safeStringWithRange:(NSRange )range{
    if (range.length >0) {
        if (range.location + range.length <= self.length) {
            return [self substringWithRange:range];
        }
    }
    return  nil;
}

@end


