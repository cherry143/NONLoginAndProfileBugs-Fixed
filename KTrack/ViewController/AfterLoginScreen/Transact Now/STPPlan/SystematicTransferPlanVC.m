//
//  SystematicTransferPlanVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 06/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "SystematicTransferPlanVC.h"

@interface SystematicTransferPlanVC ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextField *txt_folio;
    __weak IBOutlet UITextField *txt_fund;
    __weak IBOutlet UITextField *txt_schemeOut;
    __weak IBOutlet UITextField *txt_sehemeIn;
    __weak IBOutlet UITextField *txt_catergory;
    __weak IBOutlet UITextField *txt_arn;
   __weak IBOutlet UITextField *txt_broker;
    __weak IBOutlet UITextField *txt_subArn;
    __weak IBOutlet UITextField *txt_euinNo;
    __weak IBOutlet UITextField *txt_stpFrequency;
    __weak IBOutlet UITextField *txt_noInstallmnts;
    __weak IBOutlet UITextField *txt_STPday;
    __weak IBOutlet UITextField *txt_fromDate;
    __weak IBOutlet UITextField *txt_todate;
    __weak IBOutlet UITextField *txt_STPOption;
    
    
    __weak IBOutlet UITextField *txt_amount;
    
    
    
    __weak IBOutlet UILabel *lbl_currentvalue;
    __weak IBOutlet UILabel *lbl_balanceUnits;
    __weak IBOutlet UILabel *lbl_Mini;
    
    
    __weak IBOutlet UIButton *btn_noEuin;
    __weak IBOutlet UIButton *btn_yesEuin;
    __weak IBOutlet UIButton *btn_direct;
    __weak IBOutlet UIButton *btn_distr;
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UILabel *lbl_amount;
    
    
    __weak IBOutlet UIView *view_submit;
    __weak IBOutlet UIView *view_euinNo;
    __weak IBOutlet UIView *view_ARN;
    __weak IBOutlet UIView *view_switchinScheme;
    __weak IBOutlet UIView *view_invest;
    __weak IBOutlet UIView *view_switchSccheme;
    __weak IBOutlet UIView *view_fund;
    
    
        UIPickerView *picker_dropDown;
    UITextField *txt_currentTextField;
    
    __weak IBOutlet NSLayoutConstraint *height_const;
    
    NSArray *subEArnarray;
    NSArray *fundDetails;
    NSArray *folioArray;
    NSArray *   PanDetials;
    NSArray *existingArr;
    NSArray *paymentBantArr;
    NSMutableArray * categoryArr;
    NSMutableArray *newschemeArr;
    NSMutableArray  *paymentModeArray;
    
    KT_TABLE2 *schemmeDic;
    KT_TABLE8 *selectedBank;
    NSMutableDictionary *newSchemmeDic;
    NSArray *frequencyArr,*SIPDaysArr,*STPOptionArr;
    /// String
    NSString *str_selectedFundID;
    NSString *selectedPan;
    NSString *selectedfolio,*selectedSecheme,*miniAmount;
    __weak IBOutlet UIView *view_hieght;
    NSString *str_PaymentBank;
    NSString *str_Category;
    NSString*str_folioDmart;
    NSString*str_EuinNo,*str_iScheme;
    NSString*str_plan;
    NSString*str_option;
    NSString *EUINFlag,*str_tat;
    NSString *str_driect,*str_notAllowedFlag,*str_optionCode;
    NSString *str_referId,*str_redType,*ttrtype,* lastNavStr,*str_selectedSchType,*str_selectedSchPlan,*str_selectedSchOption,*str_mobileNumber,*mimimumRedAmount,*current_navValue,*mini_amount;

}


@end

@implementation SystematicTransferPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addElements];
    
    
    // Do any additional setup after loading the view.
}

-(void)addElements{
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
        [self applyRoundedCornerAndInitialisation];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [scrollView addGestureRecognizer:singleTap];
    NSArray *minorRecordDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='P' "]];
    KT_TABLE12 *pan_rec=minorRecordDetails[0];
    selectedPan=pan_rec.PAN;


    
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    [picker_dropDown reloadAllComponents];

    
    [txt_fund addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_folio addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_schemeOut addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_sehemeIn addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];

    [txt_catergory addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_arn addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_subArn addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_broker addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_stpFrequency addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_STPday addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_fromDate addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_todate addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_stpFrequency addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_euinNo addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_STPOption addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];

     
        [self fetchFundsRecordsFromDB];
}

