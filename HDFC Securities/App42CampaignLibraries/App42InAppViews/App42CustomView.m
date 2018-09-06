//
//  App42CustomView.m
//  App42CampaignAPISample
//
//  Created by Rajeev Ranjan on 19/02/16.
//  Copyright © 2016 Rajeev Ranjan. All rights reserved.
//

#import "App42CustomView.h"

@interface App42CustomView ()
{
    App42IAMLayoutType layoutType;
    App42IAMLayoutGravity layoutGravity;
}

@end

@implementation App42CustomView

-(void)buildCustomViewFromData:(App42CustomViewData*)customViewData
{
    layoutType = [customViewData getLayputType];
    layoutGravity = [customViewData getGravity];
    
    /***
     * Setting view attributes
     */
    self.backgroundColor = [self getUIColorObjectFromHexString:customViewData.backColor alpha:1.0f];
    [self createBackgroundView:customViewData];
    
    /***
     * Creating Cancel Button
     */
    if([customViewData getLayoutCancellationType] == kApp42_Manual)
    {
        UIImage *image = [UIImage imageNamed:customViewData.cancelBtnImage];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setImage:image forState:UIControlStateNormal];
        [cancelButton sizeToFit];
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.center = CGPointMake(10, cancelButton.bounds.size.height/2);
        [self addSubview:cancelButton];
    }
    else
    {
        [self automateViewLife:customViewData];
    }
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *viewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(okButtonAction:)];
    viewtap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:viewtap];
    
    
}

