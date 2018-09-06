//
//  MyStocksViewController.m
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import "MyStocksViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "StocksListTableViewCell.h"
#import "StockDetailViewController.h"

#define databaseName @"IIFL"
#define collectionNameStr @"StockWatchList"

#define stocksDetails @"myStockDetail"
#define myStockDetailIdentifier @"myStocks"
#define myRecommendStockDetailIdentifier @"myRecommededStocks"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define APP42_APP_KEY @"bf1587bf4f9cabd156e87c1be4b73af773edd60c236f9a86922afe3ab65bb2b0"
#define APP42_SECRET_KEY @"253f0841bf6851071fed40f03283aa8ffd7df879cd4e592ed464d7de2dfccd56"


@interface MyStocksViewController () {
    NSMutableArray *StockArray;
}
@property (nonatomic, strong) NSMutableArray *stocksListArray;
@property (nonatomic, strong) NSMutableArray *stockDetailArray;
@property (nonatomic, strong) NSMutableArray *finalStockArray;
@end

@implementation MyStocksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.myStocksTableView.separatorColor = UIColorFromRGB(0x909092);
    self.view.backgroundColor = UIColorFromRGB(0xECEBF3);
    
    self.navigationItem.title = @"My Portfolio";
    
    self.stocksListArray = [NSMutableArray new];
    self.stockDetailArray = [NSMutableArray new];
    self.finalStockArray = [NSMutableArray new];
    
    
    self.myStocksTableView.tableFooterView = [[UIView alloc] init];
    self.myStocksTableView.backgroundColor = UIColorFromRGB(0xECEBF3);
    self.errorMessageLabel.hidden = YES;
    self.myStocksTableView.hidden = YES;
    
    self.myStocksTableView.dataSource = self;
    self.myStocksTableView.delegate = self;
//    [self.myStocksTableView registerClass:[StocksListTableViewCell class] forCellReuseIdentifier:myStockDetailIdentifier];
    
    self.recommendTableView.dataSource = self;
    self.recommendTableView.delegate = self;
//    [self.recommendTableView registerClass:[StocksListTableViewCell class] forCellReuseIdentifier:myRecommendStockDetailIdentifier];


//    NSLog(@"stocks mapping dict: %@", stocksdict);

    
    NSMutableDictionary *myDictionary1 = [[ NSMutableDictionary alloc] init];
    [ myDictionary1 setObject:@"101" forKey:@"stockId"];
    [ myDictionary1 setObject:@"Maruti Suzuki" forKey:@"companyName"];
    
    NSMutableDictionary *myDictionary2 = [[ NSMutableDictionary alloc] init];
    [ myDictionary2 setObject:@"102" forKey:@"stockId"];
    [ myDictionary2 setObject:@"Tata Steel" forKey:@"companyName"];
    
    NSMutableDictionary *myDictionary3 = [[ NSMutableDictionary alloc] init];
    [ myDictionary3 setObject:@"103" forKey:@"stockId"];
    [ myDictionary3 setObject:@"Grasim" forKey:@"companyName"];
    
    NSMutableDictionary *myDictionary4 = [[ NSMutableDictionary alloc] init];
    [ myDictionary4 setObject:@"104" forKey:@"stockId"];
    [ myDictionary4 setObject:@"ICICI Bank" forKey:@"companyName"];
    
    NSMutableDictionary *myDictionary5 = [[ NSMutableDictionary alloc] init];
    [ myDictionary5 setObject:@"105" forKey:@"stockId"];
    [ myDictionary5 setObject:@"ONGC" forKey:@"companyName"];
    
    StockArray = [[NSMutableArray alloc] initWithObjects:myDictionary1, myDictionary2, myDictionary3, myDictionary4, myDictionary5, nil];
//    NSLog(@"all stock array: %@", _allStocksArray);
    self.recommendView.hidden = true;
    
    
    self.recommendView.layer.shadowRadius  = 3.5f;
    self.recommendView.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    self.recommendView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.recommendView.layer.shadowOpacity = 0.9f;
    self.recommendView.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.recommendView.bounds, shadowInsets)];
    self.recommendView.layer.shadowPath    = shadowPath.CGPath;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllDataFromStorage:databaseName collectionName:collectionNameStr];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllDataFromStorage:(NSString *)dbName collectionName:(NSString *)collectionName {
    StorageService *storageService = [App42API buildStorageService];
    [storageService findDocumentByKeyValue:dbName collectionName:collectionNameStr key:@"userName" value:[App42API getLoggedInUser] completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            if (self.stocksListArray) {
                [self.stocksListArray removeAllObjects];
            }
            Storage *storage =  (Storage*)responseObj;
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray) {
                [self convertStringToJson:jsonDoc.jsonDoc];
            }
            
            [self.myStocksTableView reloadData];
            
            [self getRecommendedStocks];

        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            self.errorMessageLabel.hidden = NO;
            self.errorMessageLabel.text = [exception reason];
        }
        
        self.myStocksLoader.hidden = YES;
        self.myStocksTableView.hidden = NO;
    }];
    
}

