//
//  IARLRelayResponse.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IARLRelayResponse : NSObject

@property (nonatomic, readonly) NSArray *radios;

- (id)initWithRadios:(NSArray *)radios;

@end
