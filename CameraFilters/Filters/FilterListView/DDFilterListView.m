//
//  DDFilterListView.m
//  PAPA
//
//  Created by Wei Zhang on 4/14/14.
//  Copyright (c) 2014 diandian. All rights reserved.
//

#import "DDFilterListView.h"
#import "UIView+Tools.h"
#import "DDFilterListViewSubclass.h"
#import "DDFilterItem.h"

//#define kDDFilterListView_FilterButton_Margin     (12)
//#define kDDFilterListView_FilterButton_Width      (60)
//#define kDDFilterListView_FilterButton_Height     (85)

@interface DDFilterListView ()

@property (nonatomic, assign) CGFloat horizontalSpacing;
@property (nonatomic, assign) CGFloat switchViewWidth;
@property (nonatomic, assign) CGFloat switchViewHeight;

@end

@implementation DDFilterListView

- (void)dealloc {
    self.scrollView.delegate = nil;
}

#pragma mark -
#pragma mark Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
                  filterItems:(NSArray *)filterItems
               filterDelegate:(id<DDFilterListViewDelegate>)filterDelegate
            initialFilterItem:(DDFilterItem *)initialItem {
    return [self initWithFrame:frame filterItems:filterItems filterDelegate:filterDelegate initialFilterItem:initialItem filterSwitchSize:CGSizeMake(94, 150) horizontalSpacing:6];
}

- (instancetype)initWithFrame:(CGRect)frame
                  filterItems:(NSArray *)filterItems
               filterDelegate:(id<DDFilterListViewDelegate>)filterDelegate
            initialFilterItem:(DDFilterItem *)initialItem
             filterSwitchSize:(CGSize)filterSwitchSize
            horizontalSpacing:(NSInteger)horizontalSpacing{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        self.horizontalSpacing = horizontalSpacing;
        self.switchViewHeight = filterSwitchSize.height;
        self.switchViewWidth = filterSwitchSize.width;
        
        self.filterSwitchViews = [NSMutableArray array];
        _mutipleSelectionSwitchViews = [NSMutableArray array];
        
        self.filterDelegate = filterDelegate;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:self.scrollView];
        
        CGFloat contentWidth = self.horizontalSpacing;
        NSUInteger initialItemIndex = 0;
        for (DDFilterItem *filterItem in filterItems) {
            
            NSUInteger index = [filterItems indexOfObject:filterItem];
            
            DDFilterSwitchView *filterSwitchView = [[DDFilterSwitchView alloc] initWithFrame:ccr(self.horizontalSpacing + index * (self.horizontalSpacing + self.switchViewWidth), 10, self.switchViewWidth, self.switchViewHeight) filterItem:filterItem];
            filterSwitchView.on = filterSwitchView.filterItem == initialItem;
            initialItemIndex = filterSwitchView.filterItem == initialItem ? index : initialItemIndex;
            
            if (filterItem.selectionStyle == DDFilterItemSelectionStyle_Singleton && filterSwitchView.on) {
                self.currentSelectedSingletonSwitchView = filterSwitchView;
            } else if (filterItem.selectionStyle == DDFilterItemSelectionStyle_Multiple) {
                [_mutipleSelectionSwitchViews addObject:filterSwitchView];
            }
            
            [self.filterSwitchViews addObject:filterSwitchView];
            
            [self.scrollView addSubview:filterSwitchView];
            
            contentWidth += (self.horizontalSpacing + self.switchViewWidth);
            
            
            [filterSwitchView addTarget:self tapAction:@selector(filterViewTapped:)];
            
        }
        
        self.scrollView.contentSize = ccs(contentWidth, CGRectGetHeight(frame));
        
        // init contentOffset, in need to make the initialFilter show in middle position;
        CGFloat contentOffsetX = 0;
        if (initialItemIndex > [filterItems count] - 4) {
            contentOffsetX = contentWidth - [[UIScreen mainScreen] bounds].size.width;
        }
        else
        {
            initialItemIndex = (initialItemIndex > 2) ? initialItemIndex - 2 : 0;
            contentOffsetX = initialItemIndex * (self.horizontalSpacing + self.switchViewWidth);
        }
        self.scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
        
    }
    return self;
}

#pragma mark -
#pragma mark Insert Item

- (void)reloadFilterItems:(NSArray *)filterItems {
    
    for (DDFilterItem *filterItem in filterItems) {
        NSInteger filterItemIndex = [self _filterViewIndexWithFilterItem:filterItem];
        if (filterItemIndex != -1) {
            DDFilterSwitchView *switchView = [self.filterSwitchViews objectAtIndex:filterItemIndex];
            [switchView reloadWithFilterItem:filterItem];
        }
    }
    
}

