//
//  RedemptionConVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 16/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "SwitchCnfVC.h"

@interface SwitchCnfVC (){
    
    __weak IBOutlet UIView *view_Confimation;
    __weak IBOutlet UIView *view_back;
    __weak IBOutlet UILabel *lbl_fund;
    __weak IBOutlet UILabel *label_folio;
    __weak IBOutlet UILabel *lbl_Scheme;
    __weak IBOutlet UILabel *lbl_pan;
    __weak IBOutlet UILabel *lbl_rep;
    __weak IBOutlet UILabel *lbl_value;
    __weak IBOutlet UITextField *tf_otp;
    __weak IBOutlet UIButton *btn_regenerate;
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UILabel *lbl_name;
    NSArray  *paymentBantArr;
    UIPickerView *picker_dropDown;
    __weak IBOutlet UILabel *lbl_arn;
    __weak IBOutlet UILabel *lbl_subArn;
    NSString *paymentModeStr;
    
    __weak IBOutlet UILabel *lbl_SwitchIN;
    NSString *title_BankID,*title_Bank,*randaomStr;
}

@end

@implementation SwitchCnfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lbl_pan.text = self.str_pan;
    lbl_Scheme.text = self.str_Secheme;
    label_folio.text = self.str_folio;
    lbl_fund.text = self.str_Fund;
    
    lbl_SwitchIN.text = _str_Sechemein;
    lbl_value.text = [NSString stringWithFormat:@"%@/-    ",self.str_Amount];
    
    [[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername];
    [view_back .layer setCornerRadius:15.0f];
    [view_back.layer setMasksToBounds:YES];
    [view_back .layer setCornerRadius:15.0f];
    [view_back.layer setMasksToBounds:YES];
    [btn_submit .layer setCornerRadius:15.0f];
    [btn_submit.layer setMasksToBounds:YES];
    
    lbl_name.text = _Str_name;
    
    if (![self.Str_arncode  isEqualToString:@"ARN-"]) {
        lbl_arn.text =_Str_arncode;
    }else{
           lbl_arn.text = @"-";
    }
    if (![self.Str_subarncode isEqualToString:@"ARN-"]) {
        lbl_subArn.text =_Str_subarncode;
    }else{
        lbl_subArn.text = @"-";
    }
    
    
    if ([_str_redType isEqualToString:@"Amount"]) {
        
        lbl_rep.text = @" Amount";
    }else{
        lbl_rep.text = @" Units";
        
    }
    [self gnerateOtp];
    
    NSLog(@"%@",_paymentModeArray);
    NSLog(@"%@",_schemmeDetialsDic);
    NSLog(@"%@",_schemeDic.optDesc);
    NSLog(@"%@",self.schemeDic);
    
    NSLog(@"%@",self.NewSchemmeDic);

    // Do any additional setup after loading the view.
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
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_enfolio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.str_folio];
    NSString *str_mobile =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.schemeDic.mobile];
    NSString *str_otp =[XTAPP_DELEGATE convertToBase64StrForAGivenString:randaomStr];

    
    NSString *str_url = [NSString stringWithFormat:@"%@GenerateOTP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Folio=%@&OtpPin=%@&MobileNo=%@&TranType=Uw",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_enfolio,str_otp,str_mobile];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            NSLog(@"%@",responce);
            if([self.famliyStr isEqualToString:@"PrimaryPan"]){
                
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTSuccessMsg withMessage:@"OTP has been sent to your mobile number, Please confirm Switch transaction by entering the OTP received"];
                
            }else{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTSuccessMsg withMessage:@"You have initiated Switch transaction for your Family member and OTP has been sent to the registered email ID and mobile number of the Family Folio. Please enter the OTP to submit the transaction for further processing."];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)atc_regenerateOtp:(id)sender {
    [self gnerateOtp];
    
    
}
- (IBAction)backAtc:(id)sender {
    KTPOP(YES);
    
    
}
- (IBAction)atc_sumbit:(id)sender {
    
    if ([tf_otp.text length] == 0) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter the OTP"];
        
    }else if (![tf_otp.text isEqualToString:randaomStr]) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter valid OTP"];
        
    }else{
        
        [self finalSwichAPI];
        
    }
    
}

