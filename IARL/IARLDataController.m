//
//  IARLDataController.m
//  IARL
//
//  Created by Igor Sutton on 3/15/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLDataController.h"
#import "IARLMapController.h"
#import "IARLRadioTableController.h"
#import "IARLRadioDetailViewController.h"
#import "IARLRadio.h"

@implementation IARLDataController

@synthesize dataStore = _dataStore;
@synthesize mapController = _mapController;
@synthesize radioTableController = _radioTableController;
@synthesize radios = _radios;

- (void)setRadioTableController:(IARLRadioTableController *)radioTableController
{
    _radioTableController = radioTableController;
    _radioTableController.tableView.delegate = self;
    _radioTableController.tableView.dataSource = self;
}

- (void)setMapController:(IARLMapController *)mapController
{
    _mapController = mapController;
    _mapController.delegate = self;
}

- (void)setDataStore:(IARLDataStore *)dataStore
{
    _dataStore = dataStore;
    _dataStore.delegate = self;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IARLRadio *radio = [self.radios objectAtIndex:indexPath.row];
    [self.mapController selectAnnotation:radio animated:YES];
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
    self.radios = [radiosInRegion allObjects];
    [self.radioTableController reloadData];
    
    NSMutableSet *annotationsInMap = [NSMutableSet setWithArray:mapView.annotations];
    [radiosInRegion minusSet:annotationsInMap];
    [mapView addAnnotations:[radiosInRegion allObjects]];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Foo"];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Foo"];
    }
    
    annotationView.annotation = annotation;
    annotationView.animatesDrop = NO;
    
    if (annotation == mapView.userLocation) {
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.canShowCallout = NO;
    }
    else {
        annotationView.canShowCallout = YES;
        UIButton *callOutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [callOutButton addTarget:self action:@selector(annotationDisclosureButtonTapped:) forControlEvents:UIControlEventAllTouchEvents];
        annotationView.rightCalloutAccessoryView = callOutButton;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    static BOOL didUpdateRegion;

    if (didUpdateRegion)
        return;
    
    MKCoordinateRegion region;
    region.center = userLocation.coordinate;
    region.span = MKCoordinateSpanMake(0.5, 0.5);
    [mapView setRegion:region animated:YES];
    
    didUpdateRegion = YES;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:@"Radios in Map"];
    NSMutableArray *leftBarButtonItems = [_mapController.navigationItem.leftBarButtonItems mutableCopy];
    [leftBarButtonItems insertObject:barButtonItem atIndex:0];
    _mapController.navigationItem.leftBarButtonItems = leftBarButtonItems;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *leftBarButtonItems = [_mapController.navigationItem.leftBarButtonItems mutableCopy];
    [leftBarButtonItems removeObject:barButtonItem];
    _mapController.navigationItem.leftBarButtonItems = leftBarButtonItems;
}

#pragma mark - IARLDataStoreDelegate

- (void)dataStoreDidFinishLoading:(IARLDataStore *)dataStore
{
    NSArray *radiosInRegion = [dataStore radiosInRegion:self.mapController.region];
    
    // Bail out if there's too many radios in region.
    if ([radiosInRegion count] > 50)
        return;
    
    [self.mapController performSelectorOnMainThread:@selector(addAnnotations:) withObject:radiosInRegion waitUntilDone:NO];
    self.radios = radiosInRegion;
    [self.radioTableController reloadData];
}

#pragma mark - API

- (void)annotationDisclosureButtonTapped:(id)sender
{
    IARLRadio *radio = [self.mapController.selectedAnnotations lastObject];
    IARLRadioDetailViewController *vc = [[IARLRadioDetailViewController alloc] initWithNibName:@"IARLRadioDetailViewController" bundle:nil];
    vc.radio = radio;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.mapController presentModalViewController:navigationController animated:YES];
}

@end
