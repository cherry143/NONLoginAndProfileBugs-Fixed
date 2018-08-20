//
//  PortfolioVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 23/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "PortfolioVC.h"

@interface PortfolioVC ()<UIPickerViewDelegate,UIPickerViewDataSource,commonCustomDelegate>{
    __weak IBOutlet UIImageView *img_todaysGain;
    __weak IBOutlet UITableView *tbl_portfolioList;
    __weak IBOutlet UIImageView *img_overallGain;
    __weak IBOutlet UIView *view_assestDetails;
    __weak IBOutlet UIButton *btn_liquid;
    __weak IBOutlet UIButton *btn_debt;
    __weak IBOutlet UIButton *btn_equity;
    __weak IBOutlet UIButton *btn_minorPortfolio;
    __weak IBOutlet UIButton *btn_totalPortfolio;
    __weak IBOutlet UIButton *btn_myPortfolio;
    __weak IBOutlet UIButton *btn_familyPortfolio;
    __weak IBOutlet KATCircularProgress *view_pieChart;
    __weak IBOutlet UILabel *lbl_portfolioViewTxt;
    __weak IBOutlet UILabel *lbl_fundWiseValue;
    __weak IBOutlet UILabel *lbl_todaysGainPrice;
    __weak IBOutlet UILabel *lbl_overallGainPrice;
    __weak IBOutlet UILabel *lbl_costValuePrice;
    __weak IBOutlet UILabel *lbl_underAssertPrice;
    __weak IBOutlet UIView *view_todaysGain;
    __weak IBOutlet UIView *view_overallGain;
    __weak IBOutlet UIView *view_cost;
    __weak IBOutlet UIView *view_assert;
    __weak IBOutlet UIView *view_fund;
    NSArray *arr_portfolioList;
    NSArray *pan_familyDetails;
    NSString *str_myPan,*str_userSelectedPan;
    __weak IBOutlet UIView *view_tblBackGroundView;
    __weak IBOutlet NSLayoutConstraint *tbl_heightConstraint;
    __weak IBOutlet UIView *view_scrollMainView;
    __weak IBOutlet UIScrollView *scroll_mainScroll;
    __weak IBOutlet NSLayoutConstraint *constraint_txtHeight;
    __weak IBOutlet UIButton *btn_drop;
    __weak IBOutlet UITextField *txt_familyMember;
    UIPickerView *picker_dropDown;
    __weak IBOutlet UIView *view_marqueeLbl;
    __weak IBOutlet MarqueeLabel *lbl_noFolioMessage;
    NSString *str_typeOfPortfolio;
    __weak IBOutlet MarqueeLabel *lbl_investorName;
    __weak IBOutlet UIButton *btn_clickHere;
    __weak IBOutlet UIButton *btn_backward;
    __weak IBOutlet UIButton *btn_forward;
    int currentButtonCount;
    int originalBtnCount;
    BOOL familyRecFound;
    BOOL minorRecFound;
}

@end

@implementation PortfolioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseBorderColor];
    [txt_familyMember setHidden:YES];
    [btn_drop setHidden:YES];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"Portfolio"];
}

#pragma mark - viewWillLayoutSubviews

-(void)viewWillLayoutSubviews{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - fetch Records

-(void)fetchTableRecordSectionBasedOnPAN:(NSString *)pan{
    arr_portfolioList =[[DBManager sharedDataManagerInstance]fetchRecordFromTable4:[NSString stringWithFormat:@"SELECT * FROM TABLE4_DETAILS WHERE PAN='%@' order By percentage DESC",pan]];
    if (arr_portfolioList.count==0) {
        [tbl_portfolioList setHidden:YES];
        [view_pieChart.sliceItems removeAllObjects];
        [btn_equity setTitle:[NSString stringWithFormat:@"Equity 0.0%%"] forState:UIControlStateNormal];
        [btn_debt setTitle:[NSString stringWithFormat:@"Debt 0.0%%"] forState:UIControlStateNormal];
        [btn_liquid setTitle:[NSString stringWithFormat:@"Liquid 0.0%%"] forState:UIControlStateNormal];
        [view_pieChart setLineWidth:5.0f];
        SliceItem *item1 = [[SliceItem alloc] init];
        item1.itemColor=[UIColor lightGrayColor];
        item1.itemValue = 100.00f;
        [view_pieChart.sliceItems addObject:item1];
        [view_pieChart reloadData];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [tbl_portfolioList setHidden:NO];
            [tbl_portfolioList reloadData];
            [view_pieChart setLineWidth:25.0];
            [self addSliceItems];
            [view_pieChart reloadData];
        });
    }
}

