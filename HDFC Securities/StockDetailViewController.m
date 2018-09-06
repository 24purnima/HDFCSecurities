//
//  StockDetailViewController.m
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import "StockDetailViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define databaseName @"IIFL"
#define collectionNameStr @"StockWatchList"

@interface StockDetailViewController ()

@end

@implementation StockDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"stock array: %@", self.stockArray);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    NSString *companyName = [self.stockArray valueForKey:@"companyName"];
    self.navigationItem.title = companyName;
    self.companyName.text = companyName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [self.stockArray valueForKey:@"price"]];
    self.dateLabel.text = @"10:44:49 06-09-2017";
    
    NSString *increasePercentage = [NSString stringWithFormat:@"%@", [self.stockArray valueForKey:@"increasePercentage"]];
    if ([increasePercentage hasPrefix:@"+"]) {
        self.rateLabel.textColor = UIColorFromRGB(0x44A462);
        increasePercentage = [increasePercentage stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }
    else if ([increasePercentage hasPrefix:@"-"]) {
        self.rateLabel.textColor = UIColorFromRGB(0xC93E4A);
        increasePercentage = [increasePercentage stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [self.wishlistButton setTitle:@"BUY" forState:UIControlStateNormal];
    }
    
    
    self.rateLabel.text = [NSString stringWithFormat:@"%@(%@%%)", [self.stockArray valueForKey:@"increaseRate"], increasePercentage];
//    self.title = companyName;
//    UIImage *logoImg;
//    if ([companyName isEqualToString:@"ONGC"]) {
//        logoImg = [UIImage imageNamed:@"ongc_icon.png"];
//    }
//    else if ([companyName isEqualToString:@"ICICI Bank"]) {
//        logoImg = [UIImage imageNamed:@"icici.png"];
//    }
//    else if ([companyName isEqualToString:@"Grasim"]) {
//        logoImg = [UIImage imageNamed:@"gra.png"];
//    }
//    else if ([companyName isEqualToString:@"Tata Steel"]) {
//        logoImg = [UIImage imageNamed:@"tata.png"];
//    }
//    else if ([companyName isEqualToString:@"Maruti Suzuki"]) {
//        logoImg = [UIImage imageNamed:@"maruti_suzuki_icon.png"];
//    }

//    self.companydescription.text = [self.stockArray valueForKey:@"description"];
//    self.companydescription.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = UIColorFromRGB(0xECEBF3);
//    [self.companydescription sizeToFit];
    
//    UIImage *img = logoImg;
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, 30)];
//    [imgView setImage:img];
//    // setContent mode aspect fit
//    [imgView setContentMode:UIViewContentModeScaleAspectFit];
//    self.navigationItem.titleView = imgView;



    NSLog(@"bool for company name: %d", [[NSUserDefaults standardUserDefaults] boolForKey:[self.stockArray valueForKey:@"companyName"]]);

    if ([[NSUserDefaults standardUserDefaults] boolForKey:[self.stockArray valueForKey:@"companyName"]] == true) {
        [self.wishlistButton setTitleColor:UIColorFromRGB(0xCE2C38) forState:UIControlStateNormal];
        [self.wishlistButton setTitle:@"Added To Wishlist" forState:UIControlStateNormal];
        self.wishlistButton.hidden = YES;
    }
    
    self.wishlistButton.clipsToBounds = YES;
    self.wishlistButton.layer.masksToBounds = YES;
    self.wishlistButton.layer.cornerRadius = self.wishlistButton.frame.size.height / 2;
    self.wishlistButton.layer.borderWidth = 1.0f;
    self.wishlistButton.layer.borderColor = UIColorFromRGB(0xD7D7D7).CGColor;
    
    
    self.detailLoader.hidden = YES;
    
    
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

- (IBAction)wishlistButtonClick:(id)sender {

    if ([self.wishlistButton.currentTitle isEqualToString:@"BUY"]) {
        self.detailLoader.hidden = NO;
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:[self.stockArray valueForKey:@"companyName"]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.stockArray options:0 error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //        NSLog(@"jsonnnn: %@", json);
        json = [json stringByReplacingOccurrencesOfString:@"{" withString:@""];
        json = [json stringByReplacingOccurrencesOfString:@"}" withString:@""];
        NSDictionary *arr1 = [NSDictionary dictionaryWithObjectsAndKeys:
                              [App42API getLoggedInUser], @"userName",
                              [NSNumber numberWithInt:0], @"notificationSubscribe",
                              nil];
        
        NSData *arrData = [NSJSONSerialization dataWithJSONObject:arr1 options:kNilOptions error:nil];
        NSString *appendStr = [[NSString alloc] initWithData:arrData encoding:NSUTF8StringEncoding];
        appendStr = [appendStr stringByReplacingOccurrencesOfString:@"{" withString:@","];
        appendStr = [appendStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
        
        
        json = [json stringByAppendingString:appendStr];
        json = [NSString stringWithFormat:@"{%@}", json];
        
        StorageService *storageService = [App42API buildStorageService];
        [storageService insertJSONDocument:databaseName  collectionName:collectionNameStr json:json completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
         {
             if (success)
             {
                 [self alertMessage];
                 
                 Storage *storage =  (Storage*)responseObj;
                 NSLog(@"dbName is %@" , storage.dbName);
                 NSLog(@"collectionNameId is %@" ,  storage.collectionName);
                 NSMutableArray *jsonDocArray = storage.jsonDocArray;
                 for(JSONDocument *jsonDoc in jsonDocArray)
                 {
                     NSLog(@"objectId is = %@ " , jsonDoc.docId);
                     NSLog(@"jsonDoc is = %@ " , jsonDoc.jsonDoc);
                 }
            }
             else
             {
                 NSLog(@"Exception = %@",[exception reason]);
                 NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
                 NSLog(@"App Error Code = %d",[exception appErrorCode]);
                 NSLog(@"User Info = %@",[exception userInfo]);
             }
             
             self.detailLoader.hidden = YES;
             self.wishlistButton.hidden = YES;
         }];
    }
    
}

-(void)alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Thanks for buy the stocks from HDFC" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