-(void)doneAction:(UIBarButtonItem *)done{
    [txt_currentTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
#pragma mark - scrollView Content Increase Method

-(void)scrollContentHeightIncrease:(CGFloat)height{
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width,height);
}
- (IBAction)atc_distr:(id)sender {
    
    
    str_driect =@"Regular";
    [view_euinNo setHidden:YES];
    [view_ARN setHidden:NO];
    txt_sehemeIn.text =nil;

    txt_arn.text =@"ARN-";
    txt_subArn.text =@"ARN-";
    txt_broker.text =nil;
    txt_euinNo.text =nil;
    [btn_yesEuin setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_noEuin setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    [btn_direct setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_distr setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [self newSchmemListApi];

}
- (IBAction)atc_direct:(id)sender {
    
    str_driect =@"Driect";
    
    
    [view_euinNo setHidden:YES];
    [view_ARN setHidden:YES];
    
    txt_sehemeIn.text =nil;
    
    txt_arn.text =@"ARN-";
    txt_subArn.text =@"ARN-";
    txt_broker.text =nil;
    txt_euinNo.text =nil;
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    [btn_direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_distr setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    
    [self newSchmemListApi];
}
- (IBAction)atc_yesEuin:(id)sender {
    
    
    txt_euinNo.text =nil;
    
    [view_euinNo setHidden:YES];
    
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    txt_euinNo.userInteractionEnabled = NO;
    
    [btn_yesEuin setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_noEuin setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    
    
}

- (IBAction)atc_back:(id)sender {
    
    
    KTPOP(true);
}
- (IBAction)atc_noEuin:(id)sender {
    
    
    [view_euinNo setHidden:NO];
    txt_euinNo.text =nil;
    
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    txt_euinNo.userInteractionEnabled = YES;
    [ btn_noEuin setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [    btn_yesEuin setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
}
- (IBAction)atc_euinI:(id)sender {
    
           [[SharedUtility sharedInstance]showAlertViewWithTitle:KTMessage withMessage:@"I/We hereby confirm that the EUIN box has been intentionally left blank by me us as this is an 'execution-only' transaction without any interaction or advice by any personnel of the above distributor or notwithstanding the advice of in-appropriateness, if any, provided by any personnel of the distributor and the distributor has not charged any advisory fees on this transaction. "];
    
}
- (IBAction)atc_submit:(id)sender {
    
    if (txt_fund.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_fund becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
        });
    }
    else if (txt_folio.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_folio becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
        });
    }
    else if (txt_schemeOut.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_schemeOut becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select scheme  out."];
        });
    }
    
    else if (txt_catergory.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_catergory becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select Catergory  ."];
        });
    }
    else if (txt_sehemeIn.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_sehemeIn becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select scheme In ."];
        });
    }
    
    else if( ( [str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]  ) && [ txt_arn.text   isEqualToString:@"ARN-" ] ){
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_arn becomeFirstResponder];
[[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter ARN code "];        });
        
        
        
    }
    else if ( ( [str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]  )  &&  ! [ txt_arn.text   isEqualToString:@"ARN-" ]  &&  ![ txt_subArn.text   isEqualToString:@"ARN-" ]     && [txt_arn.text   isEqualToString:txt_subArn.text] ){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_subArn becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"  ARN  Code  and  sub ARN code  Should not be Same "];

        });
        
        
    }
    else if( ( [str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]  ) &&  [btn_noEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]] && txt_euinNo.text.length == 0  )  {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_euinNo becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Select  EUIN  No  "];

            
        });
        
    }
    else if (txt_stpFrequency.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_stpFrequency becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Select SIP Frequency."];
        });
    }
    else if ([txt_noInstallmnts.text length] ==  0 ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_noInstallmnts becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter number of withdrawals."];
        });
    }
    
    else if ( [lbl_Mini.text integerValue]  >=   [txt_noInstallmnts.text   integerValue] ){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_noInstallmnts becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Please enter  the No of  Installments  greater Than Minimum%@ ",lbl_Mini.text]];
        });
    }
    else if ([txt_STPday.text length] ==  0 ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_STPday becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Select STP Day "];
        });
    }
    else if ([txt_fromDate.text length] ==  0 ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_STPday becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Select  STP day "];
        });
    }
    else if ([txt_todate.text length] ==  0 ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_STPday becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Select  STP day "];
        });
    }
    else if (txt_STPOption.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_STPOption becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select STP  Option."];
        });
    }
    else if (txt_STPOption.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_STPOption becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select STP  Option."];
        });
    }
    
    else if (   txt_STPOption.text.length!=0 && ! [str_optionCode isEqualToString:@"F"] &&  [txt_amount.text   length]  == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_amount becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter  the   Amount"];
        });
    }
    
    else if (   txt_STPOption.text.length!=0 && ! [str_optionCode isEqualToString:@"F"] &&  [txt_amount.text    integerValue]  == 0000){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_amount becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter  theAmount  greater Than  0 "];
        });
    }
    else if (txt_STPOption.text.length!=0 && ! [str_optionCode isEqualToString:@"F"] &&  [miniAmount floatValue]  >  [txt_amount.text    floatValue] ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_amount becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat: @"Please enter  STP  Amount  Greater Than : %@.",miniAmount]];
        });
    }
    
        else{
            [self STPsubmitamount];
        }
    }
    
    
    
    
    
    
    


#pragma mark - fetch Funds

