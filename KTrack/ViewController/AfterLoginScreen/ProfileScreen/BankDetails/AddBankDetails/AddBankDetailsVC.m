//
//  AddBankDetailsVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 28/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "AddBankDetailsVC.h"
#import "Base64.h"
#import <AVFoundation/AVFoundation.h>

@interface AddBankDetailsVC ()<UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    __weak IBOutlet UIButton *btn_saveDetails;
    __weak IBOutlet UITextField *txt_accountType;
    __weak IBOutlet UITextField *txt_accountNumber;
    __weak IBOutlet UITextField *txt_address2;
    __weak IBOutlet UITextField *txt_address1;
    __weak IBOutlet UITextField *txt_bankName;
    __weak IBOutlet UITextField *txt_ifscCode;
    __weak IBOutlet UIScrollView *scroll_mainScroll;
    __weak IBOutlet UIView *view_mainBackGroundView;
    NSArray *arr_accountType;
    UIPickerView *picker_dropDown;
    UITextField *txt_currentTxtField;
    __weak IBOutlet UIImageView *img_emptyCheckImage;
}

@end

@implementation AddBankDetailsVC
@synthesize str_selectedPrimaryPan;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
    [self initialiseOnViewLoad];
    [self getAccountTypeList];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"AddBankDetails"];
}

#pragma mark - InitialiseOnViewLoad

-(void)initialiseOnViewLoad{
    [txt_ifscCode setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_bankName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_accountType setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_accountNumber setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_address1 setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_address2 setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_bankName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [UIButton roundedCornerButtonWithoutBackground:btn_saveDetails forCornerRadius:KTiPad?25.0f:btn_saveDetails.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - back button Action

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

#pragma mark - save details tapped

- (IBAction)btn_saveDetailsTapped:(UIButton *)sender {
    if ([txt_ifscCode.text length]==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_ifscCode becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter IFSC Code"];
        });
    }
    else if ([txt_ifscCode.text length]!=11){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_ifscCode becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a valid IFSC Code"];
        });
    }
    else if ([[SharedUtility sharedInstance]validateIFSCCodeWithString:txt_ifscCode.text]==NO){
        dispatch_async(dispatch_get_main_queue(), ^{
            txt_ifscCode.text=@"";
            [txt_ifscCode becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a valid IFSC Code"];
        });
    }
    else if ([txt_bankName.text length]==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_bankName becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter bank name"];
        });
    }
    else if ([txt_address1.text length]==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_address1 becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter branch address"];
        });
    }
    else if ([txt_address2.text length]==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_address2 becomeFirstResponder];
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
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a vaild account number"];
        });
    }
    else if ([txt_accountNumber.text length]<=15){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_accountNumber becomeFirstResponder];
            txt_accountNumber.text=@"";
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a vaild account number"];
        });
    }
    else if ([txt_accountType.text length]==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_accountType becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select account type"];
        });
    }
    else{
        [self saveBankDetailsToServer];
    }
}

#pragma mark - View Will Appear

-(void)viewDidAppear:(BOOL)animated{
    scroll_mainScroll.contentSize=CGSizeMake(KTScreenWidth, view_mainBackGroundView.frame.origin.y+view_mainBackGroundView.frame.size.height);
}

