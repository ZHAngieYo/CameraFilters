//
//  DDFilterItem.m
//  PAPA
//
//  Created by Wei Zhang on 4/14/14.
//  Copyright (c) 2014 diandian. All rights reserved.
//

#import "DDFilterItem.h"

@interface DDFilterItem ()

@end

@implementation DDFilterItem

- (instancetype)initWithFilterName:(NSString *)filterName
                         imageName:(NSString *)imageName
                    selectionStyle:(DDFilterItemSelectionStyle)selectionStyle {
    
    if ((self = [super init])) {
        self.btnText = filterName;
        self.btnImageName = imageName;
        self.selectionStyle = selectionStyle;
        self.isNew = NO;
    }
    
    return self;
}

- (instancetype)initWithFilterName:(NSString *)filterName
                         image:(UIImage *)image
                    selectionStyle:(DDFilterItemSelectionStyle)selectionStyle {
    
    if ((self = [super init])) {
        self.btnText = filterName;
        self.btnImage = image;
        self.selectionStyle = selectionStyle;
        self.isNew = NO;
    }
    
    return self;
}

- (instancetype)initWithFilterName:(NSString *)filterName
                         imageName:(NSString *)imageName
                    selectionStyle:(DDFilterItemSelectionStyle)selectionStyle
                          selector:(SEL)selector {
    
    if ((self = [self initWithFilterName:filterName imageName:imageName selectionStyle:selectionStyle])) {
        self.customSelector = selector;
        self.isNew = NO;
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.btnText forKey:@"BtnText"];
    [aCoder encodeObject:self.btnImageUrl forKey:@"BtnImageUrl"];
    [aCoder encodeObject:self.btnImageName forKey:@"BtnImageName"];
    [aCoder encodeObject:self.btnPlaceholderImageName forKey:@"BtnPlaceholderImageName"];
    [aCoder encodeInteger:self.selectionStyle forKey:@"SelectionStyle"];
    [aCoder encodeObject:self.btnImage forKey:@"BtnImage"];
    [aCoder encodeObject:NSStringFromSelector(self.customSelector) forKey:@"CustomSelector"];
    [aCoder encodeBool:self.isNew forKey:@"IsNew"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.btnText = [aDecoder decodeObjectForKey:@"BtnText"];
        self.btnImageUrl = [aDecoder decodeObjectForKey:@"BtnImageUrl"];
        self.btnImageName = [aDecoder decodeObjectForKey:@"BtnImageName"];
        self.btnImage = [aDecoder decodeObjectForKey:@"BtnImage"];
        self.btnPlaceholderImageName = [aDecoder decodeObjectForKey:@"BtnPlaceholderImageName"];
        self.selectionStyle = [aDecoder decodeIntegerForKey:@"SelectionStyle"];
        self.customSelector = NSSelectorFromString([aDecoder decodeObjectForKey:@"CustomSelector"]);
        self.isNew = [aDecoder decodeBoolForKey:@"IsNew"];
    }
    return self;
}

- (void)copyValueFrom:(DDFilterItem *)filterItem {
    self.filterId = filterItem.filterId;
    self.btnText = filterItem.btnText;
    self.btnImage = filterItem.btnImage;
    self.btnImageName = filterItem.btnImageName;
    self.btnImageUrl = filterItem.btnImageUrl;
    self.btnPlaceholderImageName = filterItem.btnPlaceholderImageName;
    self.selectionStyle = filterItem.selectionStyle;
    self.customSelector = filterItem.customSelector;
    self.isNew = filterItem.isNew;
}

- (BOOL)writeToDataFile:(NSString *)path atomically:(BOOL)atomically {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    BOOL didWriteSuccessful = [data writeToFile:path atomically:atomically];
    return didWriteSuccessful;
}

+ (DDFilterItem *)readFromDataFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
