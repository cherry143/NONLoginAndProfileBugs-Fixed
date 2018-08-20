//
//  TransactionHistorVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 15/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "TransactionHistorVC.h"

@interface TransactionHistorVC ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    __weak IBOutlet UIScrollView *scroll_mainScroll;
    __weak IBOutlet UILabel *lbl_msgDisplay;
    __weak IBOutlet UITextField *txt_fund;
    __weak IBOutlet UITableView *tbl_trasactionHistory;
    __weak IBOutlet UITableView *tbl_transactDate;
    NSArray *arr_transactHistoryRecords,*arr_fundsRec;
    UIPickerView *picker_dropDown;
    NSString *str_myPANRec,*str_fundID;
}

@end

@implementation TransactionHistorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseOnViewLoad];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"TransactionHistory"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ViewLoad

-(void)initialiseOnViewLoad{
    [UITextField withoutRoundedCornerTextField:txt_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    lbl_msgDisplay.text=@"Last 10 transactions.\n\nNote: Units/Amount for pending transactions will be updated post transaction processing (Swipe left in the table below for more details).";
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    NSArray *arr_primaryPan = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='%@'",@"P"]];
    if (arr_primaryPan.count>0) {
        KT_TABLE12 *rec_primaryPan=arr_primaryPan[0];
        str_myPANRec=rec_primaryPan.PAN;
    }
    else{
        str_myPANRec=@"";
    }
    arr_fundsRec = [[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT(fundDesc),fund FROM TABLE2_DETAILS WHERE PAN='%@' ORDER BY fundDesc",str_myPANRec]];
    if (arr_fundsRec.count>0) {
        KT_Table2RawQuery *pan_rec=arr_fundsRec[0];
        txt_fund.text=[NSString stringWithFormat:@"%@",pan_rec.fundDesc];
        str_fundID=[NSString stringWithFormat:@"%@",pan_rec.fund];
    }
    [self transactionHistoryDetailsAPIForFund:str_fundID];
}

#pragma mark - UITableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_transactHistoryRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tbl_transactDate) {
        KYTDateCell *cell = [[KYTDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KYTDateCell"];
        if (cell!=nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KYTDateCell" owner:self options:nil];
            cell = (KYTDateCell *)[nib objectAtIndex:0];
            [tableView setSeparatorColor:[UIColor blackColor]];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor=[UIColor whiteColor];
        }
        NSDictionary *dic=arr_transactHistoryRecords[indexPath.row];
        cell.lbl_date.textColor  =[UIColor  blackColor];
        cell.lbl_date.text=[NSString stringWithFormat:@"%@",dic[@"td_trdt"]];
        cell.lbl_date.font=KTFontFamilySize(KTOpenSansRegular,12);
        return cell;
    }
    else if (tableView == tbl_trasactionHistory){
        TransactionHistoryTblCell *cell = [[TransactionHistoryTblCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TransactHistory"];
        if (cell!=nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TransactionHistoryTblCell" owner:self options:nil];
            cell = (TransactionHistoryTblCell *)[nib objectAtIndex:0];
            [tableView setSeparatorColor:[UIColor blackColor]];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor=[UIColor whiteColor];
        }
        NSDictionary *dic=arr_transactHistoryRecords[indexPath.row];
        cell.lbl_transactType.text=[NSString stringWithFormat:@"%@",dic[@"TrtypeDesc"]];
        cell.lbl_schemeName.text=[NSString stringWithFormat:@"%@",dic[@"SchemeDesc"]];
        NSString *str_Transstatus=[NSString stringWithFormat:@"%@",dic[@"Status"]];
        if ([str_Transstatus caseInsensitiveCompare:@"Rejected"]==NSOrderedSame || [str_Transstatus caseInsensitiveCompare:@"Pre Rejected"]==NSOrderedSame ) {
            [cell.lbl_status setAttributedTitle:[UIButton underlineForButton:str_Transstatus forAttributedColor:[UIColor colorWithHexString:@"#ee1a26"]] forState:UIControlStateNormal];
            [cell.lbl_status addTarget:self action:@selector(btn_statusTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [cell.lbl_status setTitle:str_Transstatus forState:UIControlStateNormal];
            [cell.lbl_status setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        cell.lbl_amount.text=[NSString stringWithFormat:@"%.2f",[dic[@"td_amt"]floatValue]];
        cell.lbl_folioNumber.text=[NSString stringWithFormat:@"%@",dic[@"td_acno"]];
        cell.lbl_lastNav.text=[NSString stringWithFormat:@"%@",dic[@"td_nav"]];
        cell.lbl_units.text=[NSString stringWithFormat:@"%@",dic[@"td_units"]];
        cell.lbl_transactType.font=KTFontFamilySize(KTOpenSansRegular,12);
        cell.lbl_schemeName.font=KTFontFamilySize(KTOpenSansRegular,12);
        cell.lbl_status.titleLabel.font=KTFontFamilySize(KTOpenSansRegular,12);
        cell.lbl_amount.font=KTFontFamilySize(KTOpenSansRegular,12);
        cell.lbl_folioNumber.font=KTFontFamilySize(KTOpenSansRegular,12);
        cell.lbl_lastNav.font=KTFontFamilySize(KTOpenSansRegular,12);
        cell.lbl_units.font=KTFontFamilySize(KTOpenSansRegular,12);
        return cell;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == tbl_transactDate) {
        KYTDateCell *headerView=(KYTDateCell*)[tableView dequeueReusableCellWithIdentifier:@"KYTDateCell"];
        if (headerView==nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KYTDateCell" owner:self options:nil];
            headerView = (KYTDateCell *)[nib objectAtIndex:0];
            headerView.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        headerView.contentView.backgroundColor=KTTableHeaderColor;
        [headerView.lbl_date setTextColor:KTButtonBackGroundBlue];
        headerView.lbl_date.text=@"Date";
        headerView.lbl_date.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        return headerView;
    }
    if (tableView == tbl_trasactionHistory) {
        TransactionHistoryTblCell *headerView=(TransactionHistoryTblCell*)[tableView dequeueReusableCellWithIdentifier:@"TransactHistory"];
        if (headerView==nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TransactionHistoryTblCell" owner:self options:nil];
            headerView = (TransactionHistoryTblCell *)[nib objectAtIndex:0];
            headerView.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        headerView.contentView.backgroundColor=KTTableHeaderColor;
        headerView.lbl_transactType.text=@"Trans Type";
        headerView.lbl_schemeName.text=@"Scheme";
        [headerView.lbl_status setTitle:@"Status" forState:UIControlStateNormal];
        headerView.lbl_amount.text=@"Amount";
        headerView.lbl_folioNumber.text=@"Folio";
        headerView.lbl_lastNav.text=@"NAV";
        headerView.lbl_units.text=@"Units";
        headerView.lbl_transactType.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        headerView.lbl_schemeName.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        headerView.lbl_status.titleLabel.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        headerView.lbl_amount.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        headerView.lbl_folioNumber.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        headerView.lbl_lastNav.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        headerView.lbl_units.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        [headerView.lbl_status setTitleColor:KTButtonBackGroundBlue forState:UIControlStateNormal];
        [headerView.lbl_units setTextColor:KTButtonBackGroundBlue];
        [headerView.lbl_transactType setTextColor:KTButtonBackGroundBlue];
        [headerView.lbl_schemeName setTextColor:KTButtonBackGroundBlue];
        [headerView.lbl_amount setTextColor:KTButtonBackGroundBlue];
        [headerView.lbl_folioNumber setTextColor:KTButtonBackGroundBlue];
        [headerView.lbl_lastNav setTextColor:KTButtonBackGroundBlue];
        return headerView;
    }
    return nil;
    
}

-(void)btn_statusTapped:(UIButton *)sender{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tbl_trasactionHistory];
    NSIndexPath *indexPath = [tbl_trasactionHistory indexPathForRowAtPoint:touchPoint];
    NSLog(@"Index %@",indexPath);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Remarks" withMessage:@"Min. amount condition fail for Out transaction. Min amt. is 1000.0"];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}


#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == tbl_transactDate) {
        CGFloat offsetY= tbl_transactDate.contentOffset.y;
        CGPoint itemOffsetY=tbl_trasactionHistory.contentOffset;
        itemOffsetY.y=offsetY;
        tbl_trasactionHistory.contentOffset=itemOffsetY;
        if(offsetY==0){
            tbl_trasactionHistory.contentOffset=CGPointZero;
        }
    }
    else{
        CGFloat offsetY= tbl_trasactionHistory.contentOffset.y;
        CGPoint itemOffsetY=tbl_transactDate.contentOffset;
        itemOffsetY.y=offsetY;
        tbl_transactDate.contentOffset=itemOffsetY;
        if(offsetY==0){
            tbl_transactDate.contentOffset=CGPointZero;
        }
    }
}


#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return arr_fundsRec.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *pickerLabel;
    CGRect frame = CGRectMake(5.0, 0.0,self.view.frame.size.width-10,40);
    pickerLabel = [[UILabel alloc] initWithFrame:frame];
    UILabel *lbl_title=[[UILabel alloc]init];
    lbl_title.frame=frame;
    NSString *str_fundName;
    KT_Table2RawQuery *pan_rec=arr_fundsRec[row];
    str_fundName=[NSString stringWithFormat:@"%@",pan_rec.fundDesc];
    lbl_title.text= str_fundName;
    lbl_title.textAlignment=NSTextAlignmentCenter;
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.font=KTFontFamilySize(KTOpenSansRegular, 12);
    lbl_title.numberOfLines=3;
    [pickerLabel addSubview:lbl_title];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    KT_Table2RawQuery *pan_rec=arr_fundsRec[row];
    txt_fund.text=[NSString stringWithFormat:@"%@",pan_rec.fundDesc];
    str_fundID=[NSString stringWithFormat:@"%@",pan_rec.fund];
    [self transactionHistoryDetailsAPIForFund:str_fundID];
    [txt_fund resignFirstResponder];
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==txt_fund) {
        if (arr_fundsRec.count>1) {
            [textField becomeFirstResponder];
            [picker_dropDown reloadAllComponents];
            txt_fund.inputView=picker_dropDown;
        }
        else{
            txt_fund.text=@"";
            [txt_fund setUserInteractionEnabled:NO];
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

#pragma mark - Transaction History API

-(void)transactionHistoryDetailsAPIForFund:(NSString *)fund{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_serverFundID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:fund];
    NSString *str_url = [NSString stringWithFormat:@"%@GetTrxnDatabyFund?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Uid=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_serverFundID,str_userId];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Table"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {
            arr_transactHistoryRecords=responce[@"Table1"];
            if (arr_transactHistoryRecords.count==0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No Data Found"];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    [tbl_transactDate reloadData];
                    [tbl_trasactionHistory reloadData];
                });
            }
        }
        else{
            [scroll_mainScroll setHidden:YES];
            [tbl_transactDate setHidden:YES];
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Back Button Tapped

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

@end
