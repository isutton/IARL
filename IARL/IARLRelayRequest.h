//
//  IARLRelayRequest.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@class IARLRelayRequest;
@class IARLRelayResponse;

@protocol IARLRelayRequestDelegate <NSObject>

- (void)relayRequest:(IARLRelayRequest *)request didReceiveResponse:(IARLRelayResponse *)response;
- (void)relayRequest:(IARLRelayRequest *)request didFailWithError:(NSError *)error;

@end

@interface IARLRelayRequest : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
}

@property (nonatomic, assign) id<IARLRelayRequestDelegate> delegate;
@property (nonatomic, strong) NSSet *bands;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, assign) CLLocationCoordinate2D northEastLocation;
@property (nonatomic, assign) CLLocationCoordinate2D southWestLocation;

- (id)initWithLocation:(CLLocationCoordinate2D)location northEastLocation:(CLLocationCoordinate2D)northEastLocation southWestLocation:(CLLocationCoordinate2D)southWestLocation bands:(NSSet *)bands;

- (void)start;
- (void)cancel;

@end
