//
//  IARLViewController.m
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLRadioTableController.h"
#import "IARLRadio.h"
#import "IARLDataStore.h"
#import "IARLRadioDetailViewController.h"
#import "IARLFiltersViewController.h"

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

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    _mapView.showsUserLocation = YES;
    _mapView.centerCoordinate = _mapView.userLocation.coordinate;
    
    self.navigationItem.title = @"Radios in Map";
    self.toolbarItems = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                         [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleBordered target:self action:@selector(filtersButtonTapped:)], 
                         nil];
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
    [_mapView selectAnnotation:radio animated:YES];
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
    [self.tableView reloadData];

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
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Foo"];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Foo"];
    }

    annotationView.annotation = annotation;
    
    if (annotation == mapView.userLocation) {
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.animatesDrop = NO;
        annotationView.canShowCallout = NO;
    }
    else {
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
        UIButton *callOutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [callOutButton addTarget:self action:@selector(annotationDisclosureButtonTapped:) forControlEvents:UIControlEventAllTouchEvents];
        annotationView.rightCalloutAccessoryView = callOutButton;
    }

    return annotationView;
}

#pragma mark - IARLDataStoreDelegate

- (void)dataStoreDidFinishLoading:(IARLDataStore *)dataStore
{
    NSArray *radiosInRegion = [dataStore radiosInRegion:_mapView.region];
    [_mapView performSelectorOnMainThread:@selector(addAnnotations:) withObject:radiosInRegion waitUntilDone:NO];
    self.radios = radiosInRegion;
    [self.tableView reloadData];
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == _filtersPopoverController) {
        _filtersPopoverController = nil;
    }
}

#pragma mark - API

- (void)annotationDisclosureButtonTapped:(id)sender
{
    IARLRadio *radio = [_mapView.selectedAnnotations lastObject];
    IARLRadioDetailViewController *vc = [[IARLRadioDetailViewController alloc] initWithNibName:@"IARLRadioDetailViewController" bundle:nil];
    vc.radio = radio;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navigationController animated:YES];
}

- (IBAction)filtersButtonTapped:(id)sender
{
    if (_filtersPopoverController)
        return;

    IARLFiltersViewController *vc = [[IARLFiltersViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    _filtersPopoverController = [[UIPopoverController alloc] initWithContentViewController:nc];
    _filtersPopoverController.delegate = self;
    [_filtersPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end