-(void)fetchFundsRecordsFromDB{
    fundDetails = [[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT distinct fundDesc, fund FROM TABLE2_DETAILS WHERE PAN='%@' AND rFlag='Y' AND rSchFlg='Y' order By FundDesc",selectedPan]];
    if (fundDetails.count>1) {
        txt_fund.inputView=picker_dropDown;
        [txt_fund setUserInteractionEnabled:YES];
    }
    else{
        if (fundDetails.count==1) {
            [txt_fund setUserInteractionEnabled:NO];
            KT_Table2RawQuery *fundRec=fundDetails[0];
            txt_fund.text=[NSString stringWithFormat:@"%@",fundRec.fundDesc];
            str_selectedFundID=[NSString stringWithFormat:@"%@",fundRec.fund];
            [self fetchFolioBasedOnFundID:str_selectedFundID];
        }
    }
}

#pragma mark - fetch FolioBased on Fund ID

-(void)fetchFolioBasedOnFundID:(NSString *)fundID{
    folioArray = [[DBManager sharedDataManagerInstance]uniqueFolioFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (Acno),notallowed_flag FROM TABLE2_DETAILS WHERE fund ='%@' AND PAN='%@'",fundID,selectedPan]];
    if (folioArray.count>1) {
        txt_folio.inputView=picker_dropDown;
    }
    else{
        if (folioArray.count==1) {
            [txt_folio setUserInteractionEnabled:NO];
            KT_TABLE2 *folioRec=folioArray[0];
            txt_folio.text=[NSString stringWithFormat:@"%@",folioRec.Acno];
            str_notAllowedFlag=[NSString stringWithFormat:@"%@",folioRec.notallowed_flag];
            selectedfolio=[NSString stringWithFormat:@"%@",folioRec.Acno];
            [self fetchSchemeBasedOnFundFolioAndNotAllowedFlag:str_selectedFundID forFolioNo:selectedfolio forFlag:str_notAllowedFlag];
        }
    }
}
#pragma mark - select Scheme Based on Fund And FolioNumber

-(void)fetchSchemeBasedOnFundFolioAndNotAllowedFlag:(NSString *)fundID forFolioNo:(NSString *)folioNumberID forFlag:(NSString *)notAllowed{
    BOOL checkSumZeroBalanceUnits=[[DBManager sharedDataManagerInstance]fetchTotalUnitBalance:[NSString stringWithFormat:@"SELECT SUM (balUnits) FROM TABLE2_DETAILS WHERE fund ='%@' AND PAN='%@' AND Acno='%@'",fundID,selectedPan,selectedfolio]];
    if (checkSumZeroBalanceUnits==YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_folio becomeFirstResponder];
            txt_folio.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"STP in zero balance folios is not allowed"];
        });
    }
    else if ([notAllowed isEqualToString:@"J"]|| [notAllowed isEqual:@"J"] || [notAllowed isEqualToString:@"j"]|| [notAllowed isEqual:@"j"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_folio becomeFirstResponder];
            txt_folio.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"STP in joint account folios is not allowed"];
        });
    }
    else if ([notAllowed isEqualToString:@"d"]|| [notAllowed isEqual:@"d"] || [notAllowed isEqualToString:@"D"]|| [notAllowed isEqual:@"D"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_folio becomeFirstResponder];
            txt_folio.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"STP in demat account folios is not allowed"];
        });
    }
    else{
       existingArr=[[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS WHERE fund ='%@' AND PAN='%@' AND Acno='%@' AND rSchFlg='Y'", str_selectedFundID, selectedPan, selectedfolio]];
        if (existingArr.count>1) {
            txt_schemeOut.inputView=picker_dropDown;
            [txt_sehemeIn setUserInteractionEnabled:YES];
        }
        else{
            if (existingArr.count==1) {
                [txt_schemeOut setUserInteractionEnabled:NO];
                KT_TABLE2 *schemeRec=existingArr[0];
                txt_schemeOut.text=[NSString stringWithFormat:@"%@",schemeRec.schDesc];
                selectedSecheme = [NSString stringWithFormat:@"%@",schemeRec.sch];
                lbl_currentvalue.text=[NSString stringWithFormat:@"%@",schemeRec.curValue];
                lbl_balanceUnits.text=[NSString stringWithFormat:@"%@",schemeRec.balUnits];
                [self DoNotAllowZeroSchemeBasedOnFundFolioAndNotAllowedFlag:fundID forFolioNo:folioNumberID forFlag:notAllowed forSchemeDesc:txt_sehemeIn.text forRecordIndex:schemeRec];
                [self categoryListApi];
      
            }
        }
    }
}

-(void)DoNotAllowZeroSchemeBasedOnFundFolioAndNotAllowedFlag:(NSString *)fundID forFolioNo:(NSString *)folioNumberID forFlag:(NSString *)notAllowed forSchemeDesc:(NSString *)schemeDesc forRecordIndex:(KT_TABLE2 *)scheRec{
    
    
    BOOL checkSumZeroBalanceUnits=[[DBManager sharedDataManagerInstance]fetchTotalUnitBalance:[NSString stringWithFormat:@"SELECT SUM (balUnits) FROM TABLE2_DETAILS WHERE fund ='%@' AND PAN='%@' AND Acno='%@' AND schDesc='%@'",fundID,selectedPan,folioNumberID,schemeDesc]];
    if (checkSumZeroBalanceUnits==YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_schemeOut becomeFirstResponder];
            txt_schemeOut.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"SWP in zero balance folios is not allowed"];
        });
    }
    else{
        txt_catergory.inputView = picker_dropDown;
        
        schemmeDic =scheRec;
        txt_schemeOut.text=[NSString stringWithFormat:@"%@",scheRec.schDesc];
        selectedSecheme=[NSString stringWithFormat:@"%@",scheRec.sch];
        lbl_currentvalue.text=[NSString stringWithFormat:@"%@",scheRec.curValue];
        lbl_balanceUnits.text=[NSString stringWithFormat:@"%@",scheRec.balUnits];
        lbl_amount.text=[NSString stringWithFormat:@"Minimum Amount ( ₹ ) : %1.f",[scheRec.redMinAmt floatValue]];
        mini_amount = [NSString stringWithFormat:@"%1.f",[scheRec.redMinAmt floatValue]];
        str_selectedSchType=[NSString stringWithFormat:@"%@",scheRec.schType];
        str_selectedSchPlan=[NSString stringWithFormat:@"%@",scheRec.pln];
        str_selectedSchOption=[NSString stringWithFormat:@"%@",scheRec.opt];
        str_mobileNumber=[NSString stringWithFormat:@"%@",scheRec.mobile];
//        mimimumRedAmount=[scheRec.redMinAmt floatValue];
//        current_navValue =[[[NSString stringWithFormat:@"%@",scheRec.curValue] stringByReplacingOccurrencesOfString:@","
//                                                                                                         withString:@""] floatValue];
 ///       [self categoryListApi];
        
        
    }
}


#pragma mark - categoryListApi
-(void)categoryListApi{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_url = [NSString stringWithFormat:@"%@GetAssetclass?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&schemetype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_folio];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            categoryArr= [[NSMutableArray alloc]init];
            if (categoryArr.count == 0) {
                categoryArr = responce[@"DtData"];
                txt_catergory.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];

                
                
            }
            
            categoryArr = responce[@"DtData"];
            
            NSLog(@"%@",categoryArr);
            
            
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


#pragma mark - NewSchemeListApi
-(void)newSchmemListApi{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_enCategory =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_catergory.text];
    NSString *str_trantype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"s"];
    NSString *str_divflg =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *  investflag ;
    if ([btn_direct.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
        investflag   = @"Regular";
        
    }else{
        
        investflag = @"Direct";
        
    }
    NSString *str_investflag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:investflag];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@getOtherSchemesSwitch?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fundCode=%@&acno=%@&category=%@&trantype=%@&divflg=%@&schtype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_folio,str_enCategory,str_trantype,str_divflg,str_investflag];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            if ([responce[@"DtData"] count]  != 0) {
                
                newschemeArr= [[NSMutableArray alloc]init];
                
                if (newschemeArr.count == 0) {
                    
                    newschemeArr =  responce[@"DtData"];
                    txt_sehemeIn.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                    [txt_sehemeIn becomeFirstResponder];
                    
                    
                    
                }
                newschemeArr =  responce[@"DtData"];
                NSLog(@"%@",responce);
            }else{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No new schemes Found"];
            }
            
            
            
            
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