-(void)finalSwichAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_enfolio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.str_folio];
    NSString *str_scheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.schemeDic.sch];
    
    NSString *str_ttrtype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"S"];

    NSString *str_plan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.schemeDic.pln];
    NSString *str_option =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.schemeDic.opt];
    NSString *str_enamount =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_Amount];
    NSString *str_enredType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.ttrtype];

    NSString * str_emp=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_untAmtFlg;
    
    if  ([_str_redType isEqualToString:@"Amount"]) {
        str_untAmtFlg =@"A";
        
    }else{
        str_untAmtFlg =@"U";
        
    }
    NSString * str_enuntAmtFlg=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_untAmtFlg];
    

    NSString *i_UserMail =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserEmailID]];

    NSString *i_Userid =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
   NSString *str_tscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.NewSchemmeDic[@"fm_scheme"]];
    NSString *str_tPlan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.NewSchemmeDic[@"fm_plan"]];
    NSString *str_toption =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.NewSchemmeDic[@"fm_option"]];
    NSString *str_enArnCode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.Str_arncode];
    NSString *str_enEnioflag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.str_euinflag];
    NSString *str_ensubarncode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.Str_subarncode];
    NSString *str_enEuinNoe =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.str_EuinNo];
    NSString *str_enpan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.str_pan];

    NSString *str_yes =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"Yes~"];
    NSString *str_i =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"I~null"];
    NSString *str_dec =[NSString stringWithFormat:@"%@%@",str_yes,str_i];
    NSLog(@"%@",str_dec);
    NSString *str_bacnk =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@" null~"];
    NSString *str_aa =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"null~ "];
    NSString *str_bank =[NSString stringWithFormat:@"%@%@",str_bacnk,str_aa];

    NSString *str_url = [NSString stringWithFormat:@"%@SentpurchasemailRed?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&i_Fund=%@&i_Scheme=%@&i_Plan=%@&i_Option=%@&i_Acno=%@&i_RedFlg=%@&i_UntAmtFlg=%@&i_UntAmtValue=%@&i_Userid=%@&i_Tpin=%@&i_Mstatus=%@&i_oldihno=%@&i_InvDistFlag=%@&i_Tfund=%@&i_Tscheme=%@&i_Tplan=%@&i_Toption=%@&i_Tacno=%@&i_Agent=%@&i_Mapinid=%@&i_entby=%@&ARNCode=%@&EUINFlag=%@&Subbroker=%@&SubbrokerArn=%@&EuinCode=%@&EuinValid=%@&o_ErrNo=%@&Otp=%@&PanNo=%@&Desci=%@&IMEINO=%@&Bankid=%@&trtype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_scheme,str_plan,str_option,str_enfolio,str_enredType,str_enuntAmtFlg,str_enamount,i_Userid,str_emp,str_emp,@"MA==",@"SQ",str_fund,str_tscheme,str_tPlan,str_toption,str_enfolio,str_emp,str_emp,i_UserMail,str_enArnCode,str_enEnioflag,str_ensubarncode,str_emp,str_enEuinNoe,str_enEnioflag,str_emp,str_emp,str_enpan,str_dec,unique_UDID,str_bank,str_ttrtype];

    
                         
               ///          ,KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_scheme,str_plan,str_option,str_enfolio,str_ttrtype,str_enuntAmtFlg,str_enamount,str_emp,str_emp,@"MA==",@"SQ",str_fund,str_tscheme,str_tPlan,str_toption,str_enfolio,str_emp,str_emp,str_enredType,str_enArnCode,str_enEnioflag,str_ensubarncode,str_emp,str_enEuinNoe,str_enEnioflag,str_emp,str_emp,@"Uw",str_enpan,str_dec,unique_UDID,str_bank,@"Uw=="];
   
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            NSString *error_message=[NSString stringWithFormat:@"Switch is done Succesfully  with the following reference:%@",responce[@"DtData"][0][@"REFNO"]];
            
            KtoMConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"KtoMConVC"];
            
            destination.refStr =error_message;
            
            KTPUSH(destination,YES);
            
            
//            UIAlertController * alert=   [UIAlertController
//                                          alertControllerWithTitle:KTSuccessMsg
//                                          message:error_message
//                                          preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* ok = [UIAlertAction
//                                 actionWithTitle:@"Ok"
//                                 style:UIAlertActionStyleDefault
//                                 handler:^(UIAlertAction * action){
//                                     
//                                     [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:[[self.navigationController viewControllers] count]-3] animated:NO];
//                                     
//                                 }];
//            [alert addAction:ok];
//            
//            [self presentViewController:alert animated:YES completion:nil];
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

@end
