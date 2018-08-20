//
//  SWPConfirmationVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 12/07/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "SWPConfirmationVC.h"

@interface SWPConfirmationVC (){
    __weak IBOutlet UIView *view_confirmation;
    __weak IBOutlet UITextField *txt_enterOTP;
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UIButton *btn_regenrateOTP;
    __weak IBOutlet UIView *view_otpView;
    __weak IBOutlet UIButton *btn_generateOTP;
    __weak IBOutlet UIView *view_amountView;
    __weak IBOutlet UILabel *lbl_investorName;
    __weak IBOutlet UILabel *lbl_amount;
    __weak IBOutlet UILabel *lbl_pan;
    __weak IBOutlet UILabel *lbl_swpEndDate;
    __weak IBOutlet UILabel *lbl_startDate;
    __weak IBOutlet UILabel *lbl_swpDay;
    __weak IBOutlet UILabel *lbl_frequency;
    __weak IBOutlet UILabel *lbl_noOfWidthdrawal;
    __weak IBOutlet UILabel *lbl_swpOption;
    __weak IBOutlet UILabel *lbl_scheme;
    __weak IBOutlet UILabel *lbl_folio;
    __weak IBOutlet UILabel *lbl_fund;
    NSString *str_randomGeneratedOTP;
    
}
@end

@implementation SWPConfirmationVC
@synthesize selected_swpDetails,hideAmountView,str_fromScreen;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseOnViewLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewInitialise View Load

-(void)initialiseOnViewLoad{
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_generateOTP forCornerRadius:KTiPad?25.0f:btn_generateOTP.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIView roundedCornerEnableForView:view_confirmation forCornerRadius:10.0f forBorderWidth:0.0f forApplyShadow:NO];
    [self loadValueIntoFields];
}

#pragma mark - load Value Into Fields

-(void)loadValueIntoFields{
    lbl_fund.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"fundName"]];
    lbl_folio.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"folioName"]];
    lbl_scheme.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"schemeName"]];
    lbl_swpOption.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"SWPOption"]];
    lbl_noOfWidthdrawal.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"numberWidthdrawals"]];
    lbl_frequency.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"SWPFrequency"]];
    lbl_swpDay.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"SWPDay"]];
    lbl_startDate.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"SWPStartDate"]];
    lbl_swpEndDate.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"SWPEndDate"]];
    lbl_pan.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"PAN"]];
    lbl_investorName.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"investorName"]];
    if (hideAmountView==YES) {
        [view_amountView setHidden:YES];
    }
    else{
        lbl_amount.text=[NSString stringWithFormat:@"%@",selected_swpDetails[@"amount"]];
    }
    [view_otpView setHidden:YES];
    [btn_generateOTP setHidden:NO];
}

#pragma mark - Generate OTP

- (IBAction)btn_generateOTP:(id)sender {
    [view_otpView setHidden:NO];
    [btn_generateOTP setHidden:YES];
    str_randomGeneratedOTP=[NSString stringWithFormat:@"%d", [self getRandomNumberBetween:100000 to:900000]];
    [self generateSWPOTPToRegisteredMobileNumber:[NSString stringWithFormat:@"%@",selected_swpDetails[@"MobileNumber"]] forOTP:str_randomGeneratedOTP];
}

#pragma mark - submit otp

- (IBAction)btn_submitTapped:(id)sender {
    if (txt_enterOTP.text.length==0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_enterOTP becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter OTP."];
        });
    }
    else if (!([str_randomGeneratedOTP isEqualToString:txt_enterOTP.text] || [str_randomGeneratedOTP isEqual:txt_enterOTP.text])) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_enterOTP becomeFirstResponder];
            txt_enterOTP.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Invalid OTP."];
        });
    }else{
        [self submitSWPDetailsToServer];
    }
}

#pragma mark - back tapped

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

#pragma mark - Generate OTP

-(void)generateSWPOTPToRegisteredMobileNumber:(NSString *)userEnterMobileNumber forOTP:(NSString *)generatedOTP{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_otpPin=[XTAPP_DELEGATE convertToBase64StrForAGivenString:generatedOTP];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"fundID"]]];
    NSString *str_folio=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"folioID"]]];
    NSString *str_mobile=[XTAPP_DELEGATE convertToBase64StrForAGivenString:userEnterMobileNumber];
    NSString *str_transactionType=@"SWP";
    NSString *str_url = [NSString stringWithFormat:@"%@GenerateOTP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Folio=%@&OtpPin=%@&MobileNo=%@&TranType=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_folio,str_otpPin,str_mobile,str_transactionType];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                if ([str_fromScreen isEqual:@"Family"] || [str_fromScreen isEqualToString:@"Family"]) {
                    [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Information" forMessage:@"You have initiated SWP transaction for your Family member and OTP has been sent to the registered email ID and mobile number of the Family Folio. Please enter the OTP to submit the transaction for further processing." andAction1:@"OK" andAction1Block:^{
                        
                    }];
                }
                else{
                    NSString *code =[NSString stringWithFormat:@"XXXXXX%@",[userEnterMobileNumber substringFromIndex: [userEnterMobileNumber length]-4]];
                    [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Information" forMessage:[NSString stringWithFormat:@"OTP has been sent to your mobile number %@. Please confirm SWP transaction by entering the OTP received.",code] andAction1:@"OK" andAction1Block:^{
                        
                    }];
                }
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
        });
    }];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

