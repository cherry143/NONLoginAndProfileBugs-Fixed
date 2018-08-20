//
//  NomineeDetailsVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 18/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "NomineeDetailsVC.h"

@interface NomineeDetailsVC ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    UIDatePicker *picker_date;
    __weak IBOutlet UIScrollView *scroll_mainScrollView;
    __weak IBOutlet UIButton *btn_dashboard;
    __weak IBOutlet UIButton *btn_titleChanged;
    __weak IBOutlet UITextField *txt_dateOfBirth;
    __weak IBOutlet UIButton *btn_nomineeDrop;
    __weak IBOutlet UITextField *txt_nomineeRelation;
    __weak IBOutlet UITextField *txt_zipcode;
    __weak IBOutlet UIButton *btn_countrydrop;
    __weak IBOutlet UITextField *txt_country;
    __weak IBOutlet UITextField *txt_stateName;
    __weak IBOutlet UITextField *txt_cityName;
    __weak IBOutlet UITextField *txt_correspondingAddress;
    __weak IBOutlet UITextField *txt_nomineeName;
    __weak IBOutlet UIButton *btn_sameasPrimary;
    UIPickerView *picker_dropDown;
    NSArray *arr_primaryAddress,*arr_countryList,*arr_nomineeRelation;
    UITextField *txt_currentTxtField;
    NSString *str_selectedCountryID,*str_nomineeID;
    BOOL isAPICalled;
}
@end

@implementation NomineeDetailsVC
@synthesize str_selectedPrimaryPan,dic_selectedNomineeRec,str_fromScreen;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
    [self initialiseBorderToFields];
    if ([str_fromScreen isEqual:@"ShowDetails"]){
        [btn_countrydrop setHidden:YES];
        [btn_nomineeDrop setHidden:YES];
        [btn_sameasPrimary setHidden:YES];
        [self nomineeDetailsIntoFields];
        [self setUserInteractionToField:NO];
        [btn_titleChanged setTitle:@"Edit Details" forState:UIControlStateNormal];
        [XTAPP_DELEGATE callPagelogOnEachScreen:@"NomineeDetails"];
    }
    else{
        [self setUserInteractionToField:YES];
        [btn_countrydrop setHidden:NO];
        [btn_nomineeDrop setHidden:NO];
        [btn_sameasPrimary setHidden:NO];
        [btn_titleChanged setTitle:@"Add Nominee" forState:UIControlStateNormal];
        [XTAPP_DELEGATE callPagelogOnEachScreen:@"AddNomineeDetails"];
        str_nomineeID=@"";
    }
}

#pragma mark - userInteractionToFields Enabling

-(void)setUserInteractionToField:(BOOL)enable{
    [txt_nomineeName setUserInteractionEnabled:enable];
    [txt_correspondingAddress setUserInteractionEnabled:enable];
    [txt_cityName setUserInteractionEnabled:enable];
    [txt_stateName setUserInteractionEnabled:enable];
    [txt_country setUserInteractionEnabled:enable];
    [txt_zipcode setUserInteractionEnabled:enable];
    [txt_nomineeRelation setUserInteractionEnabled:enable];
    [txt_dateOfBirth setUserInteractionEnabled:enable];
}

#pragma mark - View Will Appear

-(void)viewDidAppear:(BOOL)animated{
    scroll_mainScrollView.contentSize=CGSizeMake(KTScreenWidth, btn_dashboard.frame.origin.y+btn_dashboard.frame.size.height+25);
}

#pragma mark - Border to textFields

-(void)initialiseBorderToFields{
    [txt_nomineeName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_correspondingAddress setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_cityName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_stateName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_zipcode setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [UITextField withoutRoundedCornerTextField:txt_country forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_nomineeRelation forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_dateOfBirth forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIButton roundedCornerButtonWithoutBackground:btn_dashboard forCornerRadius:KTiPad?25.0f:btn_dashboard.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_titleChanged forCornerRadius:KTiPad?25.0f:btn_titleChanged.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
   
    picker_date= [[UIDatePicker alloc]init];
    picker_date.datePickerMode=UIDatePickerModeDate;
    [picker_date setDate:[NSDate date]];
    [picker_date setMaximumDate:[NSDate date]];
    [picker_date addTarget:self action:@selector(updateDateTextField:) forControlEvents:UIControlEventValueChanged];
    txt_dateOfBirth.inputView=picker_date;
    [self getPrimaryAddress];
}

#pragma mark - DatePicker date into textfield

-(void)updateDateTextField:(UIDatePicker *)sender{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:XTOnlyDateFormat];
    txt_dateOfBirth.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:sender.date]];
}

#pragma mark - clear text field value

-(void)clearTextFieldValue{
    txt_nomineeName.text=@"";
    txt_correspondingAddress.text=@"";
    txt_cityName.text=@"";
    txt_stateName.text=@"";
    txt_country.text=@"";
    txt_zipcode.text=@"";
    txt_nomineeRelation.text=@"";
    txt_dateOfBirth.text=@"";
}

