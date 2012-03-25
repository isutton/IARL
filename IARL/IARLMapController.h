//
//  IARLMapController.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class IARLDataController;

@interface IARLMapController : UIViewController <UIPopoverControllerDelegate,UISearchBarDelegate>
{
    __strong UIPopoverController *_filtersPopoverController;
}

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, weak) id<MKMapViewDelegate>delegate;
@property (nonatomic, readonly) MKCoordinateRegion region;
@property (nonatomic, readonly) NSArray *selectedAnnotations;
@property (nonatomic, weak) IARLDataController *dataController;

- (void)selectAnnotation:(id<MKAnnotation>)annotation animated:(BOOL)animated;
- (void)addAnnotations:(NSArray *)annotations;
- (void)moveToLocator:(NSString *)locator;
- (IBAction)filtersButtonTapped:(id)sender;
- (IBAction)locationButtonTapped:(id)sender;

@end
