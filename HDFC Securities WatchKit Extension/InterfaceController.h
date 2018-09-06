//
//  InterfaceController.h
//  Kotak Wealth Watch App WatchKit Extension
//
//  Created by Rajeev Ranjan on 01/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *portfolioTable;

@end
