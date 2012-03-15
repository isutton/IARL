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

@interface IARLMapController ()

@end

@implementation IARLMapController

@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;

    _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _mapView.frame = self.view.bounds;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 22.0)];
    searchBar.delegate = self;
    searchBar.placeholder = @"Go to Grid Square Locator";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleBordered target:self action:@selector(filtersButtonTapped:)];

    self.view.autoresizesSubviews = YES;
    [self.view addSubview:_mapView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
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

- (IBAction)filtersButtonTapped:(id)sender
{
    if (_filtersPopoverController)
        return;
    
    IARLFiltersViewController *vc = [[IARLFiltersViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    _filtersPopoverController = [[UIPopoverController alloc] initWithContentViewController:nc];
    _filtersPopoverController.delegate = self;
    [_filtersPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end
