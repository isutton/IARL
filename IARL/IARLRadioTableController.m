//
//  IARLViewController.m
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLRadioTableController.h"
#import "IARLRadio.h"
#import "IARLRelayRequest.h"
#import "IARLRelayResponse.h"

@interface IARLRadioTableController ()

@end

@implementation IARLRadioTableController

@synthesize mapView = _mapView;
@synthesize radios = _radios;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(52.4373333333, 4.79166666667);
    CLLocationCoordinate2D southWestLocation = CLLocationCoordinate2DMake(51.745472353475, 8.0930582682325);
    CLLocationCoordinate2D northEastLocation = CLLocationCoordinate2DMake(53.118499326185, 1.4902750651075);
    NSSet *bands = [NSSet setWithObject:@"2m"];
    
    IARLRelayRequest *request = [[IARLRelayRequest alloc] initWithLocation:location northEastLocation:northEastLocation southWestLocation:southWestLocation bands:bands];
    request.delegate = self;
    [request start];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.radios count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    IARLRadio *radio = [self.radios objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", radio.call];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IARLRadio *radio = [self.radios objectAtIndex:indexPath.row];
    
    MKCoordinateRegion region;
    region.center = radio.coordinate;
    region.span.latitudeDelta = 1;
    region.span.longitudeDelta = 1;
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    [self.mapView selectAnnotation:radio animated:YES];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKCoordinateRegion region = mapView.region;
    MKCoordinateSpan span = region.span;
    
    CLLocationCoordinate2D location = region.center;
    CLLocationCoordinate2D southWestLocation = CLLocationCoordinate2DMake(location.latitude - span.latitudeDelta, location.longitude - span.longitudeDelta);
    CLLocationCoordinate2D northEastLocation = CLLocationCoordinate2DMake(location.latitude + span.latitudeDelta, location.longitude + span.longitudeDelta);
    NSSet *bands = [NSSet setWithObject:@"2m"];
    
    IARLRelayRequest *request = [[IARLRelayRequest alloc] initWithLocation:location northEastLocation:northEastLocation southWestLocation:southWestLocation bands:bands];
    request.delegate = self;
    [request start];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Foo"];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Foo"];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    return annotationView;
}

#pragma mark - IARLRelayRequestDelegate

- (void)relayRequest:(IARLRelayRequest *)request didReceiveResponse:(IARLRelayResponse *)response
{
    [self.mapView removeAnnotations:self.radios];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"ID" ascending:YES];
    self.radios = [response.radios sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self.mapView addAnnotations:self.radios];
    [self.tableView reloadData];
}

- (void)relayRequest:(IARLRelayRequest *)request didFailWithError:(NSError *)error
{

}

@end
