//
//  NetAssetValueGraphVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 19/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "NetAssetValueGraphVC.h"

@interface NetAssetValueGraphVC ()<UIPickerViewDelegate,UIPickerViewDataSource,BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>{
    __weak IBOutlet BEMSimpleLineGraphView *view_bemGraph;
    __weak IBOutlet UITextField *txt_fund;
    __weak IBOutlet UITextField *txt_Category;
    __weak IBOutlet UITextField *txt_Scheme;
    __weak IBOutlet UITextField *txt_Duration;
     __weak IBOutlet UITableView *view_NAVTable;
    
    __weak IBOutlet UILabel *lbl_message;
    NSArray *funddetailsarr,*schmdetailsarr,*categoryarr,*durationarr,*jsnresparr;
    UIPickerView *picker_dropdown;
    UITextField *txt_currentTextField;
    NSString *str_selectedFundID,*str_selectedCateID,*str_selectedSchemeID,*str_selectedDuration,*str_pln,*str_sch;
}
@end

@implementation NetAssetValueGraphVC
@synthesize str_fromScreen,selected_Rec;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addElements];
    [self loadGraphPoint];
    str_selectedDuration=@"1D";
    [view_NAVTable setHidden:YES];
    [view_bemGraph setHidden:YES];
    durationarr = @[@{@"Title":@"1 Week",@"ServerID":@"1D"}, @{@"Title":@"1 Month",@"ServerID":@"1M"}, @{@"Title":@"3 Months",@"ServerID":@"3M"}, @{@"Title":@"6 Months",@"ServerID":@"6M"}, @{@"Title":@"1 Year",@"ServerID":@"1Y"},
                    @{@"Title":@"3 years",@"ServerID":@"3Y"},@{@"Title":@"5 years",@"ServerID":@"5Y"}];
    if ([str_fromScreen isEqual:@"DetailPort"] || [str_fromScreen isEqualToString:@"DetailPort"]) {
        txt_fund.text=[NSString stringWithFormat:@"%@",selected_Rec.fundDesc];
        str_selectedFundID=[NSString stringWithFormat:@"%@",selected_Rec.fund];
        txt_Category.text=[NSString stringWithFormat:@"%@",selected_Rec.schemeClass].uppercaseString;
        str_selectedCateID=[NSString stringWithFormat:@"%@",selected_Rec.schemeClass].uppercaseString;
        txt_Scheme.text=[NSString stringWithFormat:@"%@",selected_Rec.schDesc];
        str_selectedSchemeID=[NSString stringWithFormat:@"%@",selected_Rec.sch];
        str_sch=[NSString stringWithFormat:@"%@",selected_Rec.sch];
        str_pln=[NSString stringWithFormat:@"%@",selected_Rec.pln];
        [txt_Scheme setUserInteractionEnabled:NO];
        [txt_fund setUserInteractionEnabled:NO];
        [txt_Category setUserInteractionEnabled:NO];
        [self getGraphdata:str_selectedFundID forCategoryID:str_selectedCateID forPlanID:str_pln forInvestFlag:str_selectedDuration];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [txt_fund setUserInteractionEnabled:NO];
            [self getFunds];
        });
    }
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"NAV"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add Elements