#pragma mark - Account Type

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
    if (textField==txt_ifscCode) {
        [txt_ifscCode setClearsOnBeginEditing:YES];
        txt_address1.text=@"";
        txt_address2.text=@"";
        txt_bankName.text=@"";
    }
    else if (textField==txt_accountType) {
        if (arr_accountType.count>1) {
            [picker_dropDown selectRow:0 inComponent:0 animated:YES];
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
    if (textField==txt_ifscCode) {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
        if  ([resultingString rangeOfCharacterFromSet:whitespaceSet].location == NSNotFound){
            if (resultingString.length==11) {
                if ([[SharedUtility sharedInstance]validateIFSCCodeWithString:resultingString]==NO){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        txt_ifscCode.text=@"";
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a vaild IFSC Code"];
                    });
                }
                else{
                    [self fetchBankDetailsByIFSCCode:resultingString];
                    txt_ifscCode.text=resultingString;
                    [textField resignFirstResponder];
                }
            }
            else{
                return YES;
            }
        }
    }
    else if (textField==txt_accountNumber) {
        if (txt_accountNumber.text.length>15 && range.length == 0){
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
    if (txt_currentTxtField==txt_accountType){
        count=[arr_accountType count];
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
    if (txt_currentTxtField==txt_accountType){
        str_fundName=[NSString stringWithFormat:@"%@",arr_accountType[row][@"rm_relation"]];
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
    if (txt_currentTxtField==txt_accountType){
        txt_accountType.text=[NSString stringWithFormat:@"%@",arr_accountType[row][@"rm_relation"]];
    }
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - fetch Bank details by IFSC Code

-(void)fetchBankDetailsByIFSCCode:(NSString *)ifscCode{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ifsc =[XTAPP_DELEGATE convertToBase64StrForAGivenString:ifscCode];
    NSString *str_bankName=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_bankCity=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_bankBranch=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getBankdetailsByIFSC?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&IFSC=%@&BankName=%@&BankCity=%@&BankBranch=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_ifsc,str_bankName,str_bankCity,str_bankBranch];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
                NSDictionary *bankAddressRec=responce[@"DtData"][0];
                txt_address1.text=[NSString stringWithFormat:@"%@",bankAddressRec[@"BankAdd1"]];
                if (txt_address1.text.length==0) {
                    [txt_address1 setUserInteractionEnabled:YES];
                }
                else{
                    [txt_address1 setUserInteractionEnabled:NO];
                }
                txt_address2.text=[NSString stringWithFormat:@"%@",bankAddressRec[@"BankAdd3"]];
                if (txt_address2.text.length==0) {
                    [txt_address2 setUserInteractionEnabled:YES];
                }
                else{
                    [txt_address2 setUserInteractionEnabled:NO];
                }
                txt_bankName.text=[NSString stringWithFormat:@"%@",bankAddressRec[@"BankName"]];
                if (txt_bankName.text.length==0) {
                    [txt_bankName setUserInteractionEnabled:YES];
                }
                else{
                    [txt_bankName setUserInteractionEnabled:NO];
                }
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                txt_address1.text=@"";
                txt_address2.text=@"";
                txt_bankName.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - Add or Save Bank Details

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
    NSString *str_bankBranch=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_address1.text];
    str_bankBranch = [str_bankBranch stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *str_bankAccountNumber=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_accountNumber.text];
    NSString *str_bankAccountType=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[txt_accountType.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSString *str_bankAddress=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",txt_address2.text]];
    str_bankAddress = [str_bankAddress stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *str_bankSerialID=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@SaveBankDetails?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&PAN=%@&IFSC=%@&MICR=%@&BankName=%@&BranchName=%@&BankACNo=%@&Accounttype=%@&BankAdd=%@&Slno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_pan,str_ifsc,str_bankMicr,str_bankName,str_bankBranch,str_bankAccountNumber,str_bankAccountType,str_bankAddress,str_bankSerialID];
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

#pragma mark - upload balnck check image

- (IBAction)btn_uploadImage:(id)sender {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        [self showCameraActionSheet];
    }
    else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
            if(granted){
                [self showCameraActionSheet];
            }
            else{
                [self accessDenied];
            }
        }];
    }
}

#pragma mark - Move To Camera Access Denied By User

-(void)accessDenied{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
        [[SharedUtility sharedInstance]showAlertWithTitle:accessDescription forMessage:@"To give permissions tap on 'Change Settings' button" andAction1:@"Change Settings" andAction2:@"Cancel" andAction1Block:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } andCancelBlock:^{
            
        }];
    });
}

#pragma mark - show camera action sheet

-(void)showCameraActionSheet{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
            controller.allowsEditing = NO;
            controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            controller.delegate = self;
            [self.navigationController presentViewController:controller animated:YES completion: nil];
            
        }
        else{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Message" withMessage:@"No Camera Available"];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self.navigationController presentViewController:controller animated:YES completion: nil];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:NO completion:nil];    }]];
    [alertController setModalPresentationStyle:UIModalPresentationFormSheet];
    alertController.popoverPresentationController.sourceView=img_emptyCheckImage;
    alertController.popoverPresentationController.permittedArrowDirections=UIPopoverArrowDirectionDown;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    img_emptyCheckImage.image=image;
    [self callImageUpLoadAPI];
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - call Image Upload API

-(void)callImageUpLoadAPI{
    NSString *str_random=[NSString stringWithFormat:@"%d", [self getRandomNumberBetween:1000 to:900000]];
    NSData *imageData=UIImageJPEGRepresentation(img_emptyCheckImage.image, 1);
    NSDictionary *paramDic=@{@"Slno":str_random,@"ImgStr":[Base64 encode:imageData]};
    NSURL *url= [NSURL URLWithString:@"https://wfm.karvymfs.com/KTRACK/SmartService.svc/SaveImage"];
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
        }
        else{
        }
    }];
    [postDataTask resume];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

@end
