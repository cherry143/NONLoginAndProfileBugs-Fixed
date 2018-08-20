//
//  AppDelegate.m
//  KTrack
//
//  Created by mnarasimha murthy on 10/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "AppDelegate.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>
@import UserNotifications;

@interface AppDelegate ()<UNUserNotificationCenterDelegate,FIRMessagingDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (@available(iOS 10.0, *)) {
        if ([UNUserNotificationCenter class] != nil) {
            // iOS 10 or later
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
            UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
             }];
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            // For iOS 10 data message (sent via FCM)
        } else {
            // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [application registerUserNotificationSettings:settings];
        }
    } else {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    UIRemoteNotificationType allNotificationTypes =
                    (UIRemoteNotificationTypeSound |
                     UIRemoteNotificationTypeAlert |
                     UIRemoteNotificationTypeBadge);
                    [application registerForRemoteNotificationTypes:allNotificationTypes];
            #pragma clang diagnostic pop
    }
    [application registerForRemoteNotifications];
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
    [FIRMessaging messaging].autoInitEnabled = YES;
    [NSThread sleepForTimeInterval:1.5];
    [self initializingTheDataBaseForTheFirstTime];
    [self setHomeScreen];
    [GIDSignIn sharedInstance].clientID =KTGoogleClientID;
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    return YES;
}

#pragma mark - call everytime a new token is generated

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    // Notify about received token.
    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
                                                        NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching remote instance ID: %@", error);
        } else {
            NSLog(@"Remote instance ID token: %@", result.token);
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)reachabilityChanged:(NSNotification*)notification {
    Reachability* reachability = notification.object;
    if(reachability.currentReachabilityStatus == NotReachable){
        NSLog(@"Internet off");
        //        UIAlertView * alert =[[UIAlertView  alloc]initWithTitle:XTAPP_NAME message:STRING_NO_INTERNET delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        //        [alert show];
        
        [JDStatusBarNotification showWithStatus:STRING_NO_INTERNET
                                      styleName:JDStatusBarStyleError];
        
    }
    else{
        NSLog(@"Internet on");
        
        [JDStatusBarNotification dismiss];
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    if ([_str_loginSocio isEqualToString:@"Google"]) {
        
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        
    }
    return NO;
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([_str_loginSocio isEqualToString:@"Google"]) {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }else{
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    return NO;
    
}

#pragma mark - convert into base64String

-(NSString *)convertToBase64StrForAGivenString:(NSString *)givenStr{
    NSData *plainTextData = [givenStr dataUsingEncoding:NSUTF8StringEncoding];
    return [plainTextData base64EncodedString];
}

#pragma mark - InitialiseTheDataBaseForTheFirstTime

-(void)initializingTheDataBaseForTheFirstTime{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]){
        NSLog(@"Application is already installed");
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[DBManager  sharedDataManagerInstance] createDatabase];
    }
}

#pragma mark - Delete EXITING  Records from Tables

-(void)deleteExistingTableRecords{
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE2_DETAILS"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE3_DETAILS"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE4_DETAILS"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE5_DETAILS"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE6_DETAILS"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE7_DETAILS"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE8_BANKACCOUNT"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE9_NOMINEEDETAILS"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE10_BANKDETAILS"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE11_TRANSACTIONDETAILS"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE12_PANDETAILS"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE13_DETAILS"];
    [[DBManager sharedDataManagerInstance]executeDeleteQuery:@"DELETE FROM TABLE14_DETAILS"];
}

#pragma mark - Inserting Records Into Respective Table