#pragma mark - validate ARN API
#pragma mark - validate ARN API
-(void)validateARNAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    // NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_o_ErrNo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_subArn.text];
    
    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_arn.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@ValidateBrokercode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&AgentCd=%@&SubAgentCd=%@o_ErrNo&=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,Str_AgentCd,str_SubAgentCd,str_o_ErrNo];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            if ([responce[@"DtData"] count]  != 0) {
                self->subEArnarray= [[NSMutableArray alloc]init];
                if (self->subEArnarray.count == 0) {
                    self->subEArnarray = responce[@"DtData"];
                    self->txt_euinNo.inputView = self->picker_dropDown;
                    [self->picker_dropDown reloadAllComponents];
                    
                    if ([self->btn_yesEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]) {
                        [self->txt_euinNo becomeFirstResponder];
                        
                    }
                }
                self->subEArnarray = responce[@"DtData"];
            }
            else{
            txt_subArn.text =@"ARN-";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Please  Check ARN code"];
            }
            
            NSLog(@"%@",self->subEArnarray);
            
            
        }
        else{
            
           txt_subArn.text =@"ARN-";
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - validateSubARN API

-(void)validateSubARNAPI{
    [ [APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    // NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_o_ErrNo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_subArn.text];
    
    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_arn.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@ValidateBrokercode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&AgentCd=%@&SubAgentCd=%@o_ErrNo&=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,Str_AgentCd,str_SubAgentCd,str_o_ErrNo];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            if ([responce[@"DtData"] count]  != 0) {
                self->subEArnarray= [[NSMutableArray alloc]init];
                if (self->subEArnarray.count == 0) {
                    self->subEArnarray = responce[@"DtData"];
                    self->txt_euinNo.inputView = self->picker_dropDown;
                    [self->picker_dropDown reloadAllComponents];
                    
                    if ([self->btn_yesEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]) {
                        [self->txt_euinNo becomeFirstResponder];
                        
                    }
                }
                self->subEArnarray = responce[@"DtData"];
            }
            else{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Please  Check ARN code"];
            }
            
            NSLog(@"%@",self->subEArnarray);
            
            
        }
        else{
            
            self->txt_subArn.text =@"ARN-";
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - getInvFrequencyListApi
-(void)getInvFrequency{
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"IF"];
    NSString *str_astscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterSIP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&opt=%@&astscheme=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_opt,str_astscheme];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
        frequencyArr = responce[@"Dtinformation"];
            if (frequencyArr.count == 1) {
                self->txt_stpFrequency.userInteractionEnabled =NO;

                
                self->txt_stpFrequency.text = frequencyArr[0][@"FrequencyID"] ;
                
            }else{
                self->txt_stpFrequency.userInteractionEnabled =YES;
                ;                self->txt_stpFrequency.inputView =picker_dropDown;

            }
            
            NSLog(@"%@",self->frequencyArr);
            
            
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

#pragma mark - SIPSDAyListApi
-(void)getSTPDays{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"D"];
      NSString *str_astscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_stpFrequency.text];
    
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterSIP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&opt=%@&astscheme=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_opt,str_astscheme];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            [self getSTPOption];
            self->SIPDaysArr = responce[@"Dtinformation"];
            if (self->SIPDaysArr.count == 1) {
                txt_STPday.userInteractionEnabled =NO
                ;
                str_tat=  [NSString stringWithFormat:@"%@",SIPDaysArr[0][@"TAT"]];
                self->txt_STPday.text = [NSString  stringWithFormat:@"%@",self->SIPDaysArr[0][@"sip_cycleid"] ];
                
            }else{
                self->txt_STPday.userInteractionEnabled =YES;
                [self->txt_STPday becomeFirstResponder];
            }
            
            NSLog(@"%@",self->SIPDaysArr);
            
            
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
#pragma mark - getSTPOptionListApi
-(void)getSTPOption{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"STPW"];
    NSString *str_astscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_stpFrequency.text];
    
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterSIP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&opt=%@&astscheme=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_opt,str_astscheme];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            self->STPOptionArr = responce[@"Dtinformation"];
            if (self->STPOptionArr.count == 1) {
                txt_STPOption.userInteractionEnabled =NO
                ;
            self->txt_STPOption.text = [NSString  stringWithFormat:@"%@",self->SIPDaysArr[0][@"Description"] ];
                str_optionCode = [NSString  stringWithFormat:@"%@",self->SIPDaysArr[0][@"code"] ];

            }else{
                self->txt_STPOption.userInteractionEnabled =YES;
          
            }

            NSLog(@"%@",self->STPOptionArr);
            
            
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


