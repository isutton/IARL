//
//  IARLBandFilterViewController.h
//  IARL
//
//  Created by Igor Sutton on 3/15/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLFiltersViewController.h"

@class  IARLBandFilterViewController;

@protocol IARLBandFilterDelegate <NSObject,IARLFilterDelegate>

- (void)bandFilterControllerDidChangeFilter:(IARLBandFilterViewController *)bandFilterController;

@end

@interface IARLBandFilterViewController : UITableViewController <IARLFilterConfigurable>

@property (nonatomic, weak) id<IARLBandFilterDelegate> delegate;

@end
