//
//  DetailedPortfolioVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 05/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "DetailedPortfolioVC.h"

@interface DetailedPortfolioVC ()<UIPickerViewDelegate,UIPickerViewDataSource,folioCellCustomDelegate,NAVChildCustomDelegate>{
    __weak IBOutlet UIButton *btn_close;
    __weak IBOutlet UIButton *btn_check;
    __weak IBOutlet UIView *view_search;
    __weak IBOutlet UITableView *tbl_detailPortfolioFundWise;
    __weak IBOutlet UITableView *tbl_detailPortfolio;
    __weak IBOutlet UITextView *txt_search;
    __weak IBOutlet UITextField *txt_funds;
    BOOL executeWithZeroFolios;
    BOOL searchViaFundWise;
    NSMutableArray *arr_spinnerRec;
    NSArray *arr_tableParentRec;
    UIPickerView *picker_dropDown;
    NSString *str_selectedFundID;
    __weak IBOutlet UIButton *btn_search;
    NSMutableArray *arr_mainParentMut;
    NSMutableArray *arr_mainFundParentMut;
    NSMutableArray *arr_actualMainContent;
    __weak IBOutlet UIView *view_headerView;
    __weak IBOutlet UILabel *lbl_zeroFolioMeesageDisplay;
    __weak IBOutlet UIButton *btn_backTitle;
}
@end

@implementation DetailedPortfolioVC
@synthesize str_selectedScheme,str_selectedPAN,str_fromScreen,selected_schemeClass,str_typePortFolio;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseCornerForFields];
    [self backBtnTitle];
    searchViaFundWise=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Back button Title

-(void)backBtnTitle{
    NSString *str_recPAN=[XTAPP_DELEGATE removeNullFromStr:str_selectedPAN];
    if (str_recPAN.length==0 || [str_recPAN isEqualToString:@""] || [str_recPAN isEqual:@""]) {
        [btn_backTitle setTitle:@"   Minor Detailed Portfolio" forState:UIControlStateNormal];
        [XTAPP_DELEGATE callPagelogOnEachScreen:[NSString stringWithFormat:@"MinorDetailedPortfolio"]];
    }
    else if ([str_recPAN isEqualToString:@"ALL"] || [str_recPAN isEqual:@"ALL"]) {
        [btn_backTitle setTitle:@"   Total Detailed Portfolio" forState:UIControlStateNormal];
        [XTAPP_DELEGATE callPagelogOnEachScreen:@"TotalDetailedPortfolio"];
    }
    else {
        NSArray *primaryFound= [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE PAN ='%@'",str_recPAN]];
        if (primaryFound.count>0) {
            KT_TABLE12 *foundRec=primaryFound[0];
            NSString *primaryPan=[NSString stringWithFormat:@"%@",foundRec.flag];
            if ([primaryPan isEqualToString:@"P"] || [primaryPan isEqual:@"P"]){
                [btn_backTitle setTitle:@"   My Detailed Portfolio" forState:UIControlStateNormal];
                [XTAPP_DELEGATE callPagelogOnEachScreen:@"MYDetailedPortfolio"];
            }
            else{
                [btn_backTitle setTitle:[NSString stringWithFormat:@"   Detailed Portfolio\n   %@",foundRec.invName] forState:UIControlStateNormal];
                [XTAPP_DELEGATE callPagelogOnEachScreen:[NSString stringWithFormat:@"DetailedPortfolio%@",foundRec.invName]];
            }
        }
        else{
           [btn_backTitle setTitle:@"   My Detailed Portfolio" forState:UIControlStateNormal];
            [XTAPP_DELEGATE callPagelogOnEachScreen:@"MYDetailedPortfolio"];
        }
    }
}

#pragma mark - initialiseView

-(void)initialiseCornerForFields{
    executeWithZeroFolios=NO;
    tbl_detailPortfolio.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    tbl_detailPortfolioFundWise.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    [UITextField withoutRoundedCornerTextField:txt_funds forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIView roundedCornerEnableForView:view_search forCornerRadius:5.0f forBorderWidth:1.5f forApplyShadow:NO];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    if ([str_fromScreen isEqual:@"ShowAll"]) {
        [self spinnerDropDownForFund];
        [self loadViewDataBasedOnFund:@"ALL" forPan:str_selectedPAN];
    }
    else if([str_fromScreen isEqual:@"PANRECORD"]){
        [self spinnerDropDownForPan:str_selectedPAN forSchemeClass:selected_schemeClass];
        [self loadViewDataBasedOnPanSchemeClassForPan:str_selectedPAN forSchemeClass:selected_schemeClass];
    }
}

#pragma mark - Load Data According

/* When use select taps on total portfolio show below two methods*/

-(void)loadViewDataBasedOnFund:(NSString *)selectedFund forPan:(NSString *)pan{
    if (searchViaFundWise==NO) {
        if (executeWithZeroFolios==NO) {
            if ([selectedFund isEqual:@"ALL"] && [pan isEqual:@"ALL"]) {
                arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE CAST(costValue as decimal)>0  and schemeClass= '%@' ORDER BY fundDesc ASC",selectedFund]];
            }
            else if (![selectedFund isEqual:@"ALL"] && [pan isEqual:@"ALL"]) {
                arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE CAST(costValue as decimal)>0 AND fund ='%@' ORDER BY fundDesc ASC",selectedFund]];
            }
            else if ([selectedFund isEqual:@"ALL"] && ![pan isEqual:@"ALL"]){
                arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE CAST(costValue as decimal)>0 AND PAN ='%@' AND schemeClass= '%@' ORDER BY fundDesc ASC",pan,selectedFund]];
            }
            else{
                arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE CAST(costValue as decimal)>0 AND PAN ='%@' AND fund ='%@' ORDER BY fundDesc ASC",pan,selectedFund]];
            }
        }
        else{
            if ([selectedFund isEqual:@"ALL"] && [pan isEqual:@"ALL"]) {
                arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE schemeClass= '%@' ORDER BY fundDesc ASC",selectedFund]];
            }
            else if (![selectedFund isEqual:@"ALL"] &&  [pan isEqual:@"ALL"]) {
                arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE fund ='%@' ORDER BY fundDesc ASC",selectedFund]];
            }
            else if ([selectedFund isEqual:@"ALL"] && ![pan isEqual:@"ALL"]){
                arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE PAN ='%@' AND schemeClass= '%@' ORDER BY fundDesc ASC",pan,selectedFund]];
            }
            else{
                arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE PAN ='%@' AND fund ='%@' ORDER BY fundDesc ASC",pan,selectedFund]];
            }
        }
        [self tableReloadDataForParentArray:arr_tableParentRec];
    }
    else{
        arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchRecordFromTable6:[NSString stringWithFormat:@"SELECT * FROM TABLE6_DETAILS WHERE PAN ='%@' AND fund ='%@' ORDER BY fundDesc ASC",pan,selectedFund]];
        [self tableReloadDataForParentFundBasedArray:arr_tableParentRec];
    }
}