-(void)STPsubmitamount{
   
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_foilo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_folio.text];
    NSString *str_selectedSecheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedSecheme];

    NSString *str_plan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedSchPlan];
    NSString *str_Option =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedSchOption];
    NSString *str_TargetSchPln=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *enc_arn;
    
    
    if( ( [str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"] ) ){
enc_arn=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_arn.text];

    } else {
enc_arn=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];

    }    NSString *enc_subarn;

       
       if(! [ txt_subArn.text   isEqualToString:@"ARN-" ] ){
        enc_subarn=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_subArn.text];
        
    } else {
        enc_subarn=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
        
    }
        NSString *enc_eun,*enc_euinflag;
       if( [ txt_euinNo.text length] == 0 ){
              enc_eun=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
           enc_euinflag=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];

           
       } else {
           enc_euinflag=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"Y"];

        
           enc_eun=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_euinNo.text];

       }

    NSString *str_tscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:newSchemmeDic[@"fm_scheme"]];
    NSString *str_tPlan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:newSchemmeDic[@"fm_plan"]];
    NSString *str_toption =[XTAPP_DELEGATE convertToBase64StrForAGivenString:newSchemmeDic[@"fm_option"]];
    NSString *str_fre=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_stpFrequency.text];
    
    
    
    NSString *serverStartDate;
    NSString *serverEndDate;
    @try{
        NSDateFormatter *dateServerFormatter = [[NSDateFormatter alloc] init];
        [dateServerFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *startDate = [dateServerFormatter dateFromString:[NSString stringWithFormat:@"%@",txt_fromDate.text]];
        NSDate *endDate = [dateServerFormatter dateFromString:[NSString stringWithFormat:@"%@",txt_todate.text]];
        [dateServerFormatter setDateFormat:@"MM/dd/yyyy"];
        serverStartDate =[NSString stringWithFormat:@"%@",[dateServerFormatter stringFromDate:startDate]];
        serverEndDate =[NSString stringWithFormat:@"%@",[dateServerFormatter stringFromDate:endDate]];
    }
    @catch (NSException *exception){
        serverStartDate =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",txt_fromDate.text]];
        serverEndDate =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",txt_todate.text]];
    }
  
    
    NSLog(@"serverStartDate   %@",serverStartDate);
    NSLog(@"serverStartDate   %@",serverStartDate);

//    tf_sipStartDay.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:startDate]];
    NSString *str_endDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:serverStartDate];
    NSString *str_toDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:serverEndDate];
    NSString *str_tNoofTransfer=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_noInstallmnts.text];
    NSString *str_Amount;
    
    if ( [str_optionCode isEqualToString:@"F"]) {
     str_Amount=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];

    }else{
        str_Amount=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_amount.text];

    }
   NSString *  mDataEmpty=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];

    NSDateFormatter *daateFormatter = [[NSDateFormatter alloc] init];
    [daateFormatter setDateFormat:XTOnlyDateFormat];
    NSString *datestamp = [daateFormatter stringFromDate:[NSDate date]];
    NSString *str_withdrawTRDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:datestamp];
    NSString *str_tr_type=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"STP"];
    NSString *str_i_EntBy=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_url = [NSString stringWithFormat:@"%@SaveSTPconfirmationWeb?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Acno=%@&Scheme=%@&Plan=%@&i_option=%@&TargetSchPln=%@&Distributor=%@&Subbroker=%@&Euin=%@&Euinvalid=%@&ToScheme=%@&Toplan=%@&Tooption=%@&DividendOption=%@&Freq=%@&Stdt=%@&Enddt=%@&NoofTransfer=%@&Amount=%@&Branch=%@&Trdate=%@&Trtype=%@&Entby=%@&Ihno=%@&Refno=%@&Batchno=%@&Remarks=%@&Barcode=%@&Errno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_foilo,str_selectedSecheme,str_plan,str_Option,str_TargetSchPln,enc_arn,enc_subarn,enc_eun,enc_euinflag,str_tscheme,str_tPlan,str_toption,str_TargetSchPln,str_fre,str_endDate,str_toDate,str_tNoofTransfer,str_Amount,str_TargetSchPln,str_withdrawTRDate,str_tr_type,str_i_EntBy,mDataEmpty,mDataEmpty,mDataEmpty,str_TargetSchPln,str_TargetSchPln,str_TargetSchPln];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            
            
            NSArray *minorRecordDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='P' "]];
            KT_TABLE12 *pan_rec=minorRecordDetails[0];
            
            NSMutableDictionary *mutDic=[NSMutableDictionary new];
            [mutDic addEntriesFromDictionary:responce[@"DtData"][0]];
            [mutDic setObject:txt_fund.text forKey:@"fundName"];
            [mutDic setObject:txt_folio.text forKey:@"folioName"];
            [mutDic setObject:txt_schemeOut.text forKey:@"schemeNameOut"];
            [mutDic setObject:txt_STPOption.text forKey:@"STPOption"];
            [mutDic setObject:txt_noInstallmnts.text forKey:@"numberWidthdrawals"];
            [mutDic setObject:txt_stpFrequency.text forKey:@"STPFrequency"];
            [mutDic setObject:txt_STPday.text forKey:@"STPDay"];
            [mutDic setObject:txt_fromDate.text forKey:@"STPStartDate"];
            [mutDic setObject:txt_todate.text forKey:@"STPEndDate"];
            [mutDic setObject:selectedPan forKey:@"PAN"];
            [mutDic setObject:pan_rec.invName  forKey:@"investorName"];
            [mutDic setObject:str_selectedFundID forKey:@"fundID"];
            [mutDic setObject:@"PrimaryPan" forKey:@"famliyStr"];
                        [mutDic setObject:str_mobileNumber forKey:@"mobileNumber"];

            
            if([ txt_arn.text   isEqualToString:@"ARN-" ] ){
                            [mutDic setObject:@"" forKey:@"Arn"];
            } else {
                [mutDic setObject:txt_arn.text forKey:@"Arn"];

            }
            if([ txt_subArn.text   isEqualToString:@"ARN-" ] ){
                [mutDic setObject:@"" forKey:@"SubArn"];
            } else {
                [mutDic setObject:txt_subArn.text forKey:@"SubArn"];
                
            }
            NSString *enc_eun,*enc_euinflag;
            if( [ txt_euinNo.text length] == 0 ){
                enc_eun=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
                enc_euinflag=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
                
                [mutDic setObject:@"" forKey:@"enc_euinflag"];
                [mutDic setObject:@"" forKey:@"euin"];


                
            } else {
       
                
                [mutDic setObject:@"Y" forKey:@"enc_euinflag"];
                [mutDic setObject:@"txt_euinNo.text" forKey:@"euin"];
                
            }



            [mutDic setObject:str_mobileNumber forKey:@"MobileNumber"];
            
            if ( [str_optionCode isEqualToString:@"F"]) {
           [mutDic setObject:@"0" forKey:@"amount"];

            }else{
                               [mutDic setObject:txt_amount.text forKey:@"amount"];
                
            }
            
            
            STPCinfVc *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"STPCinfVc"];
          
            destination.schemmeDetialsDic= newSchemmeDic;
            destination.schemeDic = schemmeDic;
            destination.DetialsDic = mutDic;

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
-(void)STPStartandEnddateAPi{
    
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_days =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_STPday.text];
    NSString *str_Frequency =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_stpFrequency.text];
    NSString *str_nots =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_noInstallmnts.text];
    
    NSString *str_url = [NSString stringWithFormat:@"%@CalcSIPEnddt?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&StartDate=%@&Frequency=%@&Installments=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_days,str_Frequency,str_nots];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            self->txt_fromDate.userInteractionEnabled = NO;
            self->txt_todate.userInteractionEnabled = NO;

            self->txt_fromDate.text =  [NSString stringWithFormat:@"%@",responce[@"DtData"][0][@"SIP_StartDate"]];
            self->txt_todate.text =  [NSString stringWithFormat:@"%@",responce[@"DtData"][0][@"SIP_EndDate"]];
      
            
            
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
#pragma mark - Initialise Rounded Corner To Fields

-(void)applyRoundedCornerAndInitialisation{
    [UITextField withoutRoundedCornerTextField:txt_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_folio forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_sehemeIn forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_schemeOut forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_stpFrequency  forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_euinNo forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_fromDate forCornerRadius:5.0f forBorderWidth:1.5f];
       [UITextField withoutRoundedCornerTextField:txt_STPday forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_todate forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_STPOption forCornerRadius:5.0f forBorderWidth:1.5f];
    
        [UITextField withoutRoundedCornerTextField:txt_catergory forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
}

#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    long int count=0;
    if (txt_currentTextField==txt_fund){
        count=[fundDetails count];
    }
    else if (txt_currentTextField==txt_folio){
        count=[folioArray count];
    }
    else if (txt_currentTextField==txt_schemeOut){
        count=[existingArr count];
    }
    else if (txt_currentTextField==txt_catergory){
        count=[categoryArr count];
    }
   else if (txt_currentTextField==txt_sehemeIn) {
   count= newschemeArr.count;
    }
  else  if (txt_currentTextField== txt_stpFrequency) {
        count =   frequencyArr.count ;
    }
 else  if (txt_currentTextField== txt_STPday) {
        count= SIPDaysArr.count;
    }
 else if (txt_currentTextField==txt_STPOption){
     count= STPOptionArr.count;
     
 }
 else   if (txt_currentTextField==txt_euinNo) {
        count= subEArnarray.count;
    }
//    else if (txt_currentTextField==txt_withdrawalOption){
//        count=[arr_swpOptionList count];
//    }
//    else if (txt_currentTextField==txt_withdrawalFrequency){
//        count=[arr_swpFreqList count];
//    }
//    else if (txt_currentTextField==txt_withdrawalDay){
//        count=[arr_swpDayList count];
//    }
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str_fundName;
    if (txt_currentTextField==txt_fund){
        KT_Table2RawQuery *fundRec=fundDetails[row];
        str_fundName=[NSString stringWithFormat:@"%@",fundRec.fundDesc];
    }
    else if (txt_currentTextField==txt_folio){
        KT_TABLE2 *folioRec=folioArray[row];
        str_fundName=[NSString stringWithFormat:@"%@",folioRec.Acno];
    }
    else if (txt_currentTextField==txt_schemeOut){
        KT_TABLE2 *folioRec=existingArr[row];
        str_fundName=[NSString stringWithFormat:@"%@",folioRec.schDesc];
    }
    else if (txt_currentTextField==txt_catergory){
        NSDictionary  *rec_fund=categoryArr[row];
        str_fundName=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];
    }
        else if (txt_currentTextField==txt_sehemeIn) {
        
        
        NSDictionary *rec_fund=newschemeArr[row];
        str_fundName=[NSString stringWithFormat:@"%@",rec_fund[@"fm_schdesc"]];
        
        
    }
  else  if (txt_currentTextField== txt_stpFrequency) {
        str_fundName =frequencyArr[row][@"FrequencyID"] ;
    }
else    if (txt_currentTextField== txt_STPday) {
        str_fundName=  [NSString  stringWithFormat:@"%@",self->SIPDaysArr[row][@"sip_cycleid"] ];
    }
else if (txt_currentTextField==txt_STPOption){
    str_fundName=[NSString stringWithFormat:@"%@",STPOptionArr[row][@"Description"]].capitalizedString;
    
}
else  if (txt_currentTextField==txt_euinNo) {
    NSDictionary *rec_fund=subEArnarray[row];
str_fundName=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
}
    
//    else if (txt_currentTextField==txt_withdrawalOption){
//        str_fundName=[NSString stringWithFormat:@"%@",arr_swpOptionList[row][@"Description"]].capitalizedString;
//    }
//    else if (txt_currentTextField==txt_withdrawalFrequency){
//        str_fundName=[NSString stringWithFormat:@"%@",arr_swpFreqList[row][@"FrequencyDescription"]].capitalizedString;
//    }
//    else if (txt_currentTextField==txt_withdrawalDay){
//        str_fundName=[NSString stringWithFormat:@"%@",arr_swpDayList[row][@"sip_cycleid"]];
//    }
    return str_fundName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (txt_currentTextField==txt_fund){
        KT_Table2RawQuery *fundRec=fundDetails[row];
        txt_fund.text=[NSString stringWithFormat:@"%@",fundRec.fundDesc];
        str_selectedFundID=[NSString stringWithFormat:@"%@",fundRec.fund];
        [self fetchFolioBasedOnFundID:str_selectedFundID];
    }
    else if (txt_currentTextField==txt_folio){
        KT_TABLE2 *folioRec=folioArray[row];
        txt_folio.text=[NSString stringWithFormat:@"%@",folioRec.Acno];
        str_notAllowedFlag=[NSString stringWithFormat:@"%@",folioRec.notallowed_flag];
        selectedfolio=[NSString stringWithFormat:@"%@",folioRec.Acno];
        [self fetchSchemeBasedOnFundFolioAndNotAllowedFlag:str_selectedFundID forFolioNo:selectedfolio forFlag:str_notAllowedFlag];
    }
    else if(txt_currentTextField==txt_schemeOut){
        KT_TABLE2 *schemeRec=existingArr[row];
        txt_schemeOut.text=[NSString stringWithFormat:@"%@",schemeRec.schDesc];
        lbl_currentvalue.text=[NSString stringWithFormat:@"%@",schemeRec.curValue];
        lbl_balanceUnits.text=[NSString stringWithFormat:@"%@",schemeRec.balUnits];
        [self DoNotAllowZeroSchemeBasedOnFundFolioAndNotAllowedFlag:str_selectedFundID forFolioNo:selectedfolio forFlag:str_notAllowedFlag forSchemeDesc:txt_schemeOut.text forRecordIndex:schemeRec];
    }
   else   if (txt_currentTextField==txt_catergory) {
        NSDictionary  *rec_fund=categoryArr[row];

        newschemeArr =[[NSMutableArray alloc]init];
        txt_sehemeIn.text  =nil;
        
        txt_catergory.text=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];
        str_Category=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];
        
        
    }
   else if (txt_currentTextField==txt_STPOption){
       
       
       txt_STPOption.text=[NSString stringWithFormat:@"%@",STPOptionArr[row][@"Description"]].capitalizedString;
       str_optionCode=[NSString stringWithFormat:@"%@",STPOptionArr[row][@"code"]].capitalizedString;
       
       if ([str_optionCode isEqualToString:@"F"]  ) {
           height_const.constant = 0;
           view_hieght.hidden =YES;
           txt_amount.text =Nil;
           
       }else{
           height_const.constant = 40;
           view_hieght.hidden =NO;
           txt_amount.text =Nil;

       }
       
   }
    
       else   if  (txt_currentTextField==txt_sehemeIn) {
        newSchemmeDic=newschemeArr[row];
        txt_sehemeIn.text=[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_schdesc"]];
    }
    
       else  if (txt_currentTextField== txt_stpFrequency) {
           txt_stpFrequency.text =frequencyArr[row][@"FrequencyID"] ;
           lbl_Mini.text = [NSString stringWithFormat:@"%@",frequencyArr[row][@"Minimum_Instalment"]];

       }
else    if (txt_currentTextField== txt_STPday) {
        
        str_tat=  [NSString stringWithFormat:@"%@",SIPDaysArr[row][@"TAT"]];
        txt_STPday.text= [NSString stringWithFormat:@"%@",SIPDaysArr[row][@"sip_cycleid"]];
    }
  else  if (txt_currentTextField==txt_euinNo) {
        NSDictionary *rec_fund=subEArnarray[row];
        txt_euinNo.text=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
    }

//    else if (txt_currentTextField==txt_withdrawalOption){
//        txt_withdrawalOption.text=[NSString stringWithFormat:@"%@",arr_swpOptionList[row][@"Description"]].capitalizedString;
//    }
//    else if (txt_currentTextField==txt_withdrawalFrequency){
//        txt_withdrawalFrequency.text=[NSString stringWithFormat:@"%@",arr_swpFreqList[row][@"FrequencyDescription"]];
//    }
//    else if (txt_currentTextField==txt_withdrawalDay){
//        txt_withdrawalDay.text=[NSString stringWithFormat:@"%@",arr_swpDayList[row][@"sip_cycleid"]];
//    }
}


