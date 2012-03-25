//
//  main.m
//  Database Loader
//
//  Created by Igor Sutton on 3/18/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "IARLRadio.h"
#import "NSNumber+IARL.h"

static NSManagedObjectModel *managedObjectModel()
{
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }
    
    NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
    path = [path stringByDeletingLastPathComponent];
    path = [path stringByAppendingPathComponent:@"IARL"];
    NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

static NSManagedObjectContext *managedObjectContext()
{
    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }

    @autoreleasepool {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
        path = [path stringByDeletingLastPathComponent];
        path = [path stringByAppendingPathComponent:@"IARL"];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        if ([fm fileExistsAtPath:path]) {
            NSError *error;
            if (![fm removeItemAtPath:path error:&error]) {
                NSLog(@"Could not remove item '%@': %@", path, [error localizedDescription]);
            }
        }
        
        NSError *error;
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        // Create the managed object context
        NSManagedObjectContext *context = managedObjectContext();
        
        NSData *JSONData = [NSData dataWithContentsOfFile:@"radios.js"];
        
        NSError *error;
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:&error];
        
        if (error) {
            // ...
        }
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"IARLRadio" inManagedObjectContext:context];
        
        for (NSDictionary *radioDict in JSON) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[radioDict valueForKeyPath:@"fields.latitude"] floatValue], 
                                                                         [[radioDict valueForKeyPath:@"fields.longitude"] floatValue]);
            
            IARLRadio *radio = [[IARLRadio alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            radio.band = [radioDict valueForKeyPath:@"fields.band"];
            radio.radioID = [radioDict valueForKey:@"pk"];
            radio.callName = [radioDict valueForKeyPath:@"fields.call"];
            radio.longitude = location.longitude;
            radio.latitude = location.latitude;
            radio.shift = [NSNumber numberWithInt:[[radioDict valueForKeyPath:@"fields.shift"] intValue]];
            radio.tx = [NSNumber numberWithUnsignedInt:[[radioDict valueForKeyPath:@"fields.tx"] unsignedIntValue]];
            radio.bandFrequency = [radio.tx bandFromFrequency];
        }

        error = nil;
        if (![context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
    }
    return 0;
}

