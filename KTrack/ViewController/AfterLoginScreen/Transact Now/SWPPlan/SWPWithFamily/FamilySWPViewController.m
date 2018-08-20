//
//  FamilySWPViewController.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 13/07/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "FamilySWPViewController.h"

@interface FamilySWPViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    __weak IBOutlet UITextField *txt_familyMember;
    __weak IBOutlet UITextField *txt_amount;
    __weak IBOutlet UILabel *lbl_minAmount;
    __weak IBOutlet UIView *view_back;
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UITextField *txt_toDate;
    __weak IBOutlet UITextField *txt_fromDate;
    __weak IBOutlet UITextField *txt_withdrawalDay;
    __weak IBOutlet UITextField *txt_withdrawalFrequency;
    __weak IBOutlet UITextField *txt_noofWithdrawals;
    __weak IBOutlet UITextField *txt_withdrawalOption;
    __weak IBOutlet UILabel *lbl_currentValue;
    __weak IBOutlet UILabel *lbl_balanceUnits;
    __weak IBOutlet UITextField *txt_scheme;
    __weak IBOutlet UITextField *txt_folio;
    __weak IBOutlet UITextField *txt_fund;
    __weak IBOutlet UIScrollView *scroll_mainScroll;
    NSArray *arr_fundList, *arr_folioList, *arr_schemeList, *arr_swpOptionList, *arr_swpDayList, *arr_swpFreqList, *arr_payBankList,*arr_familyPanRec;
    NSString *str_userPrimaryPan, *str_selectedFundID, *str_selectedFolioID, *str_selectedSchemeID, *str_notAllowedFlag, *str_withdrawalAmount, *str_invName;
    UIPickerView *picker_dropDown;
    UITextField *txt_currentTextField;
    __weak IBOutlet UIView *view_stackHidden;
    BOOL checkAmount;
    CGFloat mimimumRedAmount,current_navValue;
    NSString *str_balanceUnits,*str_mobileNumber,*str_selectedSchPlan,*str_selectedSchOption,*str_selectedSchType;
}

@end

@implementation FamilySWPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
    checkAmount=YES;
    [self applyRoundedCornerAndInitialisation];
    [self onViewInitialise];
    lbl_minAmount.text=[NSString stringWithFormat:@"Minimum Amount ( ₹ ) : 0.0"];
    [txt_fund addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_folio addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_scheme addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_withdrawalOption addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_noofWithdrawals addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_withdrawalFrequency addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_withdrawalDay addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneAction:(UIBarButtonItem *)done{
    if (txt_currentTextField==txt_familyMember){
        [self fetchFundsRecordsFromDB];
    }
    else if (txt_currentTextField==txt_fund){
        [self fetchFolioBasedOnFundID:str_selectedFundID];
    }
    else if (txt_currentTextField==txt_folio){
        [self fetchSchemeBasedOnFundFolioAndNotAllowedFlag:str_selectedFundID forFolioNo:str_selectedFolioID forFlag:str_notAllowedFlag];
    }
    else if(txt_currentTextField==txt_scheme){
        
    }
    [txt_currentTextField resignFirstResponder];
}

#pragma mark - update scroll content

-(void)updateScrollContent{
    scroll_mainScroll.contentSize=CGSizeMake(self.view.frame.size.width, scroll_mainScroll.frame.origin.y+btn_submit.frame.origin.y+btn_submit.frame.size.height+20);
}

#pragma mark - Initialise Rounded Corner To Fields

-(void)applyRoundedCornerAndInitialisation{
    [UITextField withoutRoundedCornerTextField:txt_familyMember forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_folio forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_scheme forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_withdrawalOption forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_withdrawalFrequency forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_withdrawalDay forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_fromDate forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_toDate forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
}

#pragma mark - ViewDidInitialise

-(void)onViewInitialise{
    arr_familyPanRec = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE  Not flag='P'"]];
    if (arr_familyPanRec.count==1) {
        [txt_familyMember setUserInteractionEnabled:NO];
        KT_TABLE12 *rec_primaryPan=arr_familyPanRec[0];
        str_userPrimaryPan=[NSString stringWithFormat:@"%@",rec_primaryPan.PAN];
        str_invName=[NSString stringWithFormat:@"%@",rec_primaryPan.invName];
        txt_familyMember.text=str_invName;
        [self fetchFundsRecordsFromDB];
    }
    else{
        if (arr_familyPanRec.count>1){
            txt_familyMember.inputView=picker_dropDown;
            [txt_familyMember setUserInteractionEnabled:YES];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Information" withMessage:@"No family record found."];
            });
        }
    }
}

#pragma mark - fetch Funds

