//
//  forgotPasswordVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 12/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "forgotPasswordVC.h"

@interface forgotPasswordVC ()<UITextFieldDelegate>{
    NSString * randaomStr;
    
}

@end

@implementation forgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.otpTf.hidden = YES;
    self.submitBtn.hidden = YES;
    self.regenerateOtpBtn.hidden = YES;
    self.otpViewline.hidden = YES;
    self.chanagePasswordView.hidden = YES;
    [self addElement ];
    // Do any additional setup after loading the view.
}
#pragma Mark 
- (void)didReceiveMemoryWarning {
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addElement{
     [UIButton roundedCornerButtonWithoutBackground:_submitBtn forCornerRadius:KTiPad?25.0f:_submitBtn.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
     [UIButton roundedCornerButtonWithoutBackground:_passSubmitBtn forCornerRadius:KTiPad?25.0f:_passSubmitBtn.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
     [UIButton roundedCornerButtonWithoutBackground:_generateOtpBtn forCornerRadius:KTiPad?25.0f:_generateOtpBtn.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    self.EmailTf.delegate =self;
    [_EmailTf setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_otpTf setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTF setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_confPasswordTf setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (IBAction)backAtc:(id)sender {
    
    KTPOP(YES);

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)generateAtc:(id)sender {
    if ([self.EmailTf.text length] == 0) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter Used ID/Email ID"];

    }else{
        [self gernaatorOTPAPI];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;  {
    if (textField == self.EmailTf) {
        self.otpTf.text =@"";
        self.otpTf.hidden = YES;
        self.submitBtn.hidden = YES;
        self.regenerateOtpBtn.hidden = YES;
        self.otpViewline.hidden = YES;
        self.chanagePasswordView.hidden = YES;
        self. generateOtpBtn.hidden = NO;
        if (_EmailTf.text.length>=50 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==self.otpTf){
        if (_otpTf.text.length>=6 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==self.passwordTF){
        if (_passwordTF.text.length>=50 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==self.confPasswordTf){
        if (_confPasswordTf.text.length>=50 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return YES;
    
}


-(void)gernaatorOTPAPI{
    END_EDITING;
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:_EmailTf.text];
    
    randaomStr= [NSString stringWithFormat:@"%d", [self getRandomNumberBetween:100000 to:900000]];
    
    NSLog(@"%@",randaomStr);
    NSString *str_random =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:randaomStr];
    NSString *str_agent =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@""];
    
    NSString *str_url = [NSString stringWithFormat:@"%@GetForgotPassword?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&userid=%@&hintquestion=%@&hintanswer=%@&emailid=%@&otp=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_agent,str_agent,str_agent,str_random];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
                [self.EmailTf setUserInteractionEnabled:NO];
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:KTSuccessMsg
                                              message:error_message
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         self.otpTf.hidden = NO;
                                         self.submitBtn.hidden = NO;
                                         self.regenerateOtpBtn.hidden = NO;
                                         self.otpViewline.hidden = NO;
                                         self.generateOtpBtn.hidden =YES;
                                         [self.otpTf becomeFirstResponder];

                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                NSLog(@"%@",responce);
            }
            else{
                self.EmailTf.text=@"";
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:XTAPP_NAME withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
    

}
- (IBAction)submitAtc:(id)sender {
    if ([self.otpTf.text length ] ==0) {
        [self.otpTf becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter OTP  "];
    }else if (![self.otpTf.text isEqualToString:randaomStr]) {
        [self.otpTf becomeFirstResponder];
        self.otpTf.text=@"";
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter valid OTP  "];
    }else{
            END_EDITING;
        _otpView.hidden=YES;
        self.chanagePasswordView.hidden = NO;
        [self.passwordTF becomeFirstResponder];
        
    }
}
- (IBAction)regenerateotpAtc:(id)sender {
    if ([self.EmailTf.text length] == 0) {
        self.EmailTf.text=@"";
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter EmailID/UserID"];
        
    }else{
        [self.EmailTf setUserInteractionEnabled:NO];
        [self gernaatorOTPAPI];
        self.otpTf.text =@"";
    }
    
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

- (IBAction)passwordSubmitAtc:(id)sender {
    NSString *Regex = @"[A-Za-z0-9^]*";
    NSPredicate *TestResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    bool validatepassword =[[SharedUtility sharedInstance]passwordIsValid:self.passwordTF.text];
    if ([self.passwordTF.text length] ==  0 ) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter Password"];
    }
    else if ([_passwordTF.text length]<8 ){
        _passwordTF.text=@"";
        [_passwordTF becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Invalid password."];
    }
    else if ([_passwordTF.text length]>50 ){
        _passwordTF.text=@"";
        [_passwordTF becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Invalid password."];
    }
    else if (validatepassword == NO){
        _passwordTF.text=@"";
        [_passwordTF becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@" Please Enter valid password"];
    }
    else if ([[SharedUtility sharedInstance]passwordIsValid:_passwordTF.text]==YES){
        BOOL conditionFailed=[TestResult evaluateWithObject:_passwordTF.text];
        if (conditionFailed==YES) {
            _passwordTF.text=@"";
            [_passwordTF becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Invalid password."];
        }
        else{
            if ( [self.confPasswordTf.text length] == 0){
                [self.confPasswordTf becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please Re-enter  Password"];
            }else if (![self.passwordTF.text isEqualToString:self.confPasswordTf.text]){
                self.confPasswordTf.text=@"";
                [self.confPasswordTf becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Password and Confirm Password should be same"];
            }
            else{
                [self resetPassword];
            }
        }
    }
}

-(void)resetPassword{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:_EmailTf.text];
    
    NSString *newpwd= [_passwordTF.text stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"%@",randaomStr);
    NSString *str_password =[XTAPP_DELEGATE convertToBase64StrForAGivenString:newpwd];
    NSString *str_agent =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@"I"];
    NSString *str_url = [NSString stringWithFormat:@"%@ResetPassword?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&userid=%@&newPassword=%@&oldpassword=%@&ReqBy=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_password,str_password,str_agent];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [self showAlertWithTitle:KTSuccessMsg forMessage:error_message];
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
                             LoginVC *destination=[KTHomeStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"LoginVC"];
                             KTPUSH(destination,YES);
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
