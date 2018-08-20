//
//  DemographicDetailsVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 18/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "DemographicDetailsVC.h"

@interface DemographicDetailsVC ()<UIPickerViewDelegate,UIPickerViewDataSource,commonCustomDelegate>{
    __weak IBOutlet UIButton *btn_female;
    __weak IBOutlet UIButton *btn_male;
    __weak IBOutlet UIButton *btn_dropCountryOfBirth;
    __weak IBOutlet UIButton *btn_dropOccupation;
    __weak IBOutlet UIScrollView *scroll_mainScroll;
    __weak IBOutlet UITextField *txt_occupation;
    __weak IBOutlet UITextField *txt_countryOfBirth;
    __weak IBOutlet UITextField *txt_placeOfBirth;
    __weak IBOutlet UITextField *txt_dateOfBirth;
    __weak IBOutlet UITextField *txt_investorName;
    __weak IBOutlet UITextField *txt_enterPan;
    __weak IBOutlet UIView *view_profileDetailsView;
    __weak IBOutlet UIButton *btn_dashboard;
    __weak IBOutlet UIButton *btn_titleChanged;
    NSString *str_selectedGender,*str_randomGeneratedOTP,*str_folioMobileNumber,*str_folioEmailID;
    __weak IBOutlet UIButton *btn_checkKYCCompliance;
    NSArray *arr_countryList,*arr_occupationList,*arr_fundsList;
    UIDatePicker *picker_date;
    UITextField *txt_currentTxtField;
    UIPickerView *picker_dropDown;
    NSString *str_selectedOccupationID,*str_aadhaarSelectedFundID,*str_profileDetailsFund,*str_referenceTokenGen;
    __weak IBOutlet UIButton *btn_validateDetails;
    __weak IBOutlet UIView *view_aadhaarView;
    __weak IBOutlet UITextField *txt_aadhaarPhoneNumber;
    __weak IBOutlet UITextField *txt_aadhaarInvestorName;
    __weak IBOutlet UITextField *txt_aadhaarEmail;
    __weak IBOutlet UITextField *txt_aadhaarFund;
    __weak IBOutlet UIButton *btn_demographicStatus;
    __weak IBOutlet UILabel *lbl_occupationStatus;
    __weak IBOutlet UILabel *lbl_countryOfBirthStatus;
    __weak IBOutlet UILabel *lbl_placeOfBirthStatus;
    __weak IBOutlet UILabel *lbl_genderStatus;
    __weak IBOutlet UILabel *lbl_bodStatus;
    __weak IBOutlet UILabel *lbl_investorNameStatus;
    __weak IBOutlet UITextField *txt_aadhaarNumber;

}

@end

@implementation DemographicDetailsVC
@synthesize str_selectedPrimaryPan,str_ekyc;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseViewOnLoad];
    [self initilaiseDatePicker];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validateAadhaarSuccess:) name:@"ValidateAadhaar" object:nil];
    if ([str_selectedPrimaryPan isEqualToString:@""] || [str_selectedPrimaryPan isEqual:@""] || [str_selectedPrimaryPan length]==0){
        [btn_checkKYCCompliance setHidden:NO];
        [btn_demographicStatus setHidden:YES];
        [txt_enterPan setUserInteractionEnabled:YES];
    }
    else{
        [btn_checkKYCCompliance setHidden:YES];
        txt_enterPan.text=str_selectedPrimaryPan;
        if (str_selectedPrimaryPan.length>0 && ([str_ekyc isEqualToString:@"N"] || [str_ekyc isEqual:@"N"])) {
            [self checkPanExistInKRA:txt_enterPan.text];
        }
        else{
            [self getPersonalDetailsIfPanExits];
        }
        [self setUserInteractionToField:NO];
    }
    str_aadhaarSelectedFundID=@"";
    str_referenceTokenGen=@"";
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"DemographicDetails"];
    [txt_aadhaarInvestorName addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
}

-(void)doneAction:(UIBarButtonItem *)done{
    if (txt_currentTxtField==txt_aadhaarInvestorName) {
        if ([txt_aadhaarInvestorName.text length]==0) {
            
        }
        else{
            [self fetchGetFundListFromAPI];
        }
    }
    [txt_currentTxtField resignFirstResponder];
}

#pragma mark - View DID Appear

-(void)viewDidAppear:(BOOL)animated{
  scroll_mainScroll.contentSize=CGSizeMake(self.view.frame.size.width, view_profileDetailsView.frame.origin.y +btn_dashboard.frame.origin.y+ btn_dashboard.frame.size.height+20);
}