-(void)createBackgroundView:(App42CustomViewData *)customViewData{
    
    CGSize viewSize = self.frame.size;
    float x_pos_icon = 10;
    float y_pos_icon = 10;
    
    /**
     * Creating background
     */
    UIImage *bgImage = [UIImage imageNamed: customViewData.backgroundImage];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    [self addSubview:bgImageView];
    
    
    /**
     * Creating Icon
     */
    UIImageView *icon = nil;
    if (layoutType != kApp42_NoImage) {
        UIImage *iconImage = [UIImage imageNamed: customViewData.iconImage];
        icon = [[UIImageView alloc] initWithImage:iconImage];
        icon.userInteractionEnabled = YES;
        int scale = 5;
        icon.frame = CGRectMake(x_pos_icon, y_pos_icon, iconImage.size.width/scale, iconImage.size.height/scale);
        [self fixIconPosition:icon];
        [self addSubview:icon];
    }
    
    /***
     * Creating title
     */
    UILabel *titleLabel = [[UILabel alloc] init]; //[[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewSize.width - 20, 0)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    if (layoutType != kApp42_NoImage) {
        
        if (layoutGravity == kApp42_Center)
        {
            if (layoutType == kApp42_LeftImage)
            {
                titleLabel.frame = CGRectMake(0, y_pos_icon + 10, viewSize.width - icon.frame.size.width - 30, 0);
                titleLabel.center = CGPointMake((icon.frame.size.width + icon.frame.origin.x) + (titleLabel.frame.size.width / 2), titleLabel.center.y);
            }
            else if (layoutType == kApp42_RightImage)
            {
                titleLabel.frame = CGRectMake(0, y_pos_icon, viewSize.width - icon.frame.size.width - 30, 0);
                titleLabel.center = CGPointMake((titleLabel.frame.size.width / 2) + 10, titleLabel.center.y + 10.0);
            }
            else{
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.frame = CGRectMake(20, (icon.frame.size.height + icon.frame.origin.y) + 10, viewSize.width - 40, 0);
            }
        }
        else if (layoutType != kApp42_CenterImage)
            titleLabel.frame = CGRectMake(0, y_pos_icon, viewSize.width - icon.frame.size.width - 30, 0);
        else
            titleLabel.frame = CGRectMake(20, icon.frame.origin.y + icon.frame.size.height + 10.0, viewSize.width - 40, 0);

    }
    else{
        titleLabel.frame = CGRectMake(20, y_pos_icon + 10, viewSize.width - 40, 0);

        if (layoutGravity == kApp42_Center)
            titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    titleLabel.text = [customViewData.customTitle objectForKey:APP42IAM_TEXT];
    titleLabel.textColor = [self getUIColorObjectFromHexString:[customViewData.customTitle objectForKey:APP42IAM_COLOR] alpha:1.0f];
    titleLabel.font = [UIFont fontWithName:[customViewData.customTitle objectForKey:APP42IAM_STYLE] size:[[customViewData.customTitle objectForKey:APP42IAM_SIZE] intValue]];
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    [self fixTitlePosition:titleLabel withReferenceToIcon:icon];
    [self addSubview:titleLabel];
    
    /***
     * Creating message1
     */
    UILabel *messageLabel1 = [[UILabel alloc] init];
    messageLabel1.textAlignment = NSTextAlignmentLeft;
    if (layoutType != kApp42_NoImage) {
        
        if (layoutGravity == kApp42_Center) {
            messageLabel1.frame = CGRectMake(20, ((icon.frame.size.height + icon.frame.origin.y + y_pos_icon) >(titleLabel.frame.origin.y + titleLabel.frame.size.height + y_pos_icon)) ? (icon.frame.size.height + icon.frame.origin.y + y_pos_icon) : (titleLabel.frame.origin.y + titleLabel.frame.size.height + y_pos_icon), viewSize.width - 40, 0);
            messageLabel1.textAlignment = NSTextAlignmentCenter;
        }
        else if (layoutType != kApp42_CenterImage)
            messageLabel1.frame = CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + y_pos_icon, viewSize.width - icon.frame.size.width - 30, 0);
        else
            messageLabel1.frame = CGRectMake(20, titleLabel.frame.origin.y + titleLabel.frame.size.height + y_pos_icon, viewSize.width - 40, 0);

    }
    else{
        if (layoutGravity == kApp42_Center)
            messageLabel1.textAlignment = NSTextAlignmentCenter;
        
        messageLabel1.frame = CGRectMake(20, titleLabel.frame.origin.y + titleLabel.frame.size.height + y_pos_icon, viewSize.width - 40, 0);
    }
    messageLabel1.text = [customViewData.message1 objectForKey:APP42IAM_TEXT];
    messageLabel1.textColor = [self getUIColorObjectFromHexString:[customViewData.message1 objectForKey:APP42IAM_COLOR] alpha:1.0f];
    messageLabel1.font = [UIFont fontWithName:[customViewData.message1 objectForKey:APP42IAM_STYLE] size:[[customViewData.message1 objectForKey:APP42IAM_SIZE] intValue]];
    messageLabel1.numberOfLines = 0;
    [messageLabel1 sizeToFit];
    [self fixMessagePosition:messageLabel1 withReferenceToIcon:icon];
    [self addSubview:messageLabel1];
    
    CGRect backViewRect = self.frame;
    backViewRect.size.height = messageLabel1.frame.origin.y + messageLabel1.frame.size.height + 10;
    
    UILabel *messageLabel3;
    if (layoutGravity == kApp42_Center){
        /***
         * Creating message2
         */

        UILabel *messageLabel2 = [[UILabel alloc] init];
        if (layoutType != kApp42_NoImage) {
            
            if (layoutGravity == kApp42_Center){
                messageLabel2.textAlignment = NSTextAlignmentCenter;
                messageLabel2.frame = CGRectMake(20, messageLabel1.frame.origin.y + messageLabel1.frame.size.height + y_pos_icon, viewSize.width - 40, 0);
            }
            else if (layoutType != kApp42_CenterImage)
                messageLabel2.frame = CGRectMake(0, messageLabel1.frame.origin.y + messageLabel1.frame.size.height + y_pos_icon, viewSize.width - icon.frame.size.width - 30, 0);
            else
                messageLabel2.frame = CGRectMake(20, messageLabel1.frame.origin.y + messageLabel1.frame.size.height + y_pos_icon, viewSize.width - 40, 0);

        }
        else{
            if (layoutGravity == kApp42_Center)
                messageLabel2.textAlignment = NSTextAlignmentCenter;
            
            messageLabel2.frame = CGRectMake(20, messageLabel1.frame.origin.y + messageLabel1.frame.size.height + y_pos_icon, viewSize.width - 40, 0);
        }
        messageLabel2.text = [customViewData.message2 objectForKey:APP42IAM_TEXT];
        messageLabel2.textColor = [self getUIColorObjectFromHexString:[customViewData.message2 objectForKey:APP42IAM_COLOR] alpha:1.0f];
        messageLabel2.font = [UIFont fontWithName:[customViewData.message2 objectForKey:APP42IAM_STYLE] size:[[customViewData.message2 objectForKey:APP42IAM_SIZE] intValue]];
        messageLabel2.numberOfLines = 0;
        [messageLabel2 sizeToFit];
        [self fixMessagePosition:messageLabel2 withReferenceToIcon:icon];
//        if(layoutGravity == kApp42_Center){
//            messageLabel2.textAlignment = NSTextAlignmentCenter;
//            messageLabel2.frame = CGRectMake(20, messageLabel1.frame.origin.y + messageLabel1.frame.size.height + y_pos_icon, viewSize.width - 40, 0);
//        }
        [self addSubview:messageLabel2];
        
        /***
         * Creating message3
         */
        messageLabel3 = [[UILabel alloc] init];
        if (layoutType != kApp42_NoImage) {
            if (layoutGravity == kApp42_Center){
                messageLabel3.textAlignment = NSTextAlignmentCenter;
                messageLabel3.frame = CGRectMake(20, messageLabel2.frame.origin.y + messageLabel2.frame.size.height + y_pos_icon, viewSize.width - 40, 0);
            }
            else if (layoutType != kApp42_CenterImage)
                messageLabel3.frame = CGRectMake(0, messageLabel2.frame.origin.y + messageLabel2.frame.size.height + y_pos_icon, viewSize.width - icon.frame.size.width - 30, 0);
            else
                messageLabel3.frame = CGRectMake(20, messageLabel2.frame.origin.y + messageLabel2.frame.size.height + y_pos_icon, viewSize.width - 40, 0);
        }
        else{
            messageLabel3.frame = CGRectMake(20, messageLabel2.frame.origin.y + messageLabel2.frame.size.height + y_pos_icon, viewSize.width - 40, 0);

            if (layoutGravity == kApp42_Center)
            {
                messageLabel3.textAlignment = NSTextAlignmentCenter;
            }
            
        }
        messageLabel3.text = [customViewData.message3 objectForKey:APP42IAM_TEXT];
        messageLabel3.textColor = [self getUIColorObjectFromHexString:[customViewData.message3 objectForKey:APP42IAM_COLOR] alpha:1.0f];
        messageLabel3.font = [UIFont fontWithName:[customViewData.message3 objectForKey:APP42IAM_STYLE] size:[[customViewData.message3 objectForKey:APP42IAM_SIZE] intValue]];
        messageLabel3.numberOfLines = 0;
        [messageLabel3 sizeToFit];
        [self fixMessagePosition:messageLabel3 withReferenceToIcon:icon];
         [self addSubview:messageLabel3];
        
        if ([customViewData.message3 objectForKey:APP42IAM_TEXT]) {
            backViewRect.size.height = messageLabel3.frame.origin.y + messageLabel3.frame.size.height + 5.0;
        }
        else
            backViewRect.size.height = messageLabel2.frame.origin.y + messageLabel2.frame.size.height + 5.0;

    }
    
    
    if ((backViewRect.size.height < self.frame.size.height)) {
        backViewRect.size.height = self.frame.size.height;
    }
    
    
    self.frame = backViewRect;
    backViewRect.origin.x = 0;
    bgImageView.frame = backViewRect;
    
    if(customViewData.roundedCorner){
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10.0f;
    }
    
}


