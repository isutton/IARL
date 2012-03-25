//
//  IARLMapController.m
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLMapController.h"
#import "IARLFiltersViewController.h"
#import "NSString+IARL.h"
#import "IARLDataController.h"

@interface IARLMapController ()

@end

@implementation IARLMapController

@dynamic delegate;
@synthesize mapView = _mapView;
@synthesize dataController = _dataController;

- (id)init
{
    if (!(self = [super init]))
        return nil;

    _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _mapView.frame = self.view.bounds;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _mapView.showsUserLocation = YES;

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 22.0)];
    searchBar.delegate = self;
    searchBar.placeholder = @"Go to Grid Square Locator";
    
    UITextField *searchBarTextField = [searchBar.subviews objectAtIndex:1];
    [searchBarTextField setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16.0]];
    [searchBarTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:[[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleBordered target:self action:@selector(filtersButtonTapped:)]];

    self.view.autoresizesSubviews = YES;
    [self.view addSubview:_mapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    MKCoordinateRegion region;
    region.center = _mapView.userLocation.coordinate;
    region.span = MKCoordinateSpanMake(0.5, 0.5);
    [_mapView setRegion:region animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    CLLocationCoordinate2D coordinate = [searchBar.text coordinateFromGridSquareLocator];
    [_mapView setCenterCoordinate:coordinate animated:YES];
    [searchBar resignFirstResponder];
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == _filtersPopoverController) {
        _filtersPopoverController = nil;
    }
}

#pragma mark - API

- (void)setDelegate:(id<MKMapViewDelegate>)delegate
{
    self.mapView.delegate = delegate;
}

- (id<MKMapViewDelegate>)delegate
{
    return self.mapView.delegate;
}

- (void)selectAnnotation:(id<MKAnnotation>)annotation animated:(BOOL)animated
{
    [self.mapView selectAnnotation:annotation animated:animated];
}

- (MKCoordinateRegion)region
{
    return [self.mapView region];
}

- (NSArray *)selectedAnnotations
{
    return self.mapView.selectedAnnotations;
}

- (void)addAnnotations:(NSArray *)annotations
{
    [self.mapView addAnnotations:annotations];
}

- (IBAction)filtersButtonTapped:(id)sender
{
    if (_filtersPopoverController)
        return;
    
    IARLFiltersViewController *vc = [[IARLFiltersViewController alloc] init];
    vc.dataController = self.dataController;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    _filtersPopoverController = [[UIPopoverController alloc] initWithContentViewController:nc];
    _filtersPopoverController.delegate = self;
    [_filtersPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end
