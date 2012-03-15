//
//  IARLFiltersViewController.m
//  IARL
//
//  Created by Igor Sutton on 3/14/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLFiltersViewController.h"

@interface IARLFiltersViewController ()

@end

@implementation IARLFiltersViewController

@synthesize bands = _bands;

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Bands", @"Devices", nil]];
    sc.segmentedControlStyle = UISegmentedControlStyleBar;
    sc.frame = CGRectInset(self.navigationController.navigationBar.bounds, 7.0, 7.0);
    self.navigationItem.titleView = sc;
    [sc addTarget:self action:@selector(filterTypeChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    _bands = [[NSArray alloc] initWithObjects:@"2m", @"1m", nil];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.bands count];
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Bands";
            break;
            
        default:
            break;
    }
    
    return @"Foo";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [self.bands objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - API

- (IBAction)doneButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filterTypeChanged:(id)sender
{
    
}

@end
