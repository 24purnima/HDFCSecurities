//
//  StocksListTableViewCell.h
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StocksListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *nameStr;
@property (weak, nonatomic) IBOutlet UILabel *shortNameStr;
@property (weak, nonatomic) IBOutlet UILabel *ltpStr;
@property (weak, nonatomic) IBOutlet UILabel *chgStr;
@property (weak, nonatomic) IBOutlet UILabel *chgPercentageStr;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@end
