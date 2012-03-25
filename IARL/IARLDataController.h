//
//  IARLDataController.h
//  IARL
//
//  Created by Igor Sutton on 3/15/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "IARLBandFilterViewController.h"

@class IARLRadioTableController;
@class IARLMapController;

@interface IARLDataController : NSObject <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISplitViewControllerDelegate,MKMapViewDelegate>

@property (nonatomic, strong) NSArray *radios;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, copy) NSSet *bandFilter;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (NSArray *)radiosInRegion:(MKCoordinateRegion)region;

@end

extern NSString * const IARLDataControllerRadiosKey;