- (void)insertFilterItems:(NSArray *)filterItems fromIndex:(NSUInteger)index scroll:(BOOL)scrollToItem {
    
    if (index > [self.filterSwitchViews count]) {
        return;
    }
    
    NSUInteger filterIndex = 0;
    
    for (NSUInteger i = index; filterIndex < [filterItems count]; i++, ++filterIndex) {

        DDFilterSwitchView *filterSwitchView = [[DDFilterSwitchView alloc] initWithFrame:ccr(self.horizontalSpacing + i * (self.horizontalSpacing + self.switchViewWidth), (CGRectGetHeight(self.frame) -  self.switchViewHeight) / 2, self.switchViewWidth, self.switchViewHeight) filterItem:[filterItems objectAtIndex:filterIndex]];
        
        [self.filterSwitchViews insertObject:filterSwitchView atIndex:i];
        [self.scrollView addSubview:filterSwitchView];
        //[filterSwitchView addTapAction:@selector(filterViewTapped:) target:self];
        [filterSwitchView addTarget:self tapAction:@selector(filterViewTapped:)];
        if(filterSwitchView.filterItem.selectionStyle == DDFilterItemSelectionStyle_Multiple) {
            [_mutipleSelectionSwitchViews addObject:filterSwitchView];
        }
    }
    
    for (NSUInteger i = index + [filterItems count]; i < [self.filterSwitchViews count]; i++) {
        DDFilterSwitchView *filterSwitchView = [self.filterSwitchViews objectAtIndex:i];
        filterSwitchView.left = self.horizontalSpacing + i * (self.horizontalSpacing + self.switchViewWidth);
    }
    
    self.scrollView.contentSize = ccs(self.horizontalSpacing + [self.filterSwitchViews count] * (self.horizontalSpacing + self.switchViewWidth), self.height);
    
    if (scrollToItem) {
        [self.scrollView setContentOffset:ccp(index * (self.horizontalSpacing + self.switchViewWidth), 0) animated:YES];
    }
}

- (void)removeFilterItems:(NSArray *)filterItems {
    
    if (![filterItems count]) {
        return;
    }
    
    NSMutableArray *viewsToRemove = [NSMutableArray array];
    NSMutableArray *mutipleSelctionViewsToRemove = [NSMutableArray array];
    
    for (DDFilterItem *filterItem in filterItems) {
        for (DDFilterSwitchView *switchView in self.filterSwitchViews) {
            if (switchView.filterItem == filterItem) {
                [switchView removeFromSuperview];
                [viewsToRemove addObject:switchView];
                if (switchView.filterItem.selectionStyle == DDFilterItemSelectionStyle_Multiple) {
                    [mutipleSelctionViewsToRemove addObject:switchView];
                }
            }
        }
    }
    
    [self.filterSwitchViews removeObjectsInArray:viewsToRemove];
    [_mutipleSelectionSwitchViews removeObjectsInArray:mutipleSelctionViewsToRemove];
    
    self.scrollView.contentSize = ccs(self.horizontalSpacing + [self.filterSwitchViews count]* (self.horizontalSpacing + self.switchViewWidth), self.height);
    
    for (int i = 0; i < [self.filterSwitchViews count]; i++) {
        DDFilterSwitchView *filterSwitchView = [self.filterSwitchViews objectAtIndex:i];
        filterSwitchView.left = self.horizontalSpacing + i * (self.horizontalSpacing + self.switchViewWidth);
    }
}

#pragma mark -
#pragma mark Scroll To Item

- (void)scrollToFilterItem:(DDFilterItem *)filterItem animated:(BOOL)animted {
    
    NSInteger filterIndex = [self _filterViewIndexWithFilterItem:filterItem];
    
    if (filterIndex != -1) {
        [self scrollToFilterIndex:filterIndex animated:animted];
    } else {
        return;
    }
}

- (void)scrollToFilterIndex:(NSUInteger)index animated:(BOOL)animted {

    if (index >= [self.filterSwitchViews count]) {
        return;
    }
    
    [self.scrollView setContentOffset:ccp(index * (self.horizontalSpacing + self.switchViewWidth), 0) animated:animted];
}

#pragma mark -
#pragma mark Status Toggle

