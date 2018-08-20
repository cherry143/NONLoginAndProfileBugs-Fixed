//
//  APIManager.h
//  KTrack
//
//  Created by mnarasimha murthy on 10/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject <MBProgressHUDDelegate>

@property (strong, nonatomic) MBProgressHUD *HUD;

+ (id)sharedManager;

- (BOOL)hasInternetConnection;

-(void)requestGetUrl:(NSString *)strURL parameters:(NSDictionary *)dictParams success:(void (^)(NSDictionary *responce))success failure:(void (^)(NSError *error))failure ;
-(void)requestPostUrl:(NSString *)strURL parameters:(NSDictionary *)dictParams success:(void (^)(NSDictionary *responce))success failure:(void (^)(NSError *error))failure ;
-(void)showHUDInView:(UIView *)view hudMessage:(NSString *)hudMessage;
-(void)hideHUD;
-(BOOL) validateEmail:(NSString *) email;

-(void)showToasterForUIView:(UIViewController *)viewController forTitleString:(NSString *)makeToasterMessage forDuration:(NSTimeInterval)durationTime forPostitionToBePlacedAt:(id)position forTitle:(NSString *)title forImage:(UIImage *)image forStyle:(NSString *)toastStyle;

-(void)requestWithoutProgressHubGetUrl:(NSString *)strURL parameters:(NSDictionary *)dictParams success:(void (^)(NSDictionary *responce))success failure:(void (^)(NSError *error))failure;
-(void)requestGetUrlString:(NSString *)strURL parameters:(NSDictionary *)dictParams success:(void (^)(NSString *responce))success failure:(void (^)(NSError *error))failure;

@end

