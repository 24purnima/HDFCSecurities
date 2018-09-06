//
//  InterfaceController.m
//  Kotak Wealth Watch App WatchKit Extension
//
//  Created by Rajeev Ranjan on 01/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

/*
 WatchKit 2 app extension's NSExtension.NSExtensionAttributes.WKAppBundleIdentifier value does not match WatchKit app's bundle ID (found "com.shephertz.app42pushapp.Kotak-Wealth-Watch-App.watchkitapp"; expected "com.shephertz.app42pushapp.KotakWealthApp").
 */

#import "InterfaceController.h"
#import "TableRowController.h"
//#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>


#define portfolioTitle  @"Title"
#define minValue @"MinValue"
#define totalValue @"TotalValue"

@interface InterfaceController ()
{
    NSMutableArray *arrayOfDictionaries;
}
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    NSLog(@"awakeWithContext");
    // Define keys
    
    
    // A dictionary object
    NSDictionary *dict;
    
    // Create array to hold dictionaries
    arrayOfDictionaries = [NSMutableArray array];
    
    // Create three dictionaries
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            // Object and key pairs
            @"Net Worth", portfolioTitle,
            @"", minValue,
            @"5,11,429.75", totalValue,
            nil];
    [arrayOfDictionaries addObject:dict];
    
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            // Object and key pairs
            @"Days Chg", portfolioTitle,
            @"-2.86%", minValue,
            @"-15,042.55", totalValue,
            nil];
    [arrayOfDictionaries addObject:dict];
    
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Overall Chg", portfolioTitle,
            @"38.2%", minValue,
            @"1,41,361.43", totalValue,
            nil];
    [arrayOfDictionaries addObject:dict];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            // Object and key pairs
            @"Net Worth", portfolioTitle,
            @"", minValue,
            @"5,11,429.75", totalValue,
            nil];
    [arrayOfDictionaries addObject:dict];
    
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            // Object and key pairs
            @"Days Chg", portfolioTitle,
            @"-2.86%", minValue,
            @"-15,042.55", totalValue,
            nil];
    [arrayOfDictionaries addObject:dict];
    
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"Overall Chg", portfolioTitle,
            @"38.2%", minValue,
            @"1,41,361.43", totalValue,
            nil];
    [arrayOfDictionaries addObject:dict];
    
    NSLog(@"array of dictionaries: %@", arrayOfDictionaries);

    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self tableRefresh];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)tableRefresh {
    [self.portfolioTable setNumberOfRows:arrayOfDictionaries.count withRowType:@"row"];
    
    for (int i = 0; i < self.portfolioTable.numberOfRows; i++) {
        
        TableRowController *row = [self.portfolioTable rowControllerAtIndex:i];
        NSString *titleString = arrayOfDictionaries[i][portfolioTitle];
        NSString *minValueStr = arrayOfDictionaries[i][minValue];
        NSString *totalValueStr = arrayOfDictionaries[i][totalValue];
        
        [[row titleLabel]setText:titleString];
        [[row ratesLabel] setText:minValueStr];
        [[row valueLabel] setText:totalValueStr];
        
        [[row titleLabel] setTextColor:[UIColor grayColor]];
        
        if (i == 0) {
            [[row ratesLabel] setTextColor:[UIColor whiteColor]];
            [[row valueLabel] setTextColor:[UIColor whiteColor]];
        }
        else if (i%2 == 0) {
            [[row ratesLabel] setTextColor:[UIColor greenColor]];
            [[row valueLabel] setTextColor:[UIColor greenColor]];
        }
        else {
            [[row ratesLabel] setTextColor:[UIColor redColor]];
            [[row valueLabel] setTextColor:[UIColor redColor]];
        }
        
        
    }
    
    [self.portfolioTable scrollToRowAtIndex:self.portfolioTable.numberOfRows - 1];
}

@end



