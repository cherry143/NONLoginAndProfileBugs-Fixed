//
//  APIManager.m
//  KTrack
//
//  Created by mnarasimha murthy on 10/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+ (id)sharedManager {
    static APIManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (BOOL)hasInternetConnection{
    Reachability* Reachab;
    NetworkStatus internetStatus;
    Reachab = [Reachability reachabilityForInternetConnection];
    internetStatus = [Reachab currentReachabilityStatus];
    if (internetStatus == NotReachable)
    {
        return NO;
    }
    else{
        return YES;
    }
}

-(void)requestPostUrl:(NSString *)strURL parameters:(NSDictionary *)dictParams success:(void (^)(NSDictionary *responce))success failure:(void (^)(NSError *error))failure {
    @synchronized (strURL){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/json"];
        [manager POST:strURL parameters:dictParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                if(success) {
                    success(responseObject);
                }
            }
            else {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                if(success) {
                    success(response);
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTInternetConnectionFailure withMessage:KTInternetConnectionFailureMsg];
            });
        }];
    }
}


#pragma mark - Get Method

-(void)requestGetUrl:(NSString *)strURL parameters:(NSDictionary *)dictParams success:(void (^)(NSDictionary *responce))success failure:(void (^)(NSError *error))failure {
    @synchronized (strURL){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [manager GET:strURL
          parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
             if(success) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self hideHUD];
                     NSError *err = nil;
                     if ([response isKindOfClass:[NSString class]]) {
                         NSData *str_data = [response dataUsingEncoding:NSUTF8StringEncoding];
                         NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:str_data options:NSJSONReadingAllowFragments error:&err];
                         if (err) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [[SharedUtility sharedInstance]showAlertViewWithTitle:KTInternetConnectionFailure withMessage:KTInternetConnectionFailureMsg];
                             });
                         }
                         else{
                             success(responseDic);
                         }
                     }
                     else{
                         success(response);
                     }
                 });
             }
             
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self hideHUD];
                 [[SharedUtility sharedInstance]showAlertViewWithTitle:KTInternetConnectionFailure withMessage:KTInternetConnectionFailureMsg];
             });
         }];
    }
}


-(void)requestGetUrlString:(NSString *)strURL parameters:(NSDictionary *)dictParams success:(void (^)(NSString *responce))success failure:(void (^)(NSError *error))failure{
    @synchronized (strURL){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [manager GET:strURL
          parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
             if(success) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self hideHUD];
                     success(response);
                 });
             }
             
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self hideHUD];
                 [[SharedUtility sharedInstance]showAlertViewWithTitle:KTInternetConnectionFailure withMessage:KTInternetConnectionFailureMsg];
             });
         }];
    }
}
-(void)hideHUD{
    [self.HUD hideAnimated:YES];
}

-(void)showHUDInView:(UIView *)view hudMessage:(NSString *)hudMessage{
    self.HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.HUD.delegate=self;
    self.HUD.label.text = hudMessage;
}

-(BOOL) validateEmail:(NSString *) email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

-(void)showToasterForUIView:(UIViewController *)viewController forTitleString:(NSString *)makeToasterMessage forDuration:(NSTimeInterval)durationTime forPostitionToBePlacedAt:(id)position forTitle:(NSString *)title forImage:(UIImage *)image forStyle:(NSString *)toastStyle{
    [viewController.view makeToast:makeToasterMessage
                          duration:durationTime
                          position:position
                             title:title
                             image:image
                             style:(CSToastStyle *)toastStyle
                        completion:^(BOOL didTap) {
                            
                        }];
}
#pragma mark - GET API Without progress hub

-(void)requestWithoutProgressHubGetUrl:(NSString *)strURL parameters:(NSDictionary *)dictParams success:(void (^)(NSDictionary *responce))success failure:(void (^)(NSError *error))failure {
    @synchronized (strURL){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [manager GET:strURL
          parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
             if(success) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSError *err = nil;
                     if ([response isKindOfClass:[NSString class]]) {
                         NSData *str_data = [response dataUsingEncoding:NSUTF8StringEncoding];
                         NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:str_data options:NSJSONReadingAllowFragments error:&err];
                         if (err) {
                             failure(err);
                         }
                         else{
                             success(responseDic);
                         }
                     }
                     else{
                         success(response);
                     }
                 });
             }
             
         } failure:^(NSURLSessionTask *operation, NSError *error) {
                failure(error);
         }];
    }
}

@end