#pragma mark - show No records in Table2 and No Pan Records Found

-(void)showNoRecordAlerts{
    [scroll_mainScroll setHidden:YES];
    [view_assestDetails setHidden:YES];
    NSString *str_donotshowAlert=[[SharedUtility sharedInstance]readStringUserPreference:KTFetchFolioThroughMobileNo];
    if (str_donotshowAlert.length==0) {
        [[SharedUtility sharedInstance]showAlertWithTitle:KTMessage forMessage:KTNoFoliosAssociatedMsg andAction1:@"YES" andAction2:@"NO" andAction1Block:^{
            [self showMessagePopup:@"MobilePopup"];
        } andCancelBlock:^{
            lbl_investorName.text=[NSString stringWithFormat:@"Welcome, %@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]]];
            [lbl_investorName setAttributedText:[lbl_investorName boldSubstringForLabel:lbl_investorName forFirstString:@"Welcome," forSecondString:[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]]]];
            [view_marqueeLbl setHidden:NO];
            [[SharedUtility sharedInstance]writeStringUserPreference:KTFetchFolioThroughMobileNo value:@"NoMobile"];
        }];
    }
    else{
        lbl_investorName.text=[NSString stringWithFormat:@"Welcome, %@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]]];
        [lbl_investorName setAttributedText:[lbl_investorName boldSubstringForLabel:lbl_investorName forFirstString:@"Welcome," forSecondString:[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]]]];
        [view_marqueeLbl setHidden:NO];
    }
}

#pragma mark - fetch Pan Details