#pragma mark - Nominee Details show if user comes from the list

-(void)nomineeDetailsIntoFields{
    txt_nomineeName.text=[NSString stringWithFormat:@"%@",dic_selectedNomineeRec[@"kn_NomName"]];
    txt_correspondingAddress.text=[NSString stringWithFormat:@"%@",dic_selectedNomineeRec[@"kn_NomAddress1"]];
    txt_cityName.text=[NSString stringWithFormat:@"%@",dic_selectedNomineeRec[@"kn_NomCity"]];
    txt_stateName.text=[NSString stringWithFormat:@"%@",dic_selectedNomineeRec[@"kn_NomState"]];
    txt_country.text=[NSString stringWithFormat:@"%@",dic_selectedNomineeRec[@"kn_NomCountry"]];
    txt_zipcode.text=[NSString stringWithFormat:@"%@",dic_selectedNomineeRec[@"kn_NomPin"]];
    txt_nomineeRelation.text=[NSString stringWithFormat:@"%@",dic_selectedNomineeRec[@"kn_NomRelation"]];
    txt_dateOfBirth.text=[NSString stringWithFormat:@"%@",dic_selectedNomineeRec[@"kn_NomDOB"]];
    str_nomineeID=[NSString stringWithFormat:@"%@",dic_selectedNomineeRec[@"kn_slno"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Back Button Tapped

- (IBAction)btn_backTapped:(UIButton *)sender {
    KTPOP(YES);
}

#pragma mark - same as primary tapped

- (IBAction)btn_sameTapped:(UIButton *)sender {
    if([sender.imageView.image isEqual:[UIImage imageNamed:@"uncheck"]]){
        [sender setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [self checkTappedTextFieldValue];
        if ([str_fromScreen isEqual:@"ShowDetails"]){

        }
    }
    else{
        [sender setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        if ([str_fromScreen isEqual:@"ShowDetails"]){
            [self nomineeDetailsIntoFields];
        }
        else{
            [self clearTextFieldValue];
        }
    }
}

- (IBAction)btn_profileDashBoardTapped:(id)sender {
    [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:[[self.navigationController viewControllers]count]-3] animated:NO];
}

- (IBAction)btn_titleChangedTapped:(UIButton *)sender {
    if([sender.titleLabel.text isEqual:@"Edit Details"]){
        [btn_titleChanged setTitle:@"Update Details" forState:UIControlStateNormal];
        [btn_sameasPrimary setHidden:NO];
        [btn_countrydrop setHidden:NO];
        [btn_nomineeDrop setHidden:NO];
        [self setUserInteractionToField:YES];
    }
    else{
        if (txt_nomineeName.text.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_nomineeName becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter nominee name."];
            });
        }
        else if ([[SharedUtility sharedInstance]validateOnlyAlphabets:txt_nomineeName.text]==NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_nomineeName becomeFirstResponder];
                txt_nomineeName.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter valid investor name"];
            });
        }
        else if (txt_correspondingAddress.text.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_correspondingAddress becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter corresponding address."];
            });
        }
        else if (txt_cityName.text.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_cityName becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter city."];
            });
        }
        else if ([[SharedUtility sharedInstance]validateOnlyAlphabets:txt_cityName.text]==NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_cityName becomeFirstResponder];
                txt_cityName.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a vaild city."];
            });
        }
        else if (txt_stateName.text.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_stateName becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter state."];
            });
        }
        else if ([[SharedUtility sharedInstance]validateOnlyAlphabets:txt_stateName.text]==NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_stateName becomeFirstResponder];
                txt_stateName.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a vaild state."];
            });
        }
        else if (txt_country.text.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_country becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select a country."];
            });
        }
        else if (txt_zipcode.text.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_zipcode becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter area pincode."];
            });
        }
        else if ([[SharedUtility sharedInstance]validateZipCodeWithString:txt_zipcode.text]==NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_zipcode becomeFirstResponder];
                txt_zipcode.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a vaild area pincode."];
            });
        }
        else if (txt_nomineeRelation.text.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_nomineeRelation becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select a nominee relation."];
            });
        }
        else if (txt_dateOfBirth.text.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_dateOfBirth becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter date of birth."];
            });
        }
        else {
            [self saveUpdateNomineeDetailsToServer];
        }
    }
}

#pragma mark - text field value if check is tapped

