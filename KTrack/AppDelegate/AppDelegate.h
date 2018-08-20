//
//  AppDelegate.h
//  KTrack
//
//  Created by mnarasimha murthy on 10/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) NSString *str_loginSocio;
@property (retain, nonatomic) NSString *str_folioDetailsPan,*str_folioDetailFund,*str_folioDetailsAcno;

// Methods declarations
-(NSString *)convertToBase64StrForAGivenString:(NSString *)givenStr;
-(void)insertRecordIntoRespectiveTables:(NSDictionary *)responseDictionary;
-(void)deleteExistingTableRecords;
-(NSString *)removeNullFromStr:(NSString *)givenStr;
-(void)callPagelogOnEachScreen:(NSString *)pageName;

@end

