//
//  ProfileViewController.h
//  HDFC Securities
//
//  Created by Purnima Singh on 02/05/18.
//  Copyright © 2018 Shephertz Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPoints;

@end