-(void)fixIconPosition:(UIImageView *)imageView
{
    CGSize viewSize = self.frame.size;
    
    if (layoutType == kApp42_LeftImage) {
        imageView.center = CGPointMake(imageView.frame.size.width/2+10, imageView.center.y);
    }
    else if (layoutType == kApp42_RightImage) {
        imageView.center = CGPointMake(viewSize.width-imageView.frame.size.width/2-10, imageView.center.y);
    }
    else if (layoutType == kApp42_CenterImage) {
        imageView.center = CGPointMake(viewSize.width/2, imageView.center.y);
    }
    else
    {
        //No Image
    }
}

-(void)fixTitlePosition:(UILabel *)title withReferenceToIcon:(UIImageView *)imageView
{
    CGSize viewSize = self.frame.size;
    
    if (layoutType == kApp42_LeftImage)
        title.center = CGPointMake((imageView.frame.size.width + imageView.frame.origin.x) + (title.frame.size.width / 2) + 10, title.center.y);
    else if (layoutType == kApp42_RightImage) {
        title.textAlignment = NSTextAlignmentLeft;
        title.center = CGPointMake((title.frame.size.width / 2) + 10, title.center.y + 10);
    }
    else
        title.center = CGPointMake(viewSize.width / 2, title.center.y);
    
//    if (layoutGravity != kApp42_Center) {
//    
//        if (layoutType == kApp42_LeftImage) {
//            title.center = CGPointMake((imageView.frame.size.width + imageView.frame.origin.x) + (title.frame.size.width / 2) + 10, title.center.y);
//        }
//        else if (layoutType == kApp42_RightImage) {
//            title.textAlignment = NSTextAlignmentLeft;
//            title.center = CGPointMake((title.frame.size.width / 2) + 10, title.center.y);
//        }
//        else if (layoutType == kApp42_CenterImage) {
//        
//            title.textAlignment = NSTextAlignmentCenter;
//        }
//        else
//        {
//            title.textAlignment = NSTextAlignmentCenter;
//        }
//    }
//    else{
//        if (layoutType == kApp42_LeftImage)
//            title.center = CGPointMake((imageView.frame.size.width + imageView.frame.origin.x) + (title.frame.size.width / 2) + 10, title.center.y);
//        else if (layoutType == kApp42_RightImage) {
//            title.textAlignment = NSTextAlignmentLeft;
//            title.center = CGPointMake((title.frame.size.width / 2) + 10, title.center.y);
//        }
//        else
//            title.center = CGPointMake(viewSize.width / 2, title.center.y);
////        if (layoutType == kApp42_CenterImage)
////        {
////            title.center = CGPointMake(viewSize.width - title.frame.size.width / 2, title.center.y);
////        }
//    }
}

