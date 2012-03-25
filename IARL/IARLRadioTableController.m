//
//  IARLViewController.m
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLRadioTableController.h"
#import "IARLRadio.h"
#import "IARLRadioDetailViewController.h"
#import "IARLFiltersViewController.h"
#import "IARLDataController.h"

@interface IARLRadioTableController ()

@end

@implementation IARLRadioTableController

@synthesize dataController = _dataController;

- (id)initWithDataController:(IARLDataController *)dataController
{
    if (!(self = [self initWithStyle:UITableViewStylePlain]))
        return nil;
    
    _dataController = dataController;
    [_dataController addObserver:self forKeyPath:IARLDataControllerRadiosKey options:NSKeyValueObservingOptionNew context:NULL];
    [_dataController addObserver:self forKeyPath:IARLDataControllerBandsFilterKey options:NSKeyValueObservingOptionNew context:NULL];
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _dataController && [keyPath isEqualToString:IARLDataControllerRadiosKey]) {
        [self.tableView reloadData];
    }
    else if (object == _dataController && [keyPath isEqualToString:IARLDataControllerBandsFilterKey]) {
        [self.tableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    self.navigationItem.title = @"Radios in Map";
    self.tableView.delegate = (id<UITableViewDelegate>)_dataController;
    self.tableView.dataSource = (id<UITableViewDataSource>)_dataController;
}

- (void)dealloc
{
    [_dataController removeObserver:self forKeyPath:IARLDataControllerRadiosKey];
    [_dataController removeObserver:self forKeyPath:IARLDataControllerBandsFilterKey];
}

@end
