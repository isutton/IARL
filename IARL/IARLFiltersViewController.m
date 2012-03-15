//
//  IARLFiltersViewController.m
//  IARL
//
//  Created by Igor Sutton on 3/14/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLFiltersViewController.h"
#import "IARLBandFilterViewController.h"

@interface IARLFiltersViewController ()

@end

@implementation IARLFiltersViewController

- (id)init
{
    if (!(self = [super init]))
        return nil;
    
    _bandFilterViewController = [[IARLBandFilterViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
    [_filterTypesControl setEnabled:YES forSegmentAtIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: Store this in NSUserDefaults.
    _visibleFilterTypeIndex = 0;

    _filterTypesControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Bands", @"Devices", nil]];
    _filterTypesControl.segmentedControlStyle = UISegmentedControlStyleBar;
    _filterTypesControl.frame = CGRectInset(self.navigationController.navigationBar.bounds, 7.0, 7.0);
    _filterTypesControl.selectedSegmentIndex = _visibleFilterTypeIndex;
    self.navigationItem.titleView = _filterTypesControl;
    [_filterTypesControl addTarget:self action:@selector(filterTypeChanged:) forControlEvents:UIControlEventValueChanged];

    
    [self displayViewAtIndex:_visibleFilterTypeIndex];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(320.0, 300.0);
}

#pragma mark - API

- (IBAction)filterTypeChanged:(id)sender
{
    [self displayViewAtIndex:_filterTypesControl.selectedSegmentIndex];
    
}

- (void)displayViewAtIndex:(NSInteger)idx
{
    switch (idx) {
        case 0:
            self.view = _bandFilterViewController.view;
            break;
            
        default:
            break;
    }
}

@end