-(void)initialiseViewOnLoad{
    [txt_investorName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_aadhaarInvestorName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_placeOfBirth setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_aadhaarEmail setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_aadhaarPhoneNumber setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [UITextField withoutRoundedCornerTextField:txt_occupation forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_countryOfBirth forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_dateOfBirth forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_aadhaarFund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIButton roundedCornerButtonWithoutBackground:btn_dashboard forCornerRadius:KTiPad?25.0f:btn_dashboard.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_titleChanged forCornerRadius:KTiPad?25.0f:btn_titleChanged.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_checkKYCCompliance forCornerRadius:KTiPad?25.0f:btn_dashboard.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_validateDetails forCornerRadius:KTiPad?25.0f:btn_dashboard.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [btn_titleChanged setTitle:@"Edit Details" forState:UIControlStateNormal];
    [view_aadhaarView setHidden:YES];
    [view_profileDetailsView setHidden:YES];
    str_selectedGender=@"";
    txt_enterPan.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
}

#pragma mark - userInteractionToFields Enabling

-(void)setUserInteractionToField:(BOOL)enable{
    [txt_enterPan setUserInteractionEnabled:enable];
    [txt_investorName setUserInteractionEnabled:enable];
    [txt_dateOfBirth setUserInteractionEnabled:enable];
    [txt_placeOfBirth setUserInteractionEnabled:enable];
    [txt_countryOfBirth setUserInteractionEnabled:enable];
    [txt_occupation setUserInteractionEnabled:enable];
    [btn_dropOccupation setHidden:!enable];
    [btn_dropCountryOfBirth setHidden:!enable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitialisePickers

-(void)initilaiseDatePicker{
    picker_date= [[UIDatePicker alloc]init];
    picker_date.datePickerMode=UIDatePickerModeDate;
    [picker_date setMaximumDate:[NSDate date]];
    [picker_date addTarget:self action:@selector(updateDateTextField:) forControlEvents:UIControlEventValueChanged];
    txt_dateOfBirth.inputView=picker_date;
    
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
}

#pragma mark - DatePicker date into textfield

-(void)updateDateTextField:(UIDatePicker *)sender{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:XTOnlyDateFormat];
    txt_dateOfBirth.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:sender.date]];
}

#pragma mark - Back Button Tapped

- (IBAction)btn_backTapped:(UIButton *)sender {
    KTPOP(YES);
}

#pragma mark - check KYC Compliance Tapped

- (IBAction)btn_checkKYCTapped:(id)sender {
    END_EDITING;
    if (txt_enterPan.text.length==0) {
        [txt_enterPan becomeFirstResponder];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter PAN No."];
        });
    }
    else{
        NSString *str_panStr=txt_enterPan.text;
        txt_enterPan.text=str_panStr.uppercaseString;
        NSString *panRegex =  @"[A-Z]{3}P[A-Z]{1}[0-9]{4}[A-Z]{1}";
        NSPredicate *panPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", panRegex];
        if ([panPredicate evaluateWithObject:txt_enterPan.text] == NO){
            dispatch_async(dispatch_get_main_queue(), ^{
                txt_enterPan.text=@"";
                [txt_enterPan becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter correct PAN No"];
            });
        }
        else{
            [txt_enterPan setUserInteractionEnabled:NO];
            [btn_checkKYCCompliance setUserInteractionEnabled:NO];
            [self checkPanExistInKRA:txt_enterPan.text];
        }
    }
}

#pragma mark - Get Equalent Fund

-(void)getEqualentFund{
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@GetkycFundCode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
           
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

#pragma mark - checkPanExistInKRA

-(void)checkPanExistInKRA:(NSString *)userPAN{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_PAN =[XTAPP_DELEGATE convertToBase64StrForAGivenString:userPAN];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@ChkpanexistsinKRA?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&userid=%@&fund=%@&i_pan=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_fund,str_PAN];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"DtData"][0][@"KYCBlock"]];
                if ([error_message isEqualToString:@"Y"] || [error_message isEqual:@"Y"]) {
                    [[SharedUtility sharedInstance]showAlertWithTitle:KTMessage forMessage:@"Your PAN is not KYC Compliant. You can complete e-KYC through Aadhaar. Do you wish to continue with e-KYC?" andAction1:@"NO" andAction2:@"YES" andAction1Block:^{
                        txt_enterPan.text=@"";
                        [btn_checkKYCCompliance setUserInteractionEnabled:YES];
                    } andCancelBlock:^{
                        [view_profileDetailsView setHidden:YES];
                        [view_aadhaarView setHidden:NO];
                    }];
                }
                else{
                    if ([str_selectedPrimaryPan isEqual:@""] || [str_selectedPrimaryPan isEqualToString:@""]) {
                        [self checkFolioByPan:txt_enterPan.text];
                    }
                    else{
                        if (str_selectedPrimaryPan.length>0 && ([str_ekyc isEqualToString:@"N"] || [str_ekyc isEqual:@"N"])) {
                            NSString *updatePrimaryPan=[NSString stringWithFormat:@"UPDATE TABLE12_PANDETAILS set flag='%@' WHERE PAN ='%@'",@"P",str_selectedPrimaryPan];
                            [[DBManager sharedDataManagerInstance]executeUpdateQuery:updatePrimaryPan];
                            [self getPersonalDetailsIfPanExits];
                        }
                    }
                }
            });
        }
        else{
            NSString *error_messageDisplayToUser=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    txt_enterPan.text=@"";
                    [btn_checkKYCCompliance setHidden:NO];
                    [txt_enterPan setUserInteractionEnabled:YES];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_messageDisplayToUser];
                });
            });
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - check folio by pan

