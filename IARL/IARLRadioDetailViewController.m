//
//  IARLRadioDetailViewController.m
//  IARL
//
//  Created by Igor Sutton on 3/14/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import "IARLRadioDetailViewController.h"
#import "IARLRadio.h"

@interface IARLRadioDetailViewController ()

@end

@implementation IARLRadioDetailViewController

@synthesize callLabel;
@synthesize txLabel;
@synthesize shiftLabel;
@synthesize bandLabel;
@synthesize radio = _radio;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarButtonTapped:)];
    self.navigationItem.rightBarButtonItem = closeButtonItem;

    self.callLabel.text = _radio.callName;
    self.txLabel.text = [NSString stringWithFormat:@"%@", _radio.tx];
    self.shiftLabel.text = [NSString stringWithFormat:@"%@", _radio.shift];
    self.bandLabel.text = [NSString stringWithFormat:@"%@", _radio.band];
}

- (void)viewDidUnload
{
    [self setCallLabel:nil];
    [self setTxLabel:nil];
    [self setShiftLabel:nil];
    [self setBandLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - API

- (void)doneBarButtonTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
