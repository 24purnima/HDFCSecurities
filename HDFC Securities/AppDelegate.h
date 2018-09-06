//
//  AppDelegate.h
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 01/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

//@class StocksListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) LoginViewController *loginVC;

@end

