//
//  IARLMapController.m
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLMapController.h"

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
    searchBar.placeholder = @"Go to Grid Square Locator";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    
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

@end
