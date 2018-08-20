//
//  ForgotUserIDVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 12/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "ForgotUserIDVC.h"

@interface ForgotUserIDVC (){
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UITextField *txt_enterEmailID;
}

@end

@implementation ForgotUserIDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [txt_enterEmailID setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_submitClicked:(UIButton *)sender {
    if ([txt_enterEmailID.text isEqual:@""]||[txt_enterEmailID.text isEqual:NULL]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_enterEmailID becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Email ID"];
        });
    }
    else{
        if ([[SharedUtility sharedInstance]validateEmailWithString:txt_enterEmailID.text]==YES) {
            [self callForgotUserIDAPI];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_enterEmailID becomeFirstResponder];
                txt_enterEmailID.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a valid Email ID"];
            });
        }
    }
}

#pragma mark - ForgotUserID API

-(void)callForgotUserIDAPI{
    END_EDITING;
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_loginType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"i"];
    NSString *str_emailID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_enterEmailID.text];
    NSString *str_url = [NSString stringWithFormat:@"%@GetForgotUsername?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Emailid=%@&ReqBy=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_emailID,str_loginType];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [self showAlertWithTitle:KTSuccessMsg forMessage:error_message];
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
    if (textField==txt_enterEmailID) {
        if (txt_enterEmailID.text.length>=50 && range.length == 0){
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

#pragma mark - TouchEvents

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    END_EDITING;
    [super touchesBegan:touches withEvent:event];
}

-(void)showAlertWithTitle:(NSString *)strTitle forMessage:(NSString *)strMessage{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:strTitle
                                  message:strMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             KTPOP_ROOT(YES);
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - BacK Button Action

- (IBAction)backAct:(UIButton *)sender {
    KTPOP(YES);
}

@end
