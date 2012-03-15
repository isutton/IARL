//
//  IARLViewController.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "IARLDataStore.h"

@interface IARLRadioTableController : UITableViewController

@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@property (nonatomic, weak) id<UITableViewDataSource> dataSource;

- (void)reloadData;

@end
