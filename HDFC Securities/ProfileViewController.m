//
//  ProfileViewController.m
//  HDFC Securities
//
//  Created by Purnima Singh on 02/05/18.
//  Copyright © 2018 Shephertz Technologies. All rights reserved.
//


//com.shephertz.app42pushapp
//com.shephertz.App42Services

#import "ProfileViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import <App42_iOS_CampaignAPI/App42_iOS_CampaignAPI.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    self.userNameLabel.text = [userdefaults objectForKey:@"UserName"];
    self.emailLabel.text = [userdefaults objectForKey:@"Email"];
    self.totalPoints.text = @"100USD";
    [self getRewards];
}

-(void)getRewards {    
    [App42CampaignAPI getRewardOfUser:self.userNameLabel.text completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        NSLog(@"rewards responseObj: %@", responseObj);
    
        if (success) {
            
            NSArray *rewards = (NSArray*)responseObj;
            
            for (RewardsPoint *points in rewards) {
                NSLog(@"            campaignName: %@", points.campaignName);
                NSLog(@"            userName: %@", points.userName);
                NSLog(@"            points: %f", points.points);
                NSLog(@"            rewardUnit: %@", points.rewardUnit);
                self.totalPoints.text = [NSString stringWithFormat:@"%.f%@", points.points, points.rewardUnit];

            }
        }
        else {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
