//
//  LoginRaiseaQueryVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 26/07/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "LoginRaiseaQueryVC.h"

@interface LoginRaiseaQueryVC ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    UIPickerView *picker_dropDown;
    UITextField *txt_currentTextField;
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UITextView *txtView_messageTxtView;
    __weak IBOutlet UITextField *txt_emailAddress;
    __weak IBOutlet UITextField *txt_mobileNumber;
    __weak IBOutlet UITextField *txt_folio;
    __weak IBOutlet UITextField *txt_fund;
    __weak IBOutlet UITextField *txt_chooseMember;
    NSArray *arr_familyPanRec,*arr_fundList,*arr_folioList;
    NSString *selectedFundID, *selectedFolioID, *selectedPan, *investorName;
}
@end

@implementation LoginRaiseaQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initaliseOnViewLoad];
    [txt_fund addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_folio addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_chooseMember addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_mobileNumber addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
}

-(void)doneAction:(UIBarButtonItem *)done{
    [txt_currentTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialise On View Load

-(void)initaliseOnViewLoad{
    [txt_emailAddress setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_mobileNumber setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [UITextField withoutRoundedCornerTextField:txt_chooseMember forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_folio forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextView withoutRoundedCornerTextFieldView:txtView_messageTxtView forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    [txt_emailAddress setUserInteractionEnabled:NO];
    txt_emailAddress.text=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserEmailID]]];
    [self onViewInitialise];
}

#pragma mark - fetch Funds

-(void)onViewInitialise{
    arr_familyPanRec = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS"]];
    if (arr_familyPanRec.count==1) {
        [txt_chooseMember setUserInteractionEnabled:NO];
        KT_TABLE12 *rec_primaryPan=arr_familyPanRec[0];
        selectedPan=[NSString stringWithFormat:@"%@",rec_primaryPan.PAN];
        investorName=[NSString stringWithFormat:@"%@",rec_primaryPan.invName];
        txt_chooseMember.text=[NSString stringWithFormat:@"%@ - %@",[NSString stringWithFormat:@"%@",rec_primaryPan.invName],selectedPan];
    }
    else{
        if (arr_familyPanRec.count>1){
            txt_chooseMember.inputView=picker_dropDown;
            [txt_chooseMember setUserInteractionEnabled:YES];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Information" withMessage:@"No PAN Details found."];
            });
        }
    }
    [self fetchGetFundListFromAPI];
}

#pragma mark - fetch FolioBased on Fund ID

