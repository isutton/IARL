//
//  IARLFiltersViewController.h
//  IARL
//
//  Created by Igor Sutton on 3/14/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IARLFiltersViewController : UITableViewController

@property (nonatomic, strong) NSArray *bands;

- (IBAction)doneButtonTapped:(id)sender;

@end
