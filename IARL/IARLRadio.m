//
//  IARLRadio.m
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLRadio.h"

@implementation IARLRadio

@synthesize ID = _ID;
@synthesize location = _location;
@synthesize call = _call;

- (id)initWithID:(NSString *)ID location:(CLLocationCoordinate2D)location call:(NSString *)call
{
    if (!(self = [super init]))
        return nil;

    _ID = ID;
    _location = location;
    _call = call;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<IARLRadio ID:%@, Call: %@, Longitude:%f, Latitude:%f>", self.ID, self.location.longitude, self.location.latitude];
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return self.location;
}

- (NSString *)title
{
    return [[NSString stringWithFormat:@"%@", self.call] copy];
}

@end
