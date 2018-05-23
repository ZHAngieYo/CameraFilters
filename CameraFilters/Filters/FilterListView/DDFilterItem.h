//
//  DDFilterItem.h
//  PAPA
//
//  Created by Wei Zhang on 4/14/14.
//  Copyright (c) 2014 diandian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDFilterItemSelectionStyle) {
	DDFilterItemSelectionStyle_Singleton = 0,
    DDFilterItemSelectionStyle_Multiple  = 1,
    DDFilterItemSelectionStyle_Unselectable = 2,
};

@interface DDFilterItem : NSObject <NSCoding>

@property (nonatomic, copy) NSString *filterId;
@property (nonatomic, copy) NSString *btnImageUrl;
@property (nonatomic, copy) NSString *btnImageName;
@property (nonatomic, copy) NSString *btnPlaceholderImageName;
@property (nonatomic, copy) NSString *btnText;
@property (nonatomic, strong) UIImage *btnImage;
@property (nonatomic, assign) DDFilterItemSelectionStyle selectionStyle;
@property (nonatomic, assign) SEL customSelector;
//TODO :lilg 暂时用不到了，留着以后备用
@property (nonatomic, assign) BOOL isNew;

- (instancetype)initWithFilterName:(NSString *)filterName
                         imageName:(NSString *)imageName
                    selectionStyle:(DDFilterItemSelectionStyle)selectionStyle;

- (instancetype)initWithFilterName:(NSString *)filterName
                         imageName:(NSString *)imageName
                    selectionStyle:(DDFilterItemSelectionStyle)selectionStyle
                          selector:(SEL)selector;

- (void)copyValueFrom:(DDFilterItem *)filterItem;

- (BOOL)writeToDataFile:(NSString *)path atomically:(BOOL)atomically;
+ (DDFilterItem *)readFromDataFile:(NSString *)path;
- (instancetype)initWithFilterName:(NSString *)filterName
                             image:(UIImage *)image
                    selectionStyle:(DDFilterItemSelectionStyle)selectionStyle;
@end