#pragma mark - SWP Confirmation API Call

-(void)submitSWPDetailsToServer{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *serverStartDate;
    NSString *serverEndDate;
    @try{
        NSDateFormatter *dateServerFormatter = [[NSDateFormatter alloc] init];
        [dateServerFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *startDate = [dateServerFormatter dateFromString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"SWPStartDate"]]];
        NSDate *endDate = [dateServerFormatter dateFromString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"SWPEndDate"]]];
        [dateServerFormatter setDateFormat:@"MM/dd/yyyy"];
        serverStartDate =[NSString stringWithFormat:@"%@",[dateServerFormatter stringFromDate:startDate]];
        serverEndDate =[NSString stringWithFormat:@"%@",[dateServerFormatter stringFromDate:endDate]];
    }
    @catch (NSException *exception){
        serverStartDate =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",selected_swpDetails[@"SWPStartDate"]]];
        serverEndDate =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",selected_swpDetails[@"SWPEndDate"]]];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:XTOnlyDateFormat];
    NSString *datestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"fundID"]]];
    NSString *str_scheme=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"schemeID"]]];
    NSString *str_folioNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"folioID"]]];
    NSString *str_plan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"schemePlan"]]];
    NSString *str_otpn=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"schemeOption"]]];
    NSString *str_withdrawType=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"SWPOption"]]];
    NSString *str_withdrawFreq=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"SWPFrequency"]]];
    NSString *str_withdrawTRDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:datestamp];
    NSString *str_withdrawStartDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",serverStartDate]];
    NSString *str_withdrawEndDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",serverEndDate]];
    NSString *str_withdrawNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"numberWidthdrawals"]]];
    NSString *str_amount=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"amount"]]];
    NSString *str_transactType=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"SWP"];
    NSString *str_branch=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    NSString *str_entBy=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_Ihno=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"IHNO"]]];
    NSString *str_refernceNo=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"RefNo"]]];
    NSString *str_branchNo=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"BatchNo"]]];
    NSString *str_remarks=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    NSString *str_Errno=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"ErrNo"]]];
    NSString *str_url = [NSString stringWithFormat:@"%@SWPDetailsSave?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Scheme=%@&Plan=%@&Optn=%@&Acno=%@&Withdrawaltype=%@&Freq=%@&Trdate=%@&Stdt=%@&Enddt=%@&Noofwithdrawals=%@&Amount=%@&Branch=%@&Trtype=%@&Entby=%@&Ihno=%@&Refno=%@&Batchno=%@&Remarks=%@&Errno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_scheme,str_plan,str_otpn,str_folioNumber,str_withdrawType,str_withdrawFreq,str_withdrawTRDate,str_withdrawStartDate,str_withdrawEndDate,str_withdrawNumber,str_amount,str_branch,str_transactType,str_entBy,str_Ihno,str_refernceNo,str_branchNo,str_remarks,str_Errno];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            int error_statuscode=[responce[@"Table"][0][@"Error_code"]intValue];
            if(error_statuscode==0) {
                KtoMConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"KtoMConVC"];
                destination.refStr =[NSString stringWithFormat:@"%@",responce[@"Table1"][0][@"RefNo"]];
                KTPUSH(destination,YES);
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SWP Confirmation On View Load

-(void)showSTPSWPConfirmation{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"fundID"]]];
    NSString *str_referenceNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",selected_swpDetails[@"RefNo"]]];
    NSString *str_url = [NSString stringWithFormat:@"%@ShowSTPSWPConfirmation?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Refno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_referenceNumber];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
        });
    }];
}

#pragma mark regenerate OTP

- (IBAction)btn_regenerateOTPTapped:(id)sender {
    str_randomGeneratedOTP=[NSString stringWithFormat:@"%d", [self getRandomNumberBetween:100000 to:900000]];
    [self generateSWPOTPToRegisteredMobileNumber:[NSString stringWithFormat:@"%@",selected_swpDetails[@"MobileNumber"]] forOTP:str_randomGeneratedOTP];
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
    if (textField==txt_enterOTP) {
        if (txt_enterOTP.text.length>=6 && range.length == 0){
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

@end
