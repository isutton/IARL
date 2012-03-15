//
//  IARLViewController.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "IARLDataStore.h"

@interface IARLRadioTableController : UITableViewController <UIPopoverControllerDelegate,MKMapViewDelegate,IARLDataStoreDelegate>
{
    __strong UIPopoverController *_filtersPopoverController;
}

@property (nonatomic, strong) IARLDataStore *dataStore;
@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong) NSArray *radios;

- (void)annotationDisclosureButtonTapped:(id)sender;
- (IBAction)filtersButtonTapped:(id)sender;

@end
