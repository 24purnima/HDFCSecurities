//
//  App42InviteView.m
//  App42CampaignAPISample
//
//  Created by Rajeev Ranjan on 29/11/15.
//  Copyright © 2015 Rajeev Ranjan. All rights reserved.
//

#import "App42InviteView.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface App42InviteView ()
{
    App42InviteData *inviteInfo;
    BOOL isFacebookAvailable;
    BOOL isTwitterAvailable;
    BOOL isWhatsAppAvailable;
    BOOL isEmailAvailable;
}
@end

@implementation App42InviteView

@synthesize controller;


-(void)buildInviteViewFromData:(App42InviteData*)inviteData
{
    inviteInfo = inviteData;
    self.backgroundColor = [UIColor colorWithRed:236/255.0 green:228/255.0 blue:233/255.0 alpha:1.0];// [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f];
    CGSize viewSize = self.frame.size;
    
    float x_offset = self.center.x;
    float y_offset = viewSize.height;
    float viewWidth = viewSize.width-viewSize.width/16;
    float cancelButtonViewHeight = 60;
    float channelViewHeight = viewWidth + 150;
    [self checkForAvailableChannels];
    /**
     * Cancel Button
     */
    
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, 60)];
    navView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:128/255.0 alpha:1.0];
    [self addSubview:navView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, navView.frame.size.width- 40, navView.frame.size.height)];
    titleLabel.text = @"Share And Earn";
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    NSString *backImagePath = [[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"];    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:backImagePath] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(0, 0, 40, 60);
    [closeBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:closeBtn];
    
    /***
     * Creating different channels
     */
    UIView *channelsView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, viewSize.width,channelViewHeight)];
    [channelsView setBackgroundColor:[UIColor colorWithRed:236/255.0 green:228/255.0 blue:233/255.0 alpha:1.0]];
    channelsView.layer.cornerRadius = 10;
    channelsView.layer.masksToBounds = YES;
//    y_offset = y_offset-channelsView.frame.size.height/2;
//    channelsView.center = CGPointMake(x_offset, y_offset);
    [self addSubview:channelsView];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - cancelButtonViewHeight - 20, viewSize.width - 20, cancelButtonViewHeight)];
    [buttonView setBackgroundColor:[UIColor colorWithRed:236/255.0 green:228/255.0 blue:233/255.0 alpha:1.0]];
    buttonView.layer.cornerRadius = 10;
    buttonView.layer.masksToBounds = YES;
//    y_offset = y_offset-3*buttonView.frame.size.height/4;
//    buttonView.center = CGPointMake(x_offset, y_offset);
//    [self addSubview:buttonView];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0 green:107.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(0, 0, buttonView.frame.size.width, 60);
    [buttonView addSubview:cancelButton];