-(void)fixMessagePosition:(UILabel *)message withReferenceToIcon:(UIImageView *)imageView
{
    CGSize viewSize = self.frame.size;
    
//    if (layoutType == kApp42_LeftImage) {
//        //Already right aligned
//        //title.center = CGPointMake(title.frame.size.width/2, title.center.y);
//    }
//    else if (layoutType == kApp42_RightImage) {
//        
//        message.center = CGPointMake(message.frame.size.width/2, message.center.y);
//    }
//    else if (layoutType == kApp42_CenterImage) {
//        message.center = CGPointMake(viewSize.width/2, imageView.center.y+imageView.frame.size.height/2+message.frame.size.height/2+10);
//    }
//    else
//    {
//        //No Image
//    }
    
    if (layoutGravity == kApp42_Center)
        message.center = CGPointMake(viewSize.width / 2, message.center.y);
    else{
        if (layoutType == kApp42_LeftImage) {
            message.center = CGPointMake((imageView.frame.size.width + imageView.frame.origin.x) + (message.frame.size.width / 2) + 10, message.center.y);
        }
        else if (layoutType == kApp42_RightImage) {
            message.textAlignment = NSTextAlignmentLeft;
            message.center = CGPointMake((message.frame.size.width / 2) + 10, message.center.y);
        }
        else if (layoutType == kApp42_CenterImage) {
            
            message.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            message.textAlignment = NSTextAlignmentCenter;
        }
    }
}


-(void)okButtonAction:(id)sender
{
    if (self.delegate)
    {
        [self.delegate onSubmitAction];
    }
}

-(void)cancelButtonAction:(id)sender
{
    if (self.delegate)
    {
        [self.delegate onCancelAction];
    }
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

-(void)automateViewLife:(App42CustomViewData*)customViewData
{
    customViewData.autoTimeOut = 3;
    [self performSelector:@selector(cancelButtonAction:) withObject:self afterDelay:customViewData.autoTimeOut];
}

@end
