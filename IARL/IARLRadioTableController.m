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

@synthesize searchBar = _searchBar;

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    self.tableView.delegate = delegate;
}

- (id<UITableViewDelegate>)delegate
{
    return self.tableView.delegate;
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    self.tableView.dataSource = dataSource;
}

- (id<UITableViewDataSource>)dataSource
{
    return self.tableView.dataSource;
}

- (void)setSearchBarDelegate:(id<UISearchBarDelegate>)searchBarDelegate
{
    _searchBar.delegate = searchBarDelegate;
}

- (id<UISearchBarDelegate>)searchBarDelegate
{
    return _searchBar.delegate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    self.navigationItem.title = @"Radios in Map";
    _searchBar = [[UISearchBar alloc] init];
    self.tableView.tableHeaderView = _searchBar;
    [_searchBar sizeToFit];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

@end