//    y_offset = y_offset-3*buttonView.frame.size.height/4;
    
    
    
    
    UIView *giftBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, channelsView.frame.size.width - 20, viewWidth - 40)];
    giftBackView.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:52.0/255.0 blue:89.0/255.0 alpha:1];
    giftBackView.layer.cornerRadius = 8.0;
    [channelsView addSubview:giftBackView];
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, giftBackView.frame.size.width, 50)];
    headerLabel.text = @"Share And Earn";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont boldSystemFontOfSize:20.0];
    headerLabel.textColor = [UIColor whiteColor];
    [giftBackView addSubview:headerLabel];
    
    NSString *giftImagePath = [[NSBundle mainBundle] pathForResource:@"gift_icon" ofType:@"png"];
    UIImage *img = [UIImage imageNamed:giftImagePath];
    UIImageView *giftImage = [[UIImageView alloc] initWithImage:img];
    giftImage.frame = CGRectMake(viewWidth / 2 - cancelButtonViewHeight / 2, headerLabel.frame.size.height + 20, cancelButtonViewHeight, cancelButtonViewHeight);
    [giftBackView addSubview:giftImage];
    
    NSLog(@"invite info : %@", inviteInfo);
    
    NSString *points;
    NSString *unit;
    
    for (NSDictionary *rulesdata in [inviteInfo rewardRules])
    {
        NSLog(@"rulesdata:   %@", rulesdata);
        points = [rulesdata objectForKey:App42IAM_POINTS];
        unit = [rulesdata objectForKey:App42IAM_UNIT];
        
        if (unit) {
            if ([unit isEqualToString:@"USD"]) {
                unit = @"$";
            }
        }
    }
    
    NSString *pointsString = [NSString stringWithFormat:@"Earn %@ %@ points by inviting your friends through different channels", points, unit];
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, giftImage.frame.origin.y + giftImage.frame.size.height + 10, giftBackView.frame.size.width, 80)];
    pointLabel.text = pointsString;
    pointLabel.numberOfLines = 0;
    pointLabel.textAlignment = NSTextAlignmentCenter;
    pointLabel.font = [UIFont systemFontOfSize:17.0];
    pointLabel.textColor = [UIColor whiteColor];
    [giftBackView addSubview:pointLabel];
    
    UILabel *linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, pointLabel.frame.origin.y + pointLabel.frame.size.height + 10, giftBackView.frame.size.width, 30)];
    linkLabel.text = @"Share link below";
    linkLabel.numberOfLines = 0;
    linkLabel.textAlignment = NSTextAlignmentCenter;
    linkLabel.font = [UIFont systemFontOfSize:14.0];
    linkLabel.textColor = [UIColor grayColor];
    [giftBackView addSubview:linkLabel];
    
    UILabel *referralLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, linkLabel.frame.origin.y + linkLabel.frame.size.height + 10, giftBackView.frame.size.width, 30)];
    referralLabel.text = [inviteInfo referralUrl];
    referralLabel.numberOfLines = 0;
    referralLabel.textAlignment = NSTextAlignmentCenter;
    referralLabel.font = [UIFont systemFontOfSize:14.0];
    referralLabel.textColor = [UIColor whiteColor];
    [giftBackView addSubview:referralLabel];
    
    float buttonsWidth = 60;
    float numberOfButtons = 4;
    float buttonsMiddleOffset = (viewWidth-buttonsWidth*numberOfButtons)/(numberOfButtons+1);
    float x_buttonsOffset = buttonsMiddleOffset;
    float y_buttonsOffset = channelsView.frame.size.height - 60 - 25;
