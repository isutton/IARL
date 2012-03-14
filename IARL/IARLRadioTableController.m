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
#import "IARLDataStore.h"

@interface IARLRadioTableController ()

@end

@implementation IARLRadioTableController

@synthesize dataStore = _dataStore;
@synthesize mapView = _mapView;
@synthesize radios = _radios;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidLoad
{
    _mapView.showsUserLocation = YES;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    IARLRadio *radio = [self.radios objectAtIndex:indexPath.row];
    cell.textLabel.text = radio.call;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"tx: %@, shift: %@", radio.tx, radio.shift];
    
    return cell;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKCoordinateSpan span = mapView.region.span;
    
    if (span.latitudeDelta < 0.5 || span.longitudeDelta < 0.5) {
        MKCoordinateRegion region = mapView.region;
        region.span = MKCoordinateSpanMake(0.5, 0.5);
        region.center = mapView.centerCoordinate;
        [mapView setRegion:region animated:YES];
    }

    NSMutableSet *radiosInRegion = [NSMutableSet setWithArray:[_dataStore radiosInRegion:mapView.region]];
    NSMutableSet *annotationsInMap = [NSMutableSet setWithArray:mapView.annotations];
    [radiosInRegion minusSet:annotationsInMap];
    [mapView addAnnotations:[radiosInRegion allObjects]];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, span);
    mapView.region = region;
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

@end