/*
 
 {
 "vol": "358.10K",
 "price": 2660,
 "description": "Maruti Suzuki alone makes 1.5 million Maruti Suzuki family cars every year. That is one car every 12 seconds. We drove up head and shoulders above every major global auto company. Yet our story was not just about making a mark. It was about revolutionary cars that delivered great performance, efficiency and environment friendliness with low cost of ownership.",
 "increasePercentage": "+35.42",
 "increaseRate": 68,
 "companyName": "Maruti Suzuki"
 }
 
 
 
 
 {
 "vol": "1.37M",
 "price": 150,
 "description": "Maharatna' ONGC is the largest producer of crude oil and natural gas in India, contributing around 70 per cent of Indian domestic production. The crude oil is the raw material used by downstream companies like IOC, BPCL, HPCL to produce petroleum products like Petrol, Diesel, Kerosene, Naphtha, Cooking Gas-LPG.",
 "increasePercentage": "-11.11",
 "userName": "rajeev123",
 "increaseRate": "10",
 "companyName": "ONGC",
 "viewCount": 8
 }
 
 */

-(void)convertStringToJson:(NSString *)convertStr {
    NSData *strData = [convertStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:strData options:kNilOptions error:nil];
    [self.stocksListArray addObject:arr];
    
    for (int i = 0; i < self.stocksListArray.count; i++) {
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:[[self.stocksListArray objectAtIndex:i] objectForKey:@"companyName"]];
    }
    
}

//header title color- 66646B

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count;
    if (tableView == self.myStocksTableView) {
        count = [self.stocksListArray count];
    }
    
    if (tableView == self.recommendTableView) {
        count = [self.finalStockArray count];
    }
    
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StocksListTableViewCell *cell;
    
    if (tableView == self.myStocksTableView) {
        cell = (StocksListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:myStockDetailIdentifier forIndexPath:indexPath];
        cell.backgroundColor = UIColorFromRGB(0xECEBF3);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *companyName = [[self.stocksListArray objectAtIndex:indexPath.row] objectForKey:@"companyName"];
        cell.nameStr.text = companyName;
        cell.shortNameStr.text = [NSString stringWithFormat:@"%@",[[self.stocksListArray objectAtIndex:indexPath.row] objectForKey:@"vol"]];
        cell.ltpStr.text = [NSString stringWithFormat:@"%@",[[self.stocksListArray objectAtIndex:indexPath.row] objectForKey:@"price"]];
        cell.chgPercentageStr.text = [NSString stringWithFormat:@"%@",[[self.stocksListArray objectAtIndex:indexPath.row] objectForKey:@"increasePercentage"]];
        cell.chgStr.text = [NSString stringWithFormat:@"%@",[[self.stocksListArray objectAtIndex:indexPath.row] objectForKey:@"increaseRate"]];
        
        if([cell.chgPercentageStr.text rangeOfString:@"+"].location != NSNotFound) {
            cell.chgPercentageStr.backgroundColor = UIColorFromRGB(0x01b77e);
        }
        else {
            cell.chgPercentageStr.backgroundColor = UIColorFromRGB(0xf35353);
        }

    }
    
    
    if (tableView == self.recommendTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:myRecommendStockDetailIdentifier forIndexPath:indexPath];
        cell.backgroundColor = UIColorFromRGB(0xECEBF3);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *companyName = [[self.finalStockArray objectAtIndex:indexPath.row] objectForKey:@"companyName"];
        cell.nameStr.text = companyName;
        cell.shortNameStr.text = [NSString stringWithFormat:@"%@",[[self.finalStockArray objectAtIndex:indexPath.row] objectForKey:@"vol"]];
        cell.ltpStr.text = [NSString stringWithFormat:@"%@",[[self.finalStockArray objectAtIndex:indexPath.row] objectForKey:@"price"]];
        cell.chgPercentageStr.text = [NSString stringWithFormat:@"%@",[[self.finalStockArray objectAtIndex:indexPath.row] objectForKey:@"increasePercentage"]];
        cell.chgStr.text = [NSString stringWithFormat:@"%@",[[self.finalStockArray objectAtIndex:indexPath.row] objectForKey:@"increaseRate"]];
        
        if([cell.chgPercentageStr.text rangeOfString:@"+"].location != NSNotFound) {
            cell.chgPercentageStr.backgroundColor = UIColorFromRGB(0x01b77e);
        }
        else {
            cell.chgPercentageStr.backgroundColor = UIColorFromRGB(0xf35353);
        }

    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.myStocksTableView) {
        return 90.0f;
    }
    
    if (tableView == self.recommendTableView) {
        return 145.0f;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.myStocksTableView) {
        self.stockDetailArray = [self.stocksListArray objectAtIndex:indexPath.row];
    }
    
    if (tableView == self.recommendTableView) {
        self.stockDetailArray = [self.finalStockArray objectAtIndex:indexPath.row];
    }
    
    NSLog(@"self.stockDetailArray: %@", self.stockDetailArray);
    
    [self performSegueWithIdentifier:stocksDetails sender:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:stocksDetails]) {
        StockDetailViewController *detailVC = [segue destinationViewController];
        detailVC.stockArray = self.stockDetailArray;
    }
}

