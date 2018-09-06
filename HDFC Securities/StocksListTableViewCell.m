//
//  StocksListTableViewCell.m
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import "StocksListTableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation StocksListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.nameStr.textColor = [UIColor blackColor];
    self.shortNameStr.textColor = UIColorFromRGB(0x00619A);
    self.ltpStr.textColor = [UIColor blackColor];
    self.chgPercentageStr.textColor = [UIColor whiteColor];// UIColorFromRGB(0x44A462);
    self.chgStr.textColor = [UIColor blackColor]; //UIColorFromRGB(0xC93E4A);
    
    self.chgPercentageStr.layer.masksToBounds = true;
    self.chgPercentageStr.layer.cornerRadius = 5.0;
    self.chgPercentageStr.backgroundColor = [UIColor redColor];
    
    self.buyButton.backgroundColor = UIColorFromRGB(0x0e61fb);
    [self.buyButton setTintColor:[UIColor whiteColor]];
    [self.buyButton setTitle:@"BUY NOW" forState:UIControlStateNormal];
    self.buyButton.layer.masksToBounds = true;
    self.buyButton.layer.cornerRadius = 5.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
