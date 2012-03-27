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
extern NSString * const IARLDataControllerBandsFilterKey;

extern NSString * const IARLBandFilterKey;
extern NSString * const IARLHFBandKey;
extern NSString * const IARLVHFBandKey;
extern NSString * const IARLUHFBandKey;

extern NSString * const IARLHFCellImageName;
extern NSString * const IARLVHFCellImageName;
extern NSString * const IARLUHFCellImageName;

extern NSString * const IARLHFAnnotationImageName;
extern NSString * const IARLVHFAnnotationImageName;
extern NSString * const IARLUHFAnnotationImageName;

extern NSString * const IARLCellFont;

extern NSString * const IARLDataControllerRadiosKey;
extern NSString * const IARLDataControllerBandsFilterKey;