-(void)addElements{
    [UITextField withoutRoundedCornerTextField:txt_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_Category forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_Scheme forCornerRadius:5.f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_Duration forCornerRadius:5.0f forBorderWidth:1.5f];
    picker_dropdown=[[UIPickerView alloc]init];
    picker_dropdown.delegate=self;
    picker_dropdown.dataSource=self;
    picker_dropdown.backgroundColor=[UIColor whiteColor];
    [txt_fund addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_Category addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_Scheme addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    [txt_Duration addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
}

-(void)doneAction:(UIBarButtonItem *)done{
    [txt_currentTextField resignFirstResponder];
    if (txt_currentTextField==txt_Category){
        
    }
    else{
        jsnresparr=@[];
        [view_bemGraph setHidden:YES];
        [view_NAVTable setHidden:YES];
        [lbl_message setHidden:NO];
    }
}

#pragma mark - back btn tapped

- (IBAction)bk_btntapped:(id)sender {
    KTPOP(YES);
}

- (IBAction)navgrpbtn:(id)sender {
    if (jsnresparr.count>0) {
        [lbl_message setHidden:YES];
        [view_NAVTable setHidden:YES];
        [view_bemGraph setHidden:NO];
        [self.view bringSubviewToFront:view_bemGraph];
    }
    else{
        [lbl_message setText:@"NO CHART DATA AVAILABLE"];
        [lbl_message setHidden:NO];
        [self.view bringSubviewToFront:lbl_message];
    }
  
}

- (IBAction)nvtablebtn:(id)sender {
     if (jsnresparr.count>0) {
        [view_NAVTable setHidden:NO];
        [view_bemGraph setHidden:YES];
        [lbl_message setHidden:YES];
        [self.view bringSubviewToFront:view_NAVTable];
     }
    else{
        [lbl_message setText:@"NO DATA AVAILABLE"];
        [lbl_message setHidden:NO];
        [self.view bringSubviewToFront:lbl_message];
    }
}

-(void)getFunds{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_opt = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@"A"];
    NSString *str_fundcode = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@""];
    NSString *str_schmtype = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@""];
    NSString *str_plntype = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fundcode,str_schmtype,str_plntype];
    NSLog(@"fund url is %@",str_url);
    
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            funddetailsarr = responce[@"Dtinformation"];
            [[APIManager sharedManager]hideHUD];
            if (funddetailsarr.count>1) {
                [txt_fund setUserInteractionEnabled:YES];
                txt_fund.inputView=picker_dropdown;
            }
            else{
                if (funddetailsarr.count==1) {
                    [txt_fund setUserInteractionEnabled:NO];
                    txt_fund.text = funddetailsarr[0][@"amc_name"];
                    str_selectedFundID =funddetailsarr[0][@"amc_code"];
                    [self getCategory:str_selectedCateID];
                }
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
    txt_currentTextField=textField;
    if (textField==txt_fund) {
        txt_Scheme.text=@"";
        txt_Category.text=@"";
        if (funddetailsarr.count>1) {
            [picker_dropdown selectRow:0 inComponent:0 animated:YES];
            [txt_fund becomeFirstResponder];
            [picker_dropdown reloadAllComponents];
        }
        txt_fund.text = funddetailsarr[0][@"amc_name"];
        str_selectedFundID =funddetailsarr[0][@"amc_code"];
    }
    else if (textField==txt_Category) {
        txt_Scheme.text=@"";
        if ([txt_fund.text length] == 0 ) {
            [txt_Category resignFirstResponder];
            [txt_fund becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund"];
        }
        else{
            if (categoryarr.count>1) {
                [picker_dropdown selectRow:0 inComponent:0 animated:YES];
                [picker_dropdown reloadAllComponents];
                [txt_Category becomeFirstResponder];
            }
            txt_Category.text = categoryarr[0][@"fm_subcategory"];
            str_selectedCateID=categoryarr[0][@"fm_subcategory"];
        }
    }
    else if(textField==txt_Scheme) {
        if([txt_fund.text length] == 0 ) {
            [txt_Scheme resignFirstResponder];
            [txt_fund becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Fund"];
        }
        else if([txt_Category.text length] == 0){
            [txt_Scheme resignFirstResponder];
            [txt_Category becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Category"];
        }
        else{
            if (schmdetailsarr.count>1) {
                [picker_dropdown selectRow:0 inComponent:0 animated:YES];
                [picker_dropdown reloadAllComponents];
                [txt_Scheme becomeFirstResponder];
            }
            txt_Scheme.text = schmdetailsarr[0][@"Scheme_Desc"];
            str_selectedSchemeID=schmdetailsarr[0][@"Scheme_Plan"];
            NSArray *schsplarry=[str_selectedSchemeID componentsSeparatedByString:@"~"];
            str_pln=schsplarry[2];
            str_sch=schsplarry[1];
        }
    }
    else if (textField==txt_Duration) {
        if ([txt_fund.text length] == 0) {
            [txt_Duration resignFirstResponder];
            [txt_fund becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Fund"];
        }
        else if ([txt_Category.text length]==0) {
            [txt_Duration resignFirstResponder];
            [txt_Category becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Category"];
        }
        else if([txt_Scheme.text length]==0){
            [txt_Duration resignFirstResponder];
            [txt_Scheme becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Scheme"];
        }
        else{
            [picker_dropdown selectRow:0 inComponent:0 animated:YES];
            txt_Duration.inputView = picker_dropdown;
            [picker_dropdown reloadAllComponents];
            [txt_Duration becomeFirstResponder];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if (txt_currentTextField==txt_fund) {
        if ([txt_fund.text length]>0) {
            [self getCategory:str_selectedFundID];
        }
    }
    else if (txt_currentTextField==txt_Category) {
        if ([txt_Category.text length]>0 && [txt_fund.text length]>0) {
            [self getOtherSchemes:str_selectedFundID forCategoryID:str_selectedCateID];
        }
    }
    else if (txt_currentTextField==txt_Scheme){
        if (txt_fund.text.length!=0 && txt_Scheme.text.length!=0 && txt_Category.text.length!=0) {
            [self getGraphdata:str_selectedFundID forCategoryID:str_selectedCateID forPlanID:str_pln forInvestFlag:str_selectedDuration];
        }
    }
    else if (txt_currentTextField==txt_Duration){
        if (txt_fund.text.length!=0 && txt_Scheme.text.length!=0 && txt_Category.text.length!=0) {
            [self getGraphdata:str_selectedFundID forCategoryID:str_selectedCateID forPlanID:str_pln forInvestFlag:str_selectedDuration];
        }
    }
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

-(void)getOtherSchemes:(NSString *)selectedFundID forCategoryID:(NSString *)categoryID{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_opt = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@"S"];
    NSString *str_fundcode = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:selectedFundID];
    NSString *str_schmtype = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:categoryID];
    NSString *str_invflag = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@""];
    NSString *schm_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fundcode,str_schmtype,str_invflag];
    NSLog(@"schemes url is %@",schm_url);
    
    [[APIManager sharedManager]requestGetUrl:schm_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            schmdetailsarr =  responce[@"Dtinformation"];
            if (schmdetailsarr.count>1) {
                [txt_Scheme setUserInteractionEnabled:YES];
                txt_Scheme.inputView = picker_dropdown;
            }
            else{
                if (schmdetailsarr.count==1) {
                    [txt_Scheme setUserInteractionEnabled:NO];
                    txt_Scheme.text = schmdetailsarr[0][@"Scheme_Desc"];
                    str_selectedSchemeID=schmdetailsarr[0][@"Scheme_Plan"];
                    NSArray *schsplarry=[str_selectedSchemeID componentsSeparatedByString:@"~"];
                    str_pln=schsplarry[2];
                    str_sch=schsplarry[1];
                    if (txt_fund.text.length!=0 && txt_Scheme.text.length!=0 && txt_Category.text.length!=0) {
                        [self getGraphdata:str_selectedFundID forCategoryID:str_selectedCateID forPlanID:str_pln forInvestFlag:str_selectedDuration];
                    }
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No Scheme available."];
                    });
                }
            }
        });
       
    } failure:^(NSError *error) {
        
    }];
}

