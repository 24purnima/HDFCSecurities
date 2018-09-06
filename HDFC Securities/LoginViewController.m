//
//  LoginViewController.m
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import "LoginViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "StocksListViewController.h"
#import "AppDelegate.h"
#import <App42_iOS_CampaignAPI/App42_iOS_CampaignAPI.h>
#import <Shephertz_App42_iOS_API/App42IAMService.h>

#import "InAppListener.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LoginViewController () <UITextFieldDelegate>

@property(nonatomic) InAppListener *inAppListener;

@end

@implementation LoginViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [App42CampaignAPI setConfigCacheTime:0];
    self.inAppListener = [[InAppListener alloc] initWithViewController:self];
   // [App42CampaignAPI setListener:self.inAppListener];
    [App42CampaignAPI initWithListener:self.inAppListener];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsRegister"] == true) {
        self.emailtextField.hidden = YES;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"] == true) {
            StocksListViewController *stocksVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StocksListViewController"];
            [self.navigationController pushViewController:stocksVC animated:NO];
        }
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    AppDelegate *appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDele.loginVC = self;
    
    self.view.backgroundColor = UIColorFromRGB(0xECEBF3);
    self.continueButton.backgroundColor = [UIColor whiteColor];
    self.continueButton.clipsToBounds = YES;
    self.continueButton.layer.masksToBounds = YES;
    self.continueButton.layer.cornerRadius = self.continueButton.frame.size.height / 2;
    self.continueButton.layer.borderWidth = 1.0f;
    self.continueButton.layer.borderColor = UIColorFromRGB(0xD7D7D7).CGColor;
    [self.continueButton setTitleColor:UIColorFromRGB(0xAE2E23) forState:UIControlStateNormal];
    
    UIImage *img = [UIImage imageNamed:@"120px.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
//    self.navigationItem.titleView = imgView;
    self.navigationItem.title = @"Register";
    
    self.userTextField.delegate = self;
    self.emailtextField.delegate = self;
    self.passwordTextField.delegate = self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"continueButton"]) {
        NSLog(@"username %@", [App42API getLoggedInUser]);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self.emailtextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}


- (IBAction)continueButtonClick:(id)sender {
    
    NSString *username = [self.userTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailtextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *pass = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    UserService *userservice = [App42API buildUserService];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsRegister"] == false) {
        
        [userservice createUser:username password:pass emailAddress:email completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
            if (success)      {
                [self parseUserdata:responseObj];
            }
            else      {
                NSLog(@"Exception is %@",[exception reason]);
                NSLog(@"HTTP error Code is %d",[exception httpErrorCode]);
                NSLog(@"App Error Code is %d",[exception appErrorCode]);
                NSLog(@"User Info is %@",[exception userInfo]);
                
            }
        }];
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsLogin"] == false) {
        [userservice authenticateUser:username password:pass completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
            if (success)      {
                [self parseUserdata:responseObj];
            }
            else      {
                NSLog(@"Exception is %@",[exception reason]);
                NSLog(@"HTTP error Code is %d",[exception httpErrorCode]);
                NSLog(@"App Error Code is %d",[exception appErrorCode]);
                NSLog(@"User Info is %@",[exception userInfo]);
                
            }
        }];
    }
    
    
}

-(void)parseUserdata:(id)responseObject {
    User *user = (User*)responseObject;
    NSLog(@"userName is %@" , user.userName);
    NSLog(@"emailId is %@" ,  user.email);
    NSLog(@"SessionId is %@",user.sessionId);
    NSString *jsonResponse = [user toString];
    NSLog(@"register jsonResponse: %@", jsonResponse);
    
    
    [[NSUserDefaults standardUserDefaults] setValue:user.userName forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] setValue:user.email forKey:@"Email"];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"IsLogin"];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"IsRegister"];
    
//    [App42API setLoggedInUser:[self.userTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSLog(@"self.deviceToken: %@", self.deviceToken);
    [self registerDeviceToken:self.deviceToken];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([[App42API getLoggedInUser] isEqualToString:@"sid"]) {
        [userdefaults setInteger:6 forKey:@"UserId"];
    }
    else {
        [userdefaults setInteger:5 forKey:@"UserId"];
    }
    self.userTextField.text = @"";
    self.passwordTextField.text = @"";
    self.emailtextField.text = @"";
    [self.userTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.emailtextField resignFirstResponder];
    
    [self eventTrack];
    
    [self performSegueWithIdentifier:@"continueButton" sender:self];
}
-(void)registerDeviceToken:(NSString *)deviceTokenString {
    NSLog(@"device token: %@", deviceTokenString);
    
    @try
    {
        /***
         * Registering Device Token to App42 Cloud API
         */
        PushNotificationService *pushObj=[App42API buildPushService];
        [pushObj registerDeviceToken:deviceTokenString withUser:[App42API getLoggedInUser] completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
            if (success) {
                PushNotification *push = (PushNotification*)responseObj;
                NSLog(@"push.strResponse: %@", push.strResponse);
            }
            else
            {
                NSLog(@"Reason = %@",exception.reason);
            }
        }];
        
    }
    @catch (App42Exception *exception)
    {
        NSLog(@"Reason = %@",exception.reason);
    }
    @finally
    {
        
    }
}

-(void)setDeviceTokenString:(NSString *)devToken {
    self.deviceToken = devToken;
    NSLog(@"devicetoken: %@", self.deviceToken);
}

-(void)eventTrack {
    EventService *eventService1 = [App42API buildEventService];
    
    [eventService1 trackEventWithName:@"Register" andProperties:[NSDictionary dictionary] completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            App42Response *response = (App42Response*)responseObj;
            NSLog(@"Response = %@",response.strResponse);
        }
        else
        {
            NSLog(@"Exceprion = %@",exception.reason);
        }
    }];
}


@end
