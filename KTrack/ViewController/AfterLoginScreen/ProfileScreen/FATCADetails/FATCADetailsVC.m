//
//  FATCADetailsVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 18/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "FATCADetailsVC.h"

@interface FATCADetailsVC ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    __weak IBOutlet UIButton *btn_fatcaStatus;
    __weak IBOutlet NSLayoutConstraint *constraint_viewHideHeight;
    __weak IBOutlet UIView *view_hide;
    __weak IBOutlet UIButton *btn_otherNo;
    __weak IBOutlet UIButton *btn_otherYes;
    __weak IBOutlet UIButton *btn_politicalNo;
    __weak IBOutlet UIButton *btn_politicalYes;
    __weak IBOutlet UITextField *txt_annualIncome;
    __weak IBOutlet UITextField *txt_sourceOfWealth;
    __weak IBOutlet UIButton *btn_countryTaxDrop;
    __weak IBOutlet UIButton *btn_salaryDrop;
    __weak IBOutlet UIView *view_background;
    __weak IBOutlet UIScrollView *scroll_mainScrollView;
    __weak IBOutlet UIButton *btn_dashboard;
    __weak IBOutlet UIButton *btn_titleChanged;
    __weak IBOutlet UITextField *txt_countryOfTaxResidence;
    __weak IBOutlet UITextField *txt_identificationType;
    __weak IBOutlet UITextField *txt_taxIdentificationNo;
    NSString *str_selectedPolitical,*str_selectedResident,*str_selectedCountryID,*str_sourceOfWealthID;
    UIDatePicker *picker_date;
    UITextField *txt_currentTxtField;
    UIPickerView *picker_dropDown;
    NSArray *arr_sourceOfWealth;
    NSMutableArray *arr_countryList;
    __weak IBOutlet UILabel *lbl_taxIDTypeStaus;
    __weak IBOutlet UILabel *lbl_taxIDNumberStatus;
    __weak IBOutlet UILabel *lbl_countryTaxResidenceStatus;
    __weak IBOutlet UILabel *lbl_taxResidentOtherThanIndiaStatus;
    __weak IBOutlet UILabel *lbl_PEPStatus;
    __weak IBOutlet UILabel *lbl_netWorthDateStatus;
    __weak IBOutlet UILabel *lbl_netWorthStatus;
    __weak IBOutlet UILabel *lbl_grossStatus;
}

@end

@implementation FATCADetailsVC
@synthesize str_fromScreen,str_selectedPrimaryPan;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
    [view_hide setHidden:YES];
    constraint_viewHideHeight.constant=0.0f;
    [self initialiseOnViewLoad];
    str_selectedPolitical=@"";
    str_selectedResident=@"";
    [self getFATCADetailsRequest];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"FATCADetails"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitialiseView Did Load

