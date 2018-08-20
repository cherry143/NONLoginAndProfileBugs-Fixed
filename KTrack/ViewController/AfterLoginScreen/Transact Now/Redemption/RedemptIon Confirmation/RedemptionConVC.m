//
//  RedemptionConVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 16/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "RedemptionConVC.h"

@interface RedemptionConVC (){
    
    __weak IBOutlet UIView *view_Confimation;
    __weak IBOutlet UILabel *lbl_name;
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
    NSArray  *paymentBantArr;
    UIPickerView *picker_dropDown;
    NSString *paymentModeStr;
    
    NSString *title_BankID,*title_Bank,*randaomStr;
}

@end

@implementation RedemptionConVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lbl_pan.text = self.str_pan;
    lbl_Scheme.text = self.str_Secheme;
    label_folio.text = self.str_folio;
    lbl_fund.text = self.str_Fund;
    lbl_value.text = [NSString stringWithFormat:@"%@/-    ",self.str_Amount];

    [[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername];
    [view_back .layer setCornerRadius:15.0f];
    [view_back.layer setMasksToBounds:YES];
    [view_back .layer setCornerRadius:15.0f];
    [view_back.layer setMasksToBounds:YES];
    [btn_submit .layer setCornerRadius:15.0f];
    [btn_submit.layer setMasksToBounds:YES];
    lbl_name.text = _str_name;
    if ([_str_redType isEqualToString:@"Amount"]) {
        
        lbl_rep.text = @"Redemption Amount";
    }else{
        lbl_rep.text = @"Redemption Units";

    }
    [self gnerateOtp];

    NSLog(@"%@",_paymentModeArray);
    NSLog(@"%@",_schemmeDetialsDic);
    NSLog(@"%@",_schemeDic.optDesc);
    NSLog(@"%@",self.str_referId);
    // Do any additional setup after loading the view.
}
-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}
-(void)gnerateOtp{
    
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    randaomStr= [NSString stringWithFormat:@"%d", [self getRandomNumberBetween:100000 to:900000]];
    
    NSLog(@"randaomStr   %@",randaomStr);

    
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
            
                
                     [[SharedUtility sharedInstance]showAlertViewWithTitle:KTSuccessMsg withMessage:@"OTP has been sent to your mobile number, Please confirm Redemption transaction by entering the OTP received"];

            }else{
 
[[SharedUtility sharedInstance]showAlertViewWithTitle:KTSuccessMsg withMessage:@"You have initiated Redemption transaction for your Family member and OTP has been sent to the registered email ID and mobile number of the Family Folio. Please enter the OTP to submit the transaction for further processing."];
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
        
        [self finalRedemptionAPI];
        
    }
    
}

-(void)finalRedemptionAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_enfolio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.str_folio];
    NSString *str_scheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.schemeDic.sch];

    NSString *str_plan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.schemeDic.pln];
    NSString *str_option =[XTAPP_DELEGATE convertToBase64StrForAGivenString:self.schemeDic.opt];
    NSString *str_enamount =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_Amount];
    NSString * str_emp=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];

    NSString *i_Userid =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];


    NSString *str_url = [NSString stringWithFormat:@"%@Savetransaction_red?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&i_Fund=%@&i_Scheme=%@&i_Plan=%@&i_Option=%@&i_Acno=%@&i_RedFlg=%@&i_UntAmtFlg=%@&i_UntAmtValue=%@&i_Userid=%@&i_Tpin=%@&i_Mstatus=%@&i_Fname=%@&i_Mname=%@&i_Lname=%@&i_Cuttime=%@&i_pangno=%@&i_IP=%@&i_bnkacname=%@&i_bnkacno=%@&i_bnkifsc=%@&i_bnkacctype=%@&i_bnkadd1=%@&i_bnkadd2=%@&i_bnkadd3=%@&i_bnkcity=%@&i_bnkpin=%@&i_micrcode=%@&i_oldihno=%@&i_InvDistFlag=%@&o_ErrNo=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_scheme,str_plan,str_option,str_enfolio,@"UA",@"VQ",str_enamount,i_Userid,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,str_emp,@"MA",@"SQ",str_emp];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        
        
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            NSString *error_message=[NSString stringWithFormat:@"Redemption is done Succesfully  with the following reference:%@",responce[@"DtData"][0][@"REFNO"]];

            
            
            KtoMConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"KtoMConVC"];
            
            destination.refStr =error_message;
            
            KTPUSH(destination,YES);
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
