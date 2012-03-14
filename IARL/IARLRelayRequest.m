//
//  IARLRelayRequest.m
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLRelayRequest.h"
#import "IARLRelayResponse.h"
#import "IARLRadio.h"

@implementation IARLRelayRequest

@synthesize delegate = _delegate;
@synthesize bands = _bands;
@synthesize location = _location;
@synthesize northEastLocation = _northEastLocation;
@synthesize southWestLocation = _southWestLocation;

- (id)initWithLocation:(CLLocationCoordinate2D)location northEastLocation:(CLLocationCoordinate2D)northEastLocation southWestLocation:(CLLocationCoordinate2D)southWestLocation bands:(NSSet *)bands
{
    if (!(self = [super init]))
        return nil;
    
    self.bands = bands;
    self.location = location;
    self.northEastLocation = northEastLocation;
    self.southWestLocation = southWestLocation;

    _receivedData = [[NSMutableData alloc] init];
    
    return self;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate relayRequest:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    NSArray *receivedData = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *radios = [NSMutableArray arrayWithCapacity:[receivedData count]];
    for (NSDictionary *radioDict in receivedData) {

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
    
    IARLRelayResponse *response = [[IARLRelayResponse alloc] initWithRadios:radios];
    [self.delegate relayRequest:self didReceiveResponse:response];
}

#pragma mark - API

- (void)start
{
    NSMutableString *URLString = [NSMutableString stringWithString:@"http://iarl.org/api/radio/relay/area/?"];
    [URLString appendFormat:@"ne=%f%%2C%f&", self.northEastLocation.latitude, self.northEastLocation.longitude];
    [URLString appendFormat:@"sw=%f%%2C%f&", self.southWestLocation.latitude, self.southWestLocation.longitude];
    [URLString appendFormat:@"lat=%f&lon=%f&", self.location.latitude, self.location.longitude];
    [URLString appendFormat:@"bands=%@&", [[self.bands allObjects] componentsJoinedByString:@","]];
    [URLString appendFormat:@"region=1"];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)cancel
{
    [_connection cancel];
}

@end
