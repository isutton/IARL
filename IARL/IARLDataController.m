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

@implementation IARLDataController

@synthesize radios = _radios;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize bandFilter = _bandFilter;

static NSString *IARLBandFilterKey = @"IARLBandFilterKey";
static NSString *IARLHFBandKey = @"HF";
static NSString *IARLVHFBandKey = @"VHF";
static NSString *IARLUHFBandKey = @"UHF";

static NSString *IARLHFCellImageName = @"tower_blue.png";
static NSString *IARLVHFCellImageName = @"tower_red.png";
static NSString *IARLUHFCellImageName = @"tower_orange.png";

static NSString *IARLHFAnnotationImageName = @"tower_blue.png";
static NSString *IARLVHFAnnotationImageName = @"tower_red.png";
static NSString *IARLUHFAnnotationImageName = @"tower_orange.png";

static NSString *IARLCellFont = @"HelveticaNeue-CondensedBold";

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
    MKCoordinateSpan span = mapView.region.span;
    
    if (span.latitudeDelta > 0.5 || span.longitudeDelta > 0.5) {
        MKCoordinateRegion region = mapView.region;
        region.span = MKCoordinateSpanMake(0.5, 0.5);
        region.center = mapView.centerCoordinate;
        [mapView setRegion:region animated:YES];
    }
    
    NSMutableSet *radiosInRegion = [NSMutableSet setWithArray:[self radiosInRegion:mapView.region]];
    NSMutableSet *radiosToRemoveInRegion = [NSMutableSet setWithArray:mapView.annotations];
    [radiosToRemoveInRegion minusSet:radiosInRegion];
    self.radios = [radiosInRegion allObjects];
    [mapView removeAnnotations:[radiosToRemoveInRegion allObjects]];
    [mapView addAnnotations:[radiosInRegion allObjects]];    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *AnnotationReuseIdentifier = @"AnnotationReuseIdentifier";
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationReuseIdentifier];
    
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationReuseIdentifier];
    }
    
    annotationView.annotation = annotation;
    
    if (annotation == mapView.userLocation) {
        annotationView.canShowCallout = NO;
    }
    else {
        NSString *band = [((IARLRadio *)annotation).tx bandFromFrequency];
        
        if ([band isEqualToString:IARLHFBandKey])
            annotationView.image = [UIImage imageNamed:IARLHFAnnotationImageName];
        else if ([band isEqualToString:IARLVHFBandKey])
            annotationView.image = [UIImage imageNamed:IARLVHFAnnotationImageName];
        else if ([band isEqualToString:IARLUHFBandKey])
            annotationView.image = [UIImage imageNamed:IARLUHFAnnotationImageName];

        annotationView.canShowCallout = YES;
        UIButton *callOutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [callOutButton addTarget:nil action:@selector(annotationDisclosureButtonTapped:) forControlEvents:UIControlEventAllTouchEvents];
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

#pragma mark - API

- (void)setBandFilter:(NSSet *)bandFilter
{
    _bandFilter = [bandFilter copy];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[_bandFilter allObjects] forKey:IARLBandFilterKey];
    [userDefaults synchronize];
    //[self mapView:self.mapController.mapView regionDidChangeAnimated:YES];
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

@end