-(void)fetchFolioBasedOnFundID:(NSString *)fundID{
    arr_folioList = [[DBManager sharedDataManagerInstance]uniqueFolioFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (Acno),notallowed_flag FROM TABLE2_DETAILS WHERE fund ='%@' AND PAN='%@'",fundID,selectedPan]];
    if (arr_folioList.count>1) {
        [txt_folio setUserInteractionEnabled:YES];
        txt_folio.inputView=picker_dropDown;
    }
    else{
        if (arr_folioList.count==1) {
            [txt_folio setUserInteractionEnabled:NO];
            KT_TABLE2 *folioRec=arr_folioList[0];
            txt_folio.text=[NSString stringWithFormat:@"%@",folioRec.Acno];
            selectedFolioID=[NSString stringWithFormat:@"%@",folioRec.Acno];
        }
        else{
            [txt_folio setUserInteractionEnabled:NO];
            txt_folio.text=@"";
        }
    }
}

#pragma mark - Submit Button Tapped

- (IBAction)btn_submitTapped:(id)sender {
    if (txt_chooseMember.text.length==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_chooseMember becomeFirstResponder];
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
    else if (txt_mobileNumber.text.length==0) {
        [txt_mobileNumber becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Mobile number cannot be empty."];
    }
    else if ([[SharedUtility sharedInstance]validateMobileWithString:txt_mobileNumber.text]==NO) {
        [txt_mobileNumber becomeFirstResponder];
        txt_mobileNumber.text=@"";
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter vaild mobile number."];
    }
    else if (txt_emailAddress.text.length==0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_emailAddress becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter email ID."];
        });
    }
    else if ([[SharedUtility sharedInstance]validateEmailWithString:txt_emailAddress.text]!=YES) {
        [txt_emailAddress becomeFirstResponder];
        txt_emailAddress.text=@"";
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter vaild email ID."];
    }
    else if ([txtView_messageTxtView.text length]==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txtView_messageTxtView becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Message cannot be empty"];
        });
    }
    else if ([txtView_messageTxtView.text isEqualToString:@"Query Message"] || [txtView_messageTxtView.text isEqual:@"Query Message"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txtView_messageTxtView becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Message cannot be empty"];
        });
    }
    else{
        [self postRaiseAQuery];
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
        txt_fund.text=@"";
        txt_folio.text=@"";
        if (arr_familyPanRec.count>1) {
            [picker_dropDown reloadAllComponents];
        }
        [txt_folio setUserInteractionEnabled:NO];
        [textField becomeFirstResponder];
    }
    else if (textField==txt_fund) {
        if (txt_chooseMember.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_fund resignFirstResponder];
                [txt_chooseMember becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select primary / family member."];
            });
        }
        else{
            txt_folio.text=@"";
            if (arr_fundList.count>1) {
                [picker_dropDown reloadAllComponents];
            }
            [txt_folio setUserInteractionEnabled:YES];
            [textField becomeFirstResponder];
        }
    }
    else if (textField==txt_folio) {
        if (txt_chooseMember.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_folio resignFirstResponder];
                [txt_chooseMember becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select primary / family member."];
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
            if (arr_folioList.count>1) {
                [picker_dropDown reloadAllComponents];
            }
            [textField becomeFirstResponder];
        }
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (txt_currentTextField==txt_chooseMember) {

    }
    else if (txt_currentTextField == txt_fund){
        [self fetchFolioBasedOnFundID:selectedFundID];
    }
    [textField resignFirstResponder];
}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==txt_mobileNumber) {
        if (txt_mobileNumber.text.length>=10 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==txt_emailAddress) {
        if (txt_emailAddress.text.length>=50 && range.length == 0){
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
    if (txt_currentTextField==txt_chooseMember){
        count=[arr_familyPanRec count];
    }
    else if (txt_currentTextField==txt_fund){
        count=[arr_fundList count];
    }
    else if (txt_currentTextField==txt_folio){
        count=[arr_folioList count];
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
    if (txt_currentTextField==txt_chooseMember){
        KT_TABLE12 *fundRec=arr_familyPanRec[row];
        str_fundName=[NSString stringWithFormat:@"%@ - %@",[NSString stringWithFormat:@"%@",fundRec.invName],[NSString stringWithFormat:@"%@",fundRec.PAN]];
    }
    else if (txt_currentTextField==txt_fund){
        str_fundName=[NSString stringWithFormat:@"%@",arr_fundList[row][@"amc_name"]];
    }
    else if (txt_currentTextField==txt_folio){
        KT_TABLE2 *folioRec=arr_folioList[row];
        str_fundName=[NSString stringWithFormat:@"%@",folioRec.Acno];
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
    if (txt_currentTextField==txt_chooseMember){
        KT_TABLE12 *fundRec=arr_familyPanRec[row];
        txt_chooseMember.text=[NSString stringWithFormat:@"%@ - %@",[NSString stringWithFormat:@"%@",fundRec.invName],[NSString stringWithFormat:@"%@",fundRec.PAN]];
        selectedPan=[NSString stringWithFormat:@"%@",fundRec.PAN];
        investorName=[NSString stringWithFormat:@"%@",fundRec.invName];
    }
    else if (txt_currentTextField==txt_fund){
        txt_fund.text=[NSString stringWithFormat:@"%@",arr_fundList[row][@"amc_name"]];
        selectedFundID=[NSString stringWithFormat:@"%@",arr_fundList[row][@"amc_code"]];
    }
    else if (txt_currentTextField==txt_folio){
        KT_TABLE2 *folioRec=arr_folioList[row];
        txt_folio.text=[NSString stringWithFormat:@"%@",folioRec.Acno];
        selectedFolioID=[NSString stringWithFormat:@"%@",folioRec.Acno];
    }
    
}
#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - TextViewDelegate
- (BOOL)isAcceptableTextLength:(NSUInteger)length {
    return length <= 500;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    NSLog(@"Range %@",NSStringFromRange(range));
    return [self isAcceptableTextLength:txtView_messageTxtView.text.length + string.length - range.length];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text =@"Query Message";
        textView.textColor=KTButtonBackGroundBlue;
        textView.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        //optional
    }
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *) textView {
    if ([textView.text isEqualToString:@"Query Message"] || [textView.text isEqual:@"Query Message"]) {
        [textView setText:@""];
        textView.textColor = [UIColor blackColor];
        textView.font=KTFontFamilySize(KTOpenSansRegular,12);
    }
    [textView becomeFirstResponder];
}

#pragma mark - raise a query API

-(void)raiseaQueryAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedFundID];
    NSString *str_folioNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedFolioID];
    NSString *str_userName=[XTAPP_DELEGATE convertToBase64StrForAGivenString:investorName];
    NSString *str_userPan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:investorName];
    NSString *str_emailID=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_emailAddress.text];
    NSString *str_mobileNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_mobileNumber.text];
    NSString *str_textContent=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txtView_messageTxtView.text];
    str_textContent = [str_textContent stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *str_url = [NSString stringWithFormat:@"%@Ktrackcomplaint?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Name=%@&Folio=%@&Email=%@&Mobile=%@&Content=%@&PAN=%@", KTBaseurl, unique_UDID, str_operatingSystem, str_appVersion, str_fund, str_userName, str_folioNumber, str_emailID, str_mobileNumber, str_textContent, str_userPan];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            NSString *referStr=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Refno"]];
            if (referStr.length==0){
                 [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Something went wrong. Please try again later."];
            }
            else{
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Message" forMessage:[NSString stringWithFormat:@"Complaint Successfully Registered with Reference number:\t %@",referStr] andAction1:@"OK" andAction1Block:^{
                    KTPOP(YES);
                }];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

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
            arr_fundList=responce[@"Dtinformation"];
            if (arr_fundList.count>1) {
                [txt_fund setUserInteractionEnabled:YES];
                txt_fund.inputView=picker_dropDown;
            }
            else{
                [txt_fund setUserInteractionEnabled:NO];
                txt_fund.text=[NSString stringWithFormat:@"%@",arr_fundList[0][@"amc_name"]];
                selectedFundID=[NSString stringWithFormat:@"%@",arr_fundList[0][@"amc_code"]];
                [self fetchFolioBasedOnFundID:selectedFundID];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

-(void)postRaiseAQuery{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedFundID];
    NSString *str_folioNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedFolioID];
    NSString *str_userName=[XTAPP_DELEGATE convertToBase64StrForAGivenString:investorName];
    NSString *str_emailID=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_emailAddress.text];
    NSString *str_mobileNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_mobileNumber.text];
    NSString *str_textContent=txtView_messageTxtView.text;
    str_textContent = [str_textContent stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSDictionary *paramDic=@{@"Adminusername":@"c21hcnRzZXJ2aWNl", @"Adminpassword":@"a2FydnkxMjM0JTI0", @"IMEI":unique_UDID, @"OS":str_operatingSystem, @"APKVer":str_appVersion, @"Fund":str_fund, @"Folio":str_folioNumber, @"Email":str_emailID, @"Name":str_userName, @"Mobile":str_mobileNumber, @"Content":str_textContent};
    NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"https://karvymfs.com/KTRACKAPI/SmartService.svc/Ktrackcomplaint"]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/xml"  forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
    NSError *err = nil;
    NSData *body = [NSJSONSerialization dataWithJSONObject:paramDic  options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField:@"Content-Length"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data==nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Something went wrong. Please try again later."];
            });
        }
        else{
            id newResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([newResponse isKindOfClass:[NSString class]]) {
                NSError *err = nil;
                NSData *str_data = [newResponse dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:str_data options:NSJSONReadingAllowFragments error:&err];
                if (err) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[APIManager sharedManager]hideHUD];
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Something went wrong. Please try again later."];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[APIManager sharedManager]hideHUD];
                        NSString *referStr=[NSString stringWithFormat:@"%@",responseDic[@"Table1"][0][@"Refno"]];
                        if (referStr.length==0){
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Something went wrong. Please try again later."];
                        }
                        else{
                            [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Message" forMessage:[NSString stringWithFormat:@"Complaint Successfully Registered with Reference number:\t %@",referStr] andAction1:@"OK" andAction1Block:^{
                                KTPOP(YES);
                            }];
                        }
                    });
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    NSString *referStr=[NSString stringWithFormat:@"%@",newResponse[@"Table1"][0][@"Refno"]];
                    if (referStr.length==0){
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Something went wrong. Please try again later."];
                    }
                    else{
                        [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Message" forMessage:[NSString stringWithFormat:@"Complaint Successfully Registered with Reference number:\t %@",referStr] andAction1:@"OK" andAction1Block:^{
                            KTPOP(YES);
                        }];
                    }
                });
            }
        }
    }];
    [postDataTask resume];
}

@end