-(void)fetchFundsRecordsFromDB{
    arr_fundList = [[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT distinct fundDesc, fund FROM TABLE2_DETAILS WHERE PAN='%@' AND rFlag='Y' AND rSchFlg='Y' order By FundDesc",str_userPrimaryPan]];
    if (arr_fundList.count>1) {
        txt_fund.inputView=picker_dropDown;
        [txt_fund setUserInteractionEnabled:YES];
    }
    else{
        if (arr_fundList.count==1) {
            [txt_fund setUserInteractionEnabled:NO];
            KT_Table2RawQuery *fundRec=arr_fundList[0];
            txt_fund.text=[NSString stringWithFormat:@"%@",fundRec.fundDesc];
            str_selectedFundID=[NSString stringWithFormat:@"%@",fundRec.fund];
            [self fetchFolioBasedOnFundID:str_selectedFundID];
        }
    }
}

#pragma mark - fetch FolioBased on Fund ID

-(void)fetchFolioBasedOnFundID:(NSString *)fundID{
    arr_folioList = [[DBManager sharedDataManagerInstance]uniqueFolioFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (Acno),notallowed_flag FROM TABLE2_DETAILS WHERE fund ='%@' AND PAN='%@'",fundID,str_userPrimaryPan]];
    if (arr_folioList.count>1) {
        txt_folio.inputView=picker_dropDown;
    }
    else{
        if (arr_folioList.count==1) {
            [txt_folio setUserInteractionEnabled:NO];
            KT_TABLE2 *folioRec=arr_folioList[0];
            txt_folio.text=[NSString stringWithFormat:@"%@",folioRec.Acno];
            str_notAllowedFlag=[NSString stringWithFormat:@"%@",folioRec.notallowed_flag];
            str_selectedFolioID=[NSString stringWithFormat:@"%@",folioRec.Acno];
            [self fetchSchemeBasedOnFundFolioAndNotAllowedFlag:str_selectedFundID forFolioNo:str_selectedFolioID forFlag:str_notAllowedFlag];
        }
    }
}

#pragma mark - select Scheme Based on Fund And FolioNumber

-(void)fetchSchemeBasedOnFundFolioAndNotAllowedFlag:(NSString *)fundID forFolioNo:(NSString *)folioNumberID forFlag:(NSString *)notAllowed{
    BOOL checkSumZeroBalanceUnits=[[DBManager sharedDataManagerInstance]fetchTotalUnitBalance:[NSString stringWithFormat:@"SELECT SUM (balUnits) FROM TABLE2_DETAILS WHERE fund ='%@' AND PAN='%@' AND Acno='%@'",fundID,str_userPrimaryPan,folioNumberID]];
    if (checkSumZeroBalanceUnits==YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_folio becomeFirstResponder];
            txt_folio.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"SWP in zero balance folios is not allowed"];
        });
    }
    else if ([notAllowed isEqualToString:@"J"]|| [notAllowed isEqual:@"J"] || [notAllowed isEqualToString:@"j"]|| [notAllowed isEqual:@"j"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_folio becomeFirstResponder];
            txt_folio.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"SWP in joint account folios is not allowed"];
        });
    }
    else if ([notAllowed isEqualToString:@"d"]|| [notAllowed isEqual:@"d"] || [notAllowed isEqualToString:@"D"]|| [notAllowed isEqual:@"D"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_folio becomeFirstResponder];
            txt_folio.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"SWP in demat account folios is not allowed"];
        });
    }
    else{
        arr_schemeList=[[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS WHERE fund ='%@' AND PAN='%@' AND Acno='%@' AND rSchFlg='Y'", fundID, str_userPrimaryPan, folioNumberID]];
        if (arr_schemeList.count>1) {
            txt_scheme.inputView=picker_dropDown;
            [txt_scheme setUserInteractionEnabled:YES];
        }
        else{
            if (arr_schemeList.count==1) {
                [txt_scheme setUserInteractionEnabled:NO];
                KT_TABLE2 *schemeRec=arr_schemeList[0];
                txt_scheme.text=[NSString stringWithFormat:@"%@",schemeRec.schDesc];
                str_selectedSchemeID=[NSString stringWithFormat:@"%@",schemeRec.sch];
                [self DoNotAllowZeroSchemeBasedOnFundFolioAndNotAllowedFlag:fundID forFolioNo:folioNumberID forFlag:notAllowed forSchemeDesc:txt_scheme.text forRecordIndex:schemeRec];
            }
        }
    }
}

-(void)DoNotAllowZeroSchemeBasedOnFundFolioAndNotAllowedFlag:(NSString *)fundID forFolioNo:(NSString *)folioNumberID forFlag:(NSString *)notAllowed forSchemeDesc:(NSString *)schemeDesc forRecordIndex:(KT_TABLE2 *)scheRec{
    BOOL checkSumZeroBalanceUnits=[[DBManager sharedDataManagerInstance]fetchTotalUnitBalance:[NSString stringWithFormat:@"SELECT SUM (balUnits) FROM TABLE2_DETAILS WHERE fund ='%@' AND PAN='%@' AND Acno='%@' AND schDesc='%@'",fundID,str_userPrimaryPan,folioNumberID,schemeDesc]];
    if (checkSumZeroBalanceUnits==YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_scheme becomeFirstResponder];
            txt_scheme.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"SWP in zero balance folios is not allowed"];
        });
    }
    else{
        txt_scheme.text=[NSString stringWithFormat:@"%@",scheRec.schDesc];
        str_selectedSchemeID=[NSString stringWithFormat:@"%@",scheRec.sch];
        lbl_currentValue.text=[NSString stringWithFormat:@"%@",scheRec.curValue];
        lbl_balanceUnits.text=[NSString stringWithFormat:@"%@",scheRec.balUnits];
        lbl_minAmount.text=[NSString stringWithFormat:@"Minimum Amount ( ₹ ) : %1.f",[scheRec.redMinAmt floatValue]];
        str_selectedSchType=[NSString stringWithFormat:@"%@",scheRec.schType];
        str_selectedSchPlan=[NSString stringWithFormat:@"%@",scheRec.pln];
        str_selectedSchOption=[NSString stringWithFormat:@"%@",scheRec.opt];
        str_mobileNumber=[NSString stringWithFormat:@"%@",scheRec.mobile];
        mimimumRedAmount=[scheRec.redMinAmt floatValue];
        current_navValue =[[[NSString stringWithFormat:@"%@",scheRec.curValue] stringByReplacingOccurrencesOfString:@","
                                                                                                         withString:@""] floatValue];
        [self getSWPOptionDetails:str_selectedFundID];
    }
}

