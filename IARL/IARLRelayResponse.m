//
//  IARLRelayResponse.m
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLRelayResponse.h"

@implementation IARLRelayResponse

@synthesize radios = _radios;

- (id)initWithRadios:(NSArray *)radios
{
    if (!(self = [super init]))
        return nil;
    
    _radios = radios;
    
    return self;
}

@end
