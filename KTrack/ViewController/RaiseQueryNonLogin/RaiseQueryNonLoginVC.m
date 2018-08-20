//
//  RaiseQueryNonLoginVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 28/07/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "RaiseQueryNonLoginVC.h"

@interface RaiseQueryNonLoginVC (){
    UIPickerView *picker_dropDown;
    UITextField *txt_currentTextField;
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UITextView *txtView_messageTxtView;
    __weak IBOutlet UITextField *txt_emailAddress;
    __weak IBOutlet UITextField *txt_mobileNumber;
    __weak IBOutlet UITextField *txt_name;
    NSArray *arr_fundList;
    NSString *selectedFundID;
}

@end

@implementation RaiseQueryNonLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    [self initaliseOnViewLoad];
    [txt_mobileNumber addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_emailAddress addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
}

-(void)doneAction:(UIBarButtonItem *)done{
    [txt_currentTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialise On View Load

-(void)initaliseOnViewLoad{
    //this is badriss
    [txt_emailAddress setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_mobileNumber setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_name setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [UITextView withoutRoundedCornerTextFieldView:txtView_messageTxtView forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
}

- (IBAction)btn_submitTapped:(id)sender {
    if (txt_name.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_name becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter name."];
        });
    }
    else if ([[SharedUtility sharedInstance]validateOnlyAlphabets:txt_name.text]!=YES) {
        [txt_name becomeFirstResponder];
        txt_name.text=@"";
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a correct name"];
        });
    }
    else if (txt_mobileNumber.text.length==0) {
        [txt_mobileNumber becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Mobile Number."];
    }
    else if ([[SharedUtility sharedInstance]validateMobileWithString:txt_mobileNumber.text]==NO) {
        [txt_mobileNumber becomeFirstResponder];
        txt_mobileNumber.text=@"";
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter vaild mobile number."];
    }
    else if (txt_emailAddress.text.length==0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_emailAddress becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter email ID."];
        });
    }
    else if ([[SharedUtility sharedInstance]validateEmailWithString:txt_emailAddress.text]!=YES) {
        [txt_emailAddress becomeFirstResponder];
        txt_emailAddress.text=@"";
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter vaild email ID."];
    }
    else if ([txtView_messageTxtView.text length]==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txtView_messageTxtView becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter your message"];
        });
    }
    else if ([txtView_messageTxtView.text isEqualToString:@"Query Message"] || [txtView_messageTxtView.text isEqual:@"Query Message"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txtView_messageTxtView becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter your message"];
        });
    }
    else{
        [self postRaiseAQuery];
    }
}

#pragma mark - Back Button Tapped

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTextField=textField;
    [textField becomeFirstResponder];
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==txt_mobileNumber) {
        if (txt_mobileNumber.text.length>=10 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==txt_emailAddress) {
        if (txt_emailAddress.text.length>=50 && range.length == 0){
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

#pragma mark - UITextField Delegate Ends

#pragma mark - TextViewDelegate
- (BOOL)isAcceptableTextLength:(NSUInteger)length {
    return length <= 500;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    NSLog(@"Range %@",NSStringFromRange(range));
    return [self isAcceptableTextLength:txtView_messageTxtView.text.length + string.length - range.length];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text =@"Query Message";
        textView.textColor=KTButtonBackGroundBlue;
        textView.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        //optional
    }
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *) textView {
    if ([textView.text isEqualToString:@"Query Message"] || [textView.text isEqual:@"Query Message"]) {
        [textView setText:@""];
        textView.textColor = [UIColor blackColor];
        textView.font=KTFontFamilySize(KTOpenSansRegular,12);
    }
    [textView becomeFirstResponder];
}

#pragma mark - raise a query API

-(void)raiseaQueryAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_folioNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_userName=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_name.text];
    NSString *str_userPan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_emailID=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_emailAddress.text];
    NSString *str_mobileNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_mobileNumber.text];
    NSString *str_textContent=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txtView_messageTxtView.text];
    str_textContent = [str_textContent stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *str_url = [NSString stringWithFormat:@"%@Ktrackcomplaint?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Name=%@&Folio=%@&Email=%@&Mobile=%@&Content=%@&PAN=%@", KTBaseurl, unique_UDID, str_operatingSystem, str_appVersion, str_fund, str_userName, str_folioNumber, str_emailID, str_mobileNumber, str_textContent, str_userPan];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            NSString *referStr=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Refno"]];
            if (referStr.length==0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Something went wrong. Please try again later."];
            }
            else{
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Message" forMessage:[NSString stringWithFormat:@"Complaint Successfully Registered with Reference number:\t %@",referStr] andAction1:@"OK" andAction1Block:^{
                    KTPOP(YES);
                }];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

-(void)postRaiseAQuery{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_folioNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_userName=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_name.text];
    NSString *str_emailID=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_emailAddress.text];
    NSString *str_mobileNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_mobileNumber.text];
    NSString *str_textContent=txtView_messageTxtView.text;
    str_textContent = [str_textContent stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSDictionary *paramDic=@{@"Adminusername":@"c21hcnRzZXJ2aWNl", @"Adminpassword":@"a2FydnkxMjM0JTI0", @"IMEI":unique_UDID, @"OS":str_operatingSystem, @"APKVer":str_appVersion, @"Fund":str_fund, @"Folio":str_folioNumber, @"Email":str_emailID, @"Name":str_userName, @"Mobile":str_mobileNumber, @"Content":str_textContent};
    NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"https://karvymfs.com/KTRACKAPI/SmartService.svc/Ktrackcomplaint"]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/xml"  forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
    NSError *err = nil;
    NSData *body = [NSJSONSerialization dataWithJSONObject:paramDic  options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField:@"Content-Length"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Something went wrong. Please try again later."];
            });
        }
        else{
            id newResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([newResponse isKindOfClass:[NSString class]]) {
                NSError *err = nil;
                NSData *str_data = [newResponse dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:str_data options:NSJSONReadingAllowFragments error:&err];
                if (err) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[APIManager sharedManager]hideHUD];
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Something went wrong. Please try again later."];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[APIManager sharedManager]hideHUD];
                        NSString *referStr=[NSString stringWithFormat:@"%@",responseDic[@"Table1"][0][@"Refno"]];
                        if (referStr.length==0){
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Something went wrong. Please try again later."];
                        }
                        else{
                            [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Message" forMessage:[NSString stringWithFormat:@"Complaint Successfully Registered with Reference number:\t %@",referStr] andAction1:@"OK" andAction1Block:^{
                                KTPOP(YES);
                            }];
                        }
                    });
                }
            }
            else{
              dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    NSString *referStr=[NSString stringWithFormat:@"%@",newResponse[@"Table1"][0][@"Refno"]];
                    if (referStr.length==0){
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Something went wrong. Please try again later."];
                    }
                    else{
                        [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Message" forMessage:[NSString stringWithFormat:@"Complaint Successfully Registered with Reference number:\t %@",referStr] andAction1:@"OK" andAction1Block:^{
                            KTPOP(YES);
                        }];
                    }
                });
            }
        }
    }];
    [postDataTask resume];
}

@end