/* Fund wise or scheme wise below two methods */

-(void)spinnerDropDownForFund{
    arr_spinnerRec=[NSMutableArray new];
    [arr_spinnerRec mutableCopy];
    NSArray *unique_funds;
    if (executeWithZeroFolios==NO) {
        if ([str_selectedPAN isEqual:@"ALL"]) {
            unique_funds=[[DBManager sharedDataManagerInstance]fetchSpinnerUniqueFundBasedFromTable13:[NSString stringWithFormat: @"SELECT distinct (fundDesc),(fund) FROM TABLE13_DETAILS WHERE CAST(costValue as decimal)>0"]];
        }
        else{
            unique_funds=[[DBManager sharedDataManagerInstance]fetchSpinnerUniqueFundBasedFromTable13:[NSString stringWithFormat: @"SELECT distinct (fundDesc),(fund) FROM TABLE13_DETAILS WHERE CAST(costValue as decimal)>0 AND PAN = '%@'",str_selectedPAN]];
        }
    }
    else{
        if ([str_selectedPAN isEqual:@"ALL"]) {
            unique_funds=[[DBManager sharedDataManagerInstance]fetchSpinnerUniqueFundBasedFromTable13:[NSString stringWithFormat: @"SELECT distinct (fundDesc),(fund) FROM TABLE13_DETAILS"]];
        }
        else{
            unique_funds=[[DBManager sharedDataManagerInstance]fetchSpinnerUniqueFundBasedFromTable13:[NSString stringWithFormat: @"SELECT distinct (fundDesc),(fund) FROM TABLE13_DETAILS WHERE PAN = '%@'",str_selectedPAN]];
        }
    }
    if (unique_funds.count==0) {
        
    }
    else{
        [arr_spinnerRec addObject:@"ALL"];
        [arr_spinnerRec addObjectsFromArray:unique_funds];
    }
    if (arr_spinnerRec.count>0) {
        if (searchViaFundWise==NO) {
            txt_funds.text=@"ALL";
            str_selectedFundID=@"ALL";
        }
        if (arr_spinnerRec.count==1){
            [txt_funds setUserInteractionEnabled:NO];
        }
        else{
            txt_funds.inputView=picker_dropDown;
            [picker_dropDown reloadAllComponents];
            [txt_funds setUserInteractionEnabled:YES];
        }
    }
}

-(void)spinnerDropDownForPan:(NSString *)pan forSchemeClass:(NSString *)schemeClass{
    arr_spinnerRec=[NSMutableArray new];
    [arr_spinnerRec mutableCopy];
    NSArray *unique_funds=[[DBManager sharedDataManagerInstance]fetchSpinnerUniqueFundBasedOnPanFromTable13:[NSString stringWithFormat:@"SELECT name FROM TABLE4_DETAILS WHERE PAN='%@' order By percentage DESC",pan]];
    if (unique_funds.count==0) {
        
    }
    else{
        [arr_spinnerRec addObject:@"ALL"];
        [arr_spinnerRec addObjectsFromArray:unique_funds];
    }
    if (arr_spinnerRec.count>0) {
        if (arr_spinnerRec.count==1){
            [txt_funds setUserInteractionEnabled:NO];
        }
        else{
            txt_funds.text=[NSString stringWithFormat:@"%@",schemeClass];
            txt_funds.inputView=picker_dropDown;
            [picker_dropDown reloadAllComponents];
            [txt_funds setUserInteractionEnabled:YES];
        }
    }
}

-(void)loadViewDataBasedOnPanSchemeClassForPan:(NSString *)pan forSchemeClass:(NSString *)schemeClass{
    if (executeWithZeroFolios==NO) {
        if ([schemeClass isEqual:@"ALL"] && [pan isEqual:@"ALL"]) {
            arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE CAST(costValue as decimal)>0 AND schemeClass= '%@' ORDER BY fundDesc ASC",schemeClass]];
        }
        else if ([schemeClass isEqual:@"ALL"] && ![pan isEqual:@"ALL"]) {
            arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE CAST(costValue as decimal)>0 AND PAN='%@' AND schemeClass= '%@' ORDER BY fundDesc ASC",pan,schemeClass]];
        }
        else if (![schemeClass isEqual:@"ALL"] && [pan isEqual:@"ALL"]) {
            arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE CAST(costValue as decimal)>0 AND schemeClass ='%@' ORDER BY fundDesc ASC",schemeClass]];
        }
        else{
            arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE CAST(costValue as decimal)>0 AND PAN='%@' AND schemeClass ='%@' ORDER BY fundDesc ASC",pan,schemeClass]];
        }
    }
    else{
        if ([schemeClass isEqual:@"ALL"] && [pan isEqual:@"ALL"]) {
            arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS schemeClass= '%@' ORDER BY fundDesc ASC",schemeClass]];
        }
        else if ([schemeClass isEqual:@"ALL"] && ![pan isEqual:@"ALL"]) {
            arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE PAN='%@' AND schemeClass= '%@' ORDER BY fundDesc ASC",pan,schemeClass]];
        }
        else if (![schemeClass isEqual:@"ALL"] && [pan isEqual:@"ALL"]) {
            arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE schemeClass='%@' ORDER BY fundDesc ASC",schemeClass]];
        }
        else{
            arr_tableParentRec=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable13:[NSString stringWithFormat:@"SELECT * FROM TABLE13_DETAILS WHERE PAN='%@' AND schemeClass ='%@' ORDER BY fundDesc ASC",pan,schemeClass]];
        }
    }
   [self tableReloadDataForParentArray:arr_tableParentRec];
}


