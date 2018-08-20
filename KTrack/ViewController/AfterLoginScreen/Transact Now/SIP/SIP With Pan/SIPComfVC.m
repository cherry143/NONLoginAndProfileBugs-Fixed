//
//  SIPComfVC.m
//  KTrack
//
//  Created by  ramakrishna.MV on 20/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "SIPComfVC.h"

@interface SIPComfVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>{
    
    __weak IBOutlet UILabel *lbl_fund;
    __weak IBOutlet UILabel *lbl_scheme;
    __weak IBOutlet UILabel *lbl_Pan;
    __weak IBOutlet UILabel *lbl_instments;
    __weak IBOutlet UILabel *lbl_startDay;
    __weak IBOutlet UILabel *lbl_endDay;
    __weak IBOutlet UILabel *lbl_sipCycle;
    __weak IBOutlet UILabel *lbl_sip;
    __weak IBOutlet UILabel *lbl_sipAmount;
    __weak IBOutlet UILabel *lbl_arn;
    
    __weak IBOutlet UILabel *lbl_invAmount;
    __weak IBOutlet UILabel *lbl_insve;
    __weak IBOutlet UILabel *lbl_subarn;
    
    __weak IBOutlet NSLayoutConstraint *height_cont;
    
    __weak IBOutlet UILabel *lbl_modere;
    __weak IBOutlet UILabel *lbl_folio;
    
    __weak IBOutlet UILabel *lbl_name;
    
    __weak IBOutlet UILabel *lbl_paymentType;
    __weak IBOutlet UIView *view_0tp;
    __weak IBOutlet UITextField *tf_otp;
    __weak IBOutlet UIView *view_genrate;
    __weak IBOutlet UIView *view_payment;
    __weak IBOutlet UIView *view_details;
    
    
    __weak IBOutlet UIButton *btn_generate;
    __weak IBOutlet UIButton *btn_otpsubmit;
    __weak IBOutlet UIButton *btn_regOTp;
    
    UIPickerView *picker_dropDown;
    NSString *paymentModeStr;
    __weak IBOutlet UITableView *payModeTaleview;
    NSString *MobileStr;
    NSString *title_BankID,*title_Bank,*randaomStr;
}

@end

