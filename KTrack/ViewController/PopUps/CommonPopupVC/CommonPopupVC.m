//
//  CommonPopupVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 30/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "CommonPopupVC.h"

@interface CommonPopupVC (){
    __weak IBOutlet UIView *view_background;
    __weak IBOutlet UITextField *txt_common;
    __weak IBOutlet UILabel *lbl_textPlaceHolder;
    NSString *str_enterMobileNumber;
    NSString *str_randomGeneratedOTP;
    BOOL bool_mobile;
    NSString *str_serverGeneratedPAN;
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UIButton *btn_cancel;
}

@end

@implementation CommonPopupVC
@synthesize str_fromScreen,str_panEntered,str_referenceGen;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bool_mobile=NO;
    [self initialiseViewTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitialiseViewTitle and Corner Radius

-(void)initialiseViewTitle{
    if ([str_fromScreen isEqualToString:@"LinkFamily"]) {
        lbl_textPlaceHolder.text=@"OTP Number";
        txt_common.text=@"";
    }
    else if ([str_fromScreen isEqualToString:@"DemographicDetails"] || [str_fromScreen isEqual:@"DemographicDetails"]){
        lbl_textPlaceHolder.text=@"OTP Number";
        txt_common.text=@"";
    }
    else{
        if ([str_fromScreen isEqualToString:@"MobilePopup"]) {
            txt_common.keyboardType=UIKeyboardTypeNumberPad;
            lbl_textPlaceHolder.text=@"Enter Mobile Number";
            txt_common.text=@"";
        }
        else{
            txt_common.keyboardType=UIKeyboardTypeDefault;
            txt_common.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            lbl_textPlaceHolder.text=@"Enter PAN Number";
            txt_common.text=@"";
        }
    }
    [UIView roundedCornerEnableForView:view_background forCornerRadius:10.0f forBorderWidth:1.5f forApplyShadow:NO];
    view_background.layer.borderColor=[UIColor clearColor].CGColor;
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_cancel forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
}

#pragma mark - button Action

- (IBAction)btn_submitTapped:(id)sender {
    END_EDITING;
    if ([str_fromScreen isEqualToString:@"LinkFamily"]) {
        if (txt_common.text.length==0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter OTP."];
        }
        else{
            END_EDITING;
            [self associateFolioAPI];
        }
    }
    else if ([str_fromScreen isEqualToString:@"DemographicDetails"] || [str_fromScreen isEqual:@"DemographicDetails"]){
        if (txt_common.text.length==0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter OTP."];
        }
        else if (![txt_common.text isEqualToString:str_referenceGen]) {
            txt_common.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Invalid OTP."];
        }
        else{
            KTHIDEREMOVEVIEW;
            [_commondelegate demoGrpahicSuccess];
        }
    }
    else{
        if ([str_fromScreen isEqualToString:@"MobilePopup"]){
            if (bool_mobile!=YES) {
                if (txt_common.text.length==0) {
                     [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter Mobile Number."];
                }
                else{
                    if ([[SharedUtility sharedInstance]validateMobileWithString:txt_common.text]==NO) {
                        txt_common.text=@"";
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a vaild mobile number."];
                    }
                    else{
                        [txt_common resignFirstResponder];
                        str_enterMobileNumber=txt_common.text;
                        str_randomGeneratedOTP=[NSString stringWithFormat:@"%d", [self getRandomNumberBetween:100000 to:900000]];
                        [self fetchFolioWithMobileNumber:str_enterMobileNumber forRandomGeneratedOTP:str_randomGeneratedOTP];
                    }
                }
            }
            else{
                if (txt_common.text.length==0) {
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter OTP."];
                }
                else if (![txt_common.text isEqualToString:str_randomGeneratedOTP]) {
                    txt_common.text=@"";
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Invalid OTP."];
                }
                else{
                    [self setEnterPANAsPrimaryAPI:str_serverGeneratedPAN];
                }
            }
        }
        else{
            NSString *str_panStr=txt_common.text;
            txt_common.text=str_panStr.uppercaseString;
            NSString *panRegex =  @"[A-Z]{3}P[A-Z]{1}[0-9]{4}[A-Z]{1}";
            NSPredicate *panPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", panRegex];
            if (txt_common.text.length==0) {
                [txt_common becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter PAN number."];
            }
            else if ([panPredicate evaluateWithObject:txt_common.text] == NO){
                dispatch_async(dispatch_get_main_queue(), ^{
                    txt_common.text=@"";
                    [txt_common becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter correct PAN number."];
                });
            }
            else{
                NSArray *rec_primaryPan = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE PAN='%@'",txt_common.text]];
                if (rec_primaryPan.count>0) {
                    [self setEnterPANAsPrimaryAPI:txt_common.text];
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        txt_common.text=@"";
                        [txt_common becomeFirstResponder];
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"You have entered incorrect PAN."];
                    });
                }
            }
        }
    }
}

- (IBAction)btn_cancelTapped:(id)sender {
    KTHIDEREMOVEVIEW;
    [_commondelegate cancelButtonTapped];
}


#pragma mark - fetch folio with mobile number

-(void)fetchFolioWithMobileNumber:(NSString *)userEnterMobileNumber forRandomGeneratedOTP:(NSString *)genOTp{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_pin=[XTAPP_DELEGATE convertToBase64StrForAGivenString:genOTp];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_mobile=[XTAPP_DELEGATE convertToBase64StrForAGivenString:userEnterMobileNumber];
    NSString *str_url = [NSString stringWithFormat:@"%@Foliowithmobile?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Pin=%@&Userid=%@&Fund=%@&Mobile=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_pin,str_userId,str_fund,str_mobile];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Table"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                str_serverGeneratedPAN=[NSString stringWithFormat:@"%@",TRIMWHITESPACE(responce[@"Table1"][0][@"PAN"])];
                lbl_textPlaceHolder.text=@"OTP Number";
                txt_common.text=@"";
                [txt_common becomeFirstResponder];
                bool_mobile=YES;
            });
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                lbl_textPlaceHolder.text=@"Enter Mobile Number";
                txt_common.text=@"";
                bool_mobile=NO;
                [[SharedUtility sharedInstance]showAlertViewWithTitle:XTAPP_NAME withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [[APIManager sharedManager]hideHUD];
        });
    }];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

