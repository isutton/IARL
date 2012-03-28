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

@interface IARLMapController : UIViewController <UIPopoverControllerDelegate,UISearchBarDelegate,UISplitViewControllerDelegate>
{
    __strong UIPopoverController *_filtersPopoverController;
}

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, weak) IARLDataController *dataController;

- (id)initWithDataController:(IARLDataController *)dataController;
- (void)moveToLocator:(NSString *)locator;
- (IBAction)filtersButtonTapped:(id)sender;
- (IBAction)locationButtonTapped:(id)sender;

@end
