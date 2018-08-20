//
//  CancelSTConfirmationVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 01/08/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "CancelSTConfirmationVC.h"

@interface CancelSTConfirmationVC (){
    __weak IBOutlet UIView *view_SwitchSIPSWP;
    __weak IBOutlet UIView *view_switchSTPView;
    __weak IBOutlet UILabel *lbl_switchInScheme;
    __weak IBOutlet UIView *view_confirmation;
    __weak IBOutlet UILabel *lbl_switchOutScheme;
    __weak IBOutlet UITextField *txt_enterOTP;
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UIButton *btn_regenrateOTP;
    __weak IBOutlet UIView *view_otpView;
    __weak IBOutlet UIButton *btn_generateOTP;
    __weak IBOutlet UILabel *lbl_investorName;
    __weak IBOutlet UILabel *lbl_amount;
    __weak IBOutlet UILabel *lbl_pan;
    __weak IBOutlet UILabel *lbl_endDate;
    __weak IBOutlet UILabel *lbl_startDate;
    __weak IBOutlet UILabel *lbl_frequency;
    __weak IBOutlet UILabel *lbl_scheme;
    __weak IBOutlet UILabel *lbl_folio;
    __weak IBOutlet UILabel *lbl_fund;
    NSString *str_randomGeneratedOTP;
    __weak IBOutlet UILabel *lbl_registrationDate;
    __weak IBOutlet UILabel *lbl_transactionType;
}

@end

@implementation CancelSTConfirmationVC
@synthesize dic_cancellationRecord, str_investorName, str_selectedPAN, str_showSTP, str_fromScreen;
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
    lbl_fund.text=[NSString stringWithFormat:@"%@",str_fromScreen];
    lbl_folio.text=[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"acno"]];
    lbl_pan.text=[NSString stringWithFormat:@"%@",str_selectedPAN];
    lbl_investorName.text=[NSString stringWithFormat:@"%@",str_investorName];
    if ([str_showSTP isEqualToString:@"YES"]|| [str_showSTP isEqual:@"YES"]) {
        [view_SwitchSIPSWP setHidden:YES];
        [view_switchSTPView setHidden:NO];
        lbl_scheme.text=@"";
        lbl_switchInScheme.text=[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"switchin"]];
        lbl_switchOutScheme.text=[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"switchout"]];
    }
    else{
        [view_SwitchSIPSWP setHidden:NO];
        [view_switchSTPView setHidden:YES];
        lbl_scheme.text=[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"Scheme"]];
        lbl_switchInScheme.text=@"";
        lbl_switchOutScheme.text=@"";
    }
    lbl_transactionType.text=[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"trtype"]];
    lbl_registrationDate.text=[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"trdate"]];
    lbl_startDate.text=[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"fromdate"]];
    lbl_endDate.text=[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"todate"]];
    lbl_frequency.text=[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"freq"]];
    lbl_amount.text=[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"amt"]];
    [view_otpView setHidden:YES];
    [btn_generateOTP setHidden:NO];
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
}

#pragma mark - Generate OTP

