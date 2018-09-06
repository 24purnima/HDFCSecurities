//
//  MyStocksViewController.h
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStocksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myStocksTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myStocksLoader;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;

@property (nonatomic, strong) NSMutableArray *allStocksArray;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)closeBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *recommendTableView;
@property (weak, nonatomic) IBOutlet UIView *recommendView;

@end