- (void)_toggleFilterSwitchView:(DDFilterSwitchView *)filterSwitchView withStatusOn:(BOOL)statusOn {
    
    filterSwitchView.on = statusOn;
    
    if (statusOn) {
        
        if (filterSwitchView.filterItem.selectionStyle == DDFilterItemSelectionStyle_Multiple) {
            for (DDFilterSwitchView *switchView in _mutipleSelectionSwitchViews) {
                if (switchView != filterSwitchView) {
                    switchView.on = NO;
                }
            }
            
        } else if (filterSwitchView.filterItem.selectionStyle == DDFilterItemSelectionStyle_Singleton && self.currentSelectedSingletonSwitchView != filterSwitchView) {
            self.currentSelectedSingletonSwitchView.on = NO;
            self.currentSelectedSingletonSwitchView = filterSwitchView;
        }

    } else {
        
        if (filterSwitchView.filterItem.selectionStyle == DDFilterItemSelectionStyle_Singleton && self.currentSelectedSingletonSwitchView == filterSwitchView) {
            self.currentSelectedSingletonSwitchView = nil;
        }
    }
    
}

- (void)toggleFilterItem:(DDFilterItem *)filterItem withStatusOn:(BOOL)statusOn {
    
    NSInteger index = [self _filterViewIndexWithFilterItem:filterItem];
    
    if (index == -1) {
        return;
    }
    
    DDFilterSwitchView *filterSwitchView = [self.filterSwitchViews objectAtIndex:index];
    
    [self _toggleFilterSwitchView:filterSwitchView withStatusOn:statusOn];
}

- (void)toggleFilterItems:(NSArray *)filterItems withStatusOn:(BOOL)statusOn {

    for (DDFilterItem *filterItem in filterItems) {
        if (filterItem.selectionStyle != DDFilterItemSelectionStyle_Unselectable) {
            [self toggleFilterItem:filterItem withStatusOn:statusOn];
        }
    }
}

- (void)toggleFilterWithName:(NSString *)filterName withStatusOn:(BOOL)statusOn {

    NSInteger index = -1;
    
    index = [self _filterViewIndexWithFilterName:filterName];
    
    if (index == -1) {
        return;
    }
    
    DDFilterSwitchView *filterSwitchView = [self.filterSwitchViews objectAtIndex:index];
    
    [self _toggleFilterSwitchView:filterSwitchView withStatusOn:statusOn];
}

#pragma mark -
#pragma mark Tap Action

-(void)filterViewTapped:(UIGestureRecognizer *)sender {
    
    DDFilterSwitchView *filterSwitchView = (DDFilterSwitchView *)sender.view;
    
    if (self.filterDelegate && [self.filterDelegate respondsToSelector:@selector(filterListViewSelectedFilter:withFilterSwitchView:)]) {
        
        if( [self.filterDelegate filterListViewSelectedFilter:filterSwitchView.filterItem withFilterSwitchView:filterSwitchView] ) {
            
            if (filterSwitchView.filterItem.selectionStyle != DDFilterItemSelectionStyle_Unselectable) {
                
                filterSwitchView.on = YES;
                
                if (filterSwitchView.filterItem.selectionStyle == DDFilterItemSelectionStyle_Multiple) {
                    for (DDFilterSwitchView *switchView in _mutipleSelectionSwitchViews) {
                        if (switchView != filterSwitchView) {
                            switchView.on = NO;
                        }
                    }
                    
                } else if (filterSwitchView.filterItem.selectionStyle == DDFilterItemSelectionStyle_Singleton && self.currentSelectedSingletonSwitchView != filterSwitchView) {
                    self.currentSelectedSingletonSwitchView.on = NO;
                    self.currentSelectedSingletonSwitchView = filterSwitchView;
                }
            }
            
        } else {
            
            if (filterSwitchView.filterItem.selectionStyle == DDFilterItemSelectionStyle_Singleton && self.currentSelectedSingletonSwitchView != filterSwitchView) {
                filterSwitchView.on = NO;
            } else if (filterSwitchView.filterItem.selectionStyle == DDFilterItemSelectionStyle_Multiple) {
                filterSwitchView.on = NO;
            }
        }
    }
}

#pragma mark -
#pragma mark Convenience Methods

- (NSInteger)_filterViewIndexWithFilterItem:(DDFilterItem *)filterItem {

    NSInteger filterIndex = -1;
    
    for (DDFilterSwitchView *filterView in self.filterSwitchViews) {
        if (filterView.filterItem == filterItem) {
            filterIndex = [self.filterSwitchViews indexOfObject:filterView];
            break;
        }
    }
    
    return filterIndex;

}

- (NSInteger)_filterViewIndexWithFilterName:(NSString *)filterName {

    NSInteger filterIndex = -1;
    
    for (DDFilterSwitchView *filterView in self.filterSwitchViews) {
        if ([filterView.filterItem.btnText isEqualToString:filterName]) {
            filterIndex = [self.filterSwitchViews indexOfObject:filterView];
            break;
        }
    }
    
    return filterIndex;
}

@end
