//
//  KnowYourTransactionVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 11/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "KnowYourTransactionVC.h"

@interface KnowYourTransactionVC ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    __weak IBOutlet UIButton *btn_transactDrop;
    __weak IBOutlet UIButton *btn_fundDrop;
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UITextField *txt_enterPAN;
    __weak IBOutlet UITextField *txt_folioApplicationNo;
    __weak IBOutlet UITextField *txt_transactionType;
    __weak IBOutlet UITextField *txt_fund;
    NSArray *arr_transactDetails, *arr_fundList, *arr_transactionType;
    UIPickerView *picker_dropDown;
    UITextField *txt_currentTextField;
    NSString *str_selectedFundID;
    NSString *str_transactID;
    __weak IBOutlet UITableView *tbl_transact;
}

@end

@implementation KnowYourTransactionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseViewDidLoadComponents];
    [self fetchFundsLISTAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialise the view

-(void)initialiseViewDidLoadComponents{
    [UITextField withoutRoundedCornerTextField:txt_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_transactionType forCornerRadius:5.0f forBorderWidth:1.5f];
    [txt_folioApplicationNo setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_enterPAN setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [tbl_transact setHidden:YES];
    tbl_transact.estimatedRowHeight=20.0f;
    txt_enterPAN.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    txt_transactionType.inputView=picker_dropDown;
 arr_transactionType=@[@{@"Type":@"Purchase",@"ID":@"PUR"},@{@"Type":@"Redemption",@"ID":@"RED"},@{@"Type":@"Switch",@"ID":@"SWI"}];
    str_selectedFundID=@"";
    str_transactID=@"";
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
     txt_currentTextField=textField;
     if ([[APIManager sharedManager]hasInternetConnection]==NO) {
         [textField resignFirstResponder];
     }
     else{
        if (textField==txt_fund) {
            [picker_dropDown reloadAllComponents];
            [picker_dropDown selectRow:0 inComponent:0 animated:YES];
            txt_fund.text=[NSString stringWithFormat:@"%@",arr_fundList[0][@"Fund_Name"]];
            str_selectedFundID=[NSString stringWithFormat:@"%@",arr_fundList[0][@"Fund_id"]];
        }
        else if (textField==txt_transactionType) {
            [picker_dropDown reloadAllComponents];
            [picker_dropDown selectRow:0 inComponent:0 animated:YES];
            txt_transactionType.text=[NSString stringWithFormat:@"%@",arr_transactionType[0][@"Type"]];
            str_transactID=[NSString stringWithFormat:@"%@",arr_transactionType[0][@"ID"]];
        }
        [textField becomeFirstResponder];
     }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (txt_currentTextField == txt_enterPAN){
        txt_enterPAN.text=[NSString stringWithFormat:@"%@",txt_enterPAN.text].uppercaseString;
    }

    [textField resignFirstResponder];
}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==txt_enterPAN) {
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
    else if (textField==txt_folioApplicationNo) {
        if (txt_folioApplicationNo.text.length>=15 && range.length == 0){
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
#pragma mark - TextFields Delegate Methods Ends

#pragma mark - TouchEvents

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    END_EDITING;
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - TableView Delegate and Data Source delegate starts

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arr_transactDetails.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KnowYourTransactionDetailsTblCell *cell=(KnowYourTransactionDetailsTblCell*)[tableView dequeueReusableCellWithIdentifier:KTKYTDetailsCell];
    if (cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KnowYourTransactionDetailsTblCell" owner:self options:nil];
        cell = (KnowYourTransactionDetailsTblCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [self configureDataForCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, 0, tableView.frame.size.width,5)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width,5)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

#pragma mark - TableView Delegate and Data Source delegate ends

#pragma mark - Configure Data In Cell

-(void)configureDataForCell:(KnowYourTransactionDetailsTblCell*)cell atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic_branchRec=arr_transactDetails[indexPath.section];
    cell.lbl_typeFund.text=[NSString stringWithFormat:@"%@",dic_branchRec[@"Scheme Desc"]];
    cell.lbl_dateOfPurchase.text=[NSString stringWithFormat:@"%@",dic_branchRec[@"Transaction Date"]];
    cell.lbl_volumeCost.text=[NSString stringWithFormat:@"-   %@",dic_branchRec[@"Price Applied"]];
    cell.lbl_transactStatusMSg.text=[NSString stringWithFormat:@"-   %@",dic_branchRec[@"Transaction Status"]];
    cell.lbl_transactType.text=[NSString stringWithFormat:@"-   %@",dic_branchRec[@"Trtype"]];
}

#pragma mark - Button Actions

- (IBAction)btn_sumbitTapped:(UIButton *)sender {
    END_EDITING;
    NSString *str_panStr=txt_enterPAN.text;
    txt_enterPAN.text=str_panStr.uppercaseString;
    if (txt_transactionType.text.length!=0 && txt_fund.text.length!=0 && txt_folioApplicationNo.text.length!=0 && txt_enterPAN.text.length!=0) {
        NSString *panRegex =  @"[A-Z]{3}P[A-Z]{1}[0-9]{4}[A-Z]{1}";
        NSPredicate *panPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", panRegex];
        if ([panPredicate evaluateWithObject:txt_enterPAN.text] == NO){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_enterPAN becomeFirstResponder];
                txt_enterPAN.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter correct PAN No"];
            });
        }
        else{
            [self knowYourTransactionDetailsAPI];
        }
    }
    else{
        if (txt_fund.text.length==0) {
            [txt_fund becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
            });
        }
        else if (txt_transactionType.text.length==0) {
            [txt_transactionType becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select transaction type."];
            });
        }
        else  if (txt_folioApplicationNo.text.length==0) {
            [txt_folioApplicationNo becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter Folio or Application No."];
            });
        }
        else  if ([[SharedUtility sharedInstance]validateOnlyIntegerValue:txt_folioApplicationNo.text]==NO) {
            [txt_folioApplicationNo becomeFirstResponder];
            txt_folioApplicationNo.text=@"";
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter a valid Folio or Application No."];
            });
        }
        else  if (txt_enterPAN.text.length==0) {
            [txt_enterPAN becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter PAN No."];
            });
        }
        
    }
}