-(void)fetchPanDetailsBasedOnFlag{
    NSArray *folioRec=[[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS"]];
    if(folioRec.count==0){
        [self showNoRecordAlerts];
    }
    else{
        NSArray *panDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS"]];
        if (panDetails.count==0) {
            [self showNoRecordAlerts];
        }
        else{
            NSArray *arr_primaryPan = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='%@'",@"P"]];
            if (arr_primaryPan.count>0) {
                NSArray *arr_folioRec= [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS"]];
                if (arr_folioRec.count!=0) {
                    [btn_myPortfolio setBackgroundColor:KTButtonBackGroundBlue];
                    [btn_myPortfolio setTitleColor:KTWhiteColor forState:UIControlStateNormal];
                    [btn_familyPortfolio setBackgroundColor:KTButtonNotSelectedColor];
                    [btn_familyPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
                    [btn_minorPortfolio setBackgroundColor:KTButtonNotSelectedColor];
                    [btn_minorPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
                    [btn_totalPortfolio setBackgroundColor:KTButtonNotSelectedColor];
                    [btn_totalPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
                    [scroll_mainScroll setHidden:NO];
                    [view_assestDetails setHidden:NO];
                    [view_marqueeLbl setHidden:YES];
                    KT_TABLE12 *rec_primaryPan=arr_primaryPan[0];
                    str_myPan=rec_primaryPan.PAN;
                    str_userSelectedPan=str_myPan;
                    str_typeOfPortfolio=@"MyPortfolio";
                    [self fetchTableRecordSectionBasedOnPAN:rec_primaryPan.PAN];
                    [self fetchTopSectionRecordsBaseOnPAN:rec_primaryPan.PAN];
                    pan_familyDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE Not flag='P'"]];
                    if (pan_familyDetails.count>0) {
                        [btn_familyPortfolio setHidden:NO];
                        if (pan_familyDetails.count>1) {
                            [txt_familyMember setUserInteractionEnabled:YES];
                            txt_familyMember.inputView=picker_dropDown;
                            [picker_dropDown reloadAllComponents];
                        }
                        else{
                            [txt_familyMember setUserInteractionEnabled:NO];
                        }
                    }
                    else{
                        [btn_familyPortfolio setHidden:YES];
                    }
                    NSArray *minorRecordDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='%@' AND minor ='Y'",@"P"]];
                    if (minorRecordDetails.count==0) {
                        [btn_minorPortfolio setHidden:YES];
                    }
                    else{
                        [btn_minorPortfolio setHidden:NO];
                    }
                    if (pan_familyDetails.count>0 || minorRecordDetails.count>0) {
                        [btn_totalPortfolio setHidden:NO];
                    }
                    else{
                        [btn_totalPortfolio setHidden:YES];
                    }
                    if (pan_familyDetails.count==0 && minorRecordDetails.count==0) {
                        originalBtnCount=1;
                        [btn_forward setHidden:YES];
                        [btn_backward setHidden:YES];
                        currentButtonCount=1;
                    }
                    if (pan_familyDetails.count>0 && minorRecordDetails.count==0) {
                        [btn_forward setHidden:NO];
                        [btn_backward setHidden:NO];
                        originalBtnCount=3;
                        currentButtonCount=2;
                        familyRecFound=YES;
                        minorRecFound=NO;
                    }
                    if (pan_familyDetails.count==0 && minorRecordDetails.count>0) {
                        [btn_forward setHidden:NO];
                        [btn_backward setHidden:NO];
                        originalBtnCount=3;
                        currentButtonCount=2;
                        familyRecFound=NO;
                        minorRecFound=YES;
                    }
                    if (pan_familyDetails.count>0 && minorRecordDetails.count>0) {
                        [btn_forward setHidden:NO];
                        [btn_backward setHidden:NO];
                        originalBtnCount=4;
                        currentButtonCount=3;
                        familyRecFound=YES;
                        minorRecFound=YES;
                    }
                }
                else{
                    [view_marqueeLbl setHidden:NO];
                    [scroll_mainScroll setHidden:YES];
                    [view_assestDetails setHidden:YES];
                }
            }
            else{
                [scroll_mainScroll setHidden:YES];
                [view_assestDetails setHidden:YES];
                [self showMessagePopup:@"PANPopup"];
            }
        }
    }
}

-(void)fetchTopSectionRecordsBaseOnPAN:(NSString *)pan{
    NSArray *panDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable6:[NSString stringWithFormat:@"SELECT * FROM TABLE6_DETAILS where PAN='%@' AND fundDesc='Total'",pan]];
    if (panDetails.count==0) {
        lbl_underAssertPrice.text=[NSString stringWithFormat:@"Assets Under Management\n₹"];
        lbl_costValuePrice.text=[NSString stringWithFormat:@"Cost Value\n₹"];
        lbl_overallGainPrice.text=[NSString stringWithFormat:@"Overall Appr.\n₹\n(0%%)"];
        lbl_todaysGainPrice.text=[NSString stringWithFormat:@"Today's Appr.\n₹"];
        lbl_fundWiseValue.text=@"Fund wise\nAUM";
        [img_todaysGain setImage:[UIImage imageNamed:@""]];
        [img_overallGain setImage:[UIImage imageNamed:@""]];
    }
    else{
        KT_TABLE6 *assest_rec=panDetails[0];
        lbl_underAssertPrice.text=[NSString stringWithFormat:@"Assets Under Management\n₹ %@",assest_rec.currentValue];
        lbl_costValuePrice.text=[NSString stringWithFormat:@"Cost Value\n₹ %@",assest_rec.costValue];
        CGFloat overallGain=[assest_rec.gainPercent floatValue];
        lbl_overallGainPrice.text=[NSString stringWithFormat:@"Overall Appr.\n₹ %@\n(%.1f%%)",assest_rec.gainVal,[assest_rec.gainPercent floatValue]];
        if (overallGain<0) {
            [img_overallGain setImage:[UIImage imageNamed:@"Down"]];
        }
        else{
            [img_overallGain setImage:[UIImage imageNamed:@"Up"]];
        }
        CGFloat todaysGain=[assest_rec.todayGain floatValue];
        lbl_todaysGainPrice.text=[NSString stringWithFormat:@"Today's Appr.\n₹ %.2f",todaysGain];
        lbl_fundWiseValue.text=@"Fund wise\nAUM";
        if (todaysGain<0) {
           [img_todaysGain setImage:[UIImage imageNamed:@"Down"]];
        }
        else{
           [img_todaysGain setImage:[UIImage imageNamed:@"Up"]];
        }
       
    }
}

#pragma mark - apply border color

-(void)initialiseBorderColor{
    [view_pieChart setAnimationDuration:1.0]; // Set Animation Duration.
    [UIView roundedCornerEnableForView:view_cost forCornerRadius:5.0f forBorderWidth:1.5f forApplyShadow:NO];
    [UIView roundedCornerEnableForView:view_assert forCornerRadius:5.0f forBorderWidth:1.5f forApplyShadow:NO];
    [UIView roundedCornerEnableForView:view_fund forCornerRadius:5.0f forBorderWidth:1.5f forApplyShadow:NO];
    [UIView roundedCornerEnableForView:view_overallGain forCornerRadius:5.0f forBorderWidth:1.5f forApplyShadow:NO];
    [UIView roundedCornerEnableForView:view_todaysGain forCornerRadius:5.0f forBorderWidth:1.5f forApplyShadow:NO];
    [UITextField withoutRoundedCornerTextField:txt_familyMember forCornerRadius:5.0f forBorderWidth:1.5f];
    [UIButton roundedCornerButtonWithoutBackground:btn_clickHere forCornerRadius:KTiPad?25.0f:btn_clickHere.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    [view_marqueeLbl setHidden:YES];
    lbl_noFolioMessage.text=KTNoPortfolioHoldingMsg;
    [scroll_mainScroll setHidden:YES];
    [view_assestDetails setHidden:YES];
}

#pragma mark - View Did Appear

-(void)viewDidAppear:(BOOL)animated {
    [self fetchPanDetailsBasedOnFlag];
    [self hideTextFieldHeightTxtFieldHeight:0];
}

- (void)addSliceItems {
    [view_pieChart.sliceItems removeAllObjects];
    [btn_equity setHidden:YES];
    [btn_debt setHidden:YES];
    [btn_liquid setHidden:YES];
    for (KT_TABLE4 *rec in arr_portfolioList) {
        SliceItem *item1 = [[SliceItem alloc] init];
        if ([rec.name isEqualToString:@"Equity"]) {
            item1.itemColor = KTPieChartDebtColor;
            [btn_equity setTitle:[NSString stringWithFormat:@"Equity %.1f%%",[rec.percentage floatValue]] forState:UIControlStateNormal];
            [btn_equity setHidden:NO];
        }
        else if ([rec.name isEqualToString:@"Debt"]){
            item1.itemColor=KTPieChartEquityColor;
            [btn_debt setTitle:[NSString stringWithFormat:@"Debt %.1f%%",[rec.percentage floatValue]] forState:UIControlStateNormal];
            [btn_debt setHidden:NO];
        }
        else if ([rec.name isEqualToString:@"Liquid"]) {
            item1.itemColor =KTPieChartLiquidColor;
            [btn_liquid setTitle:[NSString stringWithFormat:@"Liquid %.1f%%",[rec.percentage floatValue]] forState:UIControlStateNormal];
            [btn_liquid setHidden:NO];
         }
        item1.itemValue = [rec.percentage floatValue];
        [view_pieChart.sliceItems addObject:item1];
    }
}

#pragma mark - TableView Delegate and Data Source delegate starts

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_portfolioList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PortfolioListTblCell *cell=(PortfolioListTblCell*)[tableView dequeueReusableCellWithIdentifier:@"Portfolio"];
    if (cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PortfolioListTblCell" owner:self options:nil];
        cell = (PortfolioListTblCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    KT_TABLE4 *rec=arr_portfolioList[indexPath.row];
    NSString *str_scheme=[NSString stringWithFormat:@"%@",rec.name];
    if ([str_scheme isEqualToString:@"Equity"] || [str_scheme isEqual:@"Equity"]) {
        [cell.btn_fundCategory setTitle:str_scheme forState:UIControlStateNormal];
        [cell.btn_fundCategory setImage:[UIImage imageNamed:@"Blue"] forState:UIControlStateNormal];
    }
    else if ([str_scheme isEqualToString:@"Liquid"] || [str_scheme isEqual:@"Liquid"]) {
        [cell.btn_fundCategory setTitle:str_scheme forState:UIControlStateNormal];
        [cell.btn_fundCategory setImage:[UIImage imageNamed:@"Green"] forState:UIControlStateNormal];
    }
    else if ([str_scheme isEqualToString:@"Debt"] || [str_scheme isEqual:@"Debt"]) {
        [cell.btn_fundCategory setTitle:str_scheme forState:UIControlStateNormal];
        [cell.btn_fundCategory setImage:[UIImage imageNamed:@"Red"] forState:UIControlStateNormal];
    }
    cell.lbl_costValue.text=[NSString stringWithFormat:@"%@",rec.costValue];
    cell.lbl_currentValue.text=[NSString stringWithFormat:@"%@",rec.currentValue];
    cell.lbl_absoluteGain.text=[NSString stringWithFormat:@"%@\n%.1f%%",rec.gainVal,[rec.gainPercent floatValue]];
    CGFloat absoulteGainValue=[rec.gainVal floatValue];
    if (absoulteGainValue<0) {
        cell.lbl_absoluteGain.textColor=KTTextColorBrown;
    }
    else{
        cell.lbl_absoluteGain.textColor=KTTextColorGreen;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
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
    PortfolioListTblCell *headerView=(PortfolioListTblCell*)[tableView dequeueReusableCellWithIdentifier:@"Portfolio"];
    if (headerView==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PortfolioListTblCell" owner:self options:nil];
        headerView = (PortfolioListTblCell *)[nib objectAtIndex:0];
        headerView.selectionStyle=UITableViewCellSelectionStyleNone;
        headerView.backgroundColor=[UIColor whiteColor];
    }
    [headerView.btn_fundCategory setHidden:YES];
    [headerView.img_sideDrop setHidden:YES];
    headerView.lbl_costValue.font=KTFontFamilySize(KTOpenSansRegular,10);
    headerView.lbl_currentValue.font=KTFontFamilySize(KTOpenSansRegular,10);
    headerView.lbl_absoluteGain.font=KTFontFamilySize(KTOpenSansRegular,10);
    [headerView.lbl_costValue setText:@"Cost value(₹)"];
    [headerView.lbl_currentValue setText:@"Current value(₹)"];
    [headerView.lbl_absoluteGain setText:@"Appreciation"];
    [headerView.lbl_absoluteGain setTextColor:KTButtonBackGroundBlue];
    [headerView.lbl_costValue setTextColor:KTButtonBackGroundBlue];
    [headerView.lbl_currentValue setTextColor:KTButtonBackGroundBlue];

    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KT_TABLE4 *rec=arr_portfolioList[indexPath.row];
    NSString *str_pan=[NSString stringWithFormat:@"%@",rec.PAN];
    NSString *str_scheme=[NSString stringWithFormat:@"%@",rec.name];
    DetailedPortfolioVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"DetailedPortfolioVC"];
    destination.str_fromScreen=@"PANRECORD";
    destination.str_typePortFolio=str_typeOfPortfolio;
    if ([str_pan isEqualToString:@"ALL"] || [str_pan isEqual:@"ALL"]) {
        destination.str_selectedPAN=@"ALL";
        destination.selected_schemeClass=str_scheme;
    }
    else{
        destination.str_selectedPAN=str_pan;
        destination.selected_schemeClass=str_scheme;
    }
    KTPUSH(destination,YES);
}

#pragma mark - TableView Delegate and Data Source delegate ends

#pragma mark - Button Action

-(void)familyDetailsDisplay{
    [txt_familyMember setHidden:NO];
    [btn_drop setHidden:NO];
    [btn_familyPortfolio setBackgroundColor:KTButtonBackGroundBlue];
    [btn_familyPortfolio setTitleColor:KTWhiteColor forState:UIControlStateNormal];
    [btn_myPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_myPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    [btn_minorPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_minorPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    [btn_totalPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_totalPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    KT_TABLE12 *pan_rec=pan_familyDetails[0];
    txt_familyMember.text=pan_rec.invName;
    str_userSelectedPan=pan_rec.PAN;
    str_typeOfPortfolio=@"FamilyPortfolio";
    [self fetchTableRecordSectionBasedOnPAN:pan_rec.PAN];
    [self fetchTopSectionRecordsBaseOnPAN:pan_rec.PAN];
    [self hideTextFieldHeightTxtFieldHeight:KTiPad?50.0f:40.0f];
}

- (IBAction)btn_familyPortfolio:(id)sender {
    [self familyDetailsDisplay];
    currentButtonCount=1;
    [btn_backward setHidden:NO];
    [btn_forward setHidden:YES];
}

-(void)minorDetailsDisplay{
    [txt_familyMember setHidden:YES];
    [btn_drop setHidden:YES];
    [btn_minorPortfolio setBackgroundColor:KTButtonBackGroundBlue];
    [btn_minorPortfolio setTitleColor:KTWhiteColor forState:UIControlStateNormal];
    [btn_totalPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_totalPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    [btn_myPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_myPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    [btn_familyPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_familyPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    str_userSelectedPan=@"";
    str_typeOfPortfolio=@"MinorPortfolio";
    [self fetchTableRecordSectionBasedOnPAN:@""];
    [self fetchTopSectionRecordsBaseOnPAN:@""];
    [self hideTextFieldHeightTxtFieldHeight:0];
}

- (IBAction)btn_minorPortfolio:(id)sender{
    [self minorDetailsDisplay];
    if (familyRecFound==YES && minorRecFound == YES) {
        currentButtonCount=2;
        [btn_backward setHidden:NO];
        [btn_forward setHidden:NO];
    }
    else {
        currentButtonCount=1;
        [btn_backward setHidden:NO];
        [btn_forward setHidden:YES];
    }
}

-(void)myPortfolioDetails{
    [txt_familyMember setHidden:YES];
    [btn_drop setHidden:YES];
    [btn_myPortfolio setBackgroundColor:KTButtonBackGroundBlue];
    [btn_myPortfolio setTitleColor:KTWhiteColor forState:UIControlStateNormal];
    [btn_totalPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_totalPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    [btn_minorPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_minorPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    [btn_familyPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_familyPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    str_userSelectedPan=str_myPan;
    str_typeOfPortfolio=@"MyPortfolio";
    [self fetchTableRecordSectionBasedOnPAN:str_myPan];
    [self fetchTopSectionRecordsBaseOnPAN:str_myPan];
    [self hideTextFieldHeightTxtFieldHeight:0];
}

- (IBAction)btn_myPortfolio:(id)sender {
    [self myPortfolioDetails];
    if (familyRecFound==YES && minorRecFound == YES) {
        currentButtonCount=3;
    }
    else{
        currentButtonCount=2;
    }
    [btn_backward setHidden:NO];
    [btn_forward setHidden:NO];
}

-(void)totalPortfolioDetails{
    [txt_familyMember setHidden:YES];
    [btn_drop setHidden:YES];
    [btn_totalPortfolio setBackgroundColor:KTButtonBackGroundBlue];
    [btn_totalPortfolio setTitleColor:KTWhiteColor forState:UIControlStateNormal];
    [btn_myPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_myPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    [btn_minorPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_minorPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    [btn_familyPortfolio setBackgroundColor:KTButtonNotSelectedColor];
    [btn_familyPortfolio setTitleColor:KTDarkGreyColor forState:UIControlStateNormal];
    str_userSelectedPan=@"ALL";
    str_typeOfPortfolio=@"TotalPortfolio";
    [self fetchTableRecordSectionBasedOnPAN:@"ALL"];
    [self fetchTopSectionRecordsBaseOnPAN:@"ALL"];
    [self hideTextFieldHeightTxtFieldHeight:0];
}

- (IBAction)btn_totalPortfolio:(id)sender {
    [self totalPortfolioDetails];
    if (familyRecFound==YES && minorRecFound == YES) {
        currentButtonCount=4;
    }
    else{
        currentButtonCount=3;
    }
    [btn_backward setHidden:YES];
    [btn_forward setHidden:NO];
}

#pragma mark - forward Tapped

- (IBAction)btn_forwardTapped:(id)sender {
    if (originalBtnCount==3) {
        if (currentButtonCount==2) {
            currentButtonCount=currentButtonCount-1;
            if (currentButtonCount==1) {
                if (familyRecFound==YES) {
                    [self familyDetailsDisplay];
                }
                else{
                    [self minorDetailsDisplay];
                }
                [sender setHidden:YES];
            }
            else{
                [sender setHidden:NO];
            }
            [btn_backward setHidden:NO];
        }
        else if (currentButtonCount==3) {
            currentButtonCount=currentButtonCount-1;
            [self myPortfolioDetails];
            [btn_backward setHidden:NO];
        }
    }
    else{
        if (currentButtonCount==4) {
            currentButtonCount=currentButtonCount-1;
            [self myPortfolioDetails];
            [sender setHidden:NO];
            [btn_backward setHidden:NO];
        }
       else if (currentButtonCount==3) {
            currentButtonCount=currentButtonCount-1;
            if (currentButtonCount==2) {
                [self minorDetailsDisplay];
            }
            [sender setHidden:NO];
            [btn_backward setHidden:NO];
        }
        else if (currentButtonCount==2) {
            currentButtonCount=currentButtonCount-1;
            [self familyDetailsDisplay];
            [sender setHidden:YES];
            [btn_backward setHidden:NO];
        }
    }
}

- (IBAction)btn_backwardTapped:(id)sender {
    if (originalBtnCount==3) {
        if (currentButtonCount==1) {
            currentButtonCount=currentButtonCount+1;
            [self myPortfolioDetails];
            if (currentButtonCount==originalBtnCount) {
                [sender setHidden:YES];
            }
            else{
                [sender setHidden:NO];
            }
            [btn_forward setHidden:NO];
        }
        else if (currentButtonCount==2) {
            currentButtonCount=currentButtonCount+1;
            [self totalPortfolioDetails];
            if (currentButtonCount==originalBtnCount) {
                [sender setHidden:YES];
            }
            else{
                [sender setHidden:NO];
            }
            [btn_forward setHidden:NO];
        }
    }
    else{
        if (currentButtonCount==1) {
            currentButtonCount=currentButtonCount+1;
            [self minorDetailsDisplay];
            [sender setHidden:NO];
            [btn_forward setHidden:NO];
        }
        else if (currentButtonCount==2) {
            currentButtonCount=currentButtonCount+1;
            [self myPortfolioDetails];
            [sender setHidden:NO];
            [btn_forward setHidden:NO];
        }
        else if (currentButtonCount==3) {
            currentButtonCount=currentButtonCount+1;
            [self totalPortfolioDetails];
            [sender setHidden:YES];
            [btn_forward setHidden:NO];
        }
    }
    
}
#pragma mark - hide textField Initially

-(void)hideTextFieldHeightTxtFieldHeight:(CGFloat)textHeight{
    dispatch_async(dispatch_get_main_queue(), ^{
        constraint_txtHeight.active=YES;
        constraint_txtHeight.constant=textHeight;
        tbl_heightConstraint.active=YES;
        tbl_heightConstraint.constant=(50*arr_portfolioList.count+40+textHeight);
        [self.view updateConstraints];
        [self.view layoutIfNeeded];
        scroll_mainScroll.contentSize = CGSizeMake(self.view.frame.size.width,(view_tblBackGroundView.frame.origin.y+50*arr_portfolioList.count+40+textHeight));
    });
}

#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pan_familyDetails.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *pickerLabel;
    CGRect frame = CGRectMake(5.0, 0.0,self.view.frame.size.width-10,40);
    pickerLabel = [[UILabel alloc] initWithFrame:frame];
    UILabel *lbl_title=[[UILabel alloc]init];
    lbl_title.frame=frame;
    KT_TABLE12 *pan_rec=pan_familyDetails[row];
    NSString *str_invName=[NSString stringWithFormat:@"%@",pan_rec.invName];
    lbl_title.text= str_invName;
    lbl_title.textAlignment=NSTextAlignmentCenter;
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.font=KTFontFamilySize(KTOpenSansRegular, 12);
    lbl_title.numberOfLines=3;
    [pickerLabel addSubview:lbl_title];
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    KT_TABLE12 *pan_rec=pan_familyDetails[row];
    NSString *str_invName=[NSString stringWithFormat:@"%@",pan_rec.invName];
    txt_familyMember.text=str_invName;
    [txt_familyMember resignFirstResponder];
    [self fetchTableRecordSectionBasedOnPAN:pan_rec.PAN];
    [self fetchTopSectionRecordsBaseOnPAN:pan_rec.PAN];
    [self hideTextFieldHeightTxtFieldHeight:KTiPad?50.0f:40.0f];
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

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

#pragma mark - Go to profile screen on Click HERE

- (IBAction)btn_clickHereTapped:(UIButton *)sender {
    [self getProfilePercentageAPI];
}

#pragma mark - Go to Profile screen

-(void)moveToProfileScreen{
    ProfileVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"ProfileVC"];
    KTPUSH(destination,YES);
}

#pragma mark - show popup

-(void)showMessagePopup:(NSString *)show{
    CommonPopupVC *destinationController=[self.storyboard instantiateViewControllerWithIdentifier:@"CommonPopupVC"];
    destinationController.commondelegate=self;
    destinationController.str_fromScreen=show;
    [self addChildViewController:destinationController];
    [self.view addSubview:destinationController.view];
    [destinationController didMoveToParentViewController:self];
}

-(void)cancelButtonTapped{
    [view_marqueeLbl setHidden:NO];
    lbl_investorName.text=[NSString stringWithFormat:@"Welcome, %@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]]];
    [lbl_investorName setAttributedText:[lbl_investorName boldSubstringForLabel:lbl_investorName forFirstString:@"Welcome," forSecondString:[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]]]];
}

-(void)otpSuccessMethod{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchPanDetailsBasedOnFlag];
        [self hideTextFieldHeightTxtFieldHeight:0];
    });
}

-(void)PanSuccessMethod:(NSString *)str_pan{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *updatePrimaryPan=[NSString stringWithFormat:@"UPDATE TABLE12_PANDETAILS set flag='%@' WHERE PAN ='%@'", @"P",str_pan];
        [[DBManager sharedDataManagerInstance]executeUpdateQuery:updatePrimaryPan];
        [self fetchPanDetailsBasedOnFlag];
        [self hideTextFieldHeightTxtFieldHeight:0];
    });
}

#pragma mark - menu tapped

- (IBAction)btn_menuTapped:(id)sender {
    SlideMenuVC *destinationController=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SlideMenuVC"];
    [self addChildViewController:destinationController];
    [self.view addSubview:destinationController.view];
    [UIView animateWithDuration:0.6f
                          delay:0.5f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                     }
                     completion:^(BOOL finished)
     {}];
    [destinationController didMoveToParentViewController:self];
}

#pragma mark - Fund AUM Tapped

- (IBAction)btn_fundAUMTapped:(id)sender {
    DetailedPortfolioVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"DetailedPortfolioVC"];
    destination.str_fromScreen=@"ShowAll";
    destination.str_selectedPAN=str_userSelectedPan;
    destination.str_typePortFolio=str_typeOfPortfolio;
    KTPUSH(destination,YES);
}

#pragma mark - Button Top Navigation Bar Transact of Folio

- (IBAction)btn_transact:(id)sender {
    TransactNowVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"TransactNowVC"];
    KTPUSH(destination,YES);
}

- (IBAction)btn_netAssetValueTapped:(id)sender {
    NetAssetValueGraphVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"NetAssetValueGraphVC"];
    KTPUSH(destination,YES);
}

- (IBAction)btn_profileTapped:(id)sender {
    [self moveToProfileScreen];
}

#pragma mark - get profile percentage api

-(void)getProfilePercentageAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_url = [NSString stringWithFormat:@"%@Profilepercentage?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&userid=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
            if (error_statuscode==0) {
                NSString *str_per=[NSString stringWithFormat:@"%@",responce[@"Dtdata"][0][@"Percentage"]];
                int navigateScreen=[responce[@"Table1"][0][@"Screen"] intValue];
                if ([str_per intValue]<100) {
                    [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:@"Information" forMessage:@"Complete your profile to start investing" andAction1:@"OK" andAction1Block:^{
                        [self moveToProfileScreenNavigate:navigateScreen];
                    }];
                }
                else{
                    [self moveToTransactScreen];
                }
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Navigate Screen Value passed by sevrer end

-(void)moveToProfileScreenNavigate:(int)screenStage{
    ProfileVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"ProfileVC"];
    destination.navScreenStage=screenStage;
    destination.str_fromScreen=@"NavScreen";
    KTPUSH(destination,YES);
}

#pragma mark - Move To Transact Screen

-(void)moveToTransactScreen{
    TransactNowVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"TransactNowVC"];
    KTPUSH(destination,YES);
}


@end