-(void)insertRecordIntoRespectiveTables:(NSDictionary *)responseDictionary{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SharedUtility sharedInstance]writeStringUserPreference:KTLoginUserEmailID value:responseDictionary[@"DtData"][0][@"Login_MailID"]];
        [[SharedUtility sharedInstance]writeStringUserPreference:KTLoginUserNameKey value:responseDictionary[@"Dtinformation"][0][@"UserName"]];
        NSArray *table2Rec=responseDictionary[@"Table2"];
        NSArray *table3Rec=responseDictionary[@"Table3"];
        NSArray *table4Rec=responseDictionary[@"Table4"];
        NSArray *table5Rec=responseDictionary[@"Table5"];
        NSArray *table6Rec=responseDictionary[@"Table6"];
        NSArray *table7Rec=responseDictionary[@"Table7"];
        NSArray *table8Rec=responseDictionary[@"Table8"];
        NSArray *table9Rec=responseDictionary[@"Table9"];
        NSArray *table10Rec=responseDictionary[@"Table10"];
        NSArray *table11Rec=responseDictionary[@"Table11"];
        NSArray *table12Rec=responseDictionary[@"Table12"];
        NSArray *table13Rec=responseDictionary[@"Table13"];
        NSArray *table14Rec=responseDictionary[@"Table14"];
        if (table2Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable2:table2Rec];
        }
        if (table3Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable3:table3Rec];
        }
        if (table4Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable4:table4Rec];
        }
        if (table5Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable5:table5Rec];
        }
        if (table6Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable6:table6Rec];
        }
        if (table7Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable7:table7Rec];
        }
        if (table8Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable8:table8Rec];
        }
        if (table9Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable9:table9Rec];
        }
        if (table10Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable10:table10Rec];
        }
        if (table11Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable11:table11Rec];
        }
        if (table12Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable12:table12Rec];
        }
        if (table13Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable13:table13Rec];
        }
        if (table14Rec.count!=0) {
            [[DBManager sharedDataManagerInstance]insertIntoTable14:table14Rec];
        }
    });
}

-(void)setHomeScreen{
    NSString *userName = [[SharedUtility sharedInstance]readStringUserPreference:KTLoginShowPatternPin];
    if (userName.length!=0) {
        PinPatternVC *destination=[KTHomeStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"PinPatternVC"];
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:destination];
        [navController.navigationBar setHidden:YES];
        navController.navigationItem.hidesBackButton = true;
        [self.window setRootViewController:navController];
    }
    else{
        LoginVC *destination=[KTHomeStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"LoginVC"];
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:destination];
        [navController.navigationBar setHidden:YES];
        navController.navigationItem.hidesBackButton = true;
        [self.window setRootViewController:navController];
    }
}

-(NSString *)removeNullFromStr:(NSString *)givenStr{
    NSString *newStr;
    if ([givenStr isEqualToString:@"(null)"] || [givenStr isEqualToString:@"(null)  "] || [givenStr isEqualToString:@"(null) "] || [givenStr isEqualToString:@"<null>"] || [givenStr isKindOfClass:(id)[NSNull null]] || givenStr==nil) {
        newStr=@"";
    }
    else{
        newStr=givenStr;
    }
    return newStr;
}

-(void)topBarStatusShow{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
            case 2436:
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
                    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 45)];
                    view.backgroundColor=KT_TopStatusBar;
                    [self.window.rootViewController.view addSubview:view];
                }
                break;
            default:
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
                    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
                    view.backgroundColor=KT_TopStatusBar;
                    [self.window.rootViewController.view addSubview:view];
                }
                break;
        }
    }
    else{
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
            view.backgroundColor=KT_TopStatusBar;
            [self.window.rootViewController.view addSubview:view];
        }
    }
}

#pragma mark - call screen log API In Background

-(void)callPagelogOnEachScreen:(NSString *)pageName{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:XTOnlyDateFormat];
        NSString *dateToday=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
        NSString *str_userName=[self removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]];
        NSString *unique_UDID = [self convertToBase64StrForAGivenString:KTUniqueUDID];
        NSString *str_operatingSystem = [self convertToBase64StrForAGivenString:KTOperationSystem];
        NSString *str_appVersion =[self convertToBase64StrForAGivenString:KTAppVersion];
        NSString *str_userId =[self convertToBase64StrForAGivenString:str_userName];
        NSString *str_fund =[self convertToBase64StrForAGivenString:@""];
        NSString *str_logDateTime=[self convertToBase64StrForAGivenString:dateToday];
        NSString *str_PageName=[self convertToBase64StrForAGivenString:pageName];
        NSString *str_url = [NSString stringWithFormat:@"%@Pagelog?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Userid=%@&Fund=%@&logDttime=%@&Pagename=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_fund,str_logDateTime,str_PageName];
        [[APIManager sharedManager]requestWithoutProgressHubGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
            
        } failure:^(NSError *error) {
            
        }];
    });
}


@end