@implementation SIPComfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    lbl_modere.text = _str_PayModeVal;
    [UIButton roundedCornerButtonWithoutBackground:btn_generate forCornerRadius:KTiPad?25.0f:btn_generate.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_otpsubmit forCornerRadius:KTiPad?25.0f:btn_otpsubmit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];

    lbl_insve.text= @"dfsfgerbge";

    lbl_invAmount.text= @"dfsfgerbge";
    [view_details .layer setCornerRadius:15.0f];
    [view_details.layer setMasksToBounds:YES];
    NSLog(@"%@,    Tatt %@",self.str_referId,_str_tat);
    
    payModeTaleview.delegate = self;
    payModeTaleview.dataSource = self;

    
    lbl_fund.text =self.str_Fund;
        lbl_Pan.text =self.str_pan;
    if ([self->_sipType isEqualToString:@"1"]) {
        
        if ([self.str_schemmeType  isEqualToString:@"No"]) {
                            NSLog(@"%@", self.schemeDic);
            
            lbl_scheme.text = [NSString stringWithFormat:@"%@",_schemeDic.schDesc];
        }else{
                            NSLog(@"%@", self.schemmeDetialsDic);
                lbl_scheme.text =  [NSString stringWithFormat:@"%@",self.schemmeDetialsDic[@"fm_schdesc"]];
        }

        
    }else{
                NSLog(@"%@", self.schemmeDetialsDic);
            lbl_scheme.text =  self.schemmeDetialsDic[@""];
        lbl_scheme.text =  [NSString stringWithFormat:@"%@",self.schemmeDetialsDic[@"fm_schdesc"]];

    }
    lbl_sipAmount.text =[NSString stringWithFormat:@"%@ ₹",self.str_Amount];
    lbl_sip.text =[NSString stringWithFormat:@"SIP Installment Amount"];
    
    lbl_name.text = _str_name;
    lbl_folio.text = _str_folio;
    lbl_subarn.text = _str_subarn;
    lbl_arn.text = _str_arn;
    lbl_instments.text = [NSString stringWithFormat:@" %@",self.str_installments];
    lbl_startDay.text = [NSString stringWithFormat:@"%@",self.str_SipStartDay];
    lbl_endDay.text = [NSString stringWithFormat:@"%@",self.str_SipEndDay];

    lbl_sipCycle.text = [NSString stringWithFormat:@"%@ of every %@",self.sipday,self.str_investment];
    
    
    [view_0tp setHidden:true];

    
    if ([self->_sipType isEqualToString:@"1"]) {
        
        NSArray * arr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where Fund= '%@'  and Acno= '%@' ",_str_selectedFundID,_str_folio]];
        
        NSLog(@"%@",arr);
        KT_TABLE2 * dic = arr[0];
        
        MobileStr =[NSString stringWithFormat:@"%@",dic.mobile];
        [view_0tp setHidden:YES];
        [view_payment setHidden:YES];
   [view_genrate setHidden:NO];

        
    }else if([self->_sipType isEqualToString:@"2"]){
        [self   getCommunicationDetailsFromAPI];
        _str_folio=@"0";
        [view_0tp setHidden:YES];
        [view_payment setHidden:YES];
        [view_genrate setHidden:NO];

    }
    else if([self->_sipType isEqualToString:@"3"]){
                _str_folio=@"0";
        [view_payment setHidden:NO];
        [view_genrate setHidden:YES];
        [view_0tp setHidden:YES];
        
        payModeTaleview.delegate = self;
        payModeTaleview.dataSource = self;

        picker_dropDown = [[UIPickerView alloc] initWithFrame:CGRectZero];
        picker_dropDown.delegate = self;
        picker_dropDown.dataSource = self;
        [picker_dropDown setShowsSelectionIndicator:YES];
        
        // Create done button in UIPickerView
        
        
        
        picker_dropDown=[[UIPickerView alloc]init];
        picker_dropDown.frame=CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width , 250);
        
        picker_dropDown.delegate=self;
        picker_dropDown.dataSource=self;
        picker_dropDown.backgroundColor=[UIColor whiteColor];
        [picker_dropDown setHidden:YES];
        
        UIToolbar* toolbar = [[UIToolbar alloc] init];
        toolbar.frame=CGRectMake(0,0,self.view.frame.size.width ,44);
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(doneClicked:)];
        
        UIBarButtonItem* CancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStyleDone target:self
                                                                        action:@selector(cancelClicked:)];
        
        
        
        [toolbar setItems:[NSArray arrayWithObjects:CancelButton,flexibleSpaceLeft, doneButton, nil]];
        
        
        ///[picker_dropDown addSubview:toolbar];
        [self.view addSubview:picker_dropDown];// Do any additional setup after loading the view.
              [self PayModeApi];

    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Atc_generate:(id)sender {
    
        [self gnerateOtp];
}
- (IBAction)atc_regenOtp:(id)sender {
    
    [self gnerateOtp];
    
    
}
- (IBAction)Atc_otpsubmit:(id)sender {
    
    if ([tf_otp.text length] == 0) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter the OTP"];
        
    }else if (![tf_otp.text isEqualToString:randaomStr]) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter valid OTP"];
        
    }else{
        if ([self->_sipType isEqualToString:@"1"]) {
            
                    [self SubmitSip];
            
}else if([self->_sipType isEqualToString:@"2"]){

    [self SaveDTRWebKtom];
}

    }
    
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}
-(void)gnerateOtp{

    randaomStr= [NSString stringWithFormat:@"%d", [self getRandomNumberBetween:100000 to:900000]];
    
    NSLog(@"randaomStr         fdverfv   %@",randaomStr);
    
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_enfolio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.str_folio];
    NSString *str_mobile =[XTAPP_DELEGATE convertToBase64StrForAGivenString:MobileStr];
    NSString *str_otp =[XTAPP_DELEGATE convertToBase64StrForAGivenString:randaomStr];
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@GenerateOTP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Folio=%@&OtpPin=%@&MobileNo=%@&TranType=Uw",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_enfolio,str_otp,str_mobile];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            NSLog(@"%@",responce);
            
            [view_0tp setHidden:NO];
            [view_payment setHidden:YES];
            [view_genrate setHidden:YES];
            if([self.famliyStr isEqualToString:@"PrimaryPan"]){
                
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTSuccessMsg withMessage:@"OTP has been sent to your mobile number, Please confirm SIP transaction by entering the OTP received"];
                
            }else{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTSuccessMsg withMessage:@"You have initiated SIP transaction for your Family member and OTP has been sent to the registered email ID and mobile number of the Family Folio. Please enter the OTP to submit the transaction for further processing."];
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