-(void)getCategory:(NSString *)selectedFundID{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    
    NSString *str_opt = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@"AT"];
    NSString *str_fundcode = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:selectedFundID];
    NSString *str_schmtype = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@""];
    NSString *str_plntype = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@"Regular"];
    
    NSString *catgry_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fundcode,str_schmtype,str_plntype];
    NSLog(@"category url is %@",catgry_url);
    [[APIManager sharedManager]requestGetUrl:catgry_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode = [responce[@"Table"][0][@"Error_Code"]intValue];
        if(error_statuscode == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                categoryarr =  responce[@"Dtinformation"];
                if (categoryarr.count>1) {
                    [txt_Category setUserInteractionEnabled:YES];
                    txt_Category.inputView = picker_dropdown;
                    [picker_dropdown reloadAllComponents];
                }
                else{
                    if (categoryarr.count==1) {
                        [txt_Category setUserInteractionEnabled:NO];
                        txt_Category.text = categoryarr[0][@"fm_subcategory"];
                        str_selectedCateID=categoryarr[0][@"fm_subcategory"];
                        [self getOtherSchemes:str_selectedFundID forCategoryID:str_selectedCateID];
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No Scheme available."];
                        });
                    }
                }
            });
        }
        else
        {
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)getGraphdata:(NSString *)selectedFundID forCategoryID:(NSString *)categoryID forPlanID:(NSString *)planID forInvestFlag:(NSString *)invFlag{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fundcode = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:selectedFundID];
    NSString *str_schmtype = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:str_sch];
    NSString *str_invflag = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:invFlag];
    NSString *str_plntype = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:str_pln];
    NSString *graph_url = [NSString stringWithFormat:@"%@GetNAVGraph?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Scheme=%@&flag=%@&Plan=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fundcode,str_schmtype,str_invflag,str_plntype];
    NSLog(@"graph url is %@",graph_url);
    [[APIManager sharedManager]requestGetUrl:graph_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode  =  [responce[@"Table"][0][@"Error_code"]intValue];
        if (error_statuscode == 0) {
            jsnresparr=responce[@"Table1"];
            NSLog(@"Nav Response %@",jsnresparr);
            if ([jsnresparr count]>1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    [view_NAVTable reloadData];
                    [view_bemGraph setHidden:NO];
                    [view_bemGraph reloadGraph];
                    [lbl_message setHidden:YES];
                    [self.view bringSubviewToFront:view_bemGraph];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    [lbl_message setText:@"NO CHART DATA AVAILABLE"];
                    [view_bemGraph setHidden:YES];
                    [view_NAVTable setHidden:YES];
                    [lbl_message setHidden:NO];
                    [self.view bringSubviewToFront:lbl_message];
                });
            }
            
        }
        else{
           dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [lbl_message setText:@"NO CHART DATA AVAILABLE"];
                [view_bemGraph setHidden:YES];
                [view_NAVTable setHidden:YES];
                [lbl_message setHidden:YES];
                [self.view bringSubviewToFront:lbl_message];
           });
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    long int newcount = 0;
    if (txt_currentTextField==txt_fund) {
        newcount = funddetailsarr.count;
    }
    else if(txt_currentTextField==txt_Category)
    {
        newcount = categoryarr.count;
    }
    else if(txt_currentTextField==txt_Scheme)
    {
        newcount = schmdetailsarr.count;
    }
    else if (txt_currentTextField==txt_Duration)
    {
        newcount = durationarr.count;
    }
    
    return newcount;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *pickerLabel;
    CGRect frame = CGRectMake(5.0, 0.0,self.view.frame.size.width-10,40);
    pickerLabel = [[UILabel alloc] initWithFrame:frame];
    UILabel *lbl_title=[[UILabel alloc]init];
    lbl_title.frame=frame;
    NSString *str_title;
    if (txt_currentTextField==txt_fund) {
        str_title = funddetailsarr[row][@"amc_name"];
    }
    else if (txt_currentTextField==txt_Category) {
        str_title = categoryarr[row][@"fm_subcategory"];
    }
    else if(txt_currentTextField==txt_Scheme){
        str_title = schmdetailsarr[row][@"Scheme_Desc"];
    }
    else if (txt_currentTextField==txt_Duration) {
        str_title = durationarr[row][@"Title"];
    }
    lbl_title.text= str_title;
    lbl_title.textAlignment=NSTextAlignmentCenter;
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.font=KTFontFamilySize(KTOpenSansRegular, 12);
    lbl_title.numberOfLines=3;
    [pickerLabel addSubview:lbl_title];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    if (txt_currentTextField==txt_fund) {
        txt_fund.text = funddetailsarr[row][@"amc_name"];
        str_selectedFundID =funddetailsarr[row][@"amc_code"];
        txt_Category.text=@"";
        txt_Scheme.text=@"";
        [self getCategory:str_selectedFundID];
    }
    else if (txt_currentTextField==txt_Category){
        txt_Category.text = categoryarr[row][@"fm_subcategory"];
        str_selectedCateID=categoryarr[row][@"fm_subcategory"];
        [self getOtherSchemes:str_selectedFundID forCategoryID:str_selectedCateID];
    }
    else if (txt_currentTextField==txt_Scheme){
        txt_Scheme.text = schmdetailsarr[row][@"Scheme_Desc"];
        str_selectedSchemeID=schmdetailsarr[row][@"Scheme_Plan"];
        NSArray *schsplarry=[str_selectedSchemeID componentsSeparatedByString:@"~"];
        str_pln=schsplarry[2];
        str_sch=schsplarry[1];
    }
    else if (txt_currentTextField==txt_Duration) {
        txt_Duration.text = durationarr[row][@"Title"];
        str_selectedDuration=durationarr[row][@"ServerID"];
    }
}