-(void)checkFolioByPan:(NSString *)userPAN{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_PAN =[XTAPP_DELEGATE convertToBase64StrForAGivenString:userPAN];
    NSString *str_url = [NSString stringWithFormat:@"%@CheckFoliobyPAN?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&userid=%@&pan=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_PAN];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        NSDictionary *dic_folio=responce[@"Table"][0];
        if (dic_folio.count>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                NSString *str_message=[NSString stringWithFormat:@"%@",dic_folio[@"MESSAGE"]];
                str_folioMobileNumber=[NSString stringWithFormat:@"%@",dic_folio[@"mobile"]];
                str_folioEmailID=[NSString stringWithFormat:@"%@",dic_folio[@"email"]];
                if ([str_message isEqualToString:@""] || [str_message isEqual:@""] || [str_message length]==0) {
                    if (([str_folioEmailID isEqual:@""] || [str_folioEmailID isEqualToString:@""]) && ([str_folioMobileNumber isEqualToString:@""]|| [str_folioMobileNumber isEqual:@""])) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"There is no mobile number or email ID available to send OTP. To update your mobile number or email ID, kindly reach out to your nearest karvy branch."];
                            });
                        });
                    }
                    else{
                        str_randomGeneratedOTP=[NSString stringWithFormat:@"%d", [self getRandomNumberBetween:100000 to:900000]];
                        if (str_folioMobileNumber.length>0) {
                            [self sendOTPToMobileNumber:str_folioMobileNumber forRandomGeneratedOTP:str_randomGeneratedOTP];
                        }
                        else{
                            [self sendOTPToEmailID:str_folioEmailID forRandomGeneratedOTP:str_randomGeneratedOTP];
                        }
                        [self showMessagePopup:@"DemographicDetails"];
                    }
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        str_selectedPrimaryPan=txt_enterPan.text;
                        [self setEnterPANAsPrimaryAPI:str_selectedPrimaryPan];
                    });
                }
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Error while processing,Please try again later."];
                });
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Generate OTP

-(void)generateOTP{
    
}

#pragma mark - get Fundlist

-(void)fetchGetFundListFromAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"A"];
    NSString *str_planType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"Regular"];
    NSString *str_schemeType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_fundCode=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fundCode,str_schemeType,str_planType];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            arr_fundsList=responce[@"Dtinformation"];
            if (arr_fundsList.count>1) {
                txt_aadhaarFund.inputView=picker_dropDown;
            }
            else{
                if(arr_fundsList.count==1){
                    txt_aadhaarFund.text=[NSString stringWithFormat:@"%@",arr_fundsList[0][@"amc_name"]];
                    str_aadhaarSelectedFundID=[NSString stringWithFormat:@"%@",arr_fundsList[0][@"amc_code"]];
                }
                else{
                    txt_aadhaarFund.text=@"";
                    str_aadhaarSelectedFundID=@"";
                }
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Login Service API

-(void)LoginApiWithLoginMode:(NSString*)loginType forUserName:(NSString *)username forPassword:(NSString *)password forInvestorType:(NSString *)investorType {
    END_EDITING;
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_invertorType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:investorType];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:username];
    NSString *str_LoginMode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:loginType];
    NSString *str_password=[XTAPP_DELEGATE convertToBase64StrForAGivenString:password];
    NSString *str_url = [NSString stringWithFormat:@"%@GetUserLoginnew_v17?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&username=%@&Password=%@&ReqBy=%@&loginMode=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_password,str_invertorType,str_LoginMode];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [XTAPP_DELEGATE deleteExistingTableRecords];
                [XTAPP_DELEGATE insertRecordIntoRespectiveTables:responce];
                if (str_selectedPrimaryPan.length>0) {
                    [self getPersonalDetailsIfPanExits];
                }
                else{
                    if (str_selectedPrimaryPan.length==0) {
                        [self editSaveUserDetailsForInvestorName:txt_aadhaarInvestorName.text];
                    }
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
        
    }];
}

