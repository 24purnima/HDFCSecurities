//
//  TableRowController.h
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 01/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import <WatchKit/WatchKit.h>

@interface TableRowController : NSObject
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *ratesLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *valueLabel;

@end