-(void)checkTappedTextFieldValue{
    if (arr_primaryAddress.count>0) {
        NSDictionary *dic_primary=arr_primaryAddress[0];
        txt_correspondingAddress.text=[NSString stringWithFormat:@"%@,%@,%@",dic_primary[@"kr_CorAdd1"],dic_primary[@"kr_CorAdd2"],dic_primary[@"kr_CorAdd3"]];
        txt_cityName.text=[NSString stringWithFormat:@"%@",dic_primary[@"kr_CorCity"]].capitalizedString;
        txt_stateName.text=[NSString stringWithFormat:@"%@",dic_primary[@"kr_CorState"]].capitalizedString;
        txt_country.text=[NSString stringWithFormat:@"%@",dic_primary[@"kr_CorCountry"]].capitalizedString;
        txt_zipcode.text=[NSString stringWithFormat:@"%@",dic_primary[@"kr_CorPin"]];
    }
}

#pragma mark - Get Primary Address

-(void)getPrimaryAddress{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_PAN =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",str_selectedPrimaryPan]];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_schemeType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_plnType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@Addnominee?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&pan=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_PAN,str_fund,str_schemeType,str_plnType];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        arr_primaryAddress=responce[@"Table"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            [self getCountryList];
        });
    } failure:^(NSError *error) {
        
    }];
}

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
            arr_countryList=responce[@"Dtinformation"];
            if (arr_countryList.count>1) {
                txt_country.inputView=picker_dropDown;
            }
            else{
                txt_country.text=[NSString stringWithFormat:@"%@",arr_countryList[0][@"COUNTRYNAME"]];
                str_selectedCountryID=[NSString stringWithFormat:@"%@",arr_countryList[0][@"COUNTRYCODE"]];
            }
         [self getNomineeRelationList];
        });
    } failure:^(NSError *error) {
        
    }];
}

-(void)getNomineeRelationList{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_optional =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"NR"];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_schemetype=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_plntype=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_optional,str_fund,str_schemetype,str_plntype];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            arr_nomineeRelation=responce[@"Dtinformation"];
            if (arr_nomineeRelation.count>1) {
                txt_nomineeRelation.inputView=picker_dropDown;
            }
            else{
                txt_nomineeRelation.text=[NSString stringWithFormat:@"%@",arr_nomineeRelation[0][@"rm_relation"]];
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
    txt_currentTxtField=textField;
    [textField becomeFirstResponder];
    if (textField==txt_nomineeRelation) {
        txt_nomineeRelation.text=[NSString stringWithFormat:@"%@",arr_nomineeRelation[0][@"rm_relation"]];
        [picker_dropDown reloadAllComponents];
    }
    else if (textField==txt_country) {
        txt_country.text=[NSString stringWithFormat:@"%@",arr_countryList[0][@"COUNTRYNAME"]];
        str_selectedCountryID=[NSString stringWithFormat:@"%@",arr_countryList[0][@"COUNTRYCODE"]];
        [picker_dropDown reloadAllComponents];
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==txt_nomineeName) {
        if (txt_nomineeName.text.length>=50 && range.length == 0){
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
    if (txt_currentTxtField==txt_nomineeRelation){
        count=[arr_nomineeRelation count];
    }
    else if (txt_currentTxtField==txt_country){
        count=[arr_countryList count];
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
    if (txt_currentTxtField==txt_nomineeRelation){
        str_fundName=[NSString stringWithFormat:@"%@",arr_nomineeRelation[row][@"rm_relation"]];
    }
    else if (txt_currentTxtField==txt_country){
        str_fundName=[NSString stringWithFormat:@"%@",arr_countryList[row][@"COUNTRYNAME"]];
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
    if (txt_currentTxtField==txt_nomineeRelation){
      txt_nomineeRelation.text=[NSString stringWithFormat:@"%@",arr_nomineeRelation[row][@"rm_relation"]];
    }
    else if (txt_currentTxtField==txt_country){
        txt_country.text=[NSString stringWithFormat:@"%@",arr_countryList[row][@"COUNTRYNAME"]];
        str_selectedCountryID=[NSString stringWithFormat:@"%@",arr_countryList[row][@"COUNTRYCODE"]];
    }
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

-(void)saveUpdateNomineeDetailsToServer{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_pan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedPrimaryPan];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_nomName=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_nomineeName.text];
    NSString *str_nomRelation=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_nomineeRelation.text];
    NSString *str_nomBOD=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_dateOfBirth.text];
    NSString *str_nomAdd=[[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_correspondingAddress.text] stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSString *str_nomCity=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_cityName.text];
    NSString *str_nomState=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_stateName.text];
    NSString *str_nomCountry=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_country.text];
    NSString *str_nomZipcode=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_zipcode.text];
    NSString *str_nomSerialID=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_nomineeID];
    NSString *str_url = [NSString stringWithFormat:@"%@SaveNomineeDetails?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&PAN=%@&NomName=%@&NomRelation=%@&NomDOB=%@&NomAdd=%@&NomCity=%@&NomState=%@&NomCountry=%@&NomPIN=%@&Slno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_pan,str_nomName,str_nomRelation,str_nomBOD,str_nomAdd,str_nomCity,str_nomState,str_nomCountry,str_nomZipcode,str_nomSerialID];
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
