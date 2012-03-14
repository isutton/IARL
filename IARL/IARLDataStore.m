//
//  IARLDataStore.m
//  IARL
//
//  Created by Igor Sutton on 3/14/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "IARLDataStore.h"
#import "IARLRadio.h"

@implementation IARLDataStore

@synthesize radios = _radios;

- (id)initWithContentsOfFile:(NSString *)filePath
{
    if (!(self = [self init]))
        return nil;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath];

    NSError *error;
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        // ...
    }
    
    NSMutableArray *radios = [NSMutableArray arrayWithCapacity:[JSON count]];
    for (NSDictionary *radioDict in JSON) {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[radioDict valueForKeyPath:@"fields.latitude"] floatValue], 
                                                                     [[radioDict valueForKeyPath:@"fields.longitude"] floatValue]);
        IARLRadio *radio = [[IARLRadio alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [radioDict valueForKeyPath:@"fields.call"], @"call",
                                                                  [NSValue valueWithBytes:&location objCType:@encode(CLLocationCoordinate2D)], @"coordinate",
                                                                  [radioDict valueForKey:@"pk"], @"ID",
                                                                  [NSNumber numberWithInt:[[radioDict valueForKeyPath:@"fields.shift"] intValue]], @"shift",
                                                                  [NSNumber numberWithUnsignedInt:[[radioDict valueForKeyPath:@"fields.tx"] unsignedIntValue]], @"tx",
                                                                  nil]];
        [radios addObject:radio];
    }
    self.radios = radios;
    
    return self;
}

- (NSArray *)radiosInRegion:(MKCoordinateRegion)region
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        IARLRadio *radio = (IARLRadio *)evaluatedObject;
        
        if ((radio.coordinate.latitude < (region.center.latitude + (region.span.latitudeDelta / 2.0))) &&
            (radio.coordinate.latitude > (region.center.latitude - (region.span.latitudeDelta / 2.0))) &&
            (radio.coordinate.longitude < (region.center.longitude + (region.span.longitudeDelta / 2.0))) &&
            (radio.coordinate.longitude > (region.center.longitude - (region.span.longitudeDelta / 2.0))))
            return YES;
        
        return NO; 
    }];
    NSArray *radiosInRegion = [self.radios filteredArrayUsingPredicate:predicate];
    return radiosInRegion;
}

@end
