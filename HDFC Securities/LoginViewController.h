//
//  LoginViewController.h
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailtextField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong , nonatomic) NSString *deviceToken;
- (IBAction)continueButtonClick:(id)sender;
-(void)setDeviceTokenString:(NSString *)devToken;
@end
