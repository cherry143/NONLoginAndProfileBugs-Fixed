//
//  STPCinfVc.m
//  KTrack
//
//  Created by  ramakrishna.MV on 03/08/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "STPCinfVc.h"

@interface STPCinfVc (){
    
    __weak IBOutlet UILabel *lbl_schemeIN;
    __weak IBOutlet UILabel *lbl_fund;
    __weak IBOutlet UILabel *lbl_foilo;
    
    
    __weak IBOutlet UILabel *lbl_schemmeOut;
    __weak IBOutlet UILabel *lbl_schemein;
    
    __weak IBOutlet UILabel *lbl_pan;
    
    __weak IBOutlet UILabel *lbl_name;
    __weak IBOutlet UILabel *lbl_noofin;
    __weak IBOutlet UILabel *Stp_cycle;
    
    __weak IBOutlet UILabel *lbl_stpOption;
    __weak IBOutlet UILabel *lbl_subArn;
    __weak IBOutlet UILabel *lbl_endDate;
    __weak IBOutlet UILabel *lbl_stpStartDate;
    __weak IBOutlet UILabel *lbl_arn;
    __weak IBOutlet UILabel *lbl_amount;
    __weak IBOutlet UILabel *lbl_amomtType;
    __weak IBOutlet UIView *view_details;
    __weak IBOutlet UIView *view_amount;
    
    
    __weak IBOutlet UIView *view_otp;
    __weak IBOutlet UIView *view_submit;
    __weak IBOutlet UITextField *txt_otp;

    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UIButton *btn_genentar;
    
    NSString *paymentModeStr;
    __weak IBOutlet UITableView *payModeTaleview;
    NSString *MobileStr;
    NSString *title_BankID,*title_Bank,*randaomStr;
}

@end

