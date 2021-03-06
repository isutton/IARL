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
#import "NSNumber+IARL.h"
#import "IARLAnnotationView.h"

@implementation IARLDataController

@synthesize radios = _radios;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize bandFilter = _bandFilter;
@synthesize currentRegion = _currentRegion;

NSString * const IARLBandFilterKey = @"IARLBandFilterKey";
NSString * const IARLHFBandKey = @"HF";
NSString * const IARLVHFBandKey = @"VHF";
NSString * const IARLUHFBandKey = @"UHF";

NSString * const IARLHFCellImageName = @"tower_blue.png";
NSString * const IARLVHFCellImageName = @"tower_red.png";
NSString * const IARLUHFCellImageName = @"tower_orange.png";

NSString * const IARLHFAnnotationImageName = @"tower_blue.png";
NSString * const IARLVHFAnnotationImageName = @"tower_red.png";
NSString * const IARLUHFAnnotationImageName = @"tower_orange.png";

NSString * const IARLCellFont = @"HelveticaNeue-CondensedBold";

NSString * const IARLDataControllerRadiosKey = @"radios";
NSString * const IARLDataControllerBandsFilterKey = @"bandFilter";

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
    if (!(self = [self init]))
        return nil;
    
    _managedObjectContext = managedObjectContext;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    _bandFilter = ([userDefaults objectForKey:IARLBandFilterKey] == nil)
        ? [NSSet setWithObjects:IARLHFBandKey, IARLVHFBandKey, IARLUHFBandKey, nil] 
        : [NSSet setWithArray:[userDefaults objectForKey:IARLBandFilterKey]];
    
    return self;
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
        cell.backgroundView.backgroundColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont fontWithName:IARLCellFont size:18.0];
        cell.textLabel.textColor = [UIColor colorWithRed:0.435 green:0.612 blue:0.518 alpha:1];
        cell.detailTextLabel.font = [UIFont fontWithName:IARLCellFont size:14.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.682 green:0.761 blue:0.722 alpha:1];
    }
    
    IARLRadio *radio = [self.radios objectAtIndex:indexPath.row];
    
    cell.textLabel.text = radio.callName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"tx: %@, shift: %@", radio.tx, radio.shift];

    NSString *band = [radio.tx bandFromFrequency];
    
    if ([band isEqualToString:IARLHFBandKey])
        cell.imageView.image = [UIImage imageNamed:IARLHFCellImageName];
    else if ([band isEqualToString:IARLVHFBandKey])
        cell.imageView.image = [UIImage imageNamed:IARLVHFCellImageName];
    else if ([band isEqualToString:IARLUHFBandKey])
        cell.imageView.image = [UIImage imageNamed:IARLUHFCellImageName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // IARLRadio *radio = [self.radios objectAtIndex:indexPath.row];
    // [self.mapController selectAnnotation:radio animated:YES];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.currentRegion = mapView.region ;
    [self updateRadiosInCurrentRegion];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *AnnotationReuseIdentifier = @"AnnotationReuseIdentifier";
    IARLAnnotationView *annotationView = (IARLAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationReuseIdentifier];
    
    if (!annotationView) {
        annotationView = [[IARLAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationReuseIdentifier];
    }
    
    annotationView.annotation = annotation;
    
    if (annotation == mapView.userLocation) {
        annotationView.canShowCallout = NO;
    }
    else {
        annotationView.canShowCallout = NO;
        UIButton *callOutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [callOutButton addTarget:nil action:@selector(annotationDisclosureButtonTapped:) forControlEvents:UIControlEventAllTouchEvents];
        annotationView.rightCalloutAccessoryView = callOutButton;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    IARLAnnotationView *annotationView = (IARLAnnotationView *)view;
    CGRect calloutRect;
    calloutRect.size = CGSizeMake(1.0, 1.0);
    calloutRect.origin = [mapView convertCoordinate:view.annotation.coordinate toPointToView:mapView];

    IARLRadioDetailViewController *rdvc = [[IARLRadioDetailViewController alloc] init];
    rdvc.radio = (IARLRadio *)view.annotation;
    UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:rdvc];
    annotationView.popoverController = pc;
    pc.passthroughViews = [NSArray arrayWithObject:mapView];
    [pc presentPopoverFromRect:calloutRect inView:mapView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    IARLAnnotationView *annotationView = (IARLAnnotationView *)view;
    [annotationView.popoverController dismissPopoverAnimated:YES];
    annotationView.popoverController = nil;
}

#pragma mark - API

- (void)setBandFilter:(NSSet *)bandFilter
{
    [self willChangeValueForKey:IARLDataControllerBandsFilterKey];
    _bandFilter = [bandFilter copy];
    [self didChangeValueForKey:IARLDataControllerBandsFilterKey];

    [self updateRadiosInCurrentRegion];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[_bandFilter allObjects] forKey:IARLBandFilterKey];
    [userDefaults synchronize];
}

- (NSArray *)radiosInRegion:(MKCoordinateRegion)region
{
    
    double latitudeDelta = region.span.latitudeDelta / 2.0;
    double minLatitude = region.center.latitude - latitudeDelta;
    double maxLatitude = region.center.latitude + latitudeDelta;

    double longitudeDelta = region.span.longitudeDelta / 2.0;
    double minLongitude = region.center.longitude - longitudeDelta;
    double maxLongitude = region.center.longitude + longitudeDelta;
    
    [_bandFilter count];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"latitude BETWEEN {%@, %@} AND longitude BETWEEN {%@, %@} AND bandFrequency IN %@",
                              [NSNumber numberWithDouble:minLatitude], [NSNumber numberWithDouble:maxLatitude],
                              [NSNumber numberWithDouble:minLongitude], [NSNumber numberWithDouble:maxLongitude],
                              _bandFilter,
                              nil];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IARLRadio" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"IARLRadio"];
    fetchRequest.predicate = predicate;
    fetchRequest.entity = entity;
    
    NSError *error;
    NSArray *radiosInRegion = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (radiosInRegion == nil) {
        // error.
    }

    return radiosInRegion;
}

- (void)updateRadiosInCurrentRegion
{
    [self updateRadiosInRegion:_currentRegion];
}

- (void)updateRadiosInRegion:(MKCoordinateRegion)region
{
    self.radios = [self radiosInRegion:region];
}

@end
