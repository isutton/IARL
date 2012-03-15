//
//  IARLDataController.h
//  IARL
//
//  Created by Igor Sutton on 3/15/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "IARLDataStore.h"

@class IARLRadioTableController;
@class IARLMapController;

@interface IARLDataController : NSObject <UITableViewDelegate,UITableViewDataSource,UISplitViewControllerDelegate,MKMapViewDelegate,IARLDataStoreDelegate>

@property (nonatomic, strong) IARLMapController *mapController;
@property (nonatomic, strong) IARLRadioTableController *radioTableController;
@property (nonatomic, strong) IARLDataStore *dataStore;
@property (nonatomic, strong) NSArray *radios;

- (void)annotationDisclosureButtonTapped:(id)sender;

@end
