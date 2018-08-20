//
//  CancelSystematicTransactVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 01/08/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "CancelSystematicTransactVC.h"

@interface CancelSystematicTransactVC ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    __weak IBOutlet UILabel *lbl_errorMessage;
    __weak IBOutlet UITableView *tbl_cancelSystematic;
    __weak IBOutlet UITextField *txt_folio;
    __weak IBOutlet UITextField *txt_fund;
    __weak IBOutlet UITextField *txt_name;
    NSArray *arr_familyPanRec,*arr_fundList,*arr_transactType;
    NSString *selectedFundID, *selectedTransactType, *selectedPan, *investorName;
    UIPickerView *picker_dropDown;
    UITextField *txt_currentTextField;
    NSArray *arr_cancellationRecords;
}
@end

@implementation CancelSystematicTransactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseViewOnLoad];
    tbl_cancelSystematic.estimatedRowHeight=20.0f;
    [lbl_errorMessage setHidden:YES];
    [tbl_cancelSystematic setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialise On View Load

-(void)initialiseViewOnLoad{
    arr_transactType=@[@{@"TypeID":@"SIP"},@{@"TypeID":@"SWP"},@{@"TypeID":@"STP"}];
    [txt_fund addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_folio addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_name addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [UITextField withoutRoundedCornerTextField:txt_name forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_folio forCornerRadius:5.0f forBorderWidth:1.5f];
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
        KT_TABLE12 *rec_primaryPan=arr_familyPanRec[0];
        selectedPan=[NSString stringWithFormat:@"%@",rec_primaryPan.PAN];
        investorName=[NSString stringWithFormat:@"%@",rec_primaryPan.invName];
        txt_name.text=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",rec_primaryPan.invName]];
        if (arr_familyPanRec.count>1) {
            txt_name.inputView=picker_dropDown;
            [txt_name setUserInteractionEnabled:YES];
        }
        else{
            [txt_name setUserInteractionEnabled:NO];
        }
    }
    txt_folio.text=[NSString stringWithFormat:@"%@",arr_transactType[0][@"TypeID"]];
    selectedTransactType=[NSString stringWithFormat:@"%@",arr_transactType[0][@"TypeID"]];
    txt_folio.inputView=picker_dropDown;
    [self fetchGetFundListFromAPIForPAN:selectedPan forTransferType:selectedTransactType];
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTextField=textField;
    if (textField==txt_name) {
        txt_fund.text=@"";
        if (arr_familyPanRec.count>1) {
            [picker_dropDown reloadAllComponents];
        }
        [textField becomeFirstResponder];
    }
    else if (textField==txt_folio) {
        if (txt_name.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_folio resignFirstResponder];
                [txt_name becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select a member."];
            });
        }
        else{
            [picker_dropDown reloadAllComponents];
            [textField becomeFirstResponder];
        }
    }
    else if (textField==txt_fund) {
        if (txt_name.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_fund resignFirstResponder];
                [txt_name becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select a member."];
            });
        }
        else if (txt_folio.text.length==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [txt_folio resignFirstResponder];
                [txt_fund becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select transact type."];
            });
        }
        else{
            if (arr_fundList.count>1) {
                [picker_dropDown reloadAllComponents];
            }
            [textField becomeFirstResponder];
        }
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==txt_name){
        [self fetchGetFundListFromAPIForPAN:selectedPan forTransferType:selectedTransactType];
    }
    else if (textField==txt_folio){
        [self fetchGetFundListFromAPIForPAN:selectedPan forTransferType:selectedTransactType];
    }
    else if (textField==txt_fund){
        if (txt_folio.text.length>0 && txt_fund.text.length>0 && txt_name.text.length>0) {
            [self fetchCancellationRecordForPAN:selectedPan forTransferType:selectedTransactType forSelectedFund:selectedFundID];
        }
    }
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
    if (txt_currentTextField==txt_name){
        count=[arr_familyPanRec count];
    }
    else if (txt_currentTextField==txt_fund){
        count=[arr_fundList count];
    }
    else if (txt_currentTextField==txt_folio){
        count=[arr_transactType count];
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
    if (txt_currentTextField==txt_name){
        KT_TABLE12 *fundRec=arr_familyPanRec[row];
        str_fundName=[NSString stringWithFormat:@"%@ - %@",[NSString stringWithFormat:@"%@",fundRec.invName],[NSString stringWithFormat:@"%@",fundRec.PAN]];
    }
    else if (txt_currentTextField==txt_fund){
        str_fundName=[NSString stringWithFormat:@"%@",arr_fundList[row][@"amc_name"]];
    }
    else if (txt_currentTextField==txt_folio){
        str_fundName=[NSString stringWithFormat:@"%@",arr_transactType[row][@"TypeID"]];
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
    if (txt_currentTextField==txt_name){
        KT_TABLE12 *fundRec=arr_familyPanRec[row];
        txt_name.text=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",fundRec.invName]];
        selectedPan=[NSString stringWithFormat:@"%@",fundRec.PAN];
        investorName=[NSString stringWithFormat:@"%@",fundRec.invName];
    }
    else if (txt_currentTextField==txt_fund){
        txt_fund.text=[NSString stringWithFormat:@"%@",arr_fundList[row][@"amc_name"]];
        selectedFundID=[NSString stringWithFormat:@"%@",arr_fundList[row][@"amc_code"]];
    }
    else if (txt_currentTextField==txt_folio){
        txt_folio.text=[NSString stringWithFormat:@"%@",arr_transactType[row][@"TypeID"]];
        selectedTransactType=[NSString stringWithFormat:@"%@",arr_transactType[row][@"TypeID"]];
    }
    
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - TableView Delegate and Data Source delegate starts

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arr_cancellationRecords.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectedTransactType isEqualToString:@"STP"] || [selectedTransactType isEqual:@"STP"]){
        CancelSTPTblCell *cell=(CancelSTPTblCell*)[tableView dequeueReusableCellWithIdentifier:@"CancelSTP"];
        if (cell==nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CancelSTPTblCell" owner:self options:nil];
            cell = (CancelSTPTblCell *)[nib objectAtIndex:0];
            [tableView setSeparatorColor:[UIColor blackColor]];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.contentView.layer.cornerRadius=5.0f;
        }
        NSDictionary *dic=arr_cancellationRecords[indexPath.section];
        cell.lbl_folioNumber.text=[NSString stringWithFormat:@"%@",dic[@"acno"]];
        cell.lbl_registrationDate.text=[NSString stringWithFormat:@"%@",dic[@"trdate"]];
        cell.lbl_switchOutScheme.text=[NSString stringWithFormat:@"%@",dic[@"switchout"]];
        cell.lbl_switchInScheme.text=[NSString stringWithFormat:@"%@",dic[@"switchin"]];
        cell.lbl_fromDate.text=[NSString stringWithFormat:@"%@",dic[@"fromdate"]];
        cell.lbl_toDate.text=[NSString stringWithFormat:@"%@",dic[@"todate"]];
        cell.lbl_frequency.text=[NSString stringWithFormat:@"%@",dic[@"freq"]];
        cell.lbl_amount.text=[NSString stringWithFormat:@"%@",dic[@"amt"]];
        [cell.btn_delete addTarget:self action:@selector(STPDeleteRecordTapped:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        CancelSIPSWPTblCell *cell=(CancelSIPSWPTblCell*)[tableView dequeueReusableCellWithIdentifier:@"CancelSIPSWP"];
        if (cell==nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CancelSIPSWPTblCell" owner:self options:nil];
            cell = (CancelSIPSWPTblCell *)[nib objectAtIndex:0];
            [tableView setSeparatorColor:[UIColor blackColor]];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.contentView.layer.cornerRadius=5.0f;
        }
        NSDictionary *dic=arr_cancellationRecords[indexPath.section];
        cell.lbl_folio.text=[NSString stringWithFormat:@"%@",dic[@"acno"]];
        cell.lbl_registrationDate.text=[NSString stringWithFormat:@"%@",dic[@"trdate"]];
        cell.lbl_scheme.text=[NSString stringWithFormat:@"%@",dic[@"Scheme"]];
        cell.lbl_fromDate.text=[NSString stringWithFormat:@"%@",dic[@"fromdate"]];
        cell.lbl_toDate.text=[NSString stringWithFormat:@"%@",dic[@"todate"]];
        cell.lbl_frequency.text=[NSString stringWithFormat:@"%@",dic[@"freq"]];
        cell.lbl_amount.text=[NSString stringWithFormat:@"%@",dic[@"amt"]];
        [cell.btn_cancel addTarget:self action:@selector(SIPSWPDeleteRecordTapped:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width,5)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width,5)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Cell Delete Button Tapped Action

-(void)SIPSWPDeleteRecordTapped:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_cancelSystematic];
    NSIndexPath *indexPath = [tbl_cancelSystematic indexPathForRowAtPoint:buttonPosition];
    if (indexPath!=nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic=arr_cancellationRecords[indexPath.section];
            [[SharedUtility sharedInstance]showAlertWithTitle:@"Information" forMessage:[NSString stringWithFormat:@"Are you sure that want to delete %@ transaction for selected Folio\n%@ ?",selectedTransactType,[NSString stringWithFormat:@"%@",dic[@"acno"]]] andAction1:@"YES" andAction2:@"NO" andAction1Block:^{
                CancelSTConfirmationVC *destinationVC=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"CancelSTConfirmationVC"];
                destinationVC.dic_cancellationRecord=dic;
                destinationVC.str_selectedPAN=selectedPan;
                destinationVC.str_investorName=investorName;
                destinationVC.str_showSTP=@"NO";
                destinationVC.str_fromScreen=txt_fund.text;
                KTPUSH(destinationVC,YES);
            } andCancelBlock:^{
                
            }];
        });
    }
}

