//
//  IARLViewController.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "IARLRelayRequest.h"

@interface IARLRadioTableController : UITableViewController <IARLRelayRequestDelegate,MKMapViewDelegate>

@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong) NSArray *radios;

@end
