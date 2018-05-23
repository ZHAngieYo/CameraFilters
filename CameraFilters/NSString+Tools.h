//
//  NSString+Tools.h
//  PMP
//
//  Created by Tong on 05/03/2014.
//  Copyright (c) 2014 LuckyTR. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Macros */
#ifndef _
#define _(s) NSLocalizedString(s, nil)
#endif

#define SF(FORMAT...) [NSString stringWithFormat:FORMAT]

#define DOCUMENTS_FOLDER    ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define CACHES_FOLDER       ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])

@interface NSString (Tools)

- (NSString *)firstLetterCapitalizedString;
- (NSString *)substringByRemovingLastIndex:(NSUInteger)count;
- (BOOL)phoneValiMobile;
-(BOOL)isFitNickNameFormat;
-(BOOL)isFitPassWordFormat;
- (BOOL)isEmptyString;
- (const char *)cString;

- (BOOL)containsSubString:(NSString *)subString;
- (BOOL)hasContent;
- (BOOL)isEmoji;
- (BOOL)isAllEmojiString;
- (BOOL)containsEmojiString;
- (BOOL)allChinese;
- (BOOL)allNumber;
- (BOOL)allNumberOrEnglish;
//add 1.4.30 处理粘贴过来时包含_ & - 情况
- (BOOL)containsSpecialChars:(NSString *)chars;
- (BOOL)allPreNumberPadChinese;
+ (BOOL)stringContainsEmoji:(NSString *)string;
- (BOOL)isEqualIgnoringCase:(NSString *)string;
- (NSString *)trim;
- (NSString *)trimAllSpace;
+ (NSString *)trimAllSpaceAndLineBreakWithString:(NSString *)infoTitle;
+ (NSString *)fc_trimAllSpaceAndLineBreakWithString:(NSString *)infoTitle;


- (BOOL)moreThan:(NSString *)string;
- (BOOL)noMoreThan:(NSString *)string;
- (BOOL)lessThan:(NSString *)string;
- (BOOL)noLessThan:(NSString *)string;

+ (NSUInteger)numberOfOccurrencesOfString:(NSString *)needle inString:(NSString *)haystack;

+ (NSString *)stringForCurrentNetworkStatus;

/**
 * Pinyin
 */
- (NSString *)stringInPinyin;
- (NSString *)stringInPinyinCapital;
- (NSString *)stringForInitial;

// encode url
- (NSString *)encodeString;
- (NSString *)decodeString;

+ (NSString *)getDecMobileWithStrMobile:(NSString *)strMobile;

//quanweiz added

+ (BOOL)isEmptyOrWhitespace:(NSString *)str;

+ (BOOL)isNilOrNSNull:(NSString *)str;

+ (NSString *)getNoNilOrNSNullString:(NSString *)str;

+ (BOOL)isNilOrNSNullOrEmptyOrWhitespace:(NSString *)str;
- (NSString *)safeStringWithRange:(NSRange )range;

@end

@interface NSString (Version)

- (BOOL)versionMoreThan:(NSString *)string;
- (BOOL)versionNoMoreThan:(NSString *)string;
- (BOOL)versionLessThan:(NSString *)string;
- (BOOL)versionNoLessThan:(NSString *)string;

@end

@interface NSString (Base64)
/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;

/**
 *  转换为Base64编码
 */
- (NSString *)numberBase64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)numberBase64DecodedString;

@end




