//
//  CommunicationDetailsVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 18/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "CommunicationDetailsVC.h"

@interface CommunicationDetailsVC (){
    __weak IBOutlet UILabel *lbl_addressStatus;
    __weak IBOutlet UILabel *lbl_mobileNumberStatus;
    __weak IBOutlet UITextView *txt_address;
    __weak IBOutlet UITextField *txt_mobileNo;
    __weak IBOutlet UITextField *txt_emailID;
    __weak IBOutlet UIButton *btn_dashboard;
    __weak IBOutlet UIButton *btn_titleChanged;
    __weak IBOutlet UILabel *lbl_emailStatus;
}
@end

@implementation CommunicationDetailsVC
@synthesize str_selectedPrimaryPan;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseOnViewLoad];
    [txt_address setUserInteractionEnabled:NO];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"CommunicationDetails"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitialiseView Did Load

-(void)initialiseOnViewLoad{
    [txt_emailID setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_mobileNo setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [UIButton roundedCornerButtonWithoutBackground:btn_dashboard forCornerRadius:KTiPad?25.0f:btn_dashboard.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_titleChanged forCornerRadius:KTiPad?25.0f:btn_titleChanged.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [btn_titleChanged setTitle:@"Edit Details" forState:UIControlStateNormal];
    [self setUserInteractionToField:NO];
    [self getCommunicationDetailsFromAPI];
}

#pragma mark - userInteractionToFields Enabling

-(void)setUserInteractionToField:(BOOL)enable{
    [txt_mobileNo setUserInteractionEnabled:enable];
    [txt_emailID setUserInteractionEnabled:enable];
}

#pragma mark - Back Button Tapped

- (IBAction)btn_backTapped:(UIButton *)sender {
    KTPOP(YES);
}

- (IBAction)btn_profileDashBoardTapped:(id)sender {
    [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:[[self.navigationController viewControllers]count]-2] animated:NO];
}

- (IBAction)btn_titleChangedTapped:(UIButton *)sender {
    if([sender.titleLabel.text isEqual:@"Edit Details"]){
        [btn_titleChanged setTitle:@"Update Details" forState:UIControlStateNormal];
        [self setUserInteractionToField:YES];
    }
    else{
        if (txt_emailID.text.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_emailID becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter email ID."];
            });
        }
        else if ([[SharedUtility sharedInstance]validateEmailWithString:txt_emailID.text]!=YES) {
            [txt_emailID becomeFirstResponder];
            txt_emailID.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter vaild email ID."];
        }
        else if (txt_mobileNo.text.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_mobileNo becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter mobile number."];
            });
        }
        else if ([[SharedUtility sharedInstance]validateMobileWithString:txt_mobileNo.text]==NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_mobileNo becomeFirstResponder];
                txt_mobileNo.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter vaild mobile number."];
            });
        }
        else {
            [self saveUpdateCommunicationDetails];
        }
    }
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==txt_emailID) {
        if (txt_emailID.text.length>=50 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if (textField==txt_mobileNo) {
        if (txt_mobileNo.text.length>=10 && range.length == 0){
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

#pragma mark - TextViewDelegate

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView==txt_address) {
        if ([textView.text isEqualToString:@""]) {
            textView.text =@"Address";
            textView.textColor = [UIColor blackColor]; //optional
        }
    }
    [textView resignFirstResponder];
    return YES;
}

- (void) textViewDidBeginEditing:(UITextView *) textView {
    if (textView==txt_address) {
        if ([textView.text isEqualToString:@"Address"]) {
            [textView setText:@""];
            textView.textColor = [UIColor blackColor]; //optional
        }
    }
    [textView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView becomeFirstResponder];
        [self textViewDidChange:textView];
        return NO;
    }
    return YES;
}

#pragma mark - TextView Delegate Methods Ends

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

#pragma mark - getCommunicationDetails

-(void)getCommunicationDetailsFromAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_pan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedPrimaryPan];
    NSString *str_refno=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@panbasecommunicationdetails?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&refno=%@&pan=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_refno,str_pan];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
                NSArray *arr_res=responce[@"Dtdata"];
                if (arr_res.count>0) {
                    NSDictionary *commDic=responce[@"Dtdata"][0];
                    txt_emailID.text=[NSString stringWithFormat:@"%@",commDic[@"kc_email"]];
                    txt_mobileNo.text=[NSString stringWithFormat:@"%@",commDic[@"kc_mobile"]];
                    txt_address.text=[NSString stringWithFormat:@"%@",commDic[@"kc_add"]];
                    if ([txt_emailID.text length]==0) {
                        [lbl_emailStatus  setTextColor:KTIncompleteStatusColor];
                    }
                    if ([txt_mobileNo.text length]==0) {
                        [lbl_mobileNumberStatus  setTextColor:KTIncompleteStatusColor];
                    }
                }
                else{
                    [self setUserInteractionToField:YES];
                    [btn_titleChanged setTitle:@"Update Details" forState:UIControlStateNormal];
                }
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                    [self setUserInteractionToField:YES];
                    [btn_titleChanged setTitle:@"Update Details" forState:UIControlStateNormal];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SaveOrUpdateCommunicationDetails

-(void)saveUpdateCommunicationDetails{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_pan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedPrimaryPan];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_emailID=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_emailID.text];
    NSString *str_mobileNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_mobileNo.text];
    NSString *str_address=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@panbasecommunicationdetails_save?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&pan=%@&email=%@&phone=%@&address=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_pan,str_emailID,str_mobileNumber,str_address];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
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
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
        
    } failure:^(NSError *error) {
        
    }];
}

@end
