//
//  FolioDetailsVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 18/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "FolioDetailsVC.h"

@interface FolioDetailsVC ()<YSLContainerViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    __weak IBOutlet UITextField *txt_folio;
    __weak IBOutlet UITextField *txt_fund;
    NSArray *arr_folioList,*arr_fundList;
    UITextField *txt_currentTextField;
    UIPickerView *picker_dropDown;
    __weak IBOutlet UIView *view_navBar;
    NSInteger currentIndex;
    FolioContactDetailsVC *contactVC;
    FolioNomineeDetailsVC *nomineeVC;
    FolioBankDetailsVC *bankDetailsVC;
}
@end

@implementation FolioDetailsVC
@synthesize str_selectedPrimaryPan;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    XTAPP_DELEGATE.str_folioDetailsPan=str_selectedPrimaryPan;
    [self InitialiseViewOnLoad];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"AccountInformation"];
}

#pragma mark - InitialiseViewOnLoad

-(void)InitialiseViewOnLoad{
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
    [UITextField withoutRoundedCornerTextField:txt_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_folio forCornerRadius:5.0f forBorderWidth:1.5f];
    arr_fundList=[[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT(fundDesc),fund FROM TABLE2_DETAILS WHERE PAN='%@'",str_selectedPrimaryPan]];
    if (arr_fundList.count>0) {
        KT_Table2RawQuery *arr_fundRec=arr_fundList[0];
        txt_fund.text=[NSString stringWithFormat:@"%@",arr_fundRec.fundDesc];
        XTAPP_DELEGATE.str_folioDetailFund=[NSString stringWithFormat:@"%@",arr_fundRec.fund];
        if (arr_fundList.count==1) {
            [txt_folio setUserInteractionEnabled:NO];
        }
        else{
            [txt_fund setUserInteractionEnabled:YES];
            txt_fund.inputView=picker_dropDown;
            [picker_dropDown reloadAllComponents];
        }
    }
    else{
        [txt_fund setUserInteractionEnabled:NO];
    }
    [self fetchFolioNumberBasedOnFund:XTAPP_DELEGATE.str_folioDetailFund];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
}


-(void)fetchFolioNumberBasedOnFund:(NSString *)fundSelected{
    arr_folioList=[[DBManager sharedDataManagerInstance]uniqueFolioFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (Acno), notallowed_flag FROM TABLE2_DETAILS WHERE PAN='%@' AND fund='%@'",str_selectedPrimaryPan,fundSelected]];
    if (arr_folioList.count>0) {
        KT_TABLE2 *arr_folioRec=arr_folioList[0];
        txt_folio.text=[NSString stringWithFormat:@"%@",arr_folioRec.Acno];
        XTAPP_DELEGATE.str_folioDetailsAcno=[NSString stringWithFormat:@"%@",arr_folioRec.Acno];
        if (arr_folioList.count==1) {
            [txt_folio setUserInteractionEnabled:NO];
        }
        else{
            [txt_folio setUserInteractionEnabled:YES];
            [picker_dropDown reloadAllComponents];
        }
    }
    else{
        [txt_folio setUserInteractionEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self InitialiseScrollComponentsIntoView];
}

#pragma mark - Back Button Tapped

- (IBAction)btn_backTapped:(UIButton *)sender {
    KTPOP(YES);
}

-(void)InitialiseScrollComponentsIntoView{
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
    contactVC=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"FolioContactDetailsVC"];
    contactVC.title=@"CONTACT INFO";
    
    nomineeVC=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"FolioNomineeDetailsVC"];
    nomineeVC.title=@"NOMINEE DETAILS";

    bankDetailsVC=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"FolioBankDetailsVC"];
    bankDetailsVC.title=@"BANK DETAILS";
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[contactVC,nomineeVC,bankDetailsVC]
                                                                                        topBarHeight:(txt_folio.frame.origin.y+txt_folio.frame.size.height+(KTiPad?30:15))
                                                                                parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont =KTFontFamilySize(KTOpenSansSemiBold,KTiPad?16:10);
    [self.view addSubview:containerVC.view];
    [self.view bringSubviewToFront:view_navBar];
    [self.view bringSubviewToFront:txt_fund];
    [self.view bringSubviewToFront:txt_folio];
    currentIndex=0;
}

#pragma mark -- YSLContainerViewControllerDelegate

- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller {
    currentIndex=index;
    [controller viewWillAppear:YES];
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
    if (textField==txt_folio) {
        if (arr_folioList.count>1) {
            [picker_dropDown selectRow:0 inComponent:0 animated:YES];
            txt_folio.inputView=picker_dropDown;
            [picker_dropDown reloadAllComponents];
        }
        else{
            KT_TABLE2 *arr_folioRec=arr_folioList[0];
            txt_folio.text=[NSString stringWithFormat:@"%@",arr_folioRec.Acno];
            XTAPP_DELEGATE.str_folioDetailsAcno=[NSString stringWithFormat:@"%@",arr_folioRec.Acno];
        }
    }
    else if (textField == txt_fund){
        if (arr_fundList.count>1) {
            [picker_dropDown selectRow:0 inComponent:0 animated:YES];
            txt_fund.inputView=picker_dropDown;
            [picker_dropDown reloadAllComponents];
        }
        else{
            KT_Table2RawQuery *fund_rec=arr_fundList[0];
            txt_fund.text=[NSString stringWithFormat:@"%@",fund_rec.fundDesc];
            XTAPP_DELEGATE.str_folioDetailFund=[NSString stringWithFormat:@"%@",fund_rec.fund];
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

#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    long int count=0;
    if (txt_currentTextField==txt_folio) {
        count=arr_folioList.count;
    }
    else if (txt_currentTextField==txt_fund) {
        count=arr_fundList.count;
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
    if (txt_currentTextField==txt_folio) {
        KT_TABLE2 *folio_rec=arr_folioList[row];
        str_fundName=[NSString stringWithFormat:@"%@",folio_rec.Acno];
    }
    else if (txt_currentTextField==txt_fund) {
        KT_Table2RawQuery *fund_rec=arr_fundList[row];
        str_fundName=[NSString stringWithFormat:@"%@",fund_rec.fundDesc];
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
    if (txt_currentTextField==txt_folio) {
        KT_TABLE2 *folio_rec=arr_folioList[row];
        txt_currentTextField.text=[NSString stringWithFormat:@"%@",folio_rec.Acno];
        XTAPP_DELEGATE.str_folioDetailsAcno=[NSString stringWithFormat:@"%@",folio_rec.Acno];
        [self textFieldsValueChanged];
    }
    else{
        KT_Table2RawQuery *fund_rec=arr_fundList[row];
        txt_fund.text=[NSString stringWithFormat:@"%@",fund_rec.fundDesc];
        XTAPP_DELEGATE.str_folioDetailFund=[NSString stringWithFormat:@"%@",fund_rec.fund];
        [self fetchFolioNumberBasedOnFund:XTAPP_DELEGATE.str_folioDetailFund];
        [self textFieldsValueChanged];
    }
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

-(void)textFieldsValueChanged{
    END_EDITING;
    if (currentIndex==0) {
        [self containerViewItemIndex:currentIndex currentController:contactVC];
    }
    else if (currentIndex==1) {
        [self containerViewItemIndex:currentIndex currentController:nomineeVC];
    }
    else if (currentIndex==2) {
        [self containerViewItemIndex:currentIndex currentController:bankDetailsVC];
    }
}
@end
