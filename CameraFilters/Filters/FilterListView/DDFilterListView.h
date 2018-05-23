//
//  DDFilterListView.h
//  PAPA
//
//  Created by Wei Zhang on 4/14/14.
//  Copyright (c) 2014 diandian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDFilterSwitchView.h"

@class DDFilterItem;

@protocol DDFilterListViewDelegate;

@interface DDFilterListView : UIView {
    NSMutableArray *_mutipleSelectionSwitchViews; // Currently, all mutiple-selection filters are exclusive.
}

@property (nonatomic, weak) id<DDFilterListViewDelegate> filterDelegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *filterSwitchViews;
@property (nonatomic, strong) DDFilterSwitchView *currentSelectedSingletonSwitchView;

- (instancetype)initWithFrame:(CGRect)frame
                  filterItems:(NSArray *)filterItems
               filterDelegate:(id<DDFilterListViewDelegate>)filterDelegatei
            initialFilterItem:(DDFilterItem *)initialItem;

- (instancetype)initWithFrame:(CGRect)frame
                  filterItems:(NSArray *)filterItems
               filterDelegate:(id<DDFilterListViewDelegate>)filterDelegatei
            initialFilterItem:(DDFilterItem *)initialItem
             filterSwitchSize:(CGSize)filterSwitchSize
            horizontalSpacing:(NSInteger)horizontalSpacing;

- (void)insertFilterItems:(NSArray *)filterItems fromIndex:(NSUInteger)index scroll:(BOOL)scrollToItem;
- (void)removeFilterItems:(NSArray *)filterItems;

- (void)reloadFilterItems:(NSArray *)filterItems;

- (void)toggleFilterItem:(DDFilterItem *)filterItem withStatusOn:(BOOL)statusOn;
- (void)toggleFilterItems:(NSArray *)filterItems withStatusOn:(BOOL)statusOn;
- (void)toggleFilterWithName:(NSString *)filterName withStatusOn:(BOOL)statusOn;

- (void)scrollToFilterIndex:(NSUInteger)index animated:(BOOL)animted;
- (void)scrollToFilterItem:(DDFilterItem *)filterItem animated:(BOOL)animted;

@end

@protocol DDFilterListViewDelegate <NSObject>

- (BOOL)filterListViewSelectedFilter:(DDFilterItem *)filterItem withFilterSwitchView:(DDFilterSwitchView *)filterSwitchView;

@end