-(void)getRecommendedStocks
{
    NSString *api_key = @"f340968d26e397017c6248041c69073bd266a7ce548f5b1b79c72224a889311a";
    NSString *secret_key = @"960b8f9cbc644bb45ff54ec3723d71b5c066df6d6147bfd98339ae0ef9370430";
    
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];

    long userid = [userdefaults integerForKey:@"UserId"];
    int size = 100;
    int howmany = 10;
    
    [App42API initializeWithAPIKey:api_key andSecretKey:secret_key];
    [App42API setBaseUrl:@"https://api.shephertz.com"];
    
    NSLog(@"getSecretKey key: %@", [App42API getSecretKey]);
    RecommenderService *recommenderService = [App42API buildRecommenderService];
    
    /*
    [recommenderService itemBased:userid howMany:10 completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        
        if (success)      {
            Recommender *recommender =  (Recommender*)responseObj;
            
            if (self.stocksListArray.count > 0) {
                
                NSMutableArray *recommendedItemList =  recommender.recommendedItemList;
                for(RecommendedItem *recommendedItem in recommendedItemList){
                    NSLog(@"item is = %@",recommendedItem.item);
                    NSLog(@"value is = %f",recommendedItem.value);
                    
                    //                    NSPredicate *stockIdPred = [NSPredicate predicateWithFormat:@"stockId == %@",recommendedItem.item];
                    //                    NSMutableArray *stocks = [StockArray filteredArrayUsingPredicate:stockIdPred];
                    //                    //                    NSLog(@"stocks: %@", stocks);
                    //
                    //                    if (stocks.count > 0) {
                    //
                    //                        //                        NSLog(@"recommend company name: %@", [[stocks objectAtIndex:0] objectForKey:@"companyName"]);
                    //
                    //                        NSPredicate *companynamePred = [NSPredicate predicateWithFormat:@"companyName == %@", [[stocks objectAtIndex:0] objectForKey:@"companyName"]];
                    //                        NSMutableArray *companyArray = [self.stocksListArray filteredArrayUsingPredicate:companynamePred];
                    //                        //                        NSLog(@"companyArray: %@", companyArray);
                    //
                    //                        if (companyArray.count == 0) {
                    //                            NSArray *recommendedStockArray = [self.allStocksArray filteredArrayUsingPredicate:companynamePred];
                    //                            NSLog(@"recommendedStockArray: %@", recommendedStockArray);
                    //                            [self.finalStockArray addObjectsFromArray:recommendedStockArray];
                    //                        }
                    //
                    //                        NSLog(@"finalStockArray: %@", self.finalStockArray);
                    //                    }
                }
                
                if (self.finalStockArray.count > 0) {
                    [self.recommendTableView reloadData];
                    self.recommendView.hidden = false;
                }
            }
        }
        else      {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
        
        
    }];*/
    
    
    [recommenderService userBasedNeighborhood:userid size:size howMany:howmany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)      {
            Recommender *recommender =  (Recommender*)responseObj;
            
            if (self.stocksListArray.count > 0) {
                
                NSMutableArray *recommendedItemList =  recommender.recommendedItemList;
                for(RecommendedItem *recommendedItem in recommendedItemList){
//                    NSLog(@"item is = %@",recommendedItem.item);
//                    NSLog(@"value is = %f",recommendedItem.value);
                    
                    NSPredicate *stockIdPred = [NSPredicate predicateWithFormat:@"stockId == %@",recommendedItem.item];
                    NSMutableArray *stocks = [StockArray filteredArrayUsingPredicate:stockIdPred];
//                    NSLog(@"stocks: %@", stocks);
                    
                    if (stocks.count > 0) {
                        
//                        NSLog(@"recommend company name: %@", [[stocks objectAtIndex:0] objectForKey:@"companyName"]);
                        
                        NSPredicate *companynamePred = [NSPredicate predicateWithFormat:@"companyName == %@", [[stocks objectAtIndex:0] objectForKey:@"companyName"]];
                        NSMutableArray *companyArray = [self.stocksListArray filteredArrayUsingPredicate:companynamePred];
//                        NSLog(@"companyArray: %@", companyArray);

                        if (companyArray.count == 0) {
                            NSArray *recommendedStockArray = [self.allStocksArray filteredArrayUsingPredicate:companynamePred];
                            NSLog(@"recommendedStockArray: %@", recommendedStockArray);
                            [self.finalStockArray addObjectsFromArray:recommendedStockArray];
                        }
                        
                        NSLog(@"finalStockArray: %@", self.finalStockArray);
                    }
                }
                
                if (self.finalStockArray.count > 0) {
                    [self.recommendTableView reloadData];
                    self.recommendView.hidden = false;
                }
            }
            
        }
        else      {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
    
    [App42API initializeWithAPIKey:APP42_APP_KEY andSecretKey:APP42_SECRET_KEY];
    [App42API setBaseUrl:@"https://in-api.shephertz.com"];
}


- (IBAction)closeBtnClick:(UIButton *)sender {
    
    self.recommendView.hidden = true;
}
@end
