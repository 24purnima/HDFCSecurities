//
//  StocksListViewController.h
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StocksListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *stocksTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *listLoader;
- (IBAction)logoutBtnClick:(id)sender;
@end
