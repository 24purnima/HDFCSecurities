//
//  StockDetailViewController.h
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockDetailViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *stockArray;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *detailLoader;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *nseLabel;
@property (weak, nonatomic) IBOutlet UILabel *bseLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIButton *wishlistButton;

- (IBAction)wishlistButtonClick:(id)sender;
@end