#pragma mark - User Info On Edit Save

-(void)editSaveUserDetailsForInvestorName:(NSString *)investorNameStr{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_pan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_enterPan.text];
    NSString *str_invname =[XTAPP_DELEGATE convertToBase64StrForAGivenString:investorNameStr];
    NSString *str_dob =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_dateOfBirth.text];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_aadhaarSelectedFundID];
    NSString *str_aadharNO=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_aadhaarFund.text];
    NSString *str_gender=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedGender];
    NSString *str_place=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_placeOfBirth.text];
    NSString *str_country=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_countryOfBirth.text];
    NSString *str_occupation=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_occupation.text];
    NSString *str_tokenno=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_referenceTokenGen];
    NSString *str_url = [NSString stringWithFormat:@"%@SavePersonalDetails?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&pan=%@&invname=%@&dob=%@&aadharno=%@&Gender=%@&place=%@&country=%@&occupation=%@&tokenno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_pan,str_invname,str_dob,str_aadharNO,str_gender,str_place,str_country,str_occupation,str_tokenno];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Table"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {
            if (str_selectedPrimaryPan.length==0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:KTSuccessMsg forMessage:@"You have successfully completed your eKYC. Your data will be auto-fetched from Aadhaar with in 24 hours." andAction1:@"Ok" andAction1Block:^{
                        KTPOP(YES);
                    }];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table1"][0][@"Msg"]];
                    [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:KTSuccessMsg forMessage:error_message andAction1:@"Ok" andAction1Block:^{
                        KTPOP(YES);
                    }];
                });
            }
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - set enter pan as primary

-(void)setEnterPANAsPrimaryAPI:(NSString *)panStr{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_pan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:panStr];
    NSString *str_url = [NSString stringWithFormat:@"%@PrimaryPANUpdate?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&PAN=%@&Userid=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_pan,str_userId];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                NSString *updatePrimaryPan=[NSString stringWithFormat:@"UPDATE TABLE12_PANDETAILS set flag='%@' WHERE PAN ='%@'",@"P",panStr];
                [[DBManager sharedDataManagerInstance]executeUpdateQuery:updatePrimaryPan];
                [self LoginApiWithLoginMode:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginTypeKey] forUserName:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername] forPassword:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginPassword] forInvestorType:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginInvestor]];
            });
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - get Country of Birth

-(void)getCountryofBirth{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"CB"];
    NSString *str_planType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_schemeType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fund,str_schemeType,str_planType];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            arr_countryList=responce[@"Dtinformation"];
            if (arr_countryList.count>1) {
                txt_countryOfBirth.inputView=picker_dropDown;
            }
            else{
                txt_countryOfBirth.text=[NSString stringWithFormat:@"%@",arr_countryList[0][@"COUNTRYNAME"]];
            }
            [self getOccupationDetails];
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Female and Male Button Tapped

