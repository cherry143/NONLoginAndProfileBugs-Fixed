//
//  LinkFamilyFolioVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 11/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "LinkFamilyFolioVC.h"

@interface LinkFamilyFolioVC ()<UIPickerViewDelegate,UIPickerViewDataSource,commonCustomDelegate>{
    __weak IBOutlet UIButton *btn_generateOtp;
    __weak IBOutlet UITextField *txt_familyMember;
    __weak IBOutlet UITextField *txt_pan;
    NSString *str_generatedOTP,*str_referenceNumberGenerated;
    UIPickerView *picker_dropDown;
    NSArray *arr_nomRelation;
    UITextField *txt_currentTxtField;
}

@end

@implementation LinkFamilyFolioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self InitialiseOnViewLoad];
    [self associatedMemberRelationshipAPI];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"LinkFamilyFolio"];
    txt_pan.autocapitalizationType = UITextAutocapitalizationTypeSentences;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitialiseOnViewLoad

-(void)InitialiseOnViewLoad{
    [UITextField withoutRoundedCornerTextField:txt_familyMember forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIButton roundedCornerButtonWithoutBackground:btn_generateOtp forCornerRadius:KTiPad?25.0f:btn_generateOtp.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
}

#pragma mark -BackTapped

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

- (IBAction)btn_generateOTP:(UIButton *)sender {
    if (txt_pan.text.length==0) {
        [txt_pan becomeFirstResponder];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter PAN No."];
        });
    }
    else{
        NSString *str_panStr=txt_pan.text;
        txt_pan.text=str_panStr.uppercaseString;
        NSString *panRegex =  @"[A-Z]{3}P[A-Z]{1}[0-9]{4}[A-Z]{1}";
        NSPredicate *panPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", panRegex];
        if ([panPredicate evaluateWithObject:txt_pan.text] == NO){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_pan becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter correct PAN No"];
            });
        }
        else if (txt_familyMember.text.length==0){
            [txt_familyMember becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select relation."];
            });
        }
        else{
            [self GetOnlinePINAPI];
        }
    }
}

#pragma mark - GetOnlinePINAPI

-(void)GetOnlinePINAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_pan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_pan.text];
    NSString *str_relation=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_familyMember.text];
    NSString *str_url = [NSString stringWithFormat:@"%@GetOnlinePIN?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Userid=%@&pan=%@&relation=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_pan,str_relation];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:KTSuccessMsg forMessage:error_message andAction1:@"Ok" andAction1Block:^{
                    str_referenceNumberGenerated=[NSString stringWithFormat:@"%@",responce[@"DtData"][0][@"Refno"]];
                    [self showMessagePopup:@"LinkFamily"];
                }];
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - relation API

-(void)associatedMemberRelationshipAPI{
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
            arr_nomRelation=responce[@"Dtinformation"];
            if (arr_nomRelation.count>1) {
                txt_familyMember.inputView=picker_dropDown;
                [txt_familyMember setUserInteractionEnabled:YES];
            }
            else{
                txt_familyMember.text=[NSString stringWithFormat:@"%@",arr_nomRelation[0][@"rm_relation"]];
                [txt_familyMember setUserInteractionEnabled:NO];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return arr_nomRelation.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str_fundName;
    str_fundName=[NSString stringWithFormat:@"%@",arr_nomRelation[row][@"rm_relation"]];
    return str_fundName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   txt_familyMember.text=[NSString stringWithFormat:@"%@",arr_nomRelation[row][@"rm_relation"]];
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTxtField=textField;
    [textField becomeFirstResponder];
    if (textField==txt_familyMember) {
        txt_familyMember.text=[NSString stringWithFormat:@"%@",arr_nomRelation[0][@"rm_relation"]];
        [picker_dropDown reloadAllComponents];
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

-(void)showMessagePopup:(NSString *)show{
    CommonPopupVC *destinationController=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"CommonPopupVC"];
    destinationController.commondelegate=self;
    destinationController.str_fromScreen=show;
    destinationController.str_referenceGen=str_referenceNumberGenerated;
    destinationController.str_panEntered=txt_pan.text;
    [self addChildViewController:destinationController];
    [self.view addSubview:destinationController.view];
    [destinationController didMoveToParentViewController:self];
}

-(void)cancelButtonTapped{
    txt_familyMember.text=@"";
    txt_pan.text=@"";
}

-(void)familyFolioSuccess{
    [self LoginApiWithLoginMode:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginTypeKey] forUserName:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername] forPassword:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginPassword] forInvestorType:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginInvestor]];
}

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
                KTPOP(YES);
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

@end
