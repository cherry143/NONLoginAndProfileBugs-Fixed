//
//  ChangePasswordVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 01/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC (){
    __weak IBOutlet UITextField *txt_confirmNewPassword;
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UITextField *txt_newPassword;
    __weak IBOutlet UITextField *txt_oldPassword;
}

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseViewLoad];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"ChangePassword"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - corner for button

-(void)initialiseViewLoad{
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
}

#pragma mark - submit button tapped

- (IBAction)btn_submitTapped:(UIButton *)sender {
    NSString *Regex = @"[A-Za-z0-9^]*";
    NSPredicate *TestResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    if (txt_oldPassword.text.length==0) {
        [txt_oldPassword becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter old password."];
    }
    else if (txt_newPassword.text.length==0) {
        [txt_newPassword becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter new password."];
    }
    else if (txt_newPassword.text.length<8){
        [txt_newPassword becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Invalid password."];
    }
    else if (txt_newPassword.text.length>50){
        [txt_newPassword becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Invalid password."];
    }
    else if ([txt_oldPassword.text isEqualToString:txt_newPassword.text]){
        [txt_newPassword becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Old password and new password should not be same."];
    }
    else if ([[SharedUtility sharedInstance]passwordIsValid:txt_newPassword.text]==NO){
        [txt_newPassword becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter valid password"];
    }
    else if ([[SharedUtility sharedInstance]passwordIsValid:txt_newPassword.text]==YES){
        BOOL conditionFailed=[TestResult evaluateWithObject:txt_newPassword.text];
        if (conditionFailed==YES) {
            [txt_newPassword becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Invalid password."];
        }
        else{
            if (txt_confirmNewPassword.text.length==0){
                [txt_confirmNewPassword becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter confirm new password."];
            }
            else if (![txt_newPassword.text isEqualToString:txt_confirmNewPassword.text]){
                [txt_confirmNewPassword becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Password and Confirm Password should be same"];
            }
            else{
                [self changePasswordAPI];
            }
        }
    }
    
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==txt_newPassword) {
        if (txt_newPassword.text.length>=50 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==txt_confirmNewPassword) {
        if (txt_confirmNewPassword.text.length>=50 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==txt_oldPassword) {
        if (txt_oldPassword.text.length>=50 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

// return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

// called when clear button pressed. return NO to ignore (no notifications)

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TextFields Delegate Methods Ends

#pragma mark - change password API

-(void)changePasswordAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_oldPassword=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_oldPassword.text];
    NSString *str_newPassword=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_newPassword.text];
    NSString *str_requestBy=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"I"];
    NSString *str_url = [NSString stringWithFormat:@"%@GetChangePassword?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&userid=%@&newPassword=%@&oldpassword=%@&ReqBy=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_newPassword,str_oldPassword,str_requestBy];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
            if (error_statuscode==0) {
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:KTSuccessMsg forMessage:error_message andAction1:@"OK" andAction1Block:^{
                    [[SharedUtility sharedInstance]removeUserDefaults];
                    LoginVC *destination=[KTHomeStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"LoginVC"];
                    KTPUSH(destination,YES);
                }];
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Back Tapped Action

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

@end
