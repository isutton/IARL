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
@synthesize coordinate = _coordinate;
@synthesize call = _call;

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (!(self = [self init]))
        return nil;

    _ID = [[dict objectForKey:@"ID"] copy];
    _call = [[dict objectForKey:@"call"] copy];
    [[dict objectForKey:@"coordinate"] getValue:&_coordinate];
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<IARLRadio ID:%@, Call: %@, Longitude:%f, Latitude:%f>", self.ID, self.coordinate.longitude, self.coordinate.latitude];
}

#pragma mark - MKAnnotation

- (NSString *)title
{
    return [[NSString stringWithFormat:@"%@", self.call] copy];
}

@end