#pragma mark - check tapped

- (IBAction)btn_checkTapped:(UIButton *)sender {
    txt_search.text=@"";
    [txt_search resignFirstResponder];
    if ([sender.imageView.image isEqual: [UIImage imageNamed:@"uncheck"]]) {
        [sender setImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        executeWithZeroFolios=YES;
        if ([str_fromScreen isEqual:@"ShowAll"]) {
            [self spinnerDropDownForFund];
            [self loadViewDataBasedOnFund:str_selectedFundID forPan:str_selectedPAN];
        }
        else if([str_fromScreen isEqual:@"PANRECORD"]){
            str_selectedFundID=@"ALL";
            txt_funds.text=selected_schemeClass;
            [self loadViewDataBasedOnPanSchemeClassForPan:str_selectedPAN forSchemeClass:selected_schemeClass];
        }
    }
    else{
        [sender setImage: [UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        executeWithZeroFolios=NO;
        if ([str_fromScreen isEqual:@"ShowAll"]) {
            [self spinnerDropDownForFund];
            [self loadViewDataBasedOnFund:str_selectedFundID forPan:str_selectedPAN];
        }
        else if([str_fromScreen isEqual:@"PANRECORD"]){
            str_selectedFundID=@"";
            txt_funds.text=selected_schemeClass;
            [self loadViewDataBasedOnPanSchemeClassForPan:str_selectedPAN forSchemeClass:selected_schemeClass];
        }
    }
}

#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return arr_spinnerRec.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str_fundName;
    if([str_fromScreen isEqual:@"PANRECORD"]){
        if (row==0) {
            str_fundName=@"ALL";
        }else{
            KT_TABLE13 *fund_rec=arr_spinnerRec[row];
            str_fundName=[NSString stringWithFormat:@"%@",fund_rec.fund];
        }
    }
    else if ([str_fromScreen isEqual:@"ShowAll"]){
        if (row==0) {
            str_fundName=@"ALL";
        }
        else{
            KT_TABLE13 *fund_rec=arr_spinnerRec[row];
            str_fundName=[NSString stringWithFormat:@"%@",fund_rec.fundDesc];
        }
    }
    return str_fundName;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *pickerLabel;
    CGRect frame = CGRectMake(5.0, 0.0,self.view.frame.size.width-10,40);
    pickerLabel = [[UILabel alloc] initWithFrame:frame];
    UILabel *lbl_title=[[UILabel alloc]init];
    lbl_title.frame=frame;
    NSString *str_fundName;
    if([str_fromScreen isEqual:@"PANRECORD"]){
        if (row==0) {
            str_fundName=@"ALL";
        }else{
            KT_TABLE13 *fund_rec=arr_spinnerRec[row];
            str_fundName=[NSString stringWithFormat:@"%@",fund_rec.fund];
        }
    }
    else if ([str_fromScreen isEqual:@"ShowAll"]){
        if (row==0) {
            str_fundName=@"ALL";
        }
        else{
            KT_TABLE13 *fund_rec=arr_spinnerRec[row];
            str_fundName=[NSString stringWithFormat:@"%@",fund_rec.fundDesc];
        }
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
     if([str_fromScreen isEqual:@"PANRECORD"]){
         if (row==0) {
             txt_funds.text=@"ALL";
             str_selectedFundID=@"ALL";
             selected_schemeClass=@"ALL";
             [tbl_detailPortfolio setHidden:NO];
             [tbl_detailPortfolioFundWise setHidden:YES];
             [self loadViewDataBasedOnPanSchemeClassForPan:str_selectedPAN forSchemeClass:selected_schemeClass];
         }
         else{
             KT_TABLE13 *fund_rec=arr_spinnerRec[row];
             txt_funds.text=[NSString stringWithFormat:@"%@",fund_rec.fund];
             selected_schemeClass=[NSString stringWithFormat:@"%@",fund_rec.fund];
             [tbl_detailPortfolio setHidden:YES];
             [tbl_detailPortfolioFundWise setHidden:NO];
             [self loadViewDataBasedOnPanSchemeClassForPan:str_selectedPAN forSchemeClass:selected_schemeClass];
         }
     }
     else if ([str_fromScreen isEqual:@"ShowAll"]){
        if (row==0) {
            txt_funds.text=@"ALL";
            str_selectedFundID=@"ALL";
            searchViaFundWise=NO;
            [tbl_detailPortfolio setHidden:NO];
            [tbl_detailPortfolioFundWise setHidden:YES];
            [self loadViewDataBasedOnFund:@"ALL" forPan:str_selectedPAN];
        }
        else{
            KT_TABLE13 *fund_rec=arr_spinnerRec[row];
            txt_funds.text=[NSString stringWithFormat:@"%@",fund_rec.fundDesc];
            str_selectedFundID=[NSString stringWithFormat:@"%@",fund_rec.fund];
            searchViaFundWise=YES;
            [tbl_detailPortfolio setHidden:YES];
            [tbl_detailPortfolioFundWise setHidden:NO];
            [self loadViewDataBasedOnFund:str_selectedFundID forPan:str_selectedPAN];
        }
    }
}


#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
    if (textField==txt_funds) {
        txt_search.text=@"";
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

#pragma mark - TextFields Delegate Methods Ends

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}


#pragma mark - TableView Delegate and Data Source delegate starts

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    long int count;
    if (searchViaFundWise==NO) {
        count=[arr_mainParentMut count];
    }
    else{
       count=[arr_mainFundParentMut count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (searchViaFundWise==NO) {
        NSString *str_level=arr_mainParentMut[indexPath.row][@"level"];
        if ([str_level isEqualToString:@"0"]|| [str_level isEqual:@"0"]) {
            DetailParentTblCell *cell=(DetailParentTblCell*)[tableView dequeueReusableCellWithIdentifier:@"ParentCell"];
            if (cell==nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailParentTblCell" owner:self options:nil];
                cell = (DetailParentTblCell *)[nib objectAtIndex:0];
                [tableView setSeparatorColor:[UIColor blackColor]];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            KT_TABLE13 *rec=arr_mainParentMut[indexPath.row][@"Content"];
            NSString *str_imageUrl=[NSString stringWithFormat:@"%@%@",KTImageBase_url,rec.imagePath];
            [cell.img_bankImage setImageWithURL:[NSURL URLWithString:str_imageUrl] placeholderImage:[UIImage imageNamed:@"No_Bank"]];
            cell.lbl_schemeName.text=[NSString stringWithFormat:@"%@",rec.fundDesc];
            cell.lbl_units.text=[NSString stringWithFormat:@"%@",@"--"];
            cell.lbl_costValue.text=[NSString stringWithFormat:@"%@",rec.costValue];
            cell.lbl_currentValue.text=[NSString stringWithFormat:@"%@",rec.currentValue];
            cell.lbl_apprPercent.text=[NSString stringWithFormat:@"%@\n%@",rec.gainValue,rec.gainPercent];
            CGFloat absoulteGainValue=[rec.gainValue floatValue];
            if (absoulteGainValue<0) {
                cell.lbl_apprPercent.textColor=KTTextColorBrown;
                cell.img_gainImage.image=[UIImage imageNamed:@"Down"];
            }
            else{
                cell.lbl_apprPercent.textColor=KTTextColorGreen;
                cell.img_gainImage.image=[UIImage imageNamed:@"Up"];
                
            }
            return cell;
        }
        else if ([str_level isEqualToString:@"1"]|| [str_level isEqual:@"1"]) {
            DetailPortfolioMiddleChildTblCell *cell=(DetailPortfolioMiddleChildTblCell*)[tableView dequeueReusableCellWithIdentifier:@"MiddleChildTblCell"];
            if (cell==nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailPortfolioMiddleChildTblCell" owner:self options:nil];
                cell = (DetailPortfolioMiddleChildTblCell *)[nib objectAtIndex:0];
                [tableView setSeparatorColor:[UIColor blackColor]];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            KT_TABLE14 *rec=arr_mainParentMut[indexPath.row][@"Content"];
            cell.lbl_schemeDesc.text=[NSString stringWithFormat:@"%@",rec.schDesc];
            cell.dic_childRec=arr_mainParentMut[indexPath.row];
            cell.navCustomdelegate=self;
            return cell;
        }
        else if ([str_level isEqualToString:@"2"]|| [str_level isEqual:@"2"]) {
            DetailPortfolioSubChildTblCell *cell=(DetailPortfolioSubChildTblCell*)[tableView dequeueReusableCellWithIdentifier:@"SubChildTblCell"];
            if (cell==nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailPortfolioSubChildTblCell" owner:self options:nil];
                cell = (DetailPortfolioSubChildTblCell *)[nib objectAtIndex:0];
                [tableView setSeparatorColor:[UIColor blackColor]];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            KT_TABLE2 *rec=arr_mainParentMut[indexPath.row][@"Content"];
            cell.lbl_folioNumber.text=[NSString stringWithFormat:@"Folio No.\n%@",rec.Acno];
            cell.dic_subChildList=arr_mainParentMut[indexPath.row];
            cell.folioCustomdelegate=self;
            return cell;
        }
    }
    else{
        if (indexPath.row==0) {
            DetailParentTblCell *cell=(DetailParentTblCell*)[tableView dequeueReusableCellWithIdentifier:@"ParentCell"];
            if (cell==nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailParentTblCell" owner:self options:nil];
                cell = (DetailParentTblCell *)[nib objectAtIndex:0];
                [tableView setSeparatorColor:[UIColor blackColor]];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            KT_TABLE6 *rec=arr_mainFundParentMut[indexPath.row][@"Content"];
            NSString *str_imageUrl=[NSString stringWithFormat:@"%@%@",KTImageBase_url,rec.fundDesc];
            [cell.img_bankImage setImageWithURL:[NSURL URLWithString:str_imageUrl] placeholderImage:[UIImage imageNamed:@"No_Bank"]]; 
            cell.lbl_schemeName.text=[NSString stringWithFormat:@"%@",rec.fundDesc];
            cell.lbl_units.text=[NSString stringWithFormat:@"%@",@"--"];
            cell.lbl_costValue.text=[NSString stringWithFormat:@"%@",rec.costValue];
            cell.lbl_currentValue.text=[NSString stringWithFormat:@"%@",rec.currentValue];
            cell.lbl_apprPercent.text=[NSString stringWithFormat:@"%@\n%@",rec.gainVal,rec.gainPercent];
            CGFloat absoulteGainValue=[rec.gainVal floatValue];
            if (absoulteGainValue<0) {
                cell.lbl_apprPercent.textColor=KTTextColorBrown;
                cell.img_gainImage.image=[UIImage imageNamed:@"Down"];
            }
            else{
                cell.lbl_apprPercent.textColor=KTTextColorGreen;
                cell.img_gainImage.image=[UIImage imageNamed:@"Up"];
            }
            return cell;
        }
        else{
            NSString *str_level=arr_mainFundParentMut[indexPath.row][@"level"];
            if ([str_level isEqualToString:@"0"]|| [str_level isEqual:@"0"]) {
                DetailPortfolioMiddleChildTblCell *cell=(DetailPortfolioMiddleChildTblCell*)[tableView dequeueReusableCellWithIdentifier:@"MiddleChildTblCell"];
                if (cell==nil){
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailPortfolioMiddleChildTblCell" owner:self options:nil];
                    cell = (DetailPortfolioMiddleChildTblCell *)[nib objectAtIndex:0];
                    [tableView setSeparatorColor:[UIColor blackColor]];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
                KT_TABLE14 *rec=arr_mainFundParentMut[indexPath.row][@"Content"];
                cell.lbl_schemeDesc.text=[NSString stringWithFormat:@"%@",rec.schDesc];
                cell.dic_childRec=arr_mainFundParentMut[indexPath.row];
                cell.navCustomdelegate=self;
                return cell;
            }
            else if ([str_level isEqualToString:@"1"]|| [str_level isEqual:@"1"]) {
                DetailPortfolioSubChildTblCell *cell=(DetailPortfolioSubChildTblCell*)[tableView dequeueReusableCellWithIdentifier:@"SubChildTblCell"];
                if (cell==nil){
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailPortfolioSubChildTblCell" owner:self options:nil];
                    cell = (DetailPortfolioSubChildTblCell *)[nib objectAtIndex:0];
                    [tableView setSeparatorColor:[UIColor blackColor]];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
                KT_TABLE2 *rec=arr_mainFundParentMut[indexPath.row][@"Content"];
                cell.lbl_folioNumber.text=[NSString stringWithFormat:@"Folio No.\n%@",rec.Acno];
                cell.dic_subChildList=arr_mainFundParentMut[indexPath.row];
                cell.folioCustomdelegate=self;
                return cell;
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
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
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width,0)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (searchViaFundWise==NO) {
        NSDictionary *d=[arr_mainParentMut objectAtIndex:indexPath.row];
        if([d valueForKey:@"Objects"]) {
            NSArray *ar=[d valueForKey:@"Objects"];
            BOOL isAlreadyInserted=NO;
            
            for(NSDictionary *dInner in ar ){
                NSInteger index=[arr_mainParentMut indexOfObjectIdenticalTo:dInner];
                isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                if(isAlreadyInserted) break;
            }
            
            if(isAlreadyInserted) {
                [self miniMizeThisRows:ar];
            } else {
                NSUInteger count=indexPath.row+1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NSDictionary *dInner in ar ) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [arr_mainParentMut insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
            }
        }
    }
    else{
        if (indexPath.row==0) {
            
        }
        else{
            NSDictionary *d=[arr_mainFundParentMut objectAtIndex:indexPath.row];
            if([d valueForKey:@"Objects"]) {
                NSArray *ar=[d valueForKey:@"Objects"];
                BOOL isAlreadyInserted=NO;
                
                for(NSDictionary *dInner in ar ){
                    NSInteger index=[arr_mainFundParentMut indexOfObjectIdenticalTo:dInner];
                    isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                    if(isAlreadyInserted) break;
                }
                
                if(isAlreadyInserted) {
                    [self miniMizeThisRows:ar];
                } else {
                    NSUInteger count=indexPath.row+1;
                    NSMutableArray *arCells=[NSMutableArray array];
                    for(NSDictionary *dInner in ar ) {
                        [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                        [arr_mainFundParentMut insertObject:dInner atIndex:count++];
                    }
                    [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
                }
            }
        }
    }
}

-(void)miniMizeThisRows:(NSArray*)ar{
    if (searchViaFundWise==NO) {
        for(NSDictionary *dInner in ar ) {
            NSUInteger indexToRemove=[arr_mainParentMut indexOfObjectIdenticalTo:dInner];
            NSArray *arInner=[dInner valueForKey:@"Objects"];
            if(arInner && [arInner count]>0){
                [self miniMizeThisRows:arInner];
            }
            
            if([arr_mainParentMut indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
                [arr_mainParentMut removeObjectIdenticalTo:dInner];
                [tbl_detailPortfolio deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                             [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                             ]
                                           withRowAnimation:UITableViewRowAnimationRight];
            }
        }
    }
    else{
        for(NSDictionary *dInner in ar ) {
            NSUInteger indexToRemove=[arr_mainFundParentMut indexOfObjectIdenticalTo:dInner];
            NSArray *arInner=[dInner valueForKey:@"Objects"];
            if(arInner && [arInner count]>0){
                [self miniMizeThisRows:arInner];
            }
            
            if([arr_mainFundParentMut indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
                [arr_mainFundParentMut removeObjectIdenticalTo:dInner];
                [tbl_detailPortfolioFundWise deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                             [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                             ]
                                           withRowAnimation:UITableViewRowAnimationRight];
            }
        }
    }
}

#pragma mark - Serialisation of Data

-(void)tableReloadDataForParentArray:(NSArray *)arr_mainParentArray{
    arr_mainParentMut=[NSMutableArray new];
    arr_actualMainContent=[NSMutableArray new];
    [arr_mainParentMut copy];
    [arr_actualMainContent copy];
    for (int i=0; i<arr_mainParentArray.count; i++) {
        KT_TABLE13 *rec=arr_tableParentRec[i];
        NSString *str_title=[NSString stringWithFormat:@"%@",rec.fundDesc];
        NSString *str_fund=[NSString stringWithFormat:@"%@",rec.fund];
        NSString *str_pan=[NSString stringWithFormat:@"%@",rec.PAN];
        NSString *str_schemeClass=[NSString stringWithFormat:@"%@",rec.schemeClass];
        NSMutableDictionary *new_parentDic=[NSMutableDictionary new];
        [new_parentDic setObject:str_title forKey:@"name"];
        [new_parentDic setObject:@"0" forKey:@"level"];
        [new_parentDic setObject:rec forKey:@"Content"];
        NSArray *childArray;
        if([str_fromScreen isEqual:@"PANRECORD"]){
            if ([str_schemeClass isEqual:@"ALL"] || [str_schemeClass isEqual:@"all"] || [str_schemeClass isEqual:@"All"]) {
                if (executeWithZeroFolios==NO) {
                    childArray=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable14:[NSString stringWithFormat:@"SELECT * FROM TABLE14_DETAILS WHERE CAST(costValue as decimal)>0 AND fund='%@' AND PAN ='%@' ORDER BY currentValue ASC", str_fund, str_pan]];
                }
                else{
                    childArray=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable14:[NSString stringWithFormat:@"SELECT * FROM TABLE14_DETAILS WHERE fund='%@' AND PAN ='%@' ORDER BY currentValue ASC",str_fund,str_pan]];
                }
            }
            else{
                if (executeWithZeroFolios==NO) {
                    childArray=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable14:[NSString stringWithFormat:@"SELECT * FROM TABLE14_DETAILS WHERE CAST(costValue as decimal)>0 AND schemeClass='%@' AND fund='%@' AND PAN ='%@' ORDER BY currentValue ASC", str_schemeClass, str_fund, str_pan]];
                }
                else{
                    childArray=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable14:[NSString stringWithFormat:@"SELECT * FROM TABLE14_DETAILS WHERE schemeClass='%@' AND fund='%@' AND PAN ='%@' ORDER BY currentValue ASC",str_schemeClass,str_fund,str_pan]];
                }
            }
        }
        else{
            if (executeWithZeroFolios==NO) {
                childArray=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable14:[NSString stringWithFormat:@"SELECT * FROM TABLE14_DETAILS WHERE CAST(costValue as decimal)>0  AND fund='%@' AND PAN ='%@' ORDER BY currentValue DESC", str_fund, str_pan]];
            }
            else{
                childArray=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable14:[NSString stringWithFormat:@"SELECT * FROM TABLE14_DETAILS WHERE fund='%@' AND PAN ='%@' ORDER BY currentValue DESC",str_fund,str_pan]];
            }
        }
        NSMutableArray *arr_childMut=[NSMutableArray new];
        for (int i=0; i<childArray.count; i++) {
            NSMutableDictionary *new_childDic=[NSMutableDictionary new];
            KT_TABLE14 *childRec=childArray[i];
            NSString *str_title=[NSString stringWithFormat:@"%@",childRec.schDesc];
            NSString *str_plnDesc=[NSString stringWithFormat:@"%@",childRec.pln];
            NSString *str_schemeDesc=[NSString stringWithFormat:@"%@",childRec.sch];
            [new_childDic setObject:str_title forKey:@"name"];
            [new_childDic setObject:@"1" forKey:@"level"];
            [new_childDic setObject:childRec forKey:@"Content"];
            NSArray *subChild;
            if (executeWithZeroFolios==NO) {
                subChild=[[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS WHERE fund='%@' AND PAN ='%@'AND CAST(costValue as decimal)>0 AND pln='%@' AND sch='%@' ORDER BY curValue DESC", str_fund, str_pan, str_plnDesc, str_schemeDesc]];
            }
            else {
                subChild=[[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS WHERE fund='%@' AND PAN ='%@'AND pln='%@' AND sch='%@' ORDER BY curValue DESC", str_fund, str_pan, str_plnDesc,str_schemeDesc]];
            }
            NSMutableArray *arr_mutSubChild=[NSMutableArray new];
            for (int i=0; i<subChild.count; i++) {
                NSMutableDictionary *new_subChildDic=[NSMutableDictionary new];
                KT_TABLE2 *table_rec=subChild[i];
                NSString *str_title=[NSString stringWithFormat:@"Folio No.\n%@",table_rec.Acno];
                [new_subChildDic setObject:str_title forKey:@"name"];
                [new_subChildDic setObject:@"2" forKey:@"level"];
                [new_subChildDic setObject:table_rec forKey:@"Content"];
                [arr_mutSubChild addObject:new_subChildDic];
            }
            [new_childDic setObject:arr_mutSubChild forKey:@"Objects"];
            [arr_childMut addObject:new_childDic];
        }
        [new_parentDic setObject:arr_childMut forKey:@"Objects"];
        [arr_mainParentMut addObject:new_parentDic];
    }
    [arr_actualMainContent addObjectsFromArray:arr_mainParentMut];
    if (arr_mainParentMut.count==0) {
        [view_headerView setHidden:YES];
        [lbl_zeroFolioMeesageDisplay setHidden:NO];
        [txt_search setUserInteractionEnabled:NO];
        [tbl_detailPortfolio setHidden:YES];
        [tbl_detailPortfolioFundWise setHidden:YES];
    }
    else{
        [view_headerView setHidden:NO];
        [tbl_detailPortfolio setHidden:NO];
        [txt_search setUserInteractionEnabled:YES];
        [tbl_detailPortfolioFundWise setHidden:YES];
        [lbl_zeroFolioMeesageDisplay setHidden:YES];
        [tbl_detailPortfolio reloadData];
    }
}

#pragma mark - load Parent Records Based Funds

-(void)tableReloadDataForParentFundBasedArray:(NSArray *)parentRec{
    arr_mainFundParentMut=[NSMutableArray new];
    arr_actualMainContent=[NSMutableArray new];
    [arr_mainFundParentMut copy];
    [arr_actualMainContent copy];
    for (int i=0; i<parentRec.count; i++) {
        KT_TABLE6 *rec=parentRec[i];
        NSMutableDictionary *new_newChildDic=[NSMutableDictionary new];
        NSString *str_title=[NSString stringWithFormat:@"%@",rec.fundDesc];
        [new_newChildDic setObject:str_title forKey:@"name"];
        [new_newChildDic setObject:parentRec[i] forKey:@"Content"];
        [arr_mainFundParentMut addObject:new_newChildDic];
        NSString *str_fund=[NSString stringWithFormat:@"%@",rec.fund];
        NSString *str_pan=[NSString stringWithFormat:@"%@",rec.PAN];
        NSArray *childArray;
        if (executeWithZeroFolios==NO) {
            childArray=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable14:[NSString stringWithFormat:@"SELECT * FROM TABLE14_DETAILS WHERE CAST(costValue as decimal)>0 AND fund='%@' AND PAN ='%@' ORDER BY currentValue DESC", str_fund, str_pan]];
        }
        else{
            childArray=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable14:[NSString stringWithFormat:@"SELECT * FROM TABLE14_DETAILS WHERE fund='%@' AND PAN ='%@' ORDER BY currentValue DESC",str_fund,str_pan]];
        }
        for (int i=0; i<childArray.count; i++) {
            NSMutableDictionary *new_childDic=[NSMutableDictionary new];
            KT_TABLE14 *childRec=childArray[i];
            NSString *str_title=[NSString stringWithFormat:@"%@",childRec.schDesc];
            NSString *str_plnDesc=[NSString stringWithFormat:@"%@",childRec.pln];
            NSString *str_schemeDesc=[NSString stringWithFormat:@"%@",childRec.sch];
            [new_childDic setObject:str_title forKey:@"name"];
            [new_childDic setObject:@"0" forKey:@"level"];
            [new_childDic setObject:childRec forKey:@"Content"];
            NSArray *subChild;
            if (executeWithZeroFolios==NO) {
                subChild=[[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS WHERE fund='%@' AND PAN ='%@'AND CAST(costValue as decimal)>0 AND pln='%@' AND sch='%@' ORDER BY curValue DESC",str_fund,str_pan,str_plnDesc,str_schemeDesc]];
            }
            else {
                subChild=[[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS WHERE fund='%@' AND PAN ='%@' AND pln='%@' AND sch='%@' ORDER BY curValue DESC",str_fund,str_pan,str_plnDesc,str_schemeDesc]];
            }
            NSMutableArray *arr_mutSubChild=[NSMutableArray new];
            for (int i=0; i<subChild.count; i++) {
                NSMutableDictionary *new_subChildDic=[NSMutableDictionary new];
                KT_TABLE2 *table_rec=subChild[i];
                NSString *str_title=[NSString stringWithFormat:@"Folio No.\n%@",table_rec.Acno];
                [new_subChildDic setObject:str_title forKey:@"name"];
                [new_subChildDic setObject:@"1" forKey:@"level"];
                [new_subChildDic setObject:table_rec forKey:@"Content"];
                [arr_mutSubChild addObject:new_subChildDic];
            }
            [new_childDic setObject:arr_mutSubChild forKey:@"Objects"];
            [arr_mainFundParentMut addObject:new_childDic];
        }
    }
    [arr_actualMainContent addObjectsFromArray:arr_mainFundParentMut];
    if (arr_mainFundParentMut.count==0) {
        [view_headerView setHidden:YES];
        [txt_search setUserInteractionEnabled:NO];
        [lbl_zeroFolioMeesageDisplay setHidden:NO];
        [tbl_detailPortfolio setHidden:YES];
        [tbl_detailPortfolioFundWise setHidden:YES];
    }
    else{
        [view_headerView setHidden:NO];
        [txt_search setUserInteractionEnabled:YES];
        [lbl_zeroFolioMeesageDisplay setHidden:YES];
        [tbl_detailPortfolio setHidden:YES];
        [tbl_detailPortfolioFundWise setHidden:NO];
        [tbl_detailPortfolioFundWise reloadData];
    }
}

#pragma mark - button Action of TableView Cell Custom Delegate of Required methods

-(void)aditionalPurchaseCustomDelegate:(KT_TABLE2 *)resultantdic{
    NSString *str_recPAN=[XTAPP_DELEGATE removeNullFromStr:resultantdic.PAN];
    if (str_recPAN.length==0 || [str_recPAN isEqualToString:@""] || [str_recPAN isEqual:@""]) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTMessage withMessage:@"Additional purchase cannot be done for minor pan"];
    }
    else{
        NSArray *familyPanRecFound= [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE Not flag='P' AND PAN ='%@'",str_recPAN]];
        if (familyPanRecFound.count>0) {
            [[SharedUtility sharedInstance] showAlertWithTitleWithSingleAction:KTMessage forMessage:@"You are initiating transaction for your Family Member" andAction1:@"OK" andAction1Block:^{
                AddPurchaseFamilyVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"AddPurchaseFamilyVC"];
                destination.selected_Rec=resultantdic;
                destination.str_fromScreen = @"details";
                KTPUSH(destination,YES);
            }];
        }
        else{
            AddPurchaseVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"AddPurchaseVC"];
            destination.selected_Rec=resultantdic;
            destination.str_fromScreen = @"details";
            KTPUSH(destination,YES);
        }
    }
}

-(void)switchCustomDelegate:(KT_TABLE2 *)resultantDic{
    NSString *str_recPAN=[XTAPP_DELEGATE removeNullFromStr:resultantDic.PAN];
    if (str_recPAN.length==0 || [str_recPAN isEqualToString:@""] || [str_recPAN isEqual:@""]) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTMessage withMessage:@"Switching of folio cannot be done for minor pan"];
    }
    else{
        NSArray *familyPanRecFound= [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE Not flag='P' AND PAN ='%@'",str_recPAN]];
        if (familyPanRecFound.count>0) {
            [[SharedUtility sharedInstance] showAlertWithTitleWithSingleAction:KTMessage forMessage:@"You are initiating transaction for your Family Member" andAction1:@"OK" andAction1Block:^{
                SwitchWithfamliyVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SwitchWithfamliyVC"];
                destination.selected_Rec=resultantDic;
                destination.str_fromScreen = @"details";
                KTPUSH(destination,YES);
            }];
        }
        else{
            SwitchVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SwitchVC"];
            destination.selected_Rec=resultantDic;
            destination.str_fromScreen = @"details";
            KTPUSH(destination,YES);
        }
    }
}

-(void)redemptionCustomDelegate:(KT_TABLE2 *)resultantdic{
    NSString *str_recPAN=[XTAPP_DELEGATE removeNullFromStr:resultantdic.PAN];
    if (str_recPAN.length==0 || [str_recPAN isEqualToString:@""] || [str_recPAN isEqual:@""]) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTMessage withMessage:@"Redemption cannot be done for minor pan"];
    }
    else{
        NSArray *familyPanRecFound= [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE Not flag='P' AND PAN ='%@'",str_recPAN]];
        if (familyPanRecFound.count>0) {
            [[SharedUtility sharedInstance] showAlertWithTitleWithSingleAction:KTMessage forMessage:@"You are initiating transaction for your Family Member" andAction1:@"OK" andAction1Block:^{
                RedemptonWithFamliy *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"RedemptonWithFamliy"];
                destination.selected_Rec=resultantdic;
                destination.str_fromScreen = @"details";
                KTPUSH(destination,YES);
                
            }];
        }
        else{
            RedemptonVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"RedemptonVC"];
            destination.selected_Rec=resultantdic;
            destination.str_fromScreen = @"details";
            KTPUSH(destination,YES);
        }
    }
}

-(void)latestYieldCustomDelegate:(KT_TABLE2 *)resultantDic{
    [self getLatestYieldsFromAPI:resultantDic];
}

#pragma mark - get LatestYields

-(void)getLatestYieldsFromAPI:(KT_TABLE2 *)latestYieldRec{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fundID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",latestYieldRec.fund]];
    NSString *str_schemeName=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",latestYieldRec.sch]];
    NSString *str_plan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",latestYieldRec.pln]];
    NSString *str_opt=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",latestYieldRec.opt]];
    NSString *str_folio=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",latestYieldRec.Acno]];
    NSString *str_url = [NSString stringWithFormat:@"%@PortfolioInvestmentDetails?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Scheme=%@&Plan=%@&Opt=%@&Folio=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fundID,str_schemeName,str_plan,str_opt,str_folio];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        NSArray *arr_res=responce[@"Dtinformation"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (arr_res.count>0) {
                LatestYieldPopupVC *destinationController=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"LatestYieldPopupVC"];
                destinationController.latestYieldRec=arr_res[0];
                [self addChildViewController:destinationController];
                [self.view addSubview:destinationController.view];
                [destinationController didMoveToParentViewController:self];
              
            }
            else{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTMessage withMessage:@"Couldn't fetch Latest yield details"];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

-(void)netAssetValueCustomDelegate:(KT_TABLE14 *)resultantdic{
    NetAssetValueGraphVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"NetAssetValueGraphVC"];
    destination.str_fromScreen=@"DetailPort";
    destination.selected_Rec=resultantdic;
    [self.navigationController pushViewController:destination animated:YES];
}


-(void)downloadStatementDelegate:(KT_TABLE2 *)resultantDic{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:XTOnlyDateFormat];
    NSString *dateToday=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    NSString *str_todaysDate=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",dateToday]];
    NSString *str_fundID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",resultantDic.fund]];
    NSString *str_schemeName=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",resultantDic.sch]];
    NSString *str_plan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",resultantDic.pln]];
    NSString *str_opt=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",resultantDic.opt]];
    NSString *str_folio=[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@",resultantDic.Acno]];
    NSString *str_url = [NSString stringWithFormat:@"%@Ktrack_GetAccountStatement?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&i_toDt=%@&i_scheme=%@&Fund=%@&i_option=%@&i_acno=%@&i_frmDt=%@&i_plan=%@",@"https://api.karvymfs.com/22/SmartService.svc/", unique_UDID, str_operatingSystem, str_appVersion, str_todaysDate, str_schemeName, str_fundID, str_opt, str_folio, str_todaysDate, str_plan];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
            if (error_statuscode==0) {
                FolioAccSummary *destinationController=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"FolioAccSummary"];
                destinationController.str_pdfFilePathUrl=[NSString stringWithFormat:@"%@",responce[@"Table2"][0][@"Fdata"]];
                KTPUSH(destinationController,NO);
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table1"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];            }
        });
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - TextViewDelegate

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView==txt_search) {
        if ([textView.text isEqualToString:@""]) {
            textView.text =@"Search";
            textView.textColor = [UIColor lightGrayColor]; //optional
        }
    }
    [textView resignFirstResponder];
    return YES;
}

- (void) textViewDidBeginEditing:(UITextView *) textView {
    if (textView==txt_search) {
        if ([textView.text isEqualToString:@"Search"]) {
            [textView setText:@""];
            textView.textColor = [UIColor blackColor]; //optional
        }
    }
    [textView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView becomeFirstResponder];
        return NO;
    }
    else{
        if (textView == txt_search) {
            NSString *stringToSearch=[NSString stringWithFormat:@"%@%@",txt_search.text,text];
            if (stringToSearch.length>1){
                stringToSearch = [stringToSearch stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@",stringToSearch];
                if (searchViaFundWise==NO) {
                    NSArray *arr_search= [arr_actualMainContent filteredArrayUsingPredicate:predicate];
                    arr_mainParentMut=[NSMutableArray new];
                    [arr_mainParentMut copy];
                    [arr_mainParentMut addObjectsFromArray:arr_search];
                    if (arr_mainParentMut.count==0){
                         [tbl_detailPortfolio setHidden:YES];
                         [lbl_zeroFolioMeesageDisplay setHidden:NO];
                    }else {
                         [tbl_detailPortfolio setHidden:NO];
                         [lbl_zeroFolioMeesageDisplay setHidden:YES];
                         [tbl_detailPortfolio reloadData];
                    }
                }
                else{
                    @try{
                        NSArray *zero_indexObj=arr_actualMainContent[0];
                        NSMutableArray *remainingObj=[NSMutableArray new];
                        for (int i=1; i<arr_actualMainContent.count;i++) {
                            [remainingObj addObject:arr_actualMainContent[i]];
                        }
                        NSArray *arr_search= [remainingObj filteredArrayUsingPredicate:predicate];
                        arr_mainFundParentMut=[NSMutableArray new];
                        [arr_mainFundParentMut copy];
                        [arr_mainFundParentMut addObject:zero_indexObj];
                        [arr_mainFundParentMut addObjectsFromArray:arr_search];
                        if (arr_mainFundParentMut.count==0){
                            [tbl_detailPortfolioFundWise setHidden:YES];
                            [lbl_zeroFolioMeesageDisplay setHidden:NO];
                        }else {
                            [tbl_detailPortfolioFundWise setHidden:NO];
                            [lbl_zeroFolioMeesageDisplay setHidden:YES];
                            [tbl_detailPortfolioFundWise reloadData];
                        }
                    }
                    @catch(NSException *exception){
                        arr_mainFundParentMut=[NSMutableArray new];
                        [arr_mainFundParentMut copy];
                        [arr_mainFundParentMut addObjectsFromArray:arr_actualMainContent];
                        [tbl_detailPortfolioFundWise reloadData];
                    }
                }
            }else{
                if (searchViaFundWise==NO) {
                    arr_mainParentMut=[NSMutableArray new];
                    [arr_mainParentMut copy];
                    [arr_mainParentMut addObjectsFromArray:arr_actualMainContent];
                    [tbl_detailPortfolio reloadData];
                }
                else{
                    arr_mainFundParentMut=[NSMutableArray new];
                    [arr_mainFundParentMut copy];
                    [arr_mainFundParentMut addObjectsFromArray:arr_actualMainContent];
                    [tbl_detailPortfolioFundWise reloadData];
                }
            }
        }
    }
    return YES;
}

#pragma mark - TextView Delegate Methods Ends

#pragma mark - search closed tapped

- (IBAction)btn_searchClosedTapped:(id)sender {
    txt_search.text=@"";
    [txt_search resignFirstResponder];
    if (searchViaFundWise==NO) {
        [tbl_detailPortfolio setHidden:NO];
        [lbl_zeroFolioMeesageDisplay setHidden:YES];
        arr_mainParentMut=[NSMutableArray new];
        [arr_mainParentMut copy];
        [arr_mainParentMut addObjectsFromArray:arr_actualMainContent];
        [tbl_detailPortfolio reloadData];
    }
    else{
        [tbl_detailPortfolioFundWise setHidden:NO];
        [lbl_zeroFolioMeesageDisplay setHidden:YES];
        arr_mainFundParentMut=[NSMutableArray new];
        [arr_mainFundParentMut copy];
        [arr_mainFundParentMut addObjectsFromArray:arr_actualMainContent];
        [tbl_detailPortfolioFundWise reloadData];
    }
}

#pragma mark - search Start tapped

- (IBAction)btn_searchStartTapped:(id)sender {
    [txt_search becomeFirstResponder];
}

@end
