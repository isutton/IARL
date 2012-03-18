//
//  IARLRadio.m
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLRadio.h"

@implementation IARLRadio

@dynamic callName;
@dynamic radioID;
@dynamic longitude;
@dynamic latitude;
@dynamic shift;
@dynamic tx;

- (NSString *)description
{
    return [NSString stringWithFormat:@"<IARLRadio radioID:%@, Call: %@, Longitude:%f, Latitude:%f>", self.radioID, self.coordinate.longitude, self.coordinate.latitude];
}

#pragma mark - MKAnnotation

- (NSString *)title
{
    return [[NSString stringWithFormat:@"%@", self.callName] copy];
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
