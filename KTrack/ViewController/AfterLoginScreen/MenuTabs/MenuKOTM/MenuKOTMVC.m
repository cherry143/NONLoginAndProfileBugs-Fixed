//
//  MenuKOTMVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 30/07/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "MenuKOTMVC.h"

@interface MenuKOTMVC ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    __weak IBOutlet UILabel *lbl_msgLabel;
    __weak IBOutlet UIButton *btn_electronicMandate;
    __weak IBOutlet UIButton *btn_physicalMandate;
    __weak IBOutlet UITextField *txt_chooseMember;
    __weak IBOutlet UIButton *btn_registeredagain;
    __weak IBOutlet UILabel *lbl_status;
    __weak IBOutlet UILabel *lbl_mobileNumber;
    __weak IBOutlet UILabel *lbl_emailID;
    __weak IBOutlet UILabel *mandateEndDate;
    __weak IBOutlet UILabel *lbl_mandateStartDate;
    __weak IBOutlet UILabel *lbl_reasonRejection;
    __weak IBOutlet UILabel *lbl_userUMRNNumber;
    __weak IBOutlet UILabel *lbl_userBankNumber;
    __weak IBOutlet UILabel *lbl_userName;
    NSArray *arr_familyPanRec;
    NSString *selectedPan;
    UIPickerView *picker_dropDown;
    __weak IBOutlet UIView *view_infoDetails;
    UITextField *txt_currentTextField;
    __weak IBOutlet UIView *view_withoutKOTM;
    __weak IBOutlet UIStackView *view_detailsView;
}

@end