- (IBAction)btn_femaleTapped:(UIButton *)sender {
    str_selectedGender=@"F";
    [sender setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_male setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
}

- (IBAction)btn_maleTapped:(id)sender {
    str_selectedGender=@"M";
    [sender setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_female setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
}


#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTxtField=textField;
    [textField becomeFirstResponder];
    if (textField==txt_countryOfBirth) {
        [picker_dropDown selectRow:0 inComponent:0 animated:YES];
        txt_countryOfBirth.text=[NSString stringWithFormat:@"%@",arr_countryList[0][@"COUNTRYNAME"]];
        [picker_dropDown reloadAllComponents];
    }
    else if (textField==txt_countryOfBirth) {
        [picker_dropDown selectRow:0 inComponent:0 animated:YES];
        txt_occupation.text=[NSString stringWithFormat:@"%@",arr_occupationList[0][@"OccupationDescription"]];
        str_selectedOccupationID=[NSString stringWithFormat:@"%@",arr_occupationList[0][@"OccupationCode"]];
        [picker_dropDown reloadAllComponents];
    }
    else if (textField==txt_aadhaarFund){
        if (arr_fundsList.count==0) {
            txt_aadhaarFund.text=@"";
            str_aadhaarSelectedFundID=@"";
        }
        else{
            [picker_dropDown selectRow:0 inComponent:0 animated:YES];
            txt_aadhaarFund.text=[NSString stringWithFormat:@"%@",arr_fundsList[0][@"amc_name"]];
            str_aadhaarSelectedFundID=[NSString stringWithFormat:@"%@",arr_fundsList[0][@"amc_code"]];
            [picker_dropDown reloadAllComponents];
        }
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (txt_currentTxtField == txt_enterPan){
        txt_enterPan.text=[NSString stringWithFormat:@"%@",txt_enterPan.text].uppercaseString;
    }
    [textField resignFirstResponder];
}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==txt_enterPan) {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
        if  ([resultingString rangeOfCharacterFromSet:whitespaceSet].location == NSNotFound){
            if (resultingString.length<=10) {
                return YES;
            }
            else{
                return NO;
            }
        }
    }
    else if (textField==txt_aadhaarNumber) {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
        if  ([resultingString rangeOfCharacterFromSet:whitespaceSet].location == NSNotFound){
            if (resultingString.length<=12) {
                return YES;
            }
            else{
                return NO;
            }
        }
    }
    else if (textField==txt_aadhaarPhoneNumber) {
        if (txt_aadhaarPhoneNumber.text.length>=10 && range.length == 0){
            return NO;
        }
        else{
            return YES;
        }
    }
    else if (textField==txt_aadhaarEmail) {
        if (txt_aadhaarEmail.text.length>=50 && range.length == 0){
            return NO;
        }
        else{
            return YES;
        }
    }
    else if (textField==txt_aadhaarInvestorName) {
        if (txt_aadhaarInvestorName.text.length>=50 && range.length == 0){
            return NO;
        }
        else{
            return YES;
        }
    }
    else if (textField==txt_investorName) {
        if (txt_investorName.text.length>=50 && range.length == 0){
            return NO;
        }
        else{
            return YES;
        }
    }
    else if (textField==txt_placeOfBirth) {
        if (txt_placeOfBirth.text.length>=50 && range.length == 0){
            return NO;
        }
        else{
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
    if (txt_currentTxtField==txt_countryOfBirth){
        count=[arr_countryList count];
    }
    else if (txt_currentTxtField==txt_occupation){
        count=[arr_occupationList count];
    }
    else if (txt_currentTxtField==txt_aadhaarFund){
        count=[arr_fundsList count];
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
    if (txt_currentTxtField==txt_countryOfBirth){
        str_fundName=[NSString stringWithFormat:@"%@",arr_countryList[row][@"COUNTRYNAME"]];
    }
    else if (txt_currentTxtField==txt_occupation){
        str_fundName=[NSString stringWithFormat:@"%@",arr_occupationList[row][@"OccupationDescription"]].capitalizedString;
    }
    else if (txt_currentTxtField==txt_aadhaarFund){
        str_fundName=[NSString stringWithFormat:@"%@",arr_fundsList[row][@"amc_name"]];
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
    if (txt_currentTxtField==txt_countryOfBirth){
        txt_countryOfBirth.text=[NSString stringWithFormat:@"%@",arr_countryList[row][@"COUNTRYNAME"]];
    }
    else if (txt_currentTxtField==txt_occupation){
        txt_occupation.text=[NSString stringWithFormat:@"%@",arr_occupationList[row][@"OccupationDescription"]].capitalizedString;
        str_selectedOccupationID=[NSString stringWithFormat:@"%@",arr_occupationList[row][@"OccupationCode"]];
    }
    else if (txt_currentTxtField==txt_aadhaarFund){
        txt_aadhaarFund.text=[NSString stringWithFormat:@"%@",arr_fundsList[row][@"amc_name"]];
        str_aadhaarSelectedFundID=[NSString stringWithFormat:@"%@",arr_fundsList[row][@"amc_code"]];
    }
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - GET Personal Details If PAN EXIT

-(void)getPersonalDetailsIfPanExits{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_pan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedPrimaryPan];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@GetPersonalDetailsbyPAN?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&PAN=%@&Fund=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_pan,str_fund];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        NSArray *arr_profileDetails=responce[@"Table"];
        dispatch_async(dispatch_get_main_queue(),^{
            [[APIManager sharedManager]hideHUD];
            if (arr_profileDetails.count>0) {
                [view_aadhaarView setHidden:YES];
                [view_profileDetailsView setHidden:NO];
                [btn_checkKYCCompliance setHidden:YES];
                [btn_demographicStatus setHidden:NO];
                NSDictionary *dicProfileData=arr_profileDetails[0];
                txt_enterPan.text=[NSString stringWithFormat:@"%@",dicProfileData[@"kpp_pan"]];
                str_profileDetailsFund=[NSString stringWithFormat:@"%@",dicProfileData[@"kpp_fund"]];
                txt_investorName.text=[NSString stringWithFormat:@"%@",dicProfileData[@"kpp_invname"]];
                txt_dateOfBirth.text=[NSString stringWithFormat:@"%@",dicProfileData[@"kpp_dob"]];
                txt_placeOfBirth.text=[NSString stringWithFormat:@"%@",dicProfileData[@"kpp_place"]];
                txt_countryOfBirth.text=[NSString stringWithFormat:@"%@",dicProfileData[@"kpp_country"]];
                txt_occupation.text=[NSString stringWithFormat:@"%@",dicProfileData[@"kpp_occupation"]].capitalizedString;
                str_selectedGender=[NSString stringWithFormat:@"%@",dicProfileData[@"kpp_Gender"]];
                if ([txt_investorName.text length]==0) {
                    [lbl_investorNameStatus setTextColor:KTIncompleteStatusColor];
                }
                if ([txt_dateOfBirth.text length]==0) {
                    [lbl_bodStatus setTextColor:KTIncompleteStatusColor];
                }
                if ([txt_placeOfBirth.text length]==0) {
                    [lbl_placeOfBirthStatus setTextColor:KTIncompleteStatusColor];
                }
                if ([txt_countryOfBirth.text length]==0) {
                    [lbl_countryOfBirthStatus setTextColor:KTIncompleteStatusColor];
                }
                if ([txt_occupation.text length]==0) {
                    [lbl_occupationStatus setTextColor:KTIncompleteStatusColor];
                }
                if ([str_selectedGender isEqual:@"M"] || [str_selectedGender isEqualToString:@"M"]) {
                    [btn_male setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                    [btn_female setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                    [btn_male setUserInteractionEnabled:NO];
                    [btn_female setUserInteractionEnabled:NO];
                }
                else if ([str_selectedGender isEqual:@"F"] || [str_selectedGender isEqualToString:@"F"]) {
                    [btn_female setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                    [btn_male setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                    [btn_male setUserInteractionEnabled:NO];
                    [btn_female setUserInteractionEnabled:NO];
                }
                else{
                    [lbl_genderStatus setTextColor:KTIncompleteStatusColor];
                    [btn_female setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                    [btn_male setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                    [btn_male setUserInteractionEnabled:YES];
                    [btn_female setUserInteractionEnabled:YES];
                }
                [btn_demographicStatus setTitle:@"Verified" forState:UIControlStateNormal];
                [btn_demographicStatus setImage:[UIImage imageNamed:@"SuccessTrue"] forState:UIControlStateNormal];
                scroll_mainScroll.contentSize=CGSizeMake(KTScreenWidth,view_profileDetailsView.frame.origin.y + btn_dashboard.frame.origin.y + btn_dashboard.frame.size.height + 25.0);
                [self getCountryofBirth];
            }
            else{
                if (str_selectedPrimaryPan.length>0){
                    [btn_demographicStatus setHidden:NO];
                    [view_profileDetailsView setHidden:NO];
                    [view_aadhaarView setHidden:YES];
                    [btn_checkKYCCompliance setHidden:YES];
                    [self setUserInteractionToField:YES];
                    [btn_titleChanged setTitle:@"Update Details" forState:UIControlStateNormal];
                    [self getCountryofBirth];
                }
                else{
                    [btn_demographicStatus setHidden:YES];
                    [view_aadhaarView setHidden:YES];
                    [view_profileDetailsView setHidden:YES];
                    [btn_checkKYCCompliance setHidden:NO];
                    [self setUserInteractionToField:NO];
                }
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - fetch Occupations

-(void)getOccupationDetails{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"O"];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"120"];
    NSString *str_schemeType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_planType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fund,str_schemeType,str_planType];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            arr_occupationList=responce[@"Dtinformation"];
            if (arr_occupationList.count>1) {
                txt_occupation.inputView=picker_dropDown;
            }
            else{
                txt_occupation.text=[NSString stringWithFormat:@"%@",arr_occupationList[0][@"OccupationDescription"]].capitalizedString;
                str_selectedOccupationID=[NSString stringWithFormat:@"%@",arr_occupationList[0][@"OccupationCode"]];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Validate Details Button Action

- (IBAction)btn_validateTapped:(id)sender {
    END_EDITING;
    
    if (txt_aadhaarInvestorName.text.length==0) {
        [txt_aadhaarInvestorName becomeFirstResponder];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter investor name"];
        });
    }
    else if (txt_aadhaarInvestorName.text.length<3) {
        [txt_aadhaarInvestorName becomeFirstResponder];
        dispatch_async(dispatch_get_main_queue(), ^{
            txt_aadhaarInvestorName.text=@"";
            [txt_aadhaarInvestorName becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Investor name must be min 3 characters"];
        });
    }
    else if ([[SharedUtility sharedInstance]validateOnlyAlphabets:txt_aadhaarInvestorName.text]!=YES) {
        [txt_aadhaarInvestorName becomeFirstResponder];
        dispatch_async(dispatch_get_main_queue(), ^{
            txt_aadhaarInvestorName.text=@"";
            [txt_aadhaarInvestorName becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter valid investor name"];
        });
    }
    else if (txt_aadhaarPhoneNumber.text.length==0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_aadhaarPhoneNumber becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter mobile number."];
        });
    }
    else if ([[SharedUtility sharedInstance]validateMobileWithString:txt_aadhaarPhoneNumber.text]==NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_aadhaarPhoneNumber becomeFirstResponder];
            txt_aadhaarPhoneNumber.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter vaild mobile number."];
        });
    }
    else if (txt_aadhaarEmail.text.length==0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_aadhaarEmail becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter email ID."];
        });
    }
    else if ([[SharedUtility sharedInstance]validateEmailWithString:txt_aadhaarEmail.text]!=YES) {
        [txt_aadhaarEmail becomeFirstResponder];
        dispatch_async(dispatch_get_main_queue(), ^{
            txt_aadhaarEmail.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter vaild email ID."];
        });
    }
    else if (str_aadhaarSelectedFundID.length==0 || [str_aadhaarSelectedFundID isEqualToString:@""] || [str_aadhaarSelectedFundID isEqual:@""]){
        [txt_aadhaarFund becomeFirstResponder];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
        });
    }
    else if (txt_aadhaarNumber.text.length==0) {
        [txt_aadhaarNumber becomeFirstResponder];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter Aadhaar Number"];
        });
    }
    else if ([[SharedUtility sharedInstance]validateAadhaarWithString:txt_aadhaarNumber.text]!=YES) {
        [txt_aadhaarNumber becomeFirstResponder];
        txt_aadhaarNumber.text=@"";
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a valid Aadhaar Number"];
        });
    }
    else{
        [self performAadharValidation];
    }
}