#pragma mark - UITableView Delegates

#pragma mark - TableView Delegate and Data Source delegate starts

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return jsnresparr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NavTableCell *cell = (NavTableCell*)[tableView dequeueReusableCellWithIdentifier:@"NavCell"];
    if(cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavTableCell" owner:self options:nil];
        cell = (NavTableCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic_nav=jsnresparr[indexPath.row];
    cell.lbl_navvalue.text =[NSString stringWithFormat:@"%@",dic_nav[@"fn_nav"]];
    cell.lbl_navdt.text = [NSString stringWithFormat:@"%@",dic_nav[@"fn_fromdt"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
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
    NavTableCell *headerView=(NavTableCell*)[tableView dequeueReusableCellWithIdentifier:@"NavCell"];
    if (headerView==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavTableCell" owner:self options:nil];
        headerView = (NavTableCell *)[nib objectAtIndex:0];
        headerView.selectionStyle=UITableViewCellSelectionStyleNone;
        headerView.backgroundColor=[UIColor lightGrayColor];
    }
    headerView.lbl_navvalue.text=@"NAV Value";
    headerView.lbl_navdt.text=@"NAV Date";
    headerView.lbl_navvalue.font=KTFontFamilySize(KTOpenSansSemiBold,12);
    headerView.lbl_navdt.font=KTFontFamilySize(KTOpenSansSemiBold,12);
    [headerView.lbl_navvalue setTextColor:KTButtonBackGroundBlue];
    [headerView.lbl_navdt setTextColor:KTButtonBackGroundBlue];
    return headerView;
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[jsnresparr count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[jsnresparr objectAtIndex:index][@"fn_nav"] doubleValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    long int count=0;
    if ([str_selectedDuration isEqual:@"1D"]) {
        count=0;
    }
    else if ([str_selectedDuration isEqual:@"1M"]) {
        count=3;
    }
    else if ([str_selectedDuration isEqual:@"3M"]) {
        count=10;
    }
    else if ([str_selectedDuration isEqual:@"6M"]) {
        count=20;
    }
    else if ([str_selectedDuration isEqual:@"1Y"]) {
        count=40;
    }
    else if ([str_selectedDuration isEqual:@"3Y"]) {
        count=120;
    }
    else if ([str_selectedDuration isEqual:@"5Y"]) {
        count=180;
    }
    return count;
}
- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 5;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {

}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
   
}

- (BOOL)lineGraph:(BEMSimpleLineGraphView *)graph alwaysDisplayPopUpAtIndex:(CGFloat)index{
    return YES;
}


- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph{
    return @" NAV";
}

- (NSString *)labelForDateAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%@",jsnresparr[index][@"fn_fromdt"]];
}

#pragma mark - load Graph Points

-(void)loadGraphPoint{
    view_bemGraph.enableTouchReport = YES;
    view_bemGraph.enablePopUpReport = YES;
    view_bemGraph.enableYAxisLabel = YES;
    view_bemGraph.autoScaleYAxis = YES;
    view_bemGraph.alwaysDisplayDots = NO;
    view_bemGraph.enableReferenceXAxisLines = YES;
    view_bemGraph.enableReferenceYAxisLines = YES;
    view_bemGraph.enableReferenceAxisFrame = YES;
    
    // Draw an average line
    view_bemGraph.averageLine.enableAverageLine = NO;
    view_bemGraph.averageLine.alpha = 0.6;
    view_bemGraph.averageLine.color = [UIColor clearColor];
    view_bemGraph.averageLine.width = 2.5;
    view_bemGraph.averageLine.dashPattern = @[@(2),@(2)];
    
    // Set the graph's animation style to draw, fade, or none
    view_bemGraph.animationGraphStyle = BEMLineAnimationDraw;
    // Dash the y reference lines
    view_bemGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    // Show the y axis values with this format string
    view_bemGraph.formatStringForValues = @"%.1f";
}

@end
