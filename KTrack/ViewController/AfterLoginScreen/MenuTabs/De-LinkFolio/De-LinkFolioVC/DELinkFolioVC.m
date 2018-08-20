//
//  DELinkFolioVC.m
//  
//
//  Created by mnarasimha murthy on 11/05/18.
//

#import "DELinkFolioVC.h"

@interface DELinkFolioVC ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    __weak IBOutlet UIButton *btn_delink;
    __weak IBOutlet UITableView *tbl_deLinkFolio;
    __weak IBOutlet UITextField *txt_fundName;
    __weak IBOutlet UITextField *txt_familyMember;
    NSArray *arr_funds,*arr_folioList,*arr_familyMem;
    NSString *str_selectedPan,*str_selectedFundId;
    UITextField *txt_currentTextField;
    UIPickerView *picker_dropDown;
    NSMutableArray *arr_checkUncheckRec;
    NSMutableArray *arr_folioNumberRec;
}

@end

@implementation DELinkFolioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self InitialiseOnViewLoad];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"DeLinkFolio"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitialiseOnViewLoad

-(void)InitialiseOnViewLoad{
    [txt_fundName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [txt_familyMember setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [UITextField withoutRoundedCornerTextField:txt_fundName forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_familyMember forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIButton roundedCornerButtonWithoutBackground:btn_delink forCornerRadius:KTiPad?25.0f:btn_delink.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    arr_familyMem=[[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE Not flag='P'"]];
    str_selectedFundId=@"";
    if (arr_familyMem.count==0) {
        
    }
    else if (arr_familyMem.count==1){
        [txt_familyMember setUserInteractionEnabled:NO];
        KT_TABLE12 *pan_rec=arr_familyMem[0];
        NSString *familyMem=[NSString stringWithFormat:@"%@",pan_rec.invName];
        str_selectedPan=[NSString stringWithFormat:@"%@",pan_rec.PAN];
        txt_familyMember.text=familyMem;
        [self fundDropDownRecordArr:[[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT(fundDesc), fund FROM TABLE2_DETAILS WHERE PAN='%@'",str_selectedPan]]];
    }
    else{
        [txt_familyMember setUserInteractionEnabled:YES];
        txt_familyMember.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }
}

#pragma mark - loadFundArray

-(void)fundDropDownRecordArr:(NSArray *)fundRecArr{
    arr_funds=fundRecArr;
    if (arr_funds.count==0) {
        
    }
    else if (arr_funds.count==1){
        KT_Table2RawQuery *pan_rec=arr_funds[0];
        NSString *fundName=[NSString stringWithFormat:@"%@",pan_rec.fundDesc];
        txt_fundName.text=fundName;
        str_selectedFundId=[NSString stringWithFormat:@"%@",pan_rec.fund];
        [self fetchFolioRecordsBasedOnFundPanForPan:str_selectedPan forFundId:str_selectedFundId];
    }
    else{
        txt_fundName.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }
}

#pragma mark - TableView Delegate and Data Source delegate starts

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_folioList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DELinkTblCell *cell=(DELinkTblCell*)[tableView dequeueReusableCellWithIdentifier:@"DELinkCell"];
    if (cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DELinkTblCell" owner:self options:nil];
        cell = (DELinkTblCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    KT_TABLE2 *folio_rec=arr_folioList[indexPath.row];
    cell.lbl_folioNo.text=[NSString stringWithFormat:@"%@",folio_rec.fund];
    if([[arr_checkUncheckRec objectAtIndex:indexPath.row] isEqualToString:@"Uncheck"]){
       [cell.btn_radio setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    }else{
        [cell.btn_radio setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    }
    [cell.btn_radio addTarget:self action:@selector(radioBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width,0)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DELinkHeaderTblCell *headerView=(DELinkHeaderTblCell*)[tableView dequeueReusableCellWithIdentifier:@"DelinkHeader"];
    if (headerView==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DELinkHeaderTblCell" owner:self options:nil];
        headerView = (DELinkHeaderTblCell *)[nib objectAtIndex:0];
        headerView.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [headerView.btn_cancel addTarget:self action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.btn_selectAll addTarget:self action:@selector(selectAllTapped:) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}

#pragma mark - TableView Button Action

-(void)cancelTapped:(UIButton *)sender{
    arr_checkUncheckRec=[NSMutableArray new];
    arr_folioNumberRec=[NSMutableArray new];
    for (int i=0; i<arr_folioList.count; i++) {
        [arr_checkUncheckRec addObject:@"Uncheck"];
    }
    [tbl_deLinkFolio reloadData];
}

-(void)selectAllTapped:(UIButton *)sender{
    arr_checkUncheckRec=[NSMutableArray new];
    arr_folioNumberRec=[NSMutableArray new];
    for (int i=0; i<arr_folioList.count; i++) {
        KT_TABLE2 *folioRec=arr_folioList[i];
        [arr_folioNumberRec addObject:[NSString stringWithFormat:@"%@",folioRec.fund]];
        [arr_checkUncheckRec addObject:@"Check"];
    }
    [tbl_deLinkFolio reloadData];
}

-(void)radioBtnTapped:(UIButton*)sender{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tbl_deLinkFolio];
    NSIndexPath *indexPath = [tbl_deLinkFolio indexPathForRowAtPoint:touchPoint];
    if([[arr_checkUncheckRec objectAtIndex:indexPath.row] isEqualToString:@"Uncheck"]){
        [sender setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [arr_checkUncheckRec replaceObjectAtIndex:indexPath.row withObject:@"Check"];
        KT_TABLE2 *folioRec=arr_folioList[indexPath.row];
        [arr_folioNumberRec addObject:[NSString stringWithFormat:@"%@",folioRec.fund]];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        [arr_checkUncheckRec replaceObjectAtIndex:indexPath.row withObject:@"Uncheck"];
        KT_TABLE2 *folioRec=arr_folioList[indexPath.row];
        [arr_folioNumberRec removeObject:[NSString stringWithFormat:@"%@",folioRec.fund]];
    }
}

#pragma mark - TableView Delegate and Data Source delegate ends

#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    long int count;
    if (txt_currentTextField==txt_familyMember) {
        count=arr_familyMem.count;
    }
    else if (txt_currentTextField==txt_fundName) {
        count=arr_funds.count;
    }
    else{
        count=0;
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
    if (txt_currentTextField==txt_familyMember) {
        KT_TABLE12 *pan_rec=arr_familyMem[row];
        str_fundName=[NSString stringWithFormat:@"%@",pan_rec.invName];
    }
    else if (txt_currentTextField==txt_fundName) {
        KT_Table2RawQuery *pan_rec=arr_funds[row];
        str_fundName=[NSString stringWithFormat:@"%@",pan_rec.fundDesc];
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
    if (txt_currentTextField==txt_familyMember) {
        KT_TABLE12 *pan_rec=arr_familyMem[row];
        txt_currentTextField.text=[NSString stringWithFormat:@"%@",pan_rec.invName];
        str_selectedPan=[NSString stringWithFormat:@"%@",pan_rec.PAN];
        txt_fundName.text=@"Select Fund";
        str_selectedFundId=@"";
        [self fundDropDownRecordArr:[[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT fundDesc, fund FROM TABLE2_DETAILS WHERE PAN='%@'",str_selectedPan]]];
    }
    else{
        KT_Table2RawQuery *pan_rec=arr_funds[row];
        txt_fundName.text=[NSString stringWithFormat:@"%@",pan_rec.fundDesc];
        str_selectedFundId=[NSString stringWithFormat:@"%@",pan_rec.fund];
        [self fetchFolioRecordsBasedOnFundPanForPan:str_selectedPan forFundId:str_selectedFundId];
    }
    
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTextField=textField;
    [textField becomeFirstResponder];
    if (textField==txt_familyMember) {
        if (arr_familyMem.count>1) {
            [picker_dropDown reloadAllComponents];
        }
    }
    else if (textField == txt_fundName){
        if (arr_funds.count>1) {
            [picker_dropDown reloadAllComponents];
        }
        else{
            KT_TABLE5 *pan_rec=arr_funds[0];
            txt_fundName.text=[NSString stringWithFormat:@"%@",pan_rec.fundDesc];
            str_selectedFundId=[NSString stringWithFormat:@"%@",pan_rec.fund];
            [self fetchFolioRecordsBasedOnFundPanForPan:str_selectedPan forFundId:str_selectedFundId];
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

#pragma mark -BackTapped

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

#pragma mark - delink

- (IBAction)btn_delinkTapped:(UIButton *)sender {
    if (txt_familyMember.text.length==0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select family member."];
        });
    }
    else if (txt_fundName.text.length==0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select fund."];
        });
    }
    else if (arr_folioNumberRec.count==0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Select at least one folio."];
        });
    }
    else{
        [self deAssociateFolioAPI];
    }
}

-(void)fetchFolioRecordsBasedOnFundPanForPan:(NSString *)pan forFundId:(NSString *)fundId{
    arr_checkUncheckRec=[NSMutableArray new];
    arr_folioNumberRec=[NSMutableArray new];
    arr_folioList=[[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (fund), Acno FROM TABLE2_DETAILS WHERE PAN='%@' AND fund ='%@' ORDER BY fundDesc ASC",pan,fundId]];
    if (arr_folioList.count==0) {
        [tbl_deLinkFolio setHidden:YES];
    }
    else{
        for (int i=0; i<arr_folioList.count; i++) {
            [arr_checkUncheckRec addObject:@"Uncheck"];
        }
        [tbl_deLinkFolio setHidden:NO];
        [tbl_deLinkFolio reloadData];
    }
}

#pragma mark - DeAssociateFolio

-(void)deAssociateFolioAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_fund=[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundId];
    NSString *str_tilt=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"~"];
    NSMutableString *str_mut=[NSMutableString new];
    for (int i=0;i<arr_folioNumberRec.count;i++) {
        NSString *str_fo=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@", arr_folioNumberRec[i]]];
        if (i==arr_folioNumberRec.count-1) {
            [str_mut appendString:[NSString stringWithFormat:@"%@",str_fo]];
        }
        else{
           [str_mut appendString:[NSString stringWithFormat:@"%@%@",str_fo,str_tilt]];
        }
    }
    NSString *str_url = [NSString stringWithFormat:@"%@DeAssociateFolio?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Userid=%@&Fund=%@&Foliono=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_fund,str_mut];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Table"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            NSString *succ_message=[NSString stringWithFormat:@"%@",responce[@"Table1"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:KTSuccessMsg forMessage:succ_message andAction1:@"Ok" andAction1Block:^{
                    [self deLinkfamilyFolioSuccess];
                }];
            });
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table1"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {

    }];
}


-(void)deLinkfamilyFolioSuccess{
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
