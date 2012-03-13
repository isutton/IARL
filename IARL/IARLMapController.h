//
//  IARLMapController.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface IARLMapController : UIViewController <UISplitViewControllerDelegate,MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@end
