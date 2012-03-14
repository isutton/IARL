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
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *call;
@property (nonatomic, readonly) NSNumber *tx;
@property (nonatomic, readonly) NSNumber *shift;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
