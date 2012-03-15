//
//  IARLMapController.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface IARLMapController : UIViewController <UIPopoverControllerDelegate,UISearchBarDelegate,MKMapViewDelegate>
{
    __strong UIPopoverController *_filtersPopoverController;
}

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, weak) id<MKMapViewDelegate>delegate;
@property (nonatomic, readonly) MKCoordinateRegion region;
@property (nonatomic, readonly) NSArray *selectedAnnotations;

- (void)selectAnnotation:(id<MKAnnotation>)annotation animated:(BOOL)animated;
- (void)addAnnotations:(NSArray *)annotations;
- (IBAction)filtersButtonTapped:(id)sender;

@end
