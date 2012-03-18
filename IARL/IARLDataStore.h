//
//  IARLDataStore.h
//  IARL
//
//  Created by Igor Sutton on 3/14/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <MapKit/MapKit.h>

@class IARLDataStore;

@protocol IARLDataStoreDelegate <NSObject>

- (void)dataStoreDidFinishLoading:(IARLDataStore *)dataStore;

@end

@interface IARLDataStore : NSObject

@property (nonatomic, assign) id<IARLDataStoreDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *radios;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *backgroundManagedObjectContext;

- (id)initWithContentsOfFile:(NSString *)filePath;
- (NSArray *)radiosInRegion:(MKCoordinateRegion)region;
- (void)loadContentsOfFile:(NSString *)filePath;

@end