-(void)SubmitSip{

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_enfolio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.str_folio];
    NSString *str_i_assettype=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSLog(@"%@", [NSString stringWithFormat:@"%@",_schemeDic.sch]);
    
    NSString *str_i_SchemeCode =[XTAPP_DELEGATE convertToBase64StrForAGivenString: [NSString stringWithFormat:@"%@",_schemeDic.sch]];
    NSString *str_i_brokercode;
    
    if ([_str_arn isEqualToString:@"-"]) {
        str_i_brokercode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"ARN-"];
    }else{
        str_i_brokercode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_arn];

    }
    NSString *str_i_subbroker ;
    if ([_str_subarn isEqualToString:@"-"]) {
        str_i_subbroker =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"ARN-"];
    }else{
        str_i_subbroker =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_subarn];
        
    }
 
   
    NSString *str_i_euinnor =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.str_EuinCode];
    NSString *str_i_frequency =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_investment];
    NSString *str_i_SIPday =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_sipday];
    NSString *str_i_NoofInstalment =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_installments];

    NSString *str_i_SIPStartDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_SipStartDay];
    NSString *str_i_PerpetialSIP =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_tat];

    NSString *str_i_SIPEndDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_SipEndDay];
    NSString *str_i_ModeofPayment =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_PayModeVal];
        NSString *str_i_BankName =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    
    NSString *str_i_EntBy=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserEmailID]];
    NSString *str_EntDt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_i_Amount =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.str_Amount];
    NSString *str_Option =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"R"];

  
    
    NSString *str_em =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];


    NSString *str_url = [NSString stringWithFormat:@"%@SIPSave?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&i_id=%@&i_fund=%@&i_folio=%@&i_assettype=%@&i_SchemeCode=%@&i_brokercode=%@&i_subbroker=%@&i_euinno=%@&i_frequency=%@&i_SIPday=%@&i_NoofInstalment=%@&i_SIPStartDate=%@&i_PerpetialSIP=%@&i_SIPEndDate=%@&i_ModeofPayment=%@&i_BankName=%@&i_EntBy=%@&EntDt=%@&i_Amount=%@&Option=%@&o_ErrNo=%@&o_ErrMsg=%@&euinDeclaration=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,@"MQ",str_fund,str_enfolio,str_i_assettype,str_i_SchemeCode,str_i_brokercode,str_i_subbroker,str_i_euinnor,str_i_frequency,str_i_SIPday,str_i_NoofInstalment,str_i_SIPStartDate,str_i_PerpetialSIP,str_i_SIPEndDate,str_i_ModeofPayment,str_i_BankName,str_i_EntBy,str_EntDt,str_i_Amount,str_Option,str_em,str_em,str_em];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            NSLog(@"%@",responce);
            
            KtoMConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"KtoMConVC"];
            
            destination.refStr =[NSString stringWithFormat:@"%@",responce[@"DtData"][0][@"URN"]];
            KTPUSH(destination,YES);
            
//            [view_0tp setHidden:NO];
//            [view_payment setHidden:YES];
//            [view_genrate setHidden:YES];
//            if([self.famliyStr isEqualToString:@"PrimaryPan"]){
//
//
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTSuccessMsg withMessage:@"OTP has been sent to your mobile number, Please confirm SIP transaction by entering the OTP received"];
//
//            }else{
//
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTSuccessMsg withMessage:@"You have initiated SIP transaction for your Family member and OTP has been sent to the registered email ID and mobile number of the Family Folio. Please enter the OTP to submit the transaction for further processing."];
//            }
        }else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




#pragma mark - getCommunicationDetails

-(void)getCommunicationDetailsFromAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_pan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.str_pan];
    NSString *str_refno=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@panbasecommunicationdetails?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&refno=%@&pan=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_refno,str_pan];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            NSArray *arr_res=responce[@"Dtdata"];
            if (arr_res.count>0) {
                NSDictionary *commDic=responce[@"Dtdata"][0];
                
                
            MobileStr=[NSString stringWithFormat:@"%@",commDic[@"kc_mobile"]];
                
                
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
                });
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)confKOTM:(NSString *)KtomString{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ensfund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_enpan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KtomString];
    
    
    // NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_Arn.text];
    
    //
    //
    //    p.setParam("APKVer", enc_AppVer);
    //    p.setParam("Fund", enc_FundCode);
    //    p.setParam("Appno", enc_dataAppNo);
    
    NSString *str_url = [NSString stringWithFormat:@"%@AddPurConfirmKOTM?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Appno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_ensfund,str_enpan];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Table"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            NSLog(@"%@",responce[@"Table1"][0][@"Ref_No"]);
            KtoMConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"KtoMConVC"];
            
            destination.refStr =[NSString stringWithFormat:@"%@",responce[@"Table1"][0][@"URN"]];
            KTPUSH(destination,YES);
            
            
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)SaveDTRWeb{
    NSDictionary *rec_fund=_paymentBantArr[0];
    
    
    title_BankID=[NSString stringWithFormat:@"%@~%@",rec_fund[@"gb_bankcode"],rec_fund[@"kb_Accounttype"]];
    title_Bank=[NSString stringWithFormat:@"~%@",rec_fund[@"kb_BankAcNo"]];
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ensfund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_BankID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:title_BankID];
    NSString *str_Bank =[XTAPP_DELEGATE convertToBase64StrForAGivenString:title_Bank];
    NSString *str_Trtype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"P"];
      NSLog(@"%@",_str_referId);
    NSString *En_referId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@", self.str_referId]];
    NSLog(@"%@",title_BankID);
    NSString *En_paymentModeStr =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    
    NSLog(@"%@",paymentModeStr);
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@SaveDTRWeb?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&Refno=%@&Bankid=%@%@&PaymentType=%@&Trtype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_ensfund,En_referId,str_BankID,str_Bank,En_paymentModeStr,str_Trtype];
    
    NSLog(@"%@",str_url);
    
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {

                   [self confKOTM:responce[@"DtData"][0][@"dd_appno"]];
            
            
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - PayModeApi
-(void)PayModeApi{
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    _paymentModeArray =[[NSMutableArray alloc]init];
    
    NSDictionary * dicts = @{ @"Pay_Mode" : @"Net Banking", @"Pay_Mode_Val" : @"DCB",@"Yes":@"no"};
    NSDictionary *         dict = @{ @"Pay_Mode" : @"KOTM", @"Pay_Mode_Val" : @"KOTM",@"Yes":@"no"};
    NSDictionary *   dictsaa = @{ @"Pay_Mode" : @"Debit Card", @"Pay_Mode_Val" : @"DC",@"Yes":@"no"};
    NSDictionary *  dictsa = @{ @"Pay_Mode" : @"UPI", @"Pay_Mode_Val" : @"UPI",@"Yes":@"no"};
    
    [_paymentModeArray addObject:dicts];
    [_paymentModeArray  addObject:dict];
    [_paymentModeArray addObject:dictsa];
    [_paymentModeArray addObject:dictsaa];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_otp =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"PM"];
    
    NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_pan];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_otp,str_fund,str_folio,str_folio];
    
    NSLog(@"%@",str_url);
    
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            self->_saepaymentModeArr  = responce[@"Dtinformation"];
            
            NSLog(@"%@",self.paymentModeArray);
            
            
            
            for (int i=0; i<self.saepaymentModeArr.count; i++) {
                NSDictionary * dica =  self.saepaymentModeArr[i];
                NSLog(@"%@",dica);
                
                
                
                NSDictionary *dicts ;
                NSDictionary *dict;
                NSDictionary *dictsaa;
                NSDictionary *dictsa;
                
                if ([dica[@"Pay_Mode"]isEqualToString:@"Net Banking"] ) {
                    
                    
                    NSLog(@"%@",_paymentBantArr);
                    
                    
                    if ([dica[@"Pay_Mode"]isEqualToString:@"Net Banking" ] ) {
                        
                        _payoutBankDic = _paymentBantArr[0];
                        
                        if (    [_payoutBankDic[@"gb_bankcode"]  length ]== 0 ) {
                            
                            dicts = @{ @"Pay_Mode" : @"Net Banking", @"Pay_Mode_Val" : @"DCB",@"Yes":@"no"};
                            
                            
                            [self.paymentModeArray replaceObjectAtIndex:0 withObject:dicts];
                        }else
                        {
                            
                            dicts = @{ @"Pay_Mode" : @"Net Banking", @"Pay_Mode_Val" : @"DCB",@"Yes":@"yes"};
                            [self.paymentModeArray replaceObjectAtIndex:0 withObject:dicts];
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                    }else{
                        
                        
                        
                        dicts = @{ @"Pay_Mode" : @"Net Banking", @"Pay_Mode_Val" : @"DCB",@"Yes":@"no"};
                        
                        
                        [self.paymentModeArray replaceObjectAtIndex:0 withObject:dicts];
                        
                        
                        
                        
                        
                    }
                }
                
                else    if   ([dica[@"Pay_Mode"]isEqualToString:@"Debit Card"]) {
                    
                    
                    if ([dica[@"Pay_Mode"]isEqualToString:@"Debit Card"]) {
                        if ([dica[@"Pay_Mode"]isEqualToString:@"Debit Card"]) {
                            
                            dictsaa = @{ @"Pay_Mode" : @"Debit Card", @"Pay_Mode_Val" : @"DC",@"Yes":@"yes"};
                            
                            [self.paymentModeArray replaceObjectAtIndex:3 withObject:dictsaa];
                            
                        }else{
                            dictsaa = @{ @"Pay_Mode" : @"Debit Card", @"Pay_Mode_Val" : @"DC",@"Yes":@"no"};
                            [self.paymentModeArray replaceObjectAtIndex:3 withObject:dictsaa];
                            
                            
                        }
                        
                    }
                    
                }
                
                else       if ([dica[@"Pay_Mode"]isEqualToString:@"UPI"]) {
                    
                    if ([dica[@"Pay_Mode"]isEqualToString:@"UPI"]) {
                        
                        dictsa = @{ @"Pay_Mode" : @"UPI", @"Pay_Mode_Val" : @"UPI",@"Yes":@"yes"};
                        
                        [self.paymentModeArray replaceObjectAtIndex:2 withObject:dictsa];
                        
                    }
                    
                    
                    else{
                        
                        
                        dictsa = @{ @"Pay_Mode" : @"UPI", @"Pay_Mode_Val" : @"UPI",@"Yes":@"no"};
                        [self.paymentModeArray replaceObjectAtIndex:2 withObject:dictsa];
                        
                    }
                    
                }
                else    if ([dica[@"Pay_Mode"]isEqualToString:@"KOTM"]) {
                    if ([dica[@"Pay_Mode"]isEqualToString:@"KOTM"]) {
                        
                        dict = @{ @"Pay_Mode" : @"KOTM", @"Pay_Mode_Val" : @"KOTM",@"Yes":@"yes"};
                        [self.paymentModeArray replaceObjectAtIndex:1 withObject:dict];
                        
                        
                    }else{
                        dict = @{ @"Pay_Mode" : @"KOTM", @"Pay_Mode_Val" : @"KOTM",@"Yes":@"no"};
                        [self.paymentModeArray replaceObjectAtIndex:1 withObject:dict];
                        
                    }
                    
                }else{
                    
                    NSLog(@"%@",self.paymentModeArray);
                    
                    
                }
                
                
                
            }
            NSLog(@"%@",self.paymentModeArray);
            
            
            [self->payModeTaleview reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paymentModeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PaymentModeCell *cell=(PaymentModeCell*)[tableView dequeueReusableCellWithIdentifier:@"PaymentMode"];
    if (cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentModeCell" owner:self options:nil];
        cell = (PaymentModeCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    
    NSDictionary * dic =  self.paymentModeArray[indexPath.row];
    
    
    
    if ([dic[@"Pay_Mode"]isEqualToString:@"Net Banking"] ) {
        cell.lbl_paymentModeDesc.text = [NSString stringWithFormat:@"%@",dic[@"Pay_Mode"]];
        cell.leftImage.image =[UIImage imageNamed:@"netBank"];
        
        cell.dropDownImage.image =[UIImage imageNamed:@"shape1"];
        
        
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            
            cell.backView.backgroundColor =[UIColor whiteColor];
        }else{
            cell.backView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        }
        
    }
    if ([dic[@"Pay_Mode"]isEqualToString:@"Debit Card"]) {
        cell.lbl_paymentModeDesc.text = [NSString stringWithFormat:@"%@",dic[@"Pay_Mode"]];
        cell.leftImage.image =[UIImage imageNamed:@"debitCrad"];
        cell.dropDownImage.image =[UIImage imageNamed:@"debitCradDorp"];
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            
            cell.backView.backgroundColor =[UIColor whiteColor];
        }else{
            cell.backView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        }
    }
    if ([dic[@"Pay_Mode"]isEqualToString:@"UPI"]) {
        cell.lbl_paymentModeDesc.text = [NSString stringWithFormat:@"%@",dic[@"Pay_Mode"]];
        cell.leftImage.image =[UIImage imageNamed:@"upi"];
        cell.dropDownImage.image =[UIImage imageNamed:@"shape1Copy12"];
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            
            cell.backView.backgroundColor =[UIColor whiteColor];
        }else{
            cell.backView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        }
    }
    
    if ([dic[@"Pay_Mode"]isEqualToString:@"KOTM"]) {
        cell.lbl_paymentModeDesc.text = [NSString stringWithFormat:@"%@",dic[@"Pay_Mode"]];
        cell.leftImage.image =[UIImage imageNamed:@"kotm"];
        cell.dropDownImage.image =[UIImage imageNamed:@"Ktom"];
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            
            cell.backView.backgroundColor =[UIColor whiteColor];
        }else{
            cell.backView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        }
        
        
    }
    
    cell.lbl_paymentModeDesc.text = [NSString stringWithFormat:@"%@",dic[@"Pay_Mode"]];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    
    
    NSDictionary * dic =  self.paymentModeArray[indexPath.row];
    
    
    
    if ([dic[@"Pay_Mode"]isEqualToString:@"Net Banking"] ) {
        
        
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            paymentModeStr =dic[@"Pay_Mode_Val"];
            [picker_dropDown setHidden:NO];
            [picker_dropDown reloadAllComponents];
        }else{
            
            
        }
        
    }
    if ([dic[@"Pay_Mode"]isEqualToString:@"Debit Card"]) {
        
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            paymentModeStr =dic[@"Pay_Mode_Val"];
            NSDictionary *rec_fund=_paymentBantArr[0];
            
            title_BankID=[NSString stringWithFormat:@"%@~%@", rec_fund[@"gb_bankcode"],rec_fund[@"kb_Accounttype"]];
            title_Bank=[NSString stringWithFormat:@"~%@",rec_fund[@"kb_BankAcNo"]];
//            title_BankID=[NSString stringWithFormat:@"~"];
//            title_Bank=[NSString stringWithFormat:@"~"];
            [self SaveDTRWebType3];

        }else{
            
            
        }
    }
    if ([dic[@"Pay_Mode"]isEqualToString:@"UPI"]) {
        
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            paymentModeStr =dic[@"Pay_Mode_Val"];
            
        }else{
            
            
        }
    }
    
    if ([dic[@"Pay_Mode"]isEqualToString:@"KOTM"]) {
        
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            paymentModeStr =dic[@"Pay_Mode_Val"];
            
            [self validateKOTM];
            
        }else{
            
            
        }
        
        
    }
    
}