#pragma mark - Setting PAN Primary API

-(void)setEnterPANAsPrimaryAPI:(NSString *)panStr{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_pan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:panStr];
    NSString *str_url = [NSString stringWithFormat:@"%@PrimaryPANUpdate?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&PAN=%@&Userid=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_pan,str_userId];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                if ([str_fromScreen isEqualToString:@"MobilePopup"]) {
                    [self LoginApiWithLoginMode:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginTypeKey] forUserName:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername] forPassword:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginPassword] forInvestorType:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginInvestor]];
                }
                else{
                    KTHIDEREMOVEVIEW;
                    [_commondelegate PanSuccessMethod:panStr];
                }
            });
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });

        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Login API

-(void)LoginApiWithLoginMode:(NSString*)loginType forUserName:(NSString *)username forPassword:(NSString *)password forInvestorType:(NSString *)investorType {
    END_EDITING;
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_invertorType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:investorType];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:username];
    NSString *str_LoginMode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:loginType];
    NSString *str_password=[XTAPP_DELEGATE convertToBase64StrForAGivenString:password];
    NSString *str_url = [NSString stringWithFormat:@"%@GetUserLoginnew_v17?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&username=%@&Password=%@&ReqBy=%@&loginMode=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_password,str_invertorType,str_LoginMode];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [XTAPP_DELEGATE deleteExistingTableRecords];
                [XTAPP_DELEGATE insertRecordIntoRespectiveTables:responce];
                KTHIDEREMOVEVIEW;
                [_commondelegate otpSuccessMethod];
            });
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:XTAPP_NAME withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - associated Folio

-(void)associateFolioAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_pan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_panEntered];
    NSString *str_OTPGen=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_common.text];
    NSString *str_refGen=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_referenceGen];
    NSString *str_investName=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@AssociateFolio?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Userid=%@&otp=%@&pan=%@&refno=%@&invname=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_OTPGen,str_pan,str_refGen,str_investName];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            NSString *succ_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"displaymsg"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:KTSuccessMsg forMessage:succ_message andAction1:@"Ok" andAction1Block:^{
                     KTHIDEREMOVEVIEW;
                    [_commondelegate familyFolioSuccess];
                }];
            });
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                txt_common.text=@"";
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}


// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==txt_common) {
        if ([str_fromScreen isEqualToString:@"LinkFamily"]) {
            
        }
        else if ([str_fromScreen isEqualToString:@"DemographicDetails"] || [str_fromScreen isEqual:@"DemographicDetails"]){
            
        }
        else if ([str_fromScreen isEqualToString:@"MobilePopup"]) {
            
        }
        else{
            NSString *resultingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
            if  ([resultingString rangeOfCharacterFromSet:whitespaceSet].location == NSNotFound){
                if (resultingString.length<=10) {
                    return YES;
                }
                else{
                    return NO;
                }
            }
        }
    }
    return YES;
}
@end