#pragma mark - Button actio to update and save profile details

- (IBAction)btn_titleChangedTapped:(UIButton *)sender {
    if([sender.titleLabel.text isEqual:@"Edit Details"]){
        [btn_titleChanged setTitle:@"Update Details" forState:UIControlStateNormal];
        [self setUserInteractionToField:YES];
        [btn_male setUserInteractionEnabled:YES];
        [btn_female setUserInteractionEnabled:YES];
        [txt_enterPan setUserInteractionEnabled:NO];
    }
    else{
        END_EDITING;
        NSString *str_panStr=txt_enterPan.text;
        txt_enterPan.text=str_panStr.uppercaseString;
        NSString *panRegex =  @"[A-Z]{3}P[A-Z]{1}[0-9]{4}[A-Z]{1}";
        NSPredicate *panPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", panRegex];
        if (txt_enterPan.text.length==0) {
            [txt_enterPan becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter PAN No."];
            });
        }
        else if ([panPredicate evaluateWithObject:txt_enterPan.text] == NO){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_enterPan becomeFirstResponder];
                txt_enterPan.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter correct PAN No"];
            });
        }
        else if (txt_investorName.text.length==0) {
            [txt_investorName becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter investor name"];
            });
        }
        else if (txt_investorName.text.length<3) {
            [txt_investorName becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Investor name must be min 3 characters"];
            });
        }
        else if ([[SharedUtility sharedInstance]validateOnlyAlphabets:txt_investorName.text]!=YES) {
            [txt_investorName becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter valid investor name"];
            });
        }
        else if (txt_dateOfBirth.text.length==0) {
            [txt_dateOfBirth becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter investor name"];
            });
        }
        else if ([str_selectedGender isEqual:@""] || [str_selectedGender isEqualToString:@""]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select gender"];
            });
        }
        else if (txt_placeOfBirth.text.length==0){
            [txt_placeOfBirth becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter place of birth"];
            });
        }
        else if (txt_countryOfBirth.text.length==0){
            [txt_countryOfBirth becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select country of birth"];
            });
        }
        else if (txt_occupation.text.length==0){
            [txt_occupation becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select occupation"];
            });
        }
        else{
            [self editSaveUserDetailsForInvestorName:txt_investorName.text];
        }
    }
}

