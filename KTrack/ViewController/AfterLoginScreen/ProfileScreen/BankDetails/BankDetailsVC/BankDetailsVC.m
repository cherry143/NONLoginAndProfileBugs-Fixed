//
//  BankDetailsVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 18/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "BankDetailsVC.h"

@interface BankDetailsVC ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    __weak IBOutlet UIButton *btn_editDetails;
    __weak IBOutlet UIScrollView *scroll_main;
    __weak IBOutlet UITextField *txt_branchName;
    __weak IBOutlet UIButton *btn_myProfileDashboard;
    __weak IBOutlet UITextField *txt_accountType;
    __weak IBOutlet UITextField *txt_accountNumber;
    __weak IBOutlet UITextView *txt_branchAndAdress;
    __weak IBOutlet UITextField *txt_bankName;
    __weak IBOutlet UITextField *txt_ifscCode;
    NSString *str_bankSerialID;
    NSArray *arr_accountType;
    UIPickerView *picker_dropDown;
    UITextField *txt_currentTxtField;
}
@end

@implementation BankDetailsVC
@synthesize str_selectedPrimaryPan,dic_selectedBankRec;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
    [self initialisePicker];
    [self loadTextBankDetails];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"BankDetails"];
    [btn_editDetails setTitle:@"Edit Details" forState:UIControlStateNormal];
    [self getAccountTypeList];
}

#pragma mark - Picker

-(void)initialisePicker{
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Back Button Tapped

- (IBAction)btn_backTapped:(UIButton *)sender {
    KTPOP(YES);
}

-(void)loadTextBankDetails{
    [UIButton roundedCornerButtonWithoutBackground:btn_myProfileDashboard forCornerRadius:KTiPad?25.0f:btn_myProfileDashboard.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_editDetails forCornerRadius:KTiPad?25.0f:btn_editDetails.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    txt_ifscCode.text=[NSString stringWithFormat:@"%@",dic_selectedBankRec[@"kb_IFSCCode"]];
    txt_bankName.text=[NSString stringWithFormat:@"%@",dic_selectedBankRec[@"kb_BankName"]];
    txt_branchName.text=[NSString stringWithFormat:@"%@",dic_selectedBankRec[@"kb_BranchName"]];
    txt_branchAndAdress.text=[NSString stringWithFormat:@"%@",dic_selectedBankRec[@"kb_Bankadd"]];
    txt_accountNumber.text=[NSString stringWithFormat:@"%@",dic_selectedBankRec[@"kb_BankAcNo"]];
    txt_accountType.text=[NSString stringWithFormat:@"%@",dic_selectedBankRec[@"kb_Accounttype"]];
    str_bankSerialID=[NSString stringWithFormat:@"%@",dic_selectedBankRec[@"kb_slno"]];
    [txt_ifscCode setUserInteractionEnabled:NO];
    [self setUserInteractionToField:NO];
}

#pragma mark - userInteractionToFields Enabling

-(void)setUserInteractionToField:(BOOL)enable{
    [txt_bankName setUserInteractionEnabled:enable];
    [txt_branchAndAdress setUserInteractionEnabled:enable];
    [txt_branchName setUserInteractionEnabled:enable];
    [txt_accountNumber setUserInteractionEnabled:enable];
}

#pragma mark - Button profile Dashboard Tapped

- (IBAction)btn_profileDashBoardTapped:(id)sender {
    [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:[[self.navigationController viewControllers]count]-3] animated:NO];
}

- (IBAction)btn_titileChangedTapped:(UIButton *)sender {
    if([sender.titleLabel.text isEqual:@"Edit Details"]){
        [btn_editDetails setTitle:@"Update Details" forState:UIControlStateNormal];
        [self setUserInteractionToField:YES];
    }else{
        if ([txt_ifscCode.text length]==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_ifscCode becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter IFSC Code"];
            });
        }
        else if ([txt_ifscCode.text length]!=11){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_ifscCode becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please correct IFSC Code"];
            });
        }
        else if ([[SharedUtility sharedInstance]validateIFSCCodeWithString:txt_ifscCode.text]==NO){
            dispatch_async(dispatch_get_main_queue(), ^{
                txt_ifscCode.text=@"";
                [txt_ifscCode becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please a vaild IFSC Code"];
            });
        }
        else if ([txt_bankName.text length]==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_bankName becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter bank name"];
            });
        }
        else if ([txt_branchName.text length]==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_branchName becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter branch name"];
            });
        }
        else if ([txt_branchAndAdress.text length]==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_branchAndAdress becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter branch address"];
            });
        }
        else if ([txt_accountNumber.text length]==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_accountNumber becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter account number"];
            });
        }
        else if ([[SharedUtility sharedInstance]validateOnlyIntegerValue:txt_accountNumber.text]==NO){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_accountNumber becomeFirstResponder];
                txt_accountNumber.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please a vaild account number"];
            });
        }else if ([txt_accountType.text length]==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_accountType becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select account type"];
            });
        }
        else{
            [self saveBankDetailsToServer];
        }
    }
}

#pragma mark - view Did Appear

-(void)viewDidAppear:(BOOL)animated{
    scroll_main.contentSize=CGSizeMake(self.view.frame.size.width, btn_myProfileDashboard.frame.origin.y+btn_myProfileDashboard.frame.size.height+35);
}

-(void)saveBankDetailsToServer{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_pan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedPrimaryPan];
    NSString *str_ifsc =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[txt_ifscCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSString *str_bankMicr=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_bankName=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_bankName.text];
    NSString *str_bankBranch=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_branchName.text];
    str_bankBranch = [str_bankBranch stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *str_bankAccountNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_accountNumber.text];
    NSString *str_bankAccountType=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[txt_accountType.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSString *str_bankAddress=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",txt_branchAndAdress.text]];
    str_bankAddress = [str_bankAddress stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *str_serialBankID=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_bankSerialID];
    NSString *str_url = [NSString stringWithFormat:@"%@SaveBankDetails?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&PAN=%@&IFSC=%@&MICR=%@&BankName=%@&BranchName=%@&BankACNo=%@&Accounttype=%@&BankAdd=%@&Slno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_pan,str_ifsc,str_bankMicr,str_bankName,str_bankBranch,str_bankAccountNumber,str_bankAccountType,str_bankAddress,str_serialBankID];
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


-(void)getAccountTypeList{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_optional =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"AC"];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_schemetype=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_plntype=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_optional,str_fund,str_schemetype,str_plntype];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            arr_accountType=responce[@"Dtinformation"];
            if (arr_accountType.count>1) {
                txt_accountType.inputView=picker_dropDown;
            }
            else{
                txt_accountType.text=arr_accountType[0][@"Account_Type"];
                [txt_accountType setUserInteractionEnabled:NO];
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
    if (textField==txt_accountType) {
        if (arr_accountType.count>1) {
            [picker_dropDown reloadAllComponents];
        }
        else{
            txt_accountType.text=[NSString stringWithFormat:@"%@",arr_accountType[0][@"Account_Type"]];
        }
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
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
    if (txt_currentTxtField==txt_accountType){
        count=[arr_accountType count];
    }
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str_fundName;
    if (txt_currentTxtField==txt_accountType){
        str_fundName=[NSString stringWithFormat:@"%@",arr_accountType[row][@"rm_relation"]];
    }
    return str_fundName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (txt_currentTxtField==txt_accountType){
        txt_accountType.text=[NSString stringWithFormat:@"%@",arr_accountType[row][@"rm_relation"]];
    }
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

@end