#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTextField=textField;
    if (textField==txt_fund) {
        
        if (fundDetails.count>1) {
            [picker_dropDown reloadAllComponents];
        }
        [txt_schemeOut setUserInteractionEnabled:YES];
        [txt_folio setUserInteractionEnabled:YES];
        [textField becomeFirstResponder];
    }
    else if (textField==txt_folio) {
        if (txt_fund.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_folio resignFirstResponder];
                [txt_fund becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
            });
        }
        else{
  
            if (fundDetails.count>1) {
                [picker_dropDown reloadAllComponents];
            }
            [textField becomeFirstResponder];
        }
    }
    else if (textField==txt_schemeOut) {
        if (txt_fund.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_sehemeIn resignFirstResponder];
                [txt_fund becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
            });
        }
        else if (txt_folio.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_folio resignFirstResponder];
                [txt_folio becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
            });
        }
        else{

            if (existingArr.count>1) {
                [picker_dropDown reloadAllComponents];
            }
            [textField becomeFirstResponder];
        }
    }

        else if (textField==txt_catergory) {
            if (txt_fund.text.length==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [txt_sehemeIn resignFirstResponder];
                    [txt_fund becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
                });
            }
            else if (txt_folio.text.length==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [txt_folio resignFirstResponder];
                    [txt_folio becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
                });
            }
            else if (txt_schemeOut.text.length==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [txt_schemeOut resignFirstResponder];
                    [txt_schemeOut becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select Scheme."];
                });
            }
            else{
                
                if (categoryArr.count>1) {
                    

                    [picker_dropDown reloadAllComponents];
                }
                [textField becomeFirstResponder];
            }
    }
        else if (textField==txt_sehemeIn) {
            if (txt_fund.text.length==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [txt_sehemeIn resignFirstResponder];
                    [txt_fund becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
                });
            }
            else if (txt_folio.text.length==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [txt_folio resignFirstResponder];
                    [txt_folio becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
                });
            }
            else if (txt_schemeOut.text.length==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [txt_schemeOut resignFirstResponder];
                    [txt_schemeOut becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select Scheme."];
                });
            }
            else if (txt_catergory.text.length==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [txt_catergory resignFirstResponder];
                    [txt_catergory becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select Catergory."];
                });
            }
            else{
                
                if (newschemeArr.count>1) {
                    [picker_dropDown reloadAllComponents];
                }
                [textField becomeFirstResponder];
            }
        }
