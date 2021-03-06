//
//  IARLFiltersViewController.h
//  IARL
//
//  Created by Igor Sutton on 3/14/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IARLDataController;
@class IARLFiltersViewController;
@class IARLBandFilterViewController;
@class IARLDeviceFilterViewController;

@protocol IARLFilterConfigurable <NSObject>

- (NSString *)name;
- (UIView *)view;

@end

@protocol IARLFilterDelegate <NSObject>

@end

@interface IARLFiltersViewController : UIViewController 
{
    @private
    __strong UISegmentedControl *_filterTypesControl;
    __strong NSArray *_filters;
    NSInteger _visibleFilterTypeIndex;
    
}

@property (nonatomic, weak) IARLDataController *dataController;

- (IBAction)filterTypeChanged:(id)sender;
- (void)displayViewControllerAtIndex:(NSInteger)idx;

@end
