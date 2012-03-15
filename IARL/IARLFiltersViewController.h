//
//  IARLFiltersViewController.h
//  IARL
//
//  Created by Igor Sutton on 3/14/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IARLBandFilterViewController;

@interface IARLFiltersViewController : UIViewController 
{
    @private
    __strong UISegmentedControl *_filterTypesControl;
    __strong IARLBandFilterViewController *_bandFilterViewController;
    NSInteger _visibleFilterTypeIndex;
    
}

- (IBAction)filterTypeChanged:(id)sender;
- (void)displayViewAtIndex:(NSInteger)idx;

@end