-(void)validateKOTM{
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ensfund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_Fund];
    NSString *str_enpan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_pan];
    
    
    // NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_Arn.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@CheckPANKotm?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&PAN=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_ensfund,str_enpan];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Table"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"KOTM"
                                          message:responce[@"Table1"][0][@"GM_UMRNNo"]
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"Procced"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                     
                                     NSDictionary *rec_fund=_paymentBantArr[0];
                                     
                                     title_BankID=[NSString stringWithFormat:@"%@~%@", rec_fund[@"gb_bankcode"],rec_fund[@"kb_Accounttype"]];
                                     title_Bank=[NSString stringWithFormat:@"~%@",rec_fund[@"kb_BankAcNo"]];
                                     
                                     
                                     [self SaveDTRWebKtom];
                                     //                                     [self  confKOTM:responce[@"Table1"][0][@"GM_UMRNNo"]];
                                     
                                 }];
            [alert addAction:ok];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)SaveDTRWebKtom{
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ensfund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_BankID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:title_BankID];
    NSString *str_Bank =[XTAPP_DELEGATE convertToBase64StrForAGivenString:title_Bank];
    NSString *str_Trtype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"P"];
    
    NSString *En_referId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@", self.str_referId]];
    NSLog(@"%@",title_BankID);
    NSString *En_paymentModeStr =[XTAPP_DELEGATE convertToBase64StrForAGivenString:paymentModeStr];
    
    NSLog(@"%@",paymentModeStr);
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@SaveDTRWeb?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&Refno=%@&Bankid=%@%@&PaymentType=%@&Trtype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_ensfund,En_referId,str_BankID,str_Bank,En_paymentModeStr,str_Trtype];
    
    NSLog(@"%@",str_url);
    
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {
            
            [self confKOTMtyr:responce[@"DtData"][0][@"dd_appno"]];
            
            
            
            //            PaymentVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"PaymentVC"];
            //
            //            destination.str_referId =[NSString stringWithFormat:@"%@", self.str_referId];
            //            KTPUSH(destination,YES);
            //
            //
            
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

-(void)confKOTMtyr:(NSString *)KtomString{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ensfund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_enpan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KtomString];
    
    
    // NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_Arn.text];
    
    //
    //
    //    p.setParam("APKVer", enc_AppVer);
    //    p.setParam("Fund", enc_FundCode);
    //    p.setParam("Appno", enc_dataAppNo);
    
    NSString *str_url = [NSString stringWithFormat:@"%@AddPurConfirmKOTM?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Appno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_ensfund,str_enpan];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Table"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            NSLog(@"%@",responce[@"Table1"][0][@"Msg"]);
            KtoMConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"KtoMConVC"];
            
            destination.refStr =[NSString stringWithFormat:@"%@",responce[@"Table1"][0][@"URN"]];
            KTPUSH(destination,YES);
            
            
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}




