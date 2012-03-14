//
//  IARLRadio.m
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLRadio.h"

@implementation IARLRadio

@synthesize call = _call;
@synthesize coordinate = _coordinate;
@synthesize ID = _ID;
@synthesize shift = _shift;
@synthesize tx = _tx;

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (!(self = [self init]))
        return nil;

    _call = [[dict objectForKey:@"call"] copy];
    [[dict objectForKey:@"coordinate"] getValue:&_coordinate];
    _ID = [[dict objectForKey:@"ID"] copy];
    _shift = [[dict objectForKey:@"shift"] copy];
    _tx = [[dict objectForKey:@"tx"] copy];
    
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