#pragma mark - load bank list based on PAN, Folio and Fund

-(void)fetchBankDetailsBasedOnFolio:(NSString *)folioNumber forFundName:(NSString *)fundID {
    arr_payBankList=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable10:[NSString stringWithFormat:@"SELECT * FROM TABLE10_BANKDETAILS WHERE fund='%@' AND Acno='%@' ",fundID,folioNumber]];
    if (arr_payBankList.count>1) {
        
    }
    else{
        if (arr_payBankList.count==1){
            
        }
    }
}

#pragma mark - fetch SWP Frequency

-(void)getSWPFrequency:(NSString *)selectedFund{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"SWF"];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedFund];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterSIP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fund];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            arr_swpFreqList=responce[@"Dtinformation"];
            if (arr_swpFreqList.count>1) {
                [txt_withdrawalFrequency setUserInteractionEnabled:YES];
                txt_withdrawalFrequency.inputView=picker_dropDown;
            }
            else{
                if(arr_swpFreqList.count==1){
                    [txt_withdrawalFrequency setUserInteractionEnabled:NO];
                    txt_withdrawalFrequency.text=[NSString stringWithFormat:@"%@",arr_swpFreqList[0][@"FrequencyDescription"]];
                    [self getSWPDayDetails:str_selectedFundID];
                }
                else{
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No SWP Frequencies found,Try Again!"];
                }
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - fetch SWP Options

-(void)getSWPOptionDetails:(NSString *)selectedFund{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"SWPW"];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedFund];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterSIP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fund];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            arr_swpOptionList=responce[@"Dtinformation"];
            if (arr_swpOptionList.count>1) {
                [txt_withdrawalOption setUserInteractionEnabled:YES];
                txt_withdrawalOption.inputView=picker_dropDown;
            }
            else{
                if(arr_swpOptionList.count==1){
                    [txt_withdrawalOption setUserInteractionEnabled:NO];
                    txt_withdrawalOption.text=[NSString stringWithFormat:@"%@",arr_swpOptionList[0][@"Description"]].capitalizedString;
                }
                else{
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No SWP Options found,Try Again!"];
                }
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SWP DAY

-(void)getSWPDayDetails:(NSString *)selectedFund{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"SWPD"];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedFund];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterSIP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fund];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            arr_swpDayList=responce[@"Dtinformation"];
            if (arr_swpDayList.count>1) {
                txt_withdrawalDay.inputView=picker_dropDown;
            }
            else{
                if(arr_swpDayList.count==1){
                    txt_withdrawalDay.text=[NSString stringWithFormat:@"%@",arr_swpDayList[0][@"sip_cycleid"]];
                }
                else{
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No SWP Days found,Try Again!"];
                }
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - back button tapped

- (IBAction)btn_backTapped:(UIButton *)sender {
    KTPOP(YES);
}

#pragma mark - Get SWP START AND END DATES

-(void)getSWPStartAndEndDatesForWidthDrawFreq:(NSString *)withdrawFreq forWithdrawcount:(NSString *)withdrawCount forWithdrawday:(NSString *)withdrawDay forFundSelected:(NSString *)selectedFund{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedFund];
    NSString *str_withdrawFreq=[XTAPP_DELEGATE convertToBase64StrForAGivenString:withdrawFreq];
    NSString *str_withdrawCount=[XTAPP_DELEGATE convertToBase64StrForAGivenString:withdrawCount];
    NSString *str_withdrawDay=[XTAPP_DELEGATE convertToBase64StrForAGivenString:withdrawDay];
    NSString *str_url = [NSString stringWithFormat:@"%@CalcSIPEnddt?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Frequency=%@&StartDate=%@&Installments=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_withdrawFreq,str_withdrawDay,str_withdrawCount];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error_statuscode==0) {
                txt_fromDate.text=[[SharedUtility sharedInstance]removeNullFromStr:[NSString stringWithFormat:@"%@",responce[@"DtData"][0][@"SIP_StartDate"]]];
                txt_toDate.text=[[SharedUtility sharedInstance]removeNullFromStr:[NSString stringWithFormat:@"%@",responce[@"DtData"][0][@"SIP_EndDate"]]];
                [txt_fromDate setUserInteractionEnabled:NO];
                [txt_toDate setUserInteractionEnabled:NO];
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTextField=textField;
    if (textField==txt_familyMember) {
        txt_fund.text=@"";
        txt_scheme.text=@"";
        txt_folio.text=@"";
        txt_withdrawalFrequency.text=@"";
        txt_withdrawalOption.text=@"";
        txt_withdrawalDay.text=@"";
        lbl_balanceUnits.text=@"";
        lbl_currentValue.text=@"";
        txt_fromDate.text=@"";
        txt_toDate.text=@"";
        if (arr_familyPanRec.count>1) {
            [picker_dropDown selectRow:0 inComponent:0 animated:YES];
            [picker_dropDown reloadAllComponents];
        }
        [txt_fund setUserInteractionEnabled:NO];
        [txt_scheme setUserInteractionEnabled:NO];
        [txt_folio setUserInteractionEnabled:NO];
         [textField becomeFirstResponder];
    }
    else if (textField==txt_fund) {
        if (txt_familyMember.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_fund resignFirstResponder];
                [txt_familyMember becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select family member."];
            });
        }
        else{
            txt_scheme.text=@"";
            txt_folio.text=@"";
            txt_withdrawalFrequency.text=@"";
            txt_withdrawalOption.text=@"";
            txt_withdrawalDay.text=@"";
            lbl_balanceUnits.text=@"";
            lbl_currentValue.text=@"";
            txt_fromDate.text=@"";
            txt_toDate.text=@"";
            if (arr_fundList.count>1) {
                [picker_dropDown selectRow:0 inComponent:0 animated:YES];
                [picker_dropDown reloadAllComponents];
            }
            KT_Table2RawQuery *fundRec=arr_fundList[0];
            txt_fund.text=[NSString stringWithFormat:@"%@",fundRec.fundDesc];
            str_selectedFundID=[NSString stringWithFormat:@"%@",fundRec.fund];
            [txt_scheme setUserInteractionEnabled:YES];
            [txt_folio setUserInteractionEnabled:YES];
            [textField becomeFirstResponder];
        }
    }
    else if (textField==txt_folio) {
        if (txt_familyMember.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_folio resignFirstResponder];
                [txt_familyMember becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select family member."];
            });
        }
        else if (txt_fund.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_folio resignFirstResponder];
                [txt_fund becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
            });
        }
        else{
            txt_scheme.text=@"";
            txt_withdrawalFrequency.text=@"";
            txt_withdrawalOption.text=@"";
            txt_withdrawalDay.text=@"";
            lbl_balanceUnits.text=@"";
            lbl_currentValue.text=@"";
            txt_fromDate.text=@"";
            txt_toDate.text=@"";
            if (arr_folioList.count>1) {
                [picker_dropDown selectRow:0 inComponent:0 animated:YES];
                [picker_dropDown reloadAllComponents];
            }
            KT_TABLE2 *folioRec=arr_folioList[0];
            txt_folio.text=[NSString stringWithFormat:@"%@",folioRec.Acno];
            str_notAllowedFlag=[NSString stringWithFormat:@"%@",folioRec.notallowed_flag];
            str_selectedFolioID=[NSString stringWithFormat:@"%@",folioRec.Acno];
             [textField becomeFirstResponder];
        }
    }
    else if (textField==txt_scheme) {
        if (txt_familyMember.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_scheme resignFirstResponder];
                [txt_familyMember becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select family member."];
            });
        }
        else if (txt_fund.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_scheme resignFirstResponder];
                [txt_fund becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
            });
        }
        else if (txt_folio.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_scheme resignFirstResponder];
                [txt_folio becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
            });
        }
        else{
            txt_withdrawalFrequency.text=@"";
            txt_withdrawalOption.text=@"";
            txt_withdrawalDay.text=@"";
            lbl_balanceUnits.text=@"";
            lbl_currentValue.text=@"";
            txt_fromDate.text=@"";
            txt_toDate.text=@"";
            if (arr_schemeList.count>1) {
                [picker_dropDown selectRow:0 inComponent:0 animated:YES];
                [picker_dropDown reloadAllComponents];
            }
            KT_TABLE2 *schemeRec=arr_schemeList[0];
            txt_scheme.text=[NSString stringWithFormat:@"%@",schemeRec.schDesc];
            lbl_currentValue.text=[NSString stringWithFormat:@"%@",schemeRec.curValue];
            lbl_balanceUnits.text=[NSString stringWithFormat:@"%@",schemeRec.balUnits];
             [textField becomeFirstResponder];
        }
    }
    else if (textField==txt_withdrawalOption) {
        if (txt_familyMember.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalOption resignFirstResponder];
                [txt_familyMember becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select family member."];
            });
        }
        else if (txt_fund.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalOption resignFirstResponder];
                [txt_fund becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
            });
        }
        else if (txt_folio.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalOption resignFirstResponder];
                [txt_folio becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
            });
        }
        else if (txt_scheme.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalOption resignFirstResponder];
                [txt_scheme becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select scheme."];
            });
        }
        else{
            txt_withdrawalFrequency.text=@"";
            txt_withdrawalDay.text=@"";
            txt_noofWithdrawals.text=@"";
            txt_fromDate.text=@"";
            txt_toDate.text=@"";
            txt_amount.text=@"";
            if (arr_swpOptionList.count>1) {
                [picker_dropDown selectRow:0 inComponent:0 animated:YES];
                [picker_dropDown reloadAllComponents];
            }
             [textField becomeFirstResponder];
        }
    }
    else if (textField==txt_noofWithdrawals){
        if (txt_familyMember.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_noofWithdrawals resignFirstResponder];
                [txt_familyMember becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select family member."];
            });
        }
        else if (txt_fund.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_noofWithdrawals resignFirstResponder];
                [txt_fund becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
            });
        }
        else if (txt_folio.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_noofWithdrawals resignFirstResponder];
                [txt_folio becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
            });
        }
        else if (txt_scheme.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_noofWithdrawals resignFirstResponder];
                [txt_scheme becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select scheme."];
            });
        }
        else if (txt_withdrawalOption.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_noofWithdrawals resignFirstResponder];
                [txt_withdrawalOption becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select withdrawal option."];
            });
        }
        else{
            txt_withdrawalFrequency.text=@"";
            txt_withdrawalDay.text=@"";
            txt_fromDate.text=@"";
            txt_toDate.text=@"";
            txt_amount.text=@"";
             [textField becomeFirstResponder];
        }
    }
    else if (textField==txt_withdrawalFrequency) {
        if (txt_familyMember.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalFrequency resignFirstResponder];
                [txt_familyMember becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select family member."];
            });
        }
        else if (txt_fund.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalFrequency resignFirstResponder];
                [txt_fund becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
            });
        }
        else if (txt_folio.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalFrequency resignFirstResponder];
                [txt_folio becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
            });
        }
        else if (txt_scheme.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalFrequency resignFirstResponder];
                [txt_scheme becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select scheme."];
            });
        }
        else if (txt_withdrawalOption.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalFrequency resignFirstResponder];
                [txt_withdrawalOption becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select withdrawal option."];
            });
        }
        else if (txt_noofWithdrawals.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalFrequency resignFirstResponder];
                [txt_noofWithdrawals becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter number of withdrawals."];
            });
        }
        else{
            txt_withdrawalDay.text=@"";
            txt_fromDate.text=@"";
            txt_toDate.text=@"";
            txt_amount.text=@"";
            if (arr_swpFreqList.count>1) {
                [picker_dropDown selectRow:0 inComponent:0 animated:YES];
                [picker_dropDown reloadAllComponents];
            }
             [textField becomeFirstResponder];
        }
    }
    else if (textField==txt_withdrawalDay) {
        if (txt_familyMember.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalDay resignFirstResponder];
                [txt_familyMember becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select family member."];
            });
        }
        else if (txt_fund.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalDay resignFirstResponder];
                [txt_fund becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
            });
        }
        else if (txt_folio.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalDay resignFirstResponder];
                [txt_folio becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select folio."];
            });
        }
        else if (txt_scheme.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalDay resignFirstResponder];
                [txt_scheme becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select scheme."];
            });
        }
        else if (txt_withdrawalOption.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalDay resignFirstResponder];
                [txt_withdrawalOption becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select withdrawal option."];
            });
        }
        else if (txt_noofWithdrawals.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalDay resignFirstResponder];
                [txt_noofWithdrawals becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter number of withdrawals."];
            });
        }
        else if (txt_withdrawalFrequency.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_withdrawalDay resignFirstResponder];
                [txt_withdrawalFrequency becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select withdrawal frequency."];
            });
        }
        else{
            txt_fromDate.text=@"";
            txt_toDate.text=@"";
            txt_amount.text=@"";
            if (arr_swpDayList.count>1) {
                [picker_dropDown selectRow:0 inComponent:0 animated:YES];
                [picker_dropDown reloadAllComponents];
            }
             [textField becomeFirstResponder];
        }
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (txt_currentTextField==txt_withdrawalOption) {
        if ([txt_withdrawalOption.text rangeOfString:@"Capital Appreciation" options:NSCaseInsensitiveSearch].location == NSNotFound) {
            [view_stackHidden setHidden:NO];
            checkAmount=YES;
        }
        else{
            [view_stackHidden setHidden:YES];
            checkAmount=NO;
        }
    }
    else if (txt_currentTextField == txt_noofWithdrawals){
        [self getSWPFrequency:str_selectedFundID];
    }
    else if (txt_currentTextField==txt_withdrawalFrequency) {
        [self getSWPDayDetails:str_selectedFundID];
    }
    else if (txt_currentTextField==txt_withdrawalDay) {
        [self getSWPStartAndEndDatesForWidthDrawFreq:txt_withdrawalFrequency.text forWithdrawcount:txt_noofWithdrawals.text forWithdrawday:txt_withdrawalDay.text forFundSelected:str_selectedFundID];
    }
    [textField resignFirstResponder];
}

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
    else if (textField==txt_noofWithdrawals) {
        if (txt_noofWithdrawals.text.length >= 3 && range.length == 0){
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

#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    long int count=0;
    if (txt_currentTextField==txt_familyMember){
        count=[arr_familyPanRec count];
    }
    else if (txt_currentTextField==txt_fund){
        count=[arr_fundList count];
    }
    else if (txt_currentTextField==txt_folio){
        count=[arr_folioList count];
    }
    else if (txt_currentTextField==txt_scheme){
        count=[arr_schemeList count];
    }
    else if (txt_currentTextField==txt_withdrawalOption){
        count=[arr_swpOptionList count];
    }
    else if (txt_currentTextField==txt_withdrawalFrequency){
        count=[arr_swpFreqList count];
    }
    else if (txt_currentTextField==txt_withdrawalDay){
        count=[arr_swpDayList count];
    }
    return count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *pickerLabel;
    CGRect frame = CGRectMake(5.0, 0.0,self.view.frame.size.width-10,40);
    pickerLabel = [[UILabel alloc] initWithFrame:frame];
    UILabel *lbl_title=[[UILabel alloc]init];
    lbl_title.frame=frame;
    NSString *str_fundName;
    if (txt_currentTextField==txt_familyMember){
        KT_TABLE12 *fundRec=arr_familyPanRec[row];
        str_fundName=[NSString stringWithFormat:@"%@",fundRec.invName];
    }
    else if (txt_currentTextField==txt_fund){
        KT_Table2RawQuery *fundRec=arr_fundList[row];
        str_fundName=[NSString stringWithFormat:@"%@",fundRec.fundDesc];
    }
    else if (txt_currentTextField==txt_folio){
        KT_TABLE2 *folioRec=arr_folioList[row];
        str_fundName=[NSString stringWithFormat:@"%@",folioRec.Acno];
    }
    else if (txt_currentTextField==txt_scheme){
        KT_TABLE2 *folioRec=arr_schemeList[row];
        str_fundName=[NSString stringWithFormat:@"%@",folioRec.schDesc];
    }
    else if (txt_currentTextField==txt_withdrawalOption){
        str_fundName=[NSString stringWithFormat:@"%@",arr_swpOptionList[row][@"Description"]].capitalizedString;
    }
    else if (txt_currentTextField==txt_withdrawalFrequency){
        str_fundName=[NSString stringWithFormat:@"%@",arr_swpFreqList[row][@"FrequencyDescription"]].capitalizedString;
    }
    else if (txt_currentTextField==txt_withdrawalDay){
        str_fundName=[NSString stringWithFormat:@"%@",arr_swpDayList[row][@"sip_cycleid"]];
    }
    lbl_title.text= str_fundName;
    lbl_title.textAlignment=NSTextAlignmentCenter;
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.font=KTFontFamilySize(KTOpenSansRegular, 12);
    lbl_title.numberOfLines=3;
    [pickerLabel addSubview:lbl_title];
    return pickerLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (txt_currentTextField==txt_familyMember){
        KT_TABLE12 *fundRec=arr_familyPanRec[row];
        txt_familyMember.text=[NSString stringWithFormat:@"%@",fundRec.invName];
        str_userPrimaryPan=[NSString stringWithFormat:@"%@",fundRec.PAN];
        str_invName=[NSString stringWithFormat:@"%@",fundRec.invName];
    }
    else if (txt_currentTextField==txt_fund){
        KT_Table2RawQuery *fundRec=arr_fundList[row];
        txt_fund.text=[NSString stringWithFormat:@"%@",fundRec.fundDesc];
        str_selectedFundID=[NSString stringWithFormat:@"%@",fundRec.fund];
    }
    else if (txt_currentTextField==txt_folio){
        KT_TABLE2 *folioRec=arr_folioList[row];
        txt_folio.text=[NSString stringWithFormat:@"%@",folioRec.Acno];
        str_notAllowedFlag=[NSString stringWithFormat:@"%@",folioRec.notallowed_flag];
        str_selectedFolioID=[NSString stringWithFormat:@"%@",folioRec.Acno];
    }
    else if(txt_currentTextField==txt_scheme){
        KT_TABLE2 *schemeRec=arr_schemeList[row];
        txt_scheme.text=[NSString stringWithFormat:@"%@",schemeRec.schDesc];
        lbl_currentValue.text=[NSString stringWithFormat:@"%@",schemeRec.curValue];
        lbl_balanceUnits.text=[NSString stringWithFormat:@"%@",schemeRec.balUnits];
        [self DoNotAllowZeroSchemeBasedOnFundFolioAndNotAllowedFlag:str_selectedFundID forFolioNo:str_selectedFolioID forFlag:str_notAllowedFlag forSchemeDesc:txt_scheme.text forRecordIndex:schemeRec];
    }
    else if (txt_currentTextField==txt_withdrawalOption){
        txt_withdrawalOption.text=[NSString stringWithFormat:@"%@",arr_swpOptionList[row][@"Description"]].capitalizedString;
    }
    else if (txt_currentTextField==txt_withdrawalFrequency){
        txt_withdrawalFrequency.text=[NSString stringWithFormat:@"%@",arr_swpFreqList[row][@"FrequencyDescription"]];
    }
    else if (txt_currentTextField==txt_withdrawalDay){
        txt_withdrawalDay.text=[NSString stringWithFormat:@"%@",arr_swpDayList[row][@"sip_cycleid"]];
    }
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - SWP Submit Button Tapped

- (IBAction)btn_swpSumit:(id)sender {
    if (txt_familyMember.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [scroll_mainScroll setContentOffset:CGPointZero animated:YES];
            [txt_familyMember becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select family member."];
        });
    }
    else if (txt_fund.text.length==0){
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
    else if (txt_scheme.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_scheme becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select scheme."];
        });
    }
    else if (txt_withdrawalOption.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_withdrawalOption becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select withdrawal option."];
        });
    }
    else if (txt_noofWithdrawals.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_noofWithdrawals becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter number of withdrawals."];
        });
    }
    else if ([txt_noofWithdrawals.text intValue]<2){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_noofWithdrawals becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Minimum number of withdrawals should be greater than or equal to 2."];
        });
    }
    else if (txt_withdrawalFrequency.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_withdrawalFrequency becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select withdrawal frequency."];
        });
    }
    else if (txt_withdrawalDay.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_withdrawalDay becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select withdrawal Day."];
        });
    }
    else{
        if ([txt_withdrawalOption.text rangeOfString:@"Capital Appreciation" options:NSCaseInsensitiveSearch].location == NSNotFound) {
            if (txt_amount.text.length==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [txt_amount becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter amount."];
                });
            }
            else if ([txt_amount.text intValue]==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    txt_amount.text=@"";
                    [txt_amount becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Minimum amount should not be Zero. Please enter a valid amount."];
                });
            }
            else if ([txt_amount.text floatValue]<mimimumRedAmount){
                dispatch_async(dispatch_get_main_queue(), ^{
                    txt_amount.text=@"";
                    [txt_amount becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Enter amount should be less than mimimum redemption amount."];
                });
            }
            else if ([txt_amount.text floatValue]>current_navValue){
                dispatch_async(dispatch_get_main_queue(), ^{
                    txt_amount.text=@"";
                    [txt_amount becomeFirstResponder];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Enter amount should be less than current value."];
                });
            }
            else{
                [self sendSWPTransactionDetailsAPIForAmount:txt_amount.text];
            }
        }
        else{
            [self sendSWPTransactionDetailsAPIForAmount:@"0"];
        }
    }
}