//    float y_buttonsOffset = (channelsView.frame.size.height-60)/2;
    
    y_buttonsOffset = giftBackView.frame.origin.y + giftBackView.frame.size.height + 30;
     
    if (isFacebookAvailable) {
        //First Button
        NSString *firstButtonImagePath = [[NSBundle mainBundle] pathForResource:@"fb_60_60" ofType:@"png"];
        UIImage *firstButtonImage = [UIImage imageNamed:firstButtonImagePath];
        UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [firstButton setImage:firstButtonImage forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(faceBookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        firstButton.frame = CGRectMake(x_buttonsOffset, y_buttonsOffset, 60, 60);
        [channelsView addSubview:firstButton];
        firstButton.tag = kApp42_Facebook;
        x_buttonsOffset += firstButton.frame.size.width + buttonsMiddleOffset;
    }
    
    if (isTwitterAvailable) {
        //Second Button
        NSString *secondButtonImagePath = [[NSBundle mainBundle] pathForResource:@"twitter_60_60" ofType:@"png"];
        UIImage *secondButtonImage = [UIImage imageNamed:secondButtonImagePath];
        UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [secondButton setImage:secondButtonImage forState:UIControlStateNormal];
        [secondButton addTarget:self action:@selector(twitterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        secondButton.frame = CGRectMake(x_buttonsOffset, y_buttonsOffset, 60, 60);
        [channelsView addSubview:secondButton];
        secondButton.tag = kApp42_Twitter;
        x_buttonsOffset += secondButton.frame.size.width + buttonsMiddleOffset;
    }
    
    if (isWhatsAppAvailable) {
        //Third Button
        NSString *thirdButtonImagePath = [[NSBundle mainBundle] pathForResource:@"whatsapp_60_60" ofType:@"png"];
        UIImage *thirdButtonImage = [UIImage imageNamed:thirdButtonImagePath];
        UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [thirdButton setImage:thirdButtonImage forState:UIControlStateNormal];
        [thirdButton addTarget:self action:@selector(whatsappButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        thirdButton.frame = CGRectMake(x_buttonsOffset, y_buttonsOffset, 60, 60);
        [channelsView addSubview:thirdButton];
        thirdButton.tag = kApp42_WhatsApp;
        x_buttonsOffset += thirdButton.frame.size.width + buttonsMiddleOffset;
    }
    
    if (isEmailAvailable) {
        //Fourth Button
        NSString *fourthButtonImagePath = [[NSBundle mainBundle] pathForResource:@"mail_60_60" ofType:@"png"];
        UIImage *fourthButtonImage = [UIImage imageNamed:fourthButtonImagePath];
        UIButton *fourthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [fourthButton setImage:fourthButtonImage forState:UIControlStateNormal];
        [fourthButton addTarget:self action:@selector(mailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        fourthButton.frame = CGRectMake(x_buttonsOffset, y_buttonsOffset, 60, 60);
        fourthButton.tag = kApp42_Mail;
        [channelsView addSubview:fourthButton];
    }
    
    
}

-(void)checkForAvailableChannels
{
    isFacebookAvailable = NO;
    isTwitterAvailable = NO;
    isWhatsAppAvailable = NO;
    isEmailAvailable = NO;
    
    NSDictionary *channelData = nil;
    for (channelData in [inviteInfo channels])
    {
        if ([[channelData objectForKey:@"type"] isEqualToString:@"facebook"])
        {
            isFacebookAvailable = YES;
        }
        else if ([[channelData objectForKey:@"type"] isEqualToString:@"twitter"])
        {
            if ([self isAppAvailableForChannel:@"twitter"]) {
                isTwitterAvailable = YES;
            }
        }
        else if ([[channelData objectForKey:@"type"] isEqualToString:@"whatsapp"])
        {
            if ([self isAppAvailableForChannel:@"whatsapp"]) {
                isWhatsAppAvailable = YES;
            }
        }
        else if ([[channelData objectForKey:@"type"] isEqualToString:@"email"])
        {
            isEmailAvailable = YES;
        }
    }
}

-(void)cancelButtonAction:(id)sender
{
    if (self.delegate)
    {
        [self.delegate onCancelAction];
    }
}


-(NSDictionary*)getDataForChannel:(NSString*)channel
{
    NSDictionary *channelData = nil;
    for (channelData in [inviteInfo channels])
    {
        if ([channel isEqualToString:[channelData objectForKey:@"type"]])
        {
            break;
        }
        else
        {
            channelData = nil;
        }
    }
    return channelData;
}

-(void)faceBookButtonClicked:(id)sender
{
    NSString *referralUrl = [NSString stringWithFormat:@"%@/1",inviteInfo.referralUrl];
    NSDictionary *facebookData = [self getDataForChannel:@"facebook"];
    NSMutableString *message = [[facebookData objectForKey:APP42IAM_MESSAGE] mutableCopy];
    //[message stringByReplacingOccurrencesOfString:@"$URL!" withString:referralUrl];
     
   /* NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"fb://publish/profile/me?text=%@",message?[message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:@""]];
    NSLog(@"url= %@",url);
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [self recordInviteImpressionThroughChannel:@"facebook"];
        [[UIApplication sharedApplication] openURL:url];
    }*/
    // if we're not on iOS 6, SLComposeViewController won't be available. Then fallback on website.
    Class composeViewControllerClass = [SLComposeViewController class];
    
    if(composeViewControllerClass == nil || ![composeViewControllerClass isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        NSString *facebookLink = [NSString stringWithFormat:@"http://www.facebook.com/sharer.php?u=%@&t=%@", referralUrl, message];
        facebookLink = [facebookLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebookLink]];
        
    } else {
        
        SLComposeViewController *composeViewController = [composeViewControllerClass composeViewControllerForServiceType:SLServiceTypeFacebook];
        BOOL isSet = [composeViewController setInitialText:message];
        [composeViewController addURL:[NSURL URLWithString:referralUrl]];
        [self.controller presentViewController:composeViewController animated:YES completion:^{
            
        }];
    }
}

-(void)twitterButtonClicked:(id)sender
{
    NSDictionary *twitterData = [self getDataForChannel:@"twitter"];
    NSString *referralUrl = [NSString stringWithFormat:@"%@/3",inviteInfo.referralUrl];
    NSMutableString *message = [[twitterData objectForKey:APP42IAM_MESSAGE] mutableCopy];
    NSString *finalMessage = [message stringByReplacingOccurrencesOfString:@"$URL!" withString:referralUrl];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://post?message=%@",finalMessage?[finalMessage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:@""]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [self recordInviteImpressionThroughChannel:@"twitter"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)whatsappButtonClicked:(id)sender
{
    NSDictionary *whatsAppData = [self getDataForChannel:@"whatsapp"];
    NSString *referralUrl = [NSString stringWithFormat:@"%@/2",inviteInfo.referralUrl];
    NSMutableString *message = [[whatsAppData objectForKey:APP42IAM_MESSAGE] mutableCopy];
    NSString *finalMessage = [message stringByReplacingOccurrencesOfString:@"$URL!" withString:referralUrl];
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",finalMessage?[finalMessage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:@""]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [self recordInviteImpressionThroughChannel:@"whatsapp"];
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}

-(void)mailButtonClicked:(id)sender
{
    NSDictionary *mailData = [self getDataForChannel:@"email"];
    NSString *referralUrl = [NSString stringWithFormat:@"%@/4",inviteInfo.referralUrl];
    NSMutableString *message = [[mailData objectForKey:APP42IAM_MESSAGE] mutableCopy];
    NSString *finalMessage = [message stringByReplacingOccurrencesOfString:@"$URL!" withString:referralUrl];
    NSString *subject = [mailData objectForKey:App42IAM_SUBJECT];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setSubject:subject];
        [composeViewController setMessageBody:finalMessage isHTML:NO];
        [self.controller presentViewController:composeViewController animated:YES completion:nil];
    }
    /*NSURL *mailURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:?body=%@",finalMessage?[finalMessage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:@""]];
    if ([[UIApplication sharedApplication] canOpenURL: mailURL]) {
        [self recordInviteImpressionThroughChannel:@"mail"];
        [[UIApplication sharedApplication] openURL: mailURL];
    }*/
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    if (result == MFMailComposeResultSent) {
        [self recordInviteImpressionThroughChannel:@"email"];
    }
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)recordInviteImpressionThroughChannel:(NSString*)channel
{
    NSString *campName = [inviteInfo app42CampaignName];
    NSString *eventName = [NSString stringWithFormat:@"SHARE-%@",campName]; //Need to configure the event name
    NSDictionary *shareProps = [NSDictionary dictionaryWithObjectsAndKeys:channel,@"channel",[App42API getLoggedInUser],@"userName", nil];
    [[App42IAMManager sharedInstance] executeTrackEventWithName:eventName properties:shareProps];
}

-(BOOL)isAppAvailableForChannel:(NSString*)channel
{
    BOOL isAppAvailable = NO;
    if ([channel isEqualToString:@"twitter"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
            isAppAvailable = YES;
        }
    }
    else if ([channel isEqualToString:@"whatsapp"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://"]]) {
            isAppAvailable = YES;
        }
    }
    
    return isAppAvailable;
}

@end