-(void)initialiseOnViewLoad{
    [btn_salaryDrop setHidden:YES];
    [btn_countryTaxDrop setHidden:YES];
    [btn_fatcaStatus setHidden:YES];
    [txt_annualIncome setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_taxIdentificationNo setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_identificationType setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];

    [UITextField withoutRoundedCornerTextField:txt_sourceOfWealth forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_countryOfTaxResidence forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIButton roundedCornerButtonWithoutBackground:btn_dashboard forCornerRadius:KTiPad?25.0f:btn_dashboard.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_titleChanged forCornerRadius:KTiPad?25.0f:btn_titleChanged.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [btn_titleChanged setTitle:@"Edit Details" forState:UIControlStateNormal];
    [self setUserInteractionToField:NO];
    
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
}

#pragma mark - userInteractionToFields Enabling

-(void)setUserInteractionToField:(BOOL)enable{
    [txt_annualIncome setUserInteractionEnabled:enable];
    [txt_sourceOfWealth setUserInteractionEnabled:enable];
    [txt_countryOfTaxResidence setUserInteractionEnabled:enable];
    [txt_taxIdentificationNo setUserInteractionEnabled:enable];
    [txt_identificationType setUserInteractionEnabled:enable];
    [btn_politicalNo setUserInteractionEnabled:enable];
    [btn_politicalYes setUserInteractionEnabled:enable];
    [btn_otherNo setUserInteractionEnabled:enable];
    [btn_otherYes setUserInteractionEnabled:enable];
}

#pragma mark - Back Button Tapped

- (IBAction)btn_backTapped:(UIButton *)sender {
    KTPOP(YES);
}

- (IBAction)btn_profileDashBoardTapped:(id)sender {
    KTPOP(YES);
}

- (IBAction)btn_titleChangedTapped:(UIButton *)sender {
    if([sender.titleLabel.text isEqual:@"Edit Details"]){
        [btn_titleChanged setTitle:@"Update Details" forState:UIControlStateNormal];
        [btn_salaryDrop setHidden:NO];
        [btn_countryTaxDrop setHidden:NO];
        [self setUserInteractionToField:YES];
    }
    else{
        if ([txt_annualIncome.text length]==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_annualIncome becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter gross income"];
            });
        }
        else if ([txt_annualIncome.text intValue]<=0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_annualIncome becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter gross income"];
            });
        }
        else if ([[SharedUtility sharedInstance]validateOnlyIntegerValue:txt_annualIncome.text]==NO){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_annualIncome becomeFirstResponder];
                txt_annualIncome.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter vaild gross income"];
            });
        }
        else if ([txt_sourceOfWealth.text length]==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_sourceOfWealth becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select source of wealth"];
            });
        }
        else if (str_selectedPolitical.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Choose political exposed options"];
            });
        }
        else if (str_selectedResident.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Choose tax resident of any country other than india"];
            });
        }
        else{
            if ([str_selectedResident isEqual:@"NO"]) {
                [self saveUpdateFACTADetailsToServer];
            }
            else{
                if ([txt_countryOfTaxResidence.text length]==0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [txt_countryOfTaxResidence becomeFirstResponder];
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select tax resident country"];
                    });
                }
                else if ([txt_taxIdentificationNo.text length]==0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [txt_taxIdentificationNo becomeFirstResponder];
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter branch address"];
                    });
                }
                else if ([txt_identificationType.text length]==0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [txt_identificationType becomeFirstResponder];
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter branch address"];
                    });
                }
                else{
                    [self saveUpdateFACTADetailsToServer];
                }
            }
        }
    }
}

#pragma mark - Political Exposed Button Action