@implementation STPCinfVc
- (IBAction)back:(id)sender {
    
        KTPOP(true);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIButton roundedCornerButtonWithoutBackground:btn_genentar forCornerRadius:KTiPad?25.0f:btn_genentar.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    
 
    [view_details .layer setCornerRadius:15.0f];
    [view_details.layer setMasksToBounds:YES];
    NSLog(@"%@",self.schemeDic);
    NSLog(@"%@",self.schemmeDetialsDic);
    NSLog(@"%@",self.DetialsDic);



lbl_fund.text =_DetialsDic[@"fundName"];
    lbl_foilo.text =_DetialsDic[@"folioName"];
    lbl_schemmeOut.text = [NSString stringWithFormat:@"%@",_schemeDic.schDesc];
      lbl_schemein.text =  [NSString stringWithFormat:@"%@",self.schemmeDetialsDic[@"fm_schdesc"]];
    lbl_schemeIN.text =  [NSString stringWithFormat:@"%@",self.schemmeDetialsDic[@"fm_schdesc"]];
    lbl_pan.text =_DetialsDic[@"PAN"];
    lbl_name.text =_DetialsDic[@"investorName"];
    lbl_stpOption.text =_DetialsDic[@"STPOption"];
    lbl_noofin.text =_DetialsDic[@"numberWidthdrawals"];
Stp_cycle.text = [NSString stringWithFormat:@"%@ of every %@",_DetialsDic[@"STPDay"],_DetialsDic[@"STPFrequency"]];
    lbl_endDate.text = [NSString stringWithFormat:@"%@",_DetialsDic[@"STPEndDate"]];
      lbl_stpStartDate.text =[NSString stringWithFormat:@"%@",_DetialsDic[@"STPStartDate"]];
    lbl_amomtType.text =[NSString stringWithFormat:@"STP Installment Amount"];
      lbl_amount.text=[NSString stringWithFormat:@"%@",_DetialsDic[@"amount"]];
    MobileStr= [NSString stringWithFormat:@"%@",_DetialsDic[@"mobileNumber"]];
    if ([_DetialsDic[@"Arn"]  length] == 0 ) {
        lbl_arn.text=@"--";

    }else{
        lbl_arn.text=_DetialsDic[@"Arn"];

    }
    
    if ([_DetialsDic[@"SubArn"] length ]== 0 ) {
        lbl_subArn.text=@"--";
    }else{
        lbl_subArn.text=_DetialsDic[@"SubArn"];
    }
//    lbl_pan.text =self.str_pan;
//
//                lbl_schemmeOut.text = [NSString stringWithFormat:@"%@",_schemeDic.schDesc];

//
//
//
//    lbl_amount.text =[NSString stringWithFormat:@"%@ ₹",self.str_Amount];
//
//
//    lbl_name.text = _str_name;
//    lbl_foilo.text = _str_folio;
//    lbl_subArn.text = _str_subarn;
//    lbl_arn.text = _str_arn;
//    lbl_noofin.text = [NSString stringWithFormat:@" %@",self.str_installments];
//    lbl_stpStartDate.text = [NSString stringWithFormat:@"%@",self.str_SipStartDay];
//    lbl_endDate.text = [NSString stringWithFormat:@"%@",self.str_SipEndDay];
//
//
//
//
    [view_submit setHidden:true];

    
    // Do any additional setup after loading the view.
}
- (IBAction)atc_regenertor:(id)sender {
    
    [self gnerateOtp];
}
- (IBAction)atc_submit:(id)sender {
    
    if ([txt_otp.text length] == 0) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter the OTP"];
        
    }else if (![txt_otp.text isEqualToString:randaomStr]) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter valid OTP"];
        
    }else{
        
            NSLog(@"%@",self.DetialsDic);
        [self STPsubmitamount];
    }
}
- (IBAction)atc_generateOtp:(id)sender {
    
    [self gnerateOtp];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)STPsubmitamount{
    
//
//    selectedSecheme=[NSString stringWithFormat:@"%@",scheRec.sch];
//    lbl_currentvalue.text=[NSString stringWithFormat:@"%@",scheRec.curValue];
//    lbl_balanceUnits.text=[NSString stringWithFormat:@"%@",scheRec.balUnits];
//    lbl_amount.text=[NSString stringWithFormat:@"Minimum Amount ( ₹ ) : %1.f",[scheRec.redMinAmt floatValue]];
//    mini_amount = [NSString stringWithFormat:@"%1.f",[scheRec.redMinAmt floatValue]];
//    str_selectedSchType=[NSString stringWithFormat:@"%@",scheRec.schType];
//    str_selectedSchPlan=[NSString stringWithFormat:@"%@",scheRec.pln];
//    str_selectedSchOption=[NSString stringWithFormat:@"%@",scheRec.opt];
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_DetialsDic[@"fundID"]];
    NSString *str_foilo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:lbl_foilo.text];
    NSString *str_selectedSecheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_schemeDic.sch];
    
    NSString *str_plan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_schemeDic.pln];
    NSString *str_Option =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_schemeDic.opt];
    NSString *str_TargetSchPln=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *enc_arn;
    
    
 
        enc_arn=[XTAPP_DELEGATE convertToBase64StrForAGivenString:_DetialsDic[@"Arn"]];
    
    NSString *enc_subarn;
    
    
  
        enc_subarn=[XTAPP_DELEGATE convertToBase64StrForAGivenString:_DetialsDic[@"SubArn"]];
    
 
    NSString *enc_eun,*enc_euinflag;


        enc_eun=[XTAPP_DELEGATE convertToBase64StrForAGivenString:_DetialsDic[@"euin"]];
        enc_euinflag=[XTAPP_DELEGATE convertToBase64StrForAGivenString:_DetialsDic[@"enc_euinflag"]];
    

    
    NSString *str_tscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_schemmeDetialsDic[@"fm_scheme"]];
    NSString *str_tPlan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_schemmeDetialsDic[@"fm_plan"]];
    NSString *str_toption =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_schemmeDetialsDic[@"fm_option"]];
    NSString *str_fre=[XTAPP_DELEGATE convertToBase64StrForAGivenString:_DetialsDic[@"STPFrequency"]];
    
    
    
    NSString *serverStartDate;
    NSString *serverEndDate;
    @try{
        NSDateFormatter *dateServerFormatter = [[NSDateFormatter alloc] init];
        [dateServerFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *startDate = [dateServerFormatter dateFromString:[NSString stringWithFormat:@"%@",lbl_stpStartDate.text]];
        NSDate *endDate = [dateServerFormatter dateFromString:[NSString stringWithFormat:@"%@",lbl_endDate.text]];
        [dateServerFormatter setDateFormat:@"MM/dd/yyyy"];
        serverStartDate =[NSString stringWithFormat:@"%@",[dateServerFormatter stringFromDate:startDate]];
        serverEndDate =[NSString stringWithFormat:@"%@",[dateServerFormatter stringFromDate:endDate]];
    }
    @catch (NSException *exception){
        serverStartDate =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",lbl_stpStartDate.text]];
        serverEndDate =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",lbl_endDate.text]];
    }
    
    
    NSLog(@"serverStartDate   %@",serverStartDate);
    NSLog(@"serverStartDate   %@",serverStartDate);
    
    //    tf_sipStartDay.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:startDate]];
    NSString *str_endDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:serverStartDate];
    NSString *str_toDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:serverEndDate];
    NSString *str_tNoofTransfer=[XTAPP_DELEGATE convertToBase64StrForAGivenString:lbl_noofin.text];
    NSString *str_Amount;
    


    

        str_Amount=[XTAPP_DELEGATE convertToBase64StrForAGivenString:lbl_amount.text];
    

    
    NSDateFormatter *daateFormatter = [[NSDateFormatter alloc] init];
    [daateFormatter setDateFormat:XTOnlyDateFormat];
    NSString *datestamp = [daateFormatter stringFromDate:[NSDate date]];
    NSString *str_withdrawTRDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:datestamp];
    NSString *str_tr_type=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"STP"];
    NSString *str_i_EntBy=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    