#pragma mark - Button action on Profile Dashboard

- (IBAction)btn_profileDashBoardTapped:(id)sender {
    KTPOP(YES);
}

#pragma mark -EKYC VERIFICATION BY AADHAAR

-(void)performAadharValidation{
    NSString *str_url = [NSString stringWithFormat:@"http://www.karvymfs.com/ckyc/eKYC_ktrack.aspx?Aadhaar=%@&AMC_Code=%@&PAN=%@&Investor_Name=%@&Mobile_Number=%@&Email=%@",txt_aadhaarNumber.text,str_aadhaarSelectedFundID,txt_enterPan.text,txt_aadhaarInvestorName.text,txt_aadhaarPhoneNumber.text,txt_aadhaarEmail.text];
    AadhaarValidateVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"AadhaarValidateVC"];
    destination.str_aadhaarValidateURL=str_url;
    [self.navigationController pushViewController:destination animated:YES];
}

#pragma mark - fetch folio with mobile number

-(void)sendOTPToMobileNumber:(NSString *)userEnterMobileNumber forRandomGeneratedOTP:(NSString *)genOTp{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_pin=[XTAPP_DELEGATE convertToBase64StrForAGivenString:genOTp];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_mobile=[XTAPP_DELEGATE convertToBase64StrForAGivenString:userEnterMobileNumber];
    NSString *str_url = [NSString stringWithFormat:@"%@Foliowithmobile?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Pin=%@&Userid=%@&Fund=%@&Mobile=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_pin,str_userId,str_fund,str_mobile];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (str_folioEmailID.length>0) {
                [self sendOTPToEmailID:str_folioEmailID forRandomGeneratedOTP:genOTp];
            }
        });
    } failure:^(NSError *error) {
      
    }];
}