- (IBAction)btn_politicalYesTapped:(id)sender {
    str_selectedPolitical=@"YES";
    [sender setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_politicalNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
}

- (IBAction)btn_politicalNoTapped:(id)sender {
    str_selectedPolitical=@"NO";
    [sender setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_politicalYes setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
}

#pragma mark - Resident other than India Button Action

- (IBAction)btn_residentIndiaYesTapped:(id)sender {
    str_selectedResident=@"YES";
    [sender setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_otherNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [view_hide setHidden:NO];
    constraint_viewHideHeight.constant=231.0f;
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    scroll_mainScrollView.contentSize=CGSizeMake(KTScreenWidth, view_background.frame.origin.y+btn_dashboard.frame.origin.y+btn_dashboard.frame.size.height+30);
}

- (IBAction)btn_residentIndiaNoTapped:(id)sender {
    str_selectedResident=@"NO";
    [sender setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_otherYes setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [view_hide setHidden:YES];
    constraint_viewHideHeight.constant=0.0f;
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    scroll_mainScrollView.contentSize=CGSizeMake(KTScreenWidth, view_background.frame.origin.y+btn_dashboard.frame.origin.y+btn_dashboard.frame.size.height+30);
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTxtField=textField;
    [textField becomeFirstResponder];
    if (textField==txt_countryOfTaxResidence) {
        txt_countryOfTaxResidence.text=[NSString stringWithFormat:@"%@",arr_countryList[0][@"COUNTRYNAME"]];
        str_selectedCountryID=[NSString stringWithFormat:@"%@",arr_countryList[0][@"COUNTRYCODE"]];
        [picker_dropDown reloadAllComponents];
    }
    else if (textField==txt_sourceOfWealth) {
        txt_sourceOfWealth.text=[NSString stringWithFormat:@"%@",arr_sourceOfWealth[0][@"Citizenship"]];
        str_sourceOfWealthID=[NSString stringWithFormat:@"%@",arr_sourceOfWealth[0][@"CitizenshipDesc"]];
        [picker_dropDown reloadAllComponents];
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==txt_annualIncome) {
        if (txt_annualIncome.text.length>=10 && range.length == 0){
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
    if (txt_currentTxtField==txt_countryOfTaxResidence){
        count=[arr_countryList count];
    }
    else if (txt_currentTxtField==txt_sourceOfWealth){
        count=[arr_sourceOfWealth count];
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
    if (txt_currentTxtField==txt_countryOfTaxResidence){
        str_fundName=[NSString stringWithFormat:@"%@",arr_countryList[row][@"COUNTRYNAME"]];
    }
    else if (txt_currentTxtField==txt_sourceOfWealth){
        str_fundName=[NSString stringWithFormat:@"%@",arr_sourceOfWealth[row][@"Citizenship"]];
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
    if (txt_currentTxtField==txt_countryOfTaxResidence){
        txt_countryOfTaxResidence.text=[NSString stringWithFormat:@"%@",arr_countryList[row][@"COUNTRYNAME"]];
        str_selectedCountryID=[NSString stringWithFormat:@"%@",arr_countryList[row][@"COUNTRYCODE"]];
    }
    else if (txt_currentTxtField==txt_sourceOfWealth){
        txt_sourceOfWealth.text=[NSString stringWithFormat:@"%@",arr_sourceOfWealth[row][@"Citizenship"]];
        str_selectedCountryID=[NSString stringWithFormat:@"%@",arr_sourceOfWealth[row][@"CitizenshipDesc"]];
    }
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - Get Country list

-(void)getCountryList{
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
            arr_countryList=[NSMutableArray new];
            arr_countryList=[responce[@"Dtinformation"]mutableCopy];
            if (arr_countryList.count>1) {
                [arr_countryList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *countryDic, NSUInteger index, BOOL *stop) {
                    if ([countryDic[@"COUNTRYNAME"] isEqualToString:@"India"]) {
                        [arr_countryList removeObjectAtIndex:index];
                    }
                }];
                txt_countryOfTaxResidence.inputView=picker_dropDown;
            }
            else{
                txt_countryOfTaxResidence.text=[NSString stringWithFormat:@"%@",arr_countryList[0][@"COUNTRYNAME"]];
                str_selectedCountryID=[NSString stringWithFormat:@"%@",arr_countryList[0][@"COUNTRYCODE"]];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SourceOfWealth API

-(void)getSourceOfWealthAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"C"];
    NSString *str_planType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_schemeType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fund,str_schemeType,str_planType];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            arr_sourceOfWealth=responce[@"Dtinformation"];
            if (arr_sourceOfWealth.count>1) {
                txt_sourceOfWealth.inputView=picker_dropDown;
            }
            else{
                txt_sourceOfWealth.text=[NSString stringWithFormat:@"%@",arr_sourceOfWealth[0][@"Citizenship"]];
                str_sourceOfWealthID=[NSString stringWithFormat:@"%@",arr_sourceOfWealth[0][@"CitizenshipDesc"]];
            }
            [self getCountryList];
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - get FACTA Details request

-(void)getFATCADetailsRequest{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_pan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedPrimaryPan];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@GetFATCADetailsbyPAN?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&PAN=%@&Fund=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_pan,str_fund];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        NSArray *arr_FATCARec=responce[@"Table"];
        if (arr_FATCARec.count==1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            [btn_fatcaStatus setHidden:NO];
            NSDictionary *dic_fatcaRec=arr_FATCARec[0];
            txt_annualIncome.text=[NSString stringWithFormat:@"%d",[dic_fatcaRec[@"kifd_GrossIncome"]intValue]];
            txt_sourceOfWealth.text=[NSString stringWithFormat:@"%@",dic_fatcaRec[@"kifd_SourceOfWealth"]];
            txt_countryOfTaxResidence.text=[NSString stringWithFormat:@"%@",dic_fatcaRec[@"kifd_CountryofTaxResident"]];
            txt_taxIdentificationNo.text=[NSString stringWithFormat:@"%@",dic_fatcaRec[@"kifd_TaxPayerIdentificationNumber"]];
            txt_identificationType.text=[NSString stringWithFormat:@"%@",dic_fatcaRec[@"kifd_Identificationtype"]];
            if ([txt_annualIncome.text length]==0) {
                [lbl_grossStatus setTextColor:KTIncompleteStatusColor];
            }
            BOOL checkPolitical=[[NSString stringWithFormat:@"%@",dic_fatcaRec[@"kifd_Identificationtype"]] boolValue];
            if (checkPolitical==YES) {
                str_selectedPolitical=@"YES";
                [btn_politicalYes setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_politicalNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
            }
            else{
                str_selectedPolitical=@"NO";
                [btn_politicalYes setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_politicalNo setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
            }
        
            BOOL checkOtherThanIndia=[[NSString stringWithFormat:@"%@",dic_fatcaRec[@"kifd_TaxResidentofanyCountry"]] boolValue];
            if (checkOtherThanIndia==YES) {
                str_selectedResident=@"YES";
                [btn_otherYes setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_otherNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [view_hide setHidden:NO];
                if ([txt_countryOfTaxResidence.text length]==0) {
                    [lbl_countryTaxResidenceStatus setTextColor:KTIncompleteStatusColor];
                }
                if ([txt_taxIdentificationNo.text length]==0) {
                    [lbl_taxIDNumberStatus setTextColor:KTIncompleteStatusColor];
                }
                if ([txt_identificationType.text length]==0) {
                    [lbl_taxIDTypeStaus setTextColor:KTIncompleteStatusColor];
                }
                constraint_viewHideHeight.constant=231.0f;
                [self.view updateConstraints];
                [self.view layoutIfNeeded];
            }
            else{
                str_selectedResident=@"NO";
                [btn_otherYes setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_otherNo setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [view_hide setHidden:YES];
                constraint_viewHideHeight.constant=0.0f;
                [self.view updateConstraints];
                [self.view layoutIfNeeded];
            }
            [btn_fatcaStatus setTitle:@"Compiled" forState:UIControlStateNormal];
            [btn_fatcaStatus setImage:[UIImage imageNamed:@"SuccessTrue"] forState:UIControlStateNormal];
            scroll_mainScrollView.contentSize=CGSizeMake(KTScreenWidth, view_background.frame.origin.y+btn_dashboard.frame.origin.y+btn_dashboard.frame.size.height+30);
            [self getSourceOfWealthAPI];
        });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                 [[APIManager sharedManager]hideHUD];
                 [self setUserInteractionToField:YES];
                 [btn_fatcaStatus setHidden:NO];
                 [btn_salaryDrop setHidden:NO];
                 [btn_countryTaxDrop setHidden:NO];
                 [btn_fatcaStatus setTitle:@"Not Updated" forState:UIControlStateNormal];
                 [btn_fatcaStatus setImage:[UIImage imageNamed:@"FailureFalse"] forState:UIControlStateNormal];
                 [view_hide setHidden:YES];
                 constraint_viewHideHeight.constant=0.0f;
                 [self.view updateConstraints];
                 [self.view layoutIfNeeded];
                 [btn_titleChanged setTitle:@"Update Details" forState:UIControlStateNormal];
                 scroll_mainScrollView.contentSize=CGSizeMake(KTScreenWidth, view_background.frame.origin.y+btn_dashboard.frame.origin.y+btn_dashboard.frame.size.height+30);
                [self getSourceOfWealthAPI];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - save fatca details

-(void)saveUpdateFACTADetailsToServer{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_pan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedPrimaryPan];
    NSString *str_grossAnnualIncome =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[txt_annualIncome.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSString *str_sourceOfWealthValue=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[txt_sourceOfWealth.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSString *str_netWorthValue=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_netWorthOnDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_isPolitical=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedPolitical];
    NSString *str_isOtherResident=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedResident];
    NSString *str_countryTaxResidence=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_countryOfTaxResidence.text];
    NSString *str_taxIdentificationNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_taxIdentificationNo.text];
    NSString *str_taxIdentificationType=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_identificationType.text];
    NSString *str_url = [NSString stringWithFormat:@"%@SaveFATCADetails?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&PAN=%@&GrossAnnIncome=%@&SourceOfWealth=%@&Networth=%@&NetworthDate=%@&PEP=%@&TaxResidentofanyCountry=%@&CountryofTaxResident=%@&TaxPayerIdentificationNumber=%@&IdentificationType=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_pan,str_grossAnnualIncome,str_sourceOfWealthValue,str_netWorthValue,str_netWorthOnDate,str_isPolitical,str_isOtherResident,str_countryTaxResidence,str_taxIdentificationNumber,str_taxIdentificationType];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Table"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table1"][0][@"Msg"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:KTSuccessMsg forMessage:error_message andAction1:@"OK" andAction1Block:^{
                    KTPOP(YES);
                }];
            });
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

@end
