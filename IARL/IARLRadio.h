//
//  IARLRadio.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#if TARGET_OS_IPHONE
    #import <MapKit/MapKit.h>
#endif

#if TARGET_OS_IPHONE
    @interface IARLRadio : NSManagedObject <MKAnnotation>
#else
    @interface IARLRadio : NSManagedObject
#endif

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSString *band;
@property (nonatomic, strong) NSString *bandFrequency;
@property (nonatomic, strong) NSNumber *radioID;
@property (nonatomic, strong) NSNumber *shift;
@property (nonatomic, strong) NSNumber *tx;
@property (nonatomic, strong) NSString *callName;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