- (IBAction)btn_generateOTP:(id)sender {
    [view_otpView setHidden:NO];
    [btn_generateOTP setHidden:YES];
    str_randomGeneratedOTP=[NSString stringWithFormat:@"%d", [self getRandomNumberBetween:100000 to:900000]];
    [self generateSWPOTPToRegisteredMobileNumber:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"mobile"]] forOTP:str_randomGeneratedOTP];
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
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@", dic_cancellationRecord[@"fund"]]];
    NSString *str_folio=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@", dic_cancellationRecord[@"acno"]]];
    NSString *str_mobile=[XTAPP_DELEGATE convertToBase64StrForAGivenString:userEnterMobileNumber];
    NSString *str_transactionType=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@", dic_cancellationRecord[@"trtype"]]];
    NSString *str_url = [NSString stringWithFormat:@"%@GenerateOTP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Folio=%@&OtpPin=%@&MobileNo=%@&TranType=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_folio,str_otpPin,str_mobile,str_transactionType];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                NSString *code =[NSString stringWithFormat:@"XXXXXX%@",[userEnterMobileNumber substringFromIndex: [userEnterMobileNumber length]-4]];
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Information" forMessage:[NSString stringWithFormat:@"OTP has been sent to your mobile number %@. Please confirm your Cancellation by entering the OTP received.",code] andAction1:@"OK" andAction1Block:^{
                    
                }];
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
    NSString *serverStartDate, *serverEndDate, *serverTransactDate;
    @try{
        NSDateFormatter *dateServerFormatter = [[NSDateFormatter alloc] init];
        [dateServerFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *startDate = [dateServerFormatter dateFromString:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"fromDate"]]];
        NSDate *endDate = [dateServerFormatter dateFromString:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"toDate"]]];
        NSDate *transactDate = [dateServerFormatter dateFromString:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"trdate"]]];
        [dateServerFormatter setDateFormat:@"MM/dd/yyyy"];
        serverStartDate =[NSString stringWithFormat:@"%@",[dateServerFormatter stringFromDate:startDate]];
        serverEndDate =[NSString stringWithFormat:@"%@",[dateServerFormatter stringFromDate:endDate]];
        serverTransactDate =[NSString stringWithFormat:@"%@",[dateServerFormatter stringFromDate:transactDate]];
    }
    @catch (NSException *exception){
        serverStartDate =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"fromDate"]]];
        serverEndDate =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"toDate"]]];
        serverTransactDate =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"trdate"]]];
    }
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_zeroEncode=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    NSString *str_transactionType=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"trtype"]]];
    NSString *str_empty=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_userID=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]]];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"fund"]]];
    NSString *str_scheme=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"sch"]]];
    NSString *str_folio=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"acno"]]];
    NSString *str_toScheme=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"tsch"]]]]];
    NSString *str_lname=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"lname"]]]]];
    NSString *str_amt=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"amt"]]]]];
    NSString *str_ihno=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"ihno"]]]]];
    NSString *str_mobile=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"mobile"]]]]];
    NSString *str_opt=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"opt"]]]]];
    NSString *str_pln=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"pln"]]]]];
    NSString *str_url = [NSString stringWithFormat:@"%@SIPCancelSave?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Scheme=%@&Toscheme=%@&Plan=%@&Optn=%@&Acno=%@&trdate=%@&branch=%@&trtype=%@&lname=%@&entby=%@&ihno=%@&Refno=%@&batchno=%@&rcpno=%@&appldt=%@&termdt=%@&cycledtpart=%@&cycleihno=%@&amt=%@&remarks=%@&barcode=%@&mobile=%@&subTrType=%@&chqtype=%@&allotmentFlag=%@&dpid=%@&clientid=%@&cmlflag=%@&disitributorid=%@&subBrokerCode=%@&todate=%@&errno=%@",KTBaseurl, unique_UDID, str_operatingSystem, str_appVersion, str_fund, str_scheme, str_toScheme, str_pln, str_opt, str_folio, serverTransactDate, str_empty, str_transactionType, str_lname, str_userID, str_ihno, str_ihno, str_zeroEncode, str_empty, str_empty, serverStartDate, str_empty, str_zeroEncode, str_amt, str_empty, str_empty, str_mobile, str_empty, str_empty, str_empty, str_empty, str_empty, str_empty, str_empty, str_empty, serverEndDate, str_zeroEncode];
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

#pragma mark regenerate OTP

- (IBAction)btn_regenerateOTPTapped:(id)sender {
    str_randomGeneratedOTP=[NSString stringWithFormat:@"%d", [self getRandomNumberBetween:100000 to:900000]];
    [self generateSWPOTPToRegisteredMobileNumber:[NSString stringWithFormat:@"%@",dic_cancellationRecord[@"mobile"]] forOTP:str_randomGeneratedOTP];
}

@end