//    enc_error
    NSString *str_ErrNo=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",_DetialsDic[@"ErrNo"]]];
    NSString *str_Batchno=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",_DetialsDic[@"BatchNo"]]];
    NSString *str_Ihno=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",_DetialsDic[@"IHNO"]]];
    NSString *str_Refno=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",_DetialsDic[@"RefNo"]]];
        NSString *str_BatchNo=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",_DetialsDic[@"BatchNo"]]];
    NSString *str_url = [NSString stringWithFormat:@"%@SaveSTP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Acno=%@&Scheme=%@&Plan=%@&i_option=%@&TargetSchPln=%@&Distributor=%@&Subbroker=%@&Euin=%@&Euinvalid=%@&ToScheme=%@&Toplan=%@&Tooption=%@&DividendOption=%@&Freq=%@&Stdt=%@&Enddt=%@&NoofTransfer=%@&Amount=%@&Branch=%@&Trdate=%@&Trtype=%@&Entby=%@&Ihno=%@&Refno=%@&Batchno=%@&Remarks=%@&Barcode=%@&Errno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_foilo,str_selectedSecheme,str_plan,str_Option,str_TargetSchPln,enc_arn,enc_subarn,enc_eun,enc_euinflag,str_tscheme,str_tPlan,str_toption,str_TargetSchPln,str_fre,str_endDate,str_toDate,str_tNoofTransfer,str_Amount,str_BatchNo,str_withdrawTRDate,str_tr_type,str_i_EntBy,str_Ihno,str_Refno,str_Batchno,str_TargetSchPln,str_TargetSchPln,str_ErrNo];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            KtoMConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"KtoMConVC"];
            
            destination.refStr =[NSString stringWithFormat:@"%@",responce[@"DtData"][0][@"RefNo"]];
            KTPUSH(destination,YES);
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}
-(void)gnerateOtp{
        [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    randaomStr= [NSString stringWithFormat:@"%d", [self getRandomNumberBetween:100000 to:900000]];
    
    NSLog(@"randaomStr         fdverfv   %@",randaomStr);
    
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    
    
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_DetialsDic[@"fundID"]];
    NSString *str_enfolio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_DetialsDic[@"folioName"]];
    NSString *str_mobile =[XTAPP_DELEGATE convertToBase64StrForAGivenString:MobileStr];
    NSString *str_otp =[XTAPP_DELEGATE convertToBase64StrForAGivenString:randaomStr];
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@GenerateOTP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Folio=%@&OtpPin=%@&MobileNo=%@&TranType=Uw",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_enfolio,str_otp,str_mobile];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
          [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            NSLog(@"%@",responce);
            
            [view_submit setHidden:NO];
        
            [view_otp setHidden:YES];

            if([_DetialsDic[@"famliyStr"] isEqualToString:@"PrimaryPan"]){
                
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTSuccessMsg withMessage:@"OTP has been sent to your mobile number, Please confirm STP transaction by entering the OTP received"];
                
            }else{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTSuccessMsg withMessage:@"You have initiated STP transaction for your Family member and OTP has been sent to the registered email ID and mobile number of the Family Folio. Please enter the OTP to submit the transaction for further processing."];
            }
        }else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