#pragma mark - SWP API CALL

-(void)sendSWPTransactionDetailsAPIForAmount:(NSString *)minAmountRed{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *serverStartDate;
    NSString *serverEndDate;
    @try{
        NSDateFormatter *dateServerFormatter = [[NSDateFormatter alloc] init];
        [dateServerFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *startDate = [dateServerFormatter dateFromString:[NSString stringWithFormat:@"%@",txt_fromDate.text]];
        NSDate *endDate = [dateServerFormatter dateFromString:[NSString stringWithFormat:@"%@",txt_toDate.text]];
        [dateServerFormatter setDateFormat:@"MM/dd/yyyy"];
        serverStartDate =[NSString stringWithFormat:@"%@",[dateServerFormatter stringFromDate:startDate]];
        serverEndDate =[NSString stringWithFormat:@"%@",[dateServerFormatter stringFromDate:endDate]];
    }
    @catch (NSException *exception){
        serverStartDate =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",txt_fromDate.text]];
        serverEndDate =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",txt_fromDate.text]];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:XTOnlyDateFormat];
    NSString *datestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_scheme=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedSchemeID];
    NSString *str_folioNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFolioID];
    NSString *str_plan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedSchPlan];
    NSString *str_otpn=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedSchOption];
    NSString *str_withdrawType=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_withdrawalOption.text];
    NSString *str_withdrawFreq=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_withdrawalFrequency.text];
    NSString *str_withdrawTRDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:datestamp];
    NSString *str_withdrawStartDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:serverStartDate];
    NSString *str_withdrawEndDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:serverEndDate];
    NSString *str_withdrawNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_noofWithdrawals.text];
    NSString *str_amount=[XTAPP_DELEGATE convertToBase64StrForAGivenString:minAmountRed];
    NSString *str_transactType=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"SWP"];
    NSString *str_branch=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    NSString *str_entBy=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_Ihno=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    NSString *str_refernceNo=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    NSString *str_branchNo=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    NSString *str_remarks=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    NSString *str_Errno=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    NSString *str_url = [NSString stringWithFormat:@"%@SWPDetailsSave_WEB?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Scheme=%@&Plan=%@&Optn=%@&Acno=%@&Withdrawaltype=%@&Freq=%@&Trdate=%@&Stdt=%@&Enddt=%@&Noofwithdrawals=%@&Amount=%@&Branch=%@&Trtype=%@&Entby=%@&Ihno=%@&Refno=%@&Batchno=%@&Remarks=%@&Errno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_scheme,str_plan,str_otpn,str_folioNumber,str_withdrawType,str_withdrawFreq,str_withdrawTRDate,str_withdrawStartDate,str_withdrawEndDate,str_withdrawNumber,str_amount,str_branch,str_transactType,str_entBy,str_Ihno,str_refernceNo,str_branchNo,str_remarks,str_Errno];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            int error_statuscode=[responce[@"Table"][0][@"Error_code"]intValue];
            if(error_statuscode==0) {
                [self createDictionaryAndPassValueToSWPConfirmationScreen:responce[@"Table1"][0]];
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

-(void)createDictionaryAndPassValueToSWPConfirmationScreen:(NSDictionary *)responseDic{
    NSMutableDictionary *mutDic=[NSMutableDictionary new];
    [mutDic addEntriesFromDictionary:responseDic];
    [mutDic setObject:txt_fund.text forKey:@"fundName"];
    [mutDic setObject:txt_folio.text forKey:@"folioName"];
    [mutDic setObject:txt_scheme.text forKey:@"schemeName"];
    [mutDic setObject:txt_withdrawalOption.text forKey:@"SWPOption"];
    [mutDic setObject:@([txt_noofWithdrawals.text intValue]) forKey:@"numberWidthdrawals"];
    [mutDic setObject:txt_withdrawalFrequency.text forKey:@"SWPFrequency"];
    [mutDic setObject:txt_withdrawalDay.text forKey:@"SWPDay"];
    [mutDic setObject:txt_fromDate.text forKey:@"SWPStartDate"];
    [mutDic setObject:txt_toDate.text forKey:@"SWPEndDate"];
    [mutDic setObject:str_userPrimaryPan forKey:@"PAN"];
    [mutDic setObject:str_invName forKey:@"investorName"];
    [mutDic setObject:str_selectedFundID forKey:@"fundID"];
    [mutDic setObject:str_selectedFolioID forKey:@"folioID"];
    [mutDic setObject:str_selectedSchemeID forKey:@"schemeID"];
    [mutDic setObject:str_selectedSchOption forKey:@"schemeOption"];
    [mutDic setObject:str_selectedSchPlan forKey:@"schemePlan"];
    [mutDic setObject:str_mobileNumber forKey:@"MobileNumber"];
    if ([txt_withdrawalOption.text rangeOfString:@"Capital Appreciation" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        [mutDic setObject:[NSString stringWithFormat:@"%.2f",[txt_amount.text floatValue]] forKey:@"amount"];
        SWPConfirmationVC *controller=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"SWPConfirmationVC"];
        controller.hideAmountView=NO;
        controller.str_fromScreen=@"Family";
        controller.selected_swpDetails=mutDic;
        KTPUSH(controller,YES);
        
    }
    else{
        [mutDic setObject:@"0" forKey:@"amount"];
        SWPConfirmationVC *controller=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"SWPConfirmationVC"];
        controller.hideAmountView=YES;
        controller.str_fromScreen=@"Family";
        controller.selected_swpDetails=mutDic;
        KTPUSH(controller,YES);
    }
}

@end
