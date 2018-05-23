//
//  DDFilterListViewSubclass.h
//  PAPA
//
//  Created by Wei Zhang on 5/4/14.
//  Copyright (c) 2014 diandian. All rights reserved.
//


#import "DDFilterListView.h"
#import "DDFilterItem.h"

// the extensions in this header are to be used only by subclasses of DDFilterListView
// code that uses DDFilterListView must never call these

@interface DDFilterListView (ForSubclassEyesOnly) <UIScrollViewDelegate>

- (NSInteger)_filterViewIndexWithFilterItem:(DDFilterItem *)filterItem;
- (NSInteger)_filterViewIndexWithFilterName:(NSString *)filterName;
- (void)_toggleFilterSwitchView:(DDFilterSwitchView *)filterSwitchView withStatusOn:(BOOL)statusOn;

- (void)filterViewTapped:(UIGestureRecognizer *)sender;

@end
