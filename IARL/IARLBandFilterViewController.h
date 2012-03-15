//
//  IARLBandFilterViewController.h
//  IARL
//
//  Created by Igor Sutton on 3/15/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLFiltersViewController.h"

@interface IARLBandFilterViewController : UITableViewController <IARLFilterConfigurable>

@property (nonatomic, strong) NSArray *bands;

@end
