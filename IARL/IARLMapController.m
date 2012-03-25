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
#import "IARLRadio.h"
#import "IARLRadioDetailViewController.h"

@interface IARLMapController ()

@end

@implementation IARLMapController

@synthesize mapView = _mapView;
@synthesize dataController = _dataController;

- (id)initWithDataController:(IARLDataController *)dataController
{
    if (!(self = [self init]))
        return nil;

    _dataController = dataController;
    [_dataController addObserver:self forKeyPath:IARLDataControllerBandsFilterKey options:NSKeyValueObservingOptionNew context:NULL];
    _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];

    return self;
}

- (void)dealloc
{
    [_dataController removeObserver:self forKeyPath:IARLDataControllerBandsFilterKey];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (_dataController == object && [keyPath isEqualToString:IARLDataControllerBandsFilterKey]) {
        [_mapView.delegate mapView:_mapView regionDidChangeAnimated:NO];
    }
}

- (void)loadView
{
    UIView *view = [[UIView alloc] init];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    view.autoresizesSubviews = YES;
    
    _mapView = [[MKMapView alloc] init];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [view addSubview:_mapView];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 22.0)];
    searchBar.delegate = self;
    searchBar.placeholder = @"Go to Grid Square Locator";
    
    UITextField *searchBarTextField = [searchBar.subviews objectAtIndex:1];
    [searchBarTextField setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16.0]];
    [searchBarTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:[[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleBordered target:self action:@selector(filtersButtonTapped:)]];
    
    self.navigationController.toolbarHidden = NO;
    
    self.toolbarItems = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                         [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"22-location-arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(locationButtonTapped:)], 
                         nil];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView.delegate = _dataController;
    _mapView.showsUserLocation = YES;
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
    [self moveToLocator:searchBar.text];
    [searchBar resignFirstResponder];
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == _filtersPopoverController) {
        _filtersPopoverController = nil;
    }
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:@"Radios in Map"];
    NSMutableArray *leftBarButtonItems = [self.navigationItem.leftBarButtonItems mutableCopy];
    [leftBarButtonItems insertObject:barButtonItem atIndex:0];
    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *leftBarButtonItems = [self.navigationItem.leftBarButtonItems mutableCopy];
    [leftBarButtonItems removeObject:barButtonItem];
    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
}

#pragma mark - API

- (void)moveToLocator:(NSString *)locator
{
    [_mapView setCenterCoordinate:[locator coordinateFromGridSquareLocator] animated:YES];
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

- (IBAction)locationButtonTapped:(id)sender
{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (void)annotationDisclosureButtonTapped:(id)sender
{
     IARLRadio *radio = [_mapView.selectedAnnotations lastObject];
     IARLRadioDetailViewController *vc = [[IARLRadioDetailViewController alloc] initWithNibName:@"IARLRadioDetailViewController" bundle:nil];
     vc.radio = radio;
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
     navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
     [self presentModalViewController:navigationController animated:YES];
}

@end
