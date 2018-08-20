//
//  CASVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 12/04/18.
//  Copyright © 2018 narasimha. All rights reserved.2
//

#import "CASVC.h"

@interface CASVC ()

@end

@implementation CASVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addElements];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark Add Elements
-(void)addElements{
    [self.submtBtn.layer setCornerRadius:15.0f];
    [self.submtBtn.layer setMasksToBounds:YES];
    [_emaiLTF setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_paswordTf setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txt_confirmPassword setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [UIButton roundedCornerButtonWithoutBackground:_submtBtn forCornerRadius:KTiPad?25.0f:_submtBtn.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
}

- (IBAction)backAtc:(id)sender {
    KTPOP(YES);
}

- (IBAction)submitAtc:(id)sender {
    bool  validateEmail =[[APIManager sharedManager] validateEmail:self.emaiLTF.text];
    if ([self.emaiLTF.text length] == 0){
        [self.emaiLTF becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please Enter Email ID."];
    }
    else if (!validateEmail) {
        self.emaiLTF.text=@"";
        [self.emaiLTF becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Invalid Email Id"];
    }
    else if ([self.paswordTf.text length] == 0 ) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please Enter Password"];
    }
    else if ([self.txt_confirmPassword.text length] == 0 ) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please Enter Confirm password"];
    }
    else if (![self.paswordTf.text isEqualToString:self.txt_confirmPassword.text]){
        self.txt_confirmPassword.text=@"";
        [_txt_confirmPassword becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Password and Confirm Password should be same."];
    }
    else{
        [self CASapi];
    }

}

-(void)CASapi{
    [self.emaiLTF resignFirstResponder];
    [self.paswordTf resignFirstResponder];
    END_EDITING;
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:_emaiLTF.text];
    NSString *str_password =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:_paswordTf.text];

    NSString *str_fund =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@"0"];
    NSString *str_agent =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@""];
    NSString *str_cfla =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@"C"];
    NSString *str_req =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@"I"];

  NSString *str_url = [NSString stringWithFormat:@"%@GetAccountStatement?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&userid=%@&Broker=%@&Fund=%@&Folio=%@&Pan=%@&Soaflag=%@&ReqBy=%@&EmailId=%@&Brokermail=%@&Soapwd=%@&LoginFlag=N",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_agent,str_fund,str_fund,str_agent,str_cfla,str_req,str_userId,str_userId,str_password];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [self showAlertWithTitle:KTSuccessMsg forMessage:error_message];
                NSLog(@"%@",responce);
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:XTAPP_NAME withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
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
                             KTPOP(YES);
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
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
    if (textField==_emaiLTF) {
        if (_emaiLTF.text.length>=50 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==_paswordTf) {
        if (_paswordTf.text.length>=50 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==_txt_confirmPassword) {
        if (_txt_confirmPassword.text.length>=50 && range.length == 0){
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
@end
