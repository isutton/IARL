//
//  IARLViewController.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <MapKit/MapKit.h>

@class IARLDataController;

@interface IARLRadioTableController : UITableViewController

@property (strong, nonatomic) IARLDataController *dataController;

- (id)initWithDataController:(IARLDataController *)dataController;

@end
