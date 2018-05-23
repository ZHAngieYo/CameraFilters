//
//  DDFilterButton.h
//  PAPA
//
//  Created by Wei Zhang on 4/14/14.
//  Copyright (c) 2014 diandian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDFilterItem;

@interface DDFilterSwitchView : UIView

@property (nonatomic, assign, getter=isOn) BOOL on;
@property (nonatomic, strong) DDFilterItem *filterItem;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame
                   filterItem:(DDFilterItem *)filter
                 checkerImage:(UIImage *)image
                checkerOrigin:(CGPoint)point;

- (instancetype)initWithFrame:(CGRect)frame filterItem:(DDFilterItem *)filter;

- (void)reloadWithFilterItem:(DDFilterItem *)filterItem;

@end
