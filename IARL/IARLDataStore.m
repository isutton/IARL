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

@synthesize delegate = _delegate;
@synthesize radios = _radios;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize backgroundManagedObjectContext = _backgroundManagedObjectContext;

- (id)initWithContentsOfFile:(NSString *)filePath
{
    if (!(self = [self init]))
        return nil;
    
    [self performSelectorInBackground:@selector(loadContentsOfFile:) withObject:filePath];
    
    return self;
}

- (void)loadContentsOfFile:(NSString *)filePath
{
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error;
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        // ...
    }
    
    self.backgroundManagedObjectContext = [[NSManagedObjectContext alloc] init];
    self.backgroundManagedObjectContext.persistentStoreCoordinator = self.managedObjectContext.persistentStoreCoordinator;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IARLRadio" inManagedObjectContext:_backgroundManagedObjectContext];
    
    NSMutableArray *radios = [NSMutableArray arrayWithCapacity:[JSON count]];
    
    for (NSDictionary *radioDict in JSON) {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[radioDict valueForKeyPath:@"fields.latitude"] floatValue], 
                                                                     [[radioDict valueForKeyPath:@"fields.longitude"] floatValue]);

        IARLRadio *radio = [[IARLRadio alloc] initWithEntity:entity insertIntoManagedObjectContext:_backgroundManagedObjectContext];
        radio.radioID = [radioDict valueForKey:@"pk"];
        radio.callName = [radioDict valueForKeyPath:@"fields.call"];
        radio.longitude = location.longitude;
        radio.latitude = location.latitude;
        radio.shift = [NSNumber numberWithInt:[[radioDict valueForKeyPath:@"fields.shift"] intValue]];
        radio.tx = [NSNumber numberWithUnsignedInt:[[radioDict valueForKeyPath:@"fields.tx"] unsignedIntValue]];
    }
    
    if (![self.backgroundManagedObjectContext save:&error]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Task finished" message:@"Radios should've been imported." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alertView show];
    }
    
    self.radios = radios;
    
    [_delegate dataStoreDidFinishLoading:self];
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
