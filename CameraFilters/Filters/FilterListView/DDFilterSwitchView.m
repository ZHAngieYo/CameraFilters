//
//  DDFilterButton.m
//  PAPA
//
//  Created by Wei Zhang on 4/14/14.
//  Copyright (c) 2014 diandian. All rights reserved.
//

#import "DDFilterSwitchView.h"
#import "NSString+Tools.h"
#import "UIView+Tools.h"
#import "DDFilterItem.h"
#import "GPUImage.h"
#import "MKGPUImageFilterPipeline.h"

@interface DDFilterSwitchView ()

@property (nonatomic, strong) UIImageView *checkerImageView;

@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) GPUImageView *outPut;

@property (nonatomic, strong) GPUImagePicture *picture;

@property (nonatomic, strong) MKGPUImageFilterPipeline *filterPipeline;


@end

@implementation DDFilterSwitchView

#pragma mark -
#pragma mark Life Cycle

- (void)reloadWithFilterItem:(DDFilterItem *)filterItem {
    
    self.filterItem = filterItem;
    if (filterItem.btnImageName && ![filterItem.btnImageName isEmptyString]) {
        self.imageView.image = [UIImage imageNamed:filterItem.btnImageName];
    } else if (filterItem.btnImage) {
        self.imageView.image = filterItem.btnImage;
        
    } else {
        NSLog(@"....");
    }
    
    self.titleLabel.text = _(filterItem.btnText);
    
    self.filterPipeline = [[MKGPUImageFilterPipeline alloc] initWithName:filterItem.btnText input:self.picture output:self.outPut];
}

- (GPUImageView *)outPut{
    if (_outPut == nil) {
        _outPut = [[GPUImageView alloc] init];
        _outPut.frame = self.imageView.frame;
        [_outPut setBackgroundColor:[UIColor clearColor]];
    }
    return _outPut;
}

- (GPUImagePicture *)picture{
    if (_picture == nil) {
        _picture = [[GPUImagePicture alloc] initWithImage:self.imageView.image];
    }
    return _picture;
}

- (instancetype)initWithFrame:(CGRect)frame
                   filterItem:(DDFilterItem *)filter
                 checkerImage:(UIImage *)image
                checkerOrigin:(CGPoint)point{
    self = [self initWithFrame:frame filterItem:filter];
    if (self) {
        if (image) {
            self.checkerImageView.image = image;
            [self.checkerImageView sizeToFit];
        }
        
        if (CGPointEqualToPoint(point, CGPointZero)) {
            float centerX =self.imageView.width - 2.0/13.0 * self.checkerImageView.width;
            self.checkerImageView.center = ccp(centerX, centerX);
        } else{
            self.checkerImageView.leftTopPosition = point;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame filterItem:(DDFilterItem *)filter {
    
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:ccr(0, 0, frame.size.width, 100)];
        
        [self addSubview:self.imageView];
        
        [self addSubview:self.outPut];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
        [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
        self.titleLabel.frame = ccr(self.imageView.left - 4, self.imageView.bottom + 10, self.imageView.width + 8, 20);
        [self.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:self.titleLabel];
        self.checkerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pub_insta_checker"]];
        CGFloat width = 56.0 / 60.0;
        self.checkerImageView.center = ccp(width * CGRectGetWidth(frame), width * CGRectGetWidth(frame));
        // [self addSubview:self.checkerImageView];
        
        self.selectView = [[UIView alloc] initWithFrame:CGRectMake(18, self.imageView.bottom +37, 58, 2)];
        self.selectView.backgroundColor = [UIColor colorWithRed:252/255.0 green:152/255.0 blue:28/255.0 alpha:1.0];
        [self addSubview:self.selectView];
        self.on = NO;
        
        [self reloadWithFilterItem:filter];
        
    }
    
    return self;
}

- (void)setOn:(BOOL)on {
    _on = on;
    
    if (on) {
        //self.checkerImageView.hidden = NO;
        self.selectView.hidden = NO;
        [self.titleLabel setTextColor:[UIColor colorWithRed:252/255.0 green:152/255.0 blue:28/255.0 alpha:1.0]];
    } else {
        // self.checkerImageView.hidden = YES;
        self.selectView.hidden = YES;
        [self.titleLabel setTextColor:[UIColor whiteColor]];
    }
    
    [self sizeToFit];
}
@end
