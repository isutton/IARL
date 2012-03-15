//
//  IARLAppDelegate.h
//  IARL
//
//  Created by Igor Sutton on 3/13/12.
//  Copyright (c) 2012 igorsutton.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IARLDataController;
@class IARLDataStore;

@interface IARLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IARLDataController *dataController;

@end
