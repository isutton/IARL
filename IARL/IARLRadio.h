//
//  IARLRadio.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface IARLRadio : NSObject <MKAnnotation>

@property (nonatomic, readonly) NSString *ID;
@property (nonatomic, readonly) CLLocationCoordinate2D location;
@property (nonatomic, readonly) NSString *call;

- (id)initWithID:(NSString *)ID location:(CLLocationCoordinate2D)location call:(NSString *)call;

@end
