//
//  IARLDataStore.h
//  IARL
//
//  Created by Igor Sutton on 3/14/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface IARLDataStore : NSObject

@property (nonatomic, strong) NSMutableArray *radios;

- (id)initWithContentsOfFile:(NSString *)filePath;
- (NSArray *)radiosInRegion:(MKCoordinateRegion)region;

@end