#pragma mark - KYT Details Based on PAN AND Folio NO

-(void)knowYourTransactionDetailsAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fundID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_transID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_transactID];
    NSString *str_folioID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_folioApplicationNo.text];
    NSString *str_panID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_enterPAN.text];
    NSString *str_url = [NSString stringWithFormat:@"%@GetTransactionDetails?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&TransactionType=%@&Folio=%@&Pan=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fundID,str_transID,str_folioID,str_panID];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {
            arr_transactDetails=responce[@"DtData"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                if (arr_transactDetails.count==0) {
                   [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No Data Found"];
                }
                else{
                    KnowYourTransctionDetailsVC *destination=[self.storyboard instantiateViewControllerWithIdentifier:@"KnowYourTransctionDetailsVC"];
                    destination.arr_transactRecords=arr_transactDetails;
                    [self.navigationController pushViewController:destination animated:YES];
                }
            });
        }
        else{
            [tbl_transact setHidden:YES];
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - funds list API

-(void)fetchFundsLISTAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_url = [NSString stringWithFormat:@"%@GetActiveFunds?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
                arr_fundList=responce[@"DtData"];
                txt_fund.inputView=picker_dropDown;
                [picker_dropDown reloadAllComponents];
            }
            else{
                [tbl_transact setHidden:NO];
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
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
    long int count=0;
    if (txt_currentTextField==txt_fund) {
        count=arr_fundList.count;
    }
    else if (txt_currentTextField==txt_transactionType){
        count=arr_transactionType.count;
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
    if (txt_currentTextField == txt_fund) {
        str_fundName=[NSString stringWithFormat:@"%@",arr_fundList[row][@"Fund_Name"]];
    }
    else if (txt_currentTextField == txt_transactionType){
        str_fundName=[NSString stringWithFormat:@"%@",arr_transactionType[row][@"Type"]];
    }
    lbl_title.text= str_fundName;
    lbl_title.textAlignment=NSTextAlignmentCenter;
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.font=KTFontFamilySize(KTOpenSansRegular, 12);
    lbl_title.numberOfLines=3;
    [pickerLabel addSubview:lbl_title];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    if (txt_currentTextField == txt_fund) {
        txt_fund.text=[NSString stringWithFormat:@"%@",arr_fundList[row][@"Fund_Name"]];
        str_selectedFundID=[NSString stringWithFormat:@"%@",arr_fundList[row][@"Fund_id"]];
    }
    else if (txt_currentTextField == txt_transactionType){
        txt_transactionType.text=[NSString stringWithFormat:@"%@",arr_transactionType[row][@"Type"]];
        str_transactID=[NSString stringWithFormat:@"%@",arr_transactionType[row][@"ID"]];
    }
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

- (IBAction)backAct:(UIButton *)sender {
    KTPOP(YES);
}

@end