#pragma mark - Send OTP To Email ID

-(void)sendOTPToEmailID:(NSString *)userEnterEmailID forRandomGeneratedOTP:(NSString *)genOTp{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_otp=[XTAPP_DELEGATE convertToBase64StrForAGivenString:genOTp];
    NSString *str_emailID=[XTAPP_DELEGATE convertToBase64StrForAGivenString:userEnterEmailID];
    NSString *str_url = [NSString stringWithFormat:@"%@GetemailOtp_New?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&email=%@&otp=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_emailID,str_otp];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
        });
    } failure:^(NSError *error) {
        
    }];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

-(void)showMessagePopup:(NSString *)show{
    CommonPopupVC *destinationController=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"CommonPopupVC"];
    destinationController.commondelegate=self;
    destinationController.str_fromScreen=show;
    destinationController.str_referenceGen=str_randomGeneratedOTP;
    destinationController.str_panEntered=txt_enterPan.text;
    [self addChildViewController:destinationController];
    [self.view addSubview:destinationController.view];
    [destinationController didMoveToParentViewController:self];
}

-(void)cancelButtonTapped{
   
}

-(void)demoGrpahicSuccess{
    str_selectedPrimaryPan=txt_enterPan.text;
    [self setEnterPANAsPrimaryAPI:txt_enterPan.text];
}

#pragma mark - Validate Success Observer Data fetch

-(void)validateAadhaarSuccess:(NSNotification*)notification{
    NSDictionary *dic_webObject=notification.object;
    NSString *str_status=dic_webObject[@"Response"];
    if ([str_status isEqualToString:@"Success"] || [str_status isEqual:@"Success"]) {
        if ([str_selectedPrimaryPan isEqualToString:@""] || [str_selectedPrimaryPan isEqual:@""]) {
            str_referenceTokenGen=dic_webObject[@"ReferenceNo"];
            [self setEnterPANAsPrimaryAPI:txt_enterPan.text];
            [view_aadhaarView setHidden:YES];
        }
        else if (str_selectedPrimaryPan.length>0 && ([str_ekyc isEqualToString:@"N"] || [str_ekyc isEqual:@"N"])) {
            [self getPersonalDetailsIfPanExits];
            [view_aadhaarView setHidden:YES];
        }
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"There was some internal problem. Please try again"];
        });
    }
}

#pragma mark - Get Primary PAN

-(void)getPrimaryPanCheck:(NSString *)primary{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_primaryPan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:primary];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_url = [NSString stringWithFormat:@"%@GetPrimaryPan?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&userid=%@&fund=%@&pan=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_fund,str_primaryPan];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            NSArray *arr_primaryRec=responce[@"Table"];
            if (arr_primaryRec.count==0){
                [self checkPanExistInKRA:txt_enterPan.text];
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTMessage withMessage:@"Given PAN is already associated with another user."];
                });
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

@end