else    if (textField==txt_stpFrequency) {
        
        if (frequencyArr.count>1) {
            [picker_dropDown reloadAllComponents];
        }

    }
else    if (textField==txt_STPday) {
    
    if (SIPDaysArr.count>1) {
        txt_STPday.inputView = picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }
    

}
else    if (textField==txt_STPOption) {
    
    if (STPOptionArr.count>1) {
        txt_STPOption.inputView = picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }
    
}
else if (textField==txt_euinNo) {
    
    if ([txt_arn.text   isEqualToString:@"ARN-" ]) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the ARN-"];
        [txt_euinNo becomeFirstResponder];
        
    }else{
        if (subEArnarray.count == 0) {
            [txt_euinNo resignFirstResponder];
            [self  validateARNAPI];
            
        }else{
            // [self  categoryListApi];
            
            if (subEArnarray.count == 1) {
                
                NSDictionary *rec_fund=subEArnarray[0];
                
                NSLog(@"%@",rec_fund[@"abm_agent"]);
                
                txt_euinNo.text=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
                str_EuinNo =[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
                [txt_euinNo becomeFirstResponder];
                txt_euinNo.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
            }else{
                [txt_euinNo becomeFirstResponder];
                txt_euinNo.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
            }
        }
    }
    
}
//    else if (textField==txt_withdrawalOption) {
//        if (txt_fund.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalOption resignFirstResponder];
//                [txt_fund becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
//            });
//        }
//        else if (txt_folio.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalOption resignFirstResponder];
//                [txt_folio becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
//            });
//        }
//        else if (txt_scheme.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalOption resignFirstResponder];
//                [txt_scheme becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select scheme."];
//            });
//        }
//        else{
//            txt_withdrawalFrequency.text=@"";
//            txt_withdrawalDay.text=@"";
//            txt_noofWithdrawals.text=@"";
//            txt_fromDate.text=@"";
//            txt_toDate.text=@"";
//            txt_amount.text=@"";
//            if (arr_swpOptionList.count>1) {
//                [picker_dropDown reloadAllComponents];
//            }
//            [textField becomeFirstResponder];
//        }
//    }
//    else if (textField==txt_noofWithdrawals){
//        if (txt_fund.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_noofWithdrawals resignFirstResponder];
//                [txt_fund becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
//            });
//        }
//        else if (txt_folio.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_noofWithdrawals resignFirstResponder];
//                [txt_folio becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
//            });
//        }
//        else if (txt_scheme.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_noofWithdrawals resignFirstResponder];
//                [txt_scheme becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select scheme."];
//            });
//        }
//        else if (txt_withdrawalOption.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_noofWithdrawals resignFirstResponder];
//                [txt_withdrawalOption becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select withdrawal option."];
//            });
//        }
//        else{
//            txt_withdrawalFrequency.text=@"";
//            txt_withdrawalDay.text=@"";
//            txt_fromDate.text=@"";
//            txt_toDate.text=@"";
//            txt_amount.text=@"";
//            [textField becomeFirstResponder];
//        }
//    }
//    else if (textField==txt_withdrawalFrequency) {
//        if (txt_fund.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalFrequency resignFirstResponder];
//                [txt_fund becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
//            });
//        }
//        else if (txt_folio.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalFrequency resignFirstResponder];
//                [txt_folio becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
//            });
//        }
//        else if (txt_scheme.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalFrequency resignFirstResponder];
//                [txt_scheme becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select scheme."];
//            });
//        }
//        else if (txt_withdrawalOption.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalFrequency resignFirstResponder];
//                [txt_withdrawalOption becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select withdrawal option."];
//            });
//        }
//        else if (txt_noofWithdrawals.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalFrequency resignFirstResponder];
//                [txt_noofWithdrawals becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter number of withdrawals."];
//            });
//        }
//        else{
//            txt_withdrawalDay.text=@"";
//            txt_fromDate.text=@"";
//            txt_toDate.text=@"";
//            txt_amount.text=@"";
//            if (arr_swpFreqList.count>1) {
//                [picker_dropDown reloadAllComponents];
//            }
//            [textField becomeFirstResponder];
//        }
//    }
//    else if (textField==txt_withdrawalDay) {
//        if (txt_fund.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalDay resignFirstResponder];
//                [txt_fund becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
//            });
//        }
//        else if (txt_folio.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalDay resignFirstResponder];
//                [txt_folio becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
//            });
//        }
//        else if (txt_scheme.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalDay resignFirstResponder];
//                [txt_scheme becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select scheme."];
//            });
//        }
//        else if (txt_withdrawalOption.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalDay resignFirstResponder];
//                [txt_withdrawalOption becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select withdrawal option."];
//            });
//        }
//        else if (txt_noofWithdrawals.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalDay resignFirstResponder];
//                [txt_noofWithdrawals becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter number of withdrawals."];
//            });
//        }
//        else if (txt_withdrawalFrequency.text.length==0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [txt_withdrawalDay resignFirstResponder];
//                [txt_withdrawalFrequency becomeFirstResponder];
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select withdrawal frequency."];
//            });
//        }
//        else{
//            txt_fromDate.text=@"";
//            txt_toDate.text=@"";
//            txt_amount.text=@"";
//            if (arr_swpDayList.count>1) {
//                [picker_dropDown reloadAllComponents];
//            }
//            [textField becomeFirstResponder];
//        }
//    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (txt_currentTextField==txt_withdrawalOption) {
//        if ([txt_withdrawalOption.text rangeOfString:@"Capital Appreciation" options:NSCaseInsensitiveSearch].location == NSNotFound) {
//            [view_stackHidden setHidden:NO];
//            [self.view layoutIfNeeded];
//            [self.view updateConstraints];
//            [self updateScrollContent];
//            checkAmount=YES;
//        }
//        else{
//            [view_stackHidden setHidden:YES];
//            [self.view layoutIfNeeded];
//            [self.view updateConstraints];
//            checkAmount=NO;
//            [self updateScrollContent];
//        }
//    }
//    else if (txt_currentTextField == txt_noofWithdrawals){
//        [self getSWPFrequency:str_selectedFundID];
//    }
//    else if (txt_currentTextField==txt_withdrawalFrequency) {
//        [self getSWPDayDetails:str_selectedFundID];
//    }
//    else if (txt_currentTextField==txt_withdrawalDay) {
//        [self getSWPStartAndEndDatesForWidthDrawFreq:txt_withdrawalFrequency.text forWithdrawcount:txt_noofWithdrawals.text forWithdrawday:txt_withdrawalDay.text forFundSelected:str_selectedFundID];
//    }
//    [textField resignFirstResponder];
//}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==txt_amount) {
        if (txt_amount.text.length >= MAX_LENGTH && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==txt_noInstallmnts) {
        if (txt_noInstallmnts.text.length >= 3 && range.length == 0){
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

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (txt_currentTextField==txt_schemeOut) {
        [self  categoryListApi];
        
    }
  else  if (txt_currentTextField==txt_catergory) {
        [self  newSchmemListApi];
        
    }
  else  if (txt_currentTextField==txt_sehemeIn) {
      [self  getInvFrequency];
      
  }
    
  else if (textField==txt_noInstallmnts) {
            [self  getSTPDays];

      
      }
  else if (textField==txt_STPday) {
      [self  STPStartandEnddateAPi];
      
      
  }
    
  else    if (textField==txt_arn ) {
      
      if ([txt_arn.text isEqualToString:@"ARN-"]   ) {
          
          if ([txt_arn.text length ] == 0) {
              [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the ARN- Code "];
              
          }
      } else {
          [self validateARNAPI];
          
          
      }
  }
  else    if (textField==txt_subArn ) {
      
      if ([txt_subArn.text isEqualToString:@"ARN-"]   ) {
          
          
      }
      else {
          
          [self validateSubARNAPI];
          ;
      }
      
      
      
  }
//    else if (txt_currentTextField == txt_noofWithdrawals){
//    }
//    else if (txt_currentTextField==txt_withdrawalFrequency) {
//        [self getSWPDayDetails:str_selectedFundID];
//    }
//    else if (txt_currentTextField==txt_withdrawalDay) {
//        [self getSWPStartAndEndDatesForWidthDrawFreq:txt_withdrawalFrequency.text forWithdrawcount:txt_noofWithdrawals.text forWithdrawday:txt_withdrawalDay.text forFundSelected:str_selectedFundID];
//    }
    [textField resignFirstResponder];
}

@end
