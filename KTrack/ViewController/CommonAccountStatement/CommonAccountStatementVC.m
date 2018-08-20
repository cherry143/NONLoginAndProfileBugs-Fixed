//
//  CommonAccountStatementVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 01/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "CommonAccountStatementVC.h"

@interface CommonAccountStatementVC (){
    __weak IBOutlet UITextField *txt_email;
    __weak IBOutlet UITextField *txt_password;
    __weak IBOutlet UITextField *txt_confirmPassword;
    __weak IBOutlet UILabel *lbl_serviceConsolidatedMsg;
    __weak IBOutlet UIButton *btn_submit;
}

@end

@implementation CommonAccountStatementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseTheTitlesOnViewLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (textField==txt_email) {
        if (txt_email.text.length>=50 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==txt_password) {
        if (txt_password.text.length>=50 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==txt_confirmPassword) {
        if (txt_confirmPassword.text.length>=50 && range.length == 0){
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

#pragma mark - Initialise the Value

-(void)initialiseTheTitlesOnViewLoad{
    lbl_serviceConsolidatedMsg.text=KTConsolidatedStatementMsg;
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    txt_email.text=[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserEmailID];
}

#pragma mark - Button Action

- (IBAction)btn_submitTapped:(id)sender {
        if (txt_email.text.length==0) {
            [txt_email becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter Email ID"];
        }
        else if ([[SharedUtility sharedInstance]validateEmailWithString:txt_email.text]!=YES) {
            [txt_email becomeFirstResponder];
            txt_email.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter vaild email ID."];
        }
        else if (txt_password.text.length==0) {
            [txt_password becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter password for statement."];
        }
        else if (txt_password.text.length<6){
            [txt_password becomeFirstResponder];
            txt_password.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Password for statement should contain atleast 6 characters."];
        }
        else if (txt_password.text.length>50){
            [txt_password becomeFirstResponder];
            txt_password.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Invalid Password"];
        }
        else if (txt_confirmPassword.text.length==0){
            [txt_confirmPassword becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please confirm password."];
        }
        else if (![txt_password.text isEqualToString:txt_confirmPassword.text]){
           [txt_confirmPassword becomeFirstResponder];
            txt_password.text=@"";
           [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Confirm Password and Password should be same"];
        }
        else{
            [self commonAccountStatements];
        }
}


#pragma mark - Common Account Statement

-(void)commonAccountStatements{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    NSString *str_folio=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    NSString *str_broker=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_requestBy=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"I"];
    NSString *str_pan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_soaflag=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"C"];
    NSString *str_emailID=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_email.text];
    NSString *str_password=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_password.text];
    NSString *str_loginFlag=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"Y"];
    NSString *str_url = [NSString stringWithFormat:@"%@GetAccountStatement?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&userid=%@&ReqBy=%@&Broker=%@&Fund=%@&Folio=%@&Pan=%@&Soaflag=%@&EmailId=%@&Brokermail=%@&Soapwd=%@&LoginFlag=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_requestBy,str_broker,str_fund,str_folio,str_pan,str_soaflag,str_emailID,str_emailID,str_password,str_loginFlag];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
               NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:KTSuccessMsg forMessage:error_message andAction1:@"OK" andAction1Block:^{
                    KTPOP(YES);
                }];
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:XTAPP_NAME withMessage:error_message];
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