@implementation MenuKOTMVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self onloadViewInitialise];
    [view_withoutKOTM setHidden:YES];
    [view_detailsView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ON Load View

-(void)onloadViewInitialise{
    [txt_chooseMember addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [UIButton roundedCornerButtonWithoutBackground:btn_registeredagain forCornerRadius:KTiPad?25.0f:btn_registeredagain.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UITextField withoutRoundedCornerTextField:txt_chooseMember forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIButton roundedCornerButtonWithoutBackground:btn_physicalMandate forCornerRadius:KTiPad?25.0f:btn_physicalMandate.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_electronicMandate forCornerRadius:KTiPad?25.0f:btn_electronicMandate.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIView roundedCornerEnableForView:view_infoDetails forCornerRadius:10.0f forBorderWidth:0.0f forApplyShadow:NO];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    [self onViewInitialise];
}

-(void)doneAction:(UIBarButtonItem *)done{
    [txt_currentTextField resignFirstResponder];
}


#pragma mark - fetch Funds

-(void)onViewInitialise{
    arr_familyPanRec = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS"]];
    if (arr_familyPanRec.count>0) {
        if (arr_familyPanRec.count>1){
            txt_chooseMember.inputView=picker_dropDown;
            [txt_chooseMember setUserInteractionEnabled:YES];
        }
        else{
            [txt_chooseMember setUserInteractionEnabled:NO];
        }
        KT_TABLE12 *rec_primaryPan=arr_familyPanRec[0];
        selectedPan=[NSString stringWithFormat:@"%@",rec_primaryPan.PAN];
        txt_chooseMember.text=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",rec_primaryPan.invName]];
        [self fetchKOTMDetailsBasedOnSelectedPAN:selectedPan];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Information" withMessage:@"No PAN Details found."];
        });
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
    if (textField==txt_chooseMember) {
        if (arr_familyPanRec.count>1) {
            [picker_dropDown reloadAllComponents];
        }
        [textField becomeFirstResponder];
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self fetchKOTMDetailsBasedOnSelectedPAN:selectedPan];
    [textField resignFirstResponder];
}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
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
    count=[arr_familyPanRec count];
    return count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *pickerLabel;
    CGRect frame = CGRectMake(5.0, 0.0,self.view.frame.size.width-10,40);
    pickerLabel = [[UILabel alloc] initWithFrame:frame];
    UILabel *lbl_title=[[UILabel alloc]init];
    lbl_title.frame=frame;
    NSString *str_fundName;
    KT_TABLE12 *fundRec=arr_familyPanRec[row];
    str_fundName=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",fundRec.invName]];
    lbl_title.text= str_fundName;
    lbl_title.textAlignment=NSTextAlignmentCenter;
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.font=KTFontFamilySize(KTOpenSansRegular, 12);
    lbl_title.numberOfLines=3;
    [pickerLabel addSubview:lbl_title];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    KT_TABLE12 *fundRec=arr_familyPanRec[row];
    txt_chooseMember.text=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",fundRec.invName]];
    selectedPan=[NSString stringWithFormat:@"%@",fundRec.PAN];
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - Button Actions

- (IBAction)btn_physicalMandateTapped:(id)sender {
    NSArray *panDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='%@'",@"P"]];
    KT_TABLE12 *dic=panDetails[0];
    NSString *str_userID=TRIMWHITESPACE([[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]);
    str_userID = [str_userID stringByReplacingOccurrencesOfString:@" "
                                         withString:@""];
    NSString *urlAddress = [NSString stringWithFormat:@"http://karvymfs.com/ckyc/KOTM.aspx?PAN=%@&UserID=%@",[NSString stringWithFormat:@"%@",dic.PAN],str_userID];
    LinkAadhaarFamilyFolioVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"LinkAadhaarFamilyFolioVC"];
    destination.str_webURL=urlAddress;
    KTPUSH(destination,YES);
}

- (IBAction)btn_electronicManadate:(id)sender {
    [self EOTMWebViewUrlGeneration];
}

- (IBAction)btn_registeragainTapped:(id)sender {
    [view_withoutKOTM setHidden:NO];
    [view_detailsView setHidden:YES];
}

#pragma mark - Fetch KOTM Details Based On PAN

-(void)fetchKOTMDetailsBasedOnSelectedPAN:(NSString *)str_selectedPAN{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_userPan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedPAN];
    NSString *str_url = [NSString stringWithFormat:@"%@CheckPANKotm?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&PAN=%@", KTBaseurl, unique_UDID, str_operatingSystem, str_appVersion, str_fund, str_userPan];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            int success = [responce[@"Table"][0][@"Error_Code"] intValue];
            if (success==0){
                NSDictionary *dic=responce[@"Table1"][0];
                NSString *nameStr=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"NAME"]]];
                if (nameStr.length==0) {
                    lbl_userName.text=@"--";
                }
                else{
                    lbl_userName.text=nameStr;
                }
                NSString *str_bank=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"BANK A/C NO"]]];
                if (str_bank.length==0) {
                    lbl_userBankNumber.text=@"--";
                }
                else{
                    lbl_userBankNumber.text=str_bank;
                }
                NSString *str_UMRONO=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"UMRNNO"]]];
                if (str_UMRONO.length==0) {
                    lbl_userUMRNNumber.text=@"--";
                }
                else{
                    lbl_userUMRNNumber.text=str_UMRONO;
                }
                NSString *str_Reason=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"REJ REASON"]]];
                if (str_Reason.length==0) {
                    lbl_reasonRejection.text=@"--";
                }
                else{
                    lbl_reasonRejection.text=str_Reason;
                }
                NSString *str_mandateStart=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"MANDATE START DATE"]]];
                if (str_mandateStart.length==0) {
                    lbl_mandateStartDate.text=@"--";
                }
                else{
                    lbl_mandateStartDate.text=str_mandateStart;
                }
                NSString *str_mandateEnd=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"MANDATE END DATE"]]];
                if (str_mandateEnd.length==0) {
                    mandateEndDate.text=@"--";
                }
                else{
                    mandateEndDate.text=str_mandateEnd;
                }
                NSString *emailID=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"EMAIL"]]];
                if (emailID.length==0) {
                    lbl_emailID.text=@"--";
                }
                else{
                    lbl_emailID.text=emailID;
                }
                NSString *str_mob=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"MOBILE NO"]]];
                if (str_mob.length==0) {
                    lbl_mobileNumber.text=@"--";
                }
                else{
                    lbl_mobileNumber.text=str_mob;
                }
                NSString *status=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"KOTM REGD STATUS"]]];
                if (status.length==0) {
                    lbl_status.text=@"--";
                }
                else{
                    lbl_status.text=status;
                }
                lbl_msgLabel.text=@"KOTM Details Summary";
                [btn_registeredagain setHidden:YES];
                [view_detailsView setHidden:NO];
                [view_withoutKOTM setHidden:YES];
            }
            else if (success==14){
                NSArray *arr_object=responce[@"Table1"];
                if (arr_object.count>0) {
                    NSDictionary *dic=arr_object[0];
                    NSString *nameStr=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"NAME"]]];
                    if (nameStr.length==0) {
                        lbl_userName.text=@"--";
                    }
                    else{
                        lbl_userName.text=nameStr;
                    }
                    NSString *str_bank=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"BANK A/C NO"]]];
                    if (str_bank.length==0) {
                        lbl_userBankNumber.text=@"--";
                    }
                    else{
                        lbl_userBankNumber.text=str_bank;
                    }
                    NSString *str_UMRONO=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"UMRNNO"]]];
                    if (str_UMRONO.length==0) {
                        lbl_userUMRNNumber.text=@"--";
                    }
                    else{
                        lbl_userUMRNNumber.text=str_UMRONO;
                    }
                    NSString *str_Reason=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"REJ REASON"]]];
                    if (str_Reason.length==0) {
                        lbl_reasonRejection.text=@"--";
                    }
                    else{
                        lbl_reasonRejection.text=str_Reason;
                    }
                    NSString *str_mandateStart=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"MANDATE START DATE"]]];
                    if (str_mandateStart.length==0) {
                        lbl_mandateStartDate.text=@"--";
                    }
                    else{
                        lbl_mandateStartDate.text=str_mandateStart;
                    }
                    NSString *str_mandateEnd=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"MANDATE END DATE"]]];
                    if (str_mandateEnd.length==0) {
                        mandateEndDate.text=@"--";
                    }
                    else{
                        mandateEndDate.text=str_mandateEnd;
                    }
                    NSString *emailID=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"EMAIL"]]];
                    if (emailID.length==0) {
                        lbl_emailID.text=@"--";
                    }
                    else{
                        lbl_emailID.text=emailID;
                    }
                    NSString *str_mob=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"MOBILE NO1"]]];
                    if (str_mob.length==0) {
                        lbl_mobileNumber.text=@"--";
                    }
                    else{
                        lbl_mobileNumber.text=str_mob;
                    }
                    NSString *status=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"KOTM REGD STATUS"]]];
                    if (status.length==0) {
                        lbl_status.text=@"--";
                    }
                    else{
                        lbl_status.text=status;
                    }
                    NSString *str_flag=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",dic[@"Bank Flag"]]];
                    if ([str_flag isEqualToString:@"R"] || [str_flag isEqualToString:@"r"] || [str_flag isEqual:@"R"] || [str_flag isEqual:@"r"]) {
                        [btn_registeredagain setHidden:NO];
                    }
                    else{
                        [btn_registeredagain setHidden:YES];
                    }
                    [view_detailsView setHidden:NO];
                    [view_withoutKOTM setHidden:YES];
                    lbl_msgLabel.text=@"KOTM Details Summary";
                }
                else{
                    lbl_msgLabel.text=@"Please Register your KOTM by using below options";
                    [view_withoutKOTM setHidden:NO];
                    [view_detailsView setHidden:YES];
                }
            }
            else{
                NSString *str_message=responce[@"Table"][0][@"Error_Message"];
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Message" forMessage:str_message andAction1:@"OK" andAction1Block:^{
                }];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - EOTM WEBVIEW URL GENERATION


-(void)EOTMWebViewUrlGeneration{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_loginID=[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_loginName=[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]];
    NSString *str_userName=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@/%@",str_loginID,str_loginName]];
    str_userName = [str_userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *str_key=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"karvymfs"];
    NSString *str_url = [NSString stringWithFormat:@"%@Ktrack_TamperProofStringEncode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&value=%@&key=%@", KTBaseurl, unique_UDID, str_operatingSystem, str_appVersion, str_userName, str_key];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrlString:str_url parameters:nil success:^(NSString *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (responce.length>0){
                NSString *urlAddress = [NSString stringWithFormat:@"http://karvymfs.com/emandate?param=%@",responce];
                LinkAadhaarFamilyFolioVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"LinkAadhaarFamilyFolioVC"];
                destination.str_webURL=urlAddress;
                KTPUSH(destination,YES);
            }
            else{
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Message" forMessage:@"Server not sending any response" andAction1:@"OK" andAction1Block:^{
                }];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

@end
