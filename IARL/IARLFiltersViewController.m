//
//  IARLFiltersViewController.m
//  IARL
//
//  Created by Igor Sutton on 3/14/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLFiltersViewController.h"
#import "IARLBandFilterViewController.h"
#import "IARLDeviceFilterViewController.h"

@interface IARLFiltersViewController ()

@end

@implementation IARLFiltersViewController

@synthesize dataController = _dataController;

- (id)init
{
    if (!(self = [super init]))
        return nil;
    
    _filters = [NSArray arrayWithObjects:
                [[IARLBandFilterViewController alloc] initWithStyle:UITableViewStyleGrouped],
                // [[IARLDeviceFilterViewController alloc] initWithStyle:UITableViewStyleGrouped],
                nil];
    
    return self;
}

- (void)setDataController:(IARLDataController *)dataController
{
    _dataController = dataController;
    [_filters makeObjectsPerformSelector:@selector(setDataController:) withObject:_dataController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
    [_filterTypesControl setEnabled:YES forSegmentAtIndex:_visibleFilterTypeIndex];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _visibleFilterTypeIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"IARLVisibleFilterTypeIndex"];
    
    NSMutableArray *filterNames = [NSMutableArray arrayWithCapacity:[_filters count]];
    
    for (id<IARLFilterConfigurable> filter in _filters) {
        [filterNames addObject:[filter name]];
    }
    
    _filterTypesControl = [[UISegmentedControl alloc] initWithItems:filterNames];
    _filterTypesControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    _filterTypesControl.frame = CGRectInset(self.navigationController.navigationBar.bounds, 9.0, 9.0);
    _filterTypesControl.selectedSegmentIndex = _visibleFilterTypeIndex;
    self.navigationItem.titleView = _filterTypesControl;
    [_filterTypesControl addTarget:self action:@selector(filterTypeChanged:) forControlEvents:UIControlEventValueChanged];

    if ([_filters count] == 1) {
        self.navigationController.navigationBarHidden = YES;
    }
    
    [self displayViewControllerAtIndex:_visibleFilterTypeIndex];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_filters makeObjectsPerformSelector:@selector(setDelegate:) withObject:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(320.0, 180.0);
}

#pragma mark - API

- (IBAction)filterTypeChanged:(id)sender
{
    [self displayViewControllerAtIndex:_filterTypesControl.selectedSegmentIndex];
}

- (void)displayViewControllerAtIndex:(NSInteger)idx
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:idx] forKey:@"IARLVisibleFilterTypeIndex"];
    self.view = [[_filters objectAtIndex:idx] view];    

}

@end