#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _paymentBantArr.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *rec_fund=_paymentBantArr[row];
    NSString *str_title;
    str_title=[NSString stringWithFormat:@"%@  %@",rec_fund[@"kb_BankName"],rec_fund[@"kb_BankAcNo"]];
    return str_title ;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    
    NSDictionary *rec_fund=_paymentBantArr[row];
    
    
    title_BankID=[NSString stringWithFormat:@"%@~%@",rec_fund[@"gb_bankcode"],rec_fund[@"kb_Accounttype"]];
    title_Bank=[NSString stringWithFormat:@"~%@",rec_fund[@"kb_BankAcNo"]];
    
    //   [picker_dropDown setHidden:YES];
    NSLog(@"%@",title_BankID);
    picker_dropDown.hidden = YES;
    
    [self SaveDTRWebType3];
    
}

-(void)doneClicked:(id)sender {
    picker_dropDown.hidden = YES;
    
    [self SaveDTRWeb];
}

-(void)cancelClicked:(id)sender {
    picker_dropDown.hidden = NO;
}
#pragma mark - UIPickerView Delegates and DataSource methods Ends
-(void)SaveDTRWebType3{
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ensfund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_BankID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:title_BankID];
    NSString *str_Bank =[XTAPP_DELEGATE convertToBase64StrForAGivenString:title_Bank];
    NSString *str_Trtype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"P"];
    
    NSString *En_referId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@", self.str_referId]];
    NSLog(@"%@",title_BankID);
    NSString *En_paymentModeStr =[XTAPP_DELEGATE convertToBase64StrForAGivenString:paymentModeStr];
    
    NSLog(@"%@",paymentModeStr);
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@SaveDTRWeb?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&Refno=%@&Bankid=%@%@&PaymentType=%@&Trtype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_ensfund,En_referId,str_BankID,str_Bank,En_paymentModeStr,str_Trtype];
    
    NSLog(@"%@",str_url);
    
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {
            
            PaymentVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"PaymentVC"];
            
            destination.str_referId =[NSString stringWithFormat:@"%@", self.str_referId];
            KTPUSH(destination,YES);
            
            
            
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)back:(id)sender {
    KTPOP(YES);

    
}
@end
