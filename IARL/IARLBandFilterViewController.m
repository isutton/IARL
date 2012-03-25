//
//  IARLBandFilterViewController.m
//  IARL
//
//  Created by Igor Sutton on 3/15/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLBandFilterViewController.h"
#import "IARLDataController.h"

@interface IARLBandFilterViewController ()

@end

@implementation IARLBandFilterViewController

@synthesize dataController = _dataController;

- (NSString *)name
{
    return @"Bands";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
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
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"HF";
            cell.accessoryType = [self.dataController.bandFilter containsObject:@"HF"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            cell.imageView.image = [UIImage imageNamed:@"tower_blue.png"];
            break;
            
        case 1:
            cell.textLabel.text = @"VHF";
            cell.accessoryType = [self.dataController.bandFilter containsObject:@"VHF"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            cell.imageView.image = [UIImage imageNamed:@"tower_red.png"];
            break;
            
        case 2:
            cell.textLabel.text = @"UHF";
            cell.accessoryType = [self.dataController.bandFilter containsObject:@"UHF"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            cell.imageView.image = [UIImage imageNamed:@"tower_orange.png"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *band = cell.textLabel.text;
    NSMutableSet *bandFilter = [self.dataController.bandFilter mutableCopy];
    if ([bandFilter containsObject:band]) {
        [bandFilter removeObject:band];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        [bandFilter addObject:band];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    self.dataController.bandFilter = bandFilter;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
