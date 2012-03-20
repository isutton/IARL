//
//  IARLRadioDetailViewController.h
//  IARL
//
//  Created by Igor Sutton on 3/14/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IARLRadio;

@interface IARLRadioDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *callLabel;
@property (strong, nonatomic) IBOutlet UILabel *txLabel;
@property (strong, nonatomic) IBOutlet UILabel *shiftLabel;
@property (strong, nonatomic) IBOutlet UILabel *bandLabel;
@property (weak, nonatomic) IARLRadio *radio;

- (void)doneBarButtonTapped:(id)sender;

@end