-(void)STPDeleteRecordTapped:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_cancelSystematic];
    NSIndexPath *indexPath = [tbl_cancelSystematic indexPathForRowAtPoint:buttonPosition];
    if (indexPath!=nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic=arr_cancellationRecords[indexPath.section];
            [[SharedUtility sharedInstance]showAlertWithTitle:@"Information" forMessage:[NSString stringWithFormat:@"Are you sure that want to delete %@ transaction for selected Folio\n%@ ?",selectedTransactType,[NSString stringWithFormat:@"%@",dic[@"acno"]]] andAction1:@"YES" andAction2:@"NO" andAction1Block:^{
                CancelSTConfirmationVC *destinationVC=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"CancelSTConfirmationVC"];
                destinationVC.dic_cancellationRecord=dic;
                destinationVC.str_selectedPAN=selectedPan;
                destinationVC.str_investorName=investorName;
                destinationVC.str_showSTP=@"YES";
                destinationVC.str_fromScreen=txt_fund.text;
                KTPUSH(destinationVC,YES);
            } andCancelBlock:^{
                
            }];
        });
    }
}

#pragma mark - Fund Details Based ON PAN and Selected Transfer Type

-(void)fetchGetFundListFromAPIForPAN:(NSString *)str_selectedPan forTransferType:(NSString *)str_selectedTransactionType{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"CF"];
    NSString *str_planType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedTransactionType];
    NSString *str_schemeType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedPan];
    NSString *str_fundCode=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fundCode,str_schemeType,str_planType];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            arr_fundList=responce[@"Dtinformation"];
            if (arr_fundList.count>0){
                txt_fund.text=[NSString stringWithFormat:@"%@",arr_fundList[0][@"amc_name"]];
                selectedFundID=[NSString stringWithFormat:@"%@",arr_fundList[0][@"amc_code"]];
                if (arr_fundList.count>1) {
                    [txt_fund setUserInteractionEnabled:YES];
                    txt_fund.inputView=picker_dropDown;
                }
                else{
                    [txt_fund setUserInteractionEnabled:NO];
                }
                [self fetchCancellationRecordForPAN:selectedPan forTransferType:selectedTransactType forSelectedFund:selectedFundID];
            }
            else{
                txt_fund.text=@"";
                [txt_fund setUserInteractionEnabled:NO];
                [lbl_errorMessage setHidden:NO];
                [tbl_cancelSystematic setHidden:YES];
                lbl_errorMessage.text=[NSString stringWithFormat:@"Currently you do not have any active %@ Registrations",str_selectedTransactionType];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - Fetch Cancellation Record based on fund, transact type and

-(void)fetchCancellationRecordForPAN:(NSString *)str_selectedPan forTransferType:(NSString *)str_selectedTransactionType forSelectedFund:(NSString *)str_selectedFund{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_encodeTransactionType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedTransactionType];
    NSString *str_encodePAN =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedPan];
    NSString *str_fundCode=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFund];
    NSString *str_url = [NSString stringWithFormat:@"%@GetFoliosForSIPCancelation?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Pan=%@&Trtype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fundCode,str_encodePAN,str_encodeTransactionType];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
            if (error_statuscode==0) {
                arr_cancellationRecords=responce[@"DtData"];
                [tbl_cancelSystematic setHidden:NO];
                [lbl_errorMessage setHidden:YES];
                [tbl_cancelSystematic reloadData];
            }
            else{
                [tbl_cancelSystematic setHidden:YES];
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:KTError forMessage:error_message andAction1:@"Ok" andAction1Block:^{
                     [lbl_errorMessage setHidden:NO];
                }];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Back Tapped

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

@end
