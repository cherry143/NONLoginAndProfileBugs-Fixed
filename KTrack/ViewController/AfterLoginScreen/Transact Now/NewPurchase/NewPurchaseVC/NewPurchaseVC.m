//
//  NewPurchaseVC.m
//  KTrack
//
//  Created by  ramakrishna.MV on 25/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "NewPurchaseVC.h"

@interface NewPurchaseVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>{
    
    __weak IBOutlet UIView *view_fund;
    __weak IBOutlet UIView *view_category;
    __weak IBOutlet UIView *view_schemeType;
    __weak IBOutlet UIView *view_repemetionType;
    __weak IBOutlet UIView *view_scheme;
    __weak IBOutlet UIView *view_arn;
    __weak IBOutlet UIView *view_euin;
__weak IBOutlet UIView *view_paymentAmount;
    __weak IBOutlet UIView *view_addNominee;
    __weak IBOutlet UIView *view_checkNominee;
    __weak IBOutlet UIView *view_Nominee1;
    __weak IBOutlet UIView *view_Nominee2;
    __weak IBOutlet UIView *view_Nominee3;
    __weak IBOutlet UIView *view_submit;
    __weak IBOutlet UIView *view_nomiee;
    
    // text  field
    
    __weak IBOutlet UITextField *txt_fund;
    __weak IBOutlet UITextField *txt_category;
    __weak IBOutlet UITextField *txt_schemme;
    __weak IBOutlet UITextField *txt_arnCode;
    __weak IBOutlet UITextField *txt_sub;
    __weak IBOutlet UITextField *txt_subarn;
    __weak IBOutlet UITextField *txt_euin;
    __weak IBOutlet UITextField *txt_amount;
    __weak IBOutlet UITextField *tf_nomieesPer1;
    __weak IBOutlet UITextField *tf_nomieesPer2;
    __weak IBOutlet UITextField *tf_nomieesPer3;
    __weak IBOutlet UITextField *tf_payoutBank;
    
    
    /// label
    __weak IBOutlet UIButton *lbl_nomiee1;
    __weak IBOutlet UIButton *lbl_nomiee2;
    __weak IBOutlet UIButton *lbl_nomiee3;
    
    __weak IBOutlet UILabel *lbl_MiniAmunt;
    
    __weak IBOutlet UITableView *nomieeTableView;
    __weak IBOutlet UIScrollView *scrollview;
    
    ////btn
    
    __weak IBOutlet UIButton *btn_addNomiee;
    __weak IBOutlet UIButton *btn_yesEuin;
    __weak IBOutlet UIButton *btn_nEuin;
    __weak IBOutlet UIButton *btn_distri;
    __weak IBOutlet UIButton *btn_driect;

    
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UIButton *btn_selectNomiee;
    
    
    
    NSArray *Siptype,*SiptypeDicArray,*sipFunddetailsarr;
    NSArray *noInstaArr;
    NSArray *SIPDaysArr;
    NSArray *subEArnarray;
    NSArray *fundDetails;
    NSArray *folioArray;
    NSArray *   PanDetials;
    NSArray *existingArr;
    NSArray *paymentBankArr;
    NSArray *paymentModeArr;
    NSArray *modeofRegisArr;
    NSArray *nomieeDetailsArr;
    
    NSMutableArray * categoryArr;
    NSMutableArray *newschemeArr;
    NSMutableArray  *paymentModeArray,*arr_checkUncheckRec,*arr_nomieerefence;
    
    KT_TABLE2 *schemmeDic;
    KT_TABLE8 *selectedBank;
    NSMutableDictionary *newSchemmeDic;
    NSMutableDictionary *paymentBankDic;
    /// String
    NSString *selectedPan;
    NSString *selectSIPtype,*selectSIPtypeInt,*str_installments;
    
    NSString *str_selectedFundID;
    NSString *selectedfolio,*selectedSecheme,*miniAmount;
    NSString *str_PaymentBank;
    NSString *str_Category;
    NSString*str_folioDmart;
    NSString*str_EuinNo,*str_iScheme;
    NSString*str_plan;
    NSString*str_option;
    NSString *EUINFlag;
    NSString *str_driect;
    NSString *str_tat;
    
    UIPickerView *picker_dropDown;
    UITextField *txt_currentTextField;
    NSString *str_referId,*str_redType,*ttrtype,* lastNavStr;
}

@end

@implementation NewPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
     [self addElements];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
   

}


-(void)addElements{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [scrollview addGestureRecognizer:singleTap];
    txt_fund.userInteractionEnabled =false;
    nomieeTableView.delegate =self;;
    nomieeTableView.dataSource =self;;

    
        txt_euin.userInteractionEnabled =false;
    txt_fund.userInteractionEnabled =false;
    txt_category.userInteractionEnabled =false;
    txt_arnCode.userInteractionEnabled =false;
    txt_sub.userInteractionEnabled =false;
    txt_schemme.userInteractionEnabled =false;
    txt_subarn.userInteractionEnabled =false;
    txt_amount.userInteractionEnabled =false;
    tf_nomieesPer2.userInteractionEnabled =false;
    tf_nomieesPer1.userInteractionEnabled =false;
    tf_nomieesPer3.userInteractionEnabled =false;
      tf_payoutBank.userInteractionEnabled =false;
    [UITextField withoutRoundedCornerTextField:txt_category forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_schemme forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_euin forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_payoutBank forCornerRadius:5.0f forBorderWidth:1.5f];

    /// selection Pan   // Sip Type
    NSArray *minorRecordDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='P' "]];
    KT_TABLE12 *pan_rec=minorRecordDetails[0];
    selectedPan=pan_rec.PAN;
 
    [self getNomineeDetails];
    [view_nomiee setHidden:YES];
    
    NSLog(@"%@",fundDetails);
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    txt_fund.inputView=picker_dropDown;
    [picker_dropDown reloadAllComponents];
    txt_fund.delegate =self;
    paymentBankDic =[[NSMutableDictionary alloc]init];
    
    scrollview.delegate = self;

        [view_euin setHidden:YES];
    [view_Nominee1 setHidden:YES];
    [view_Nominee2 setHidden:YES];
    [view_Nominee3 setHidden:YES];
    
    
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];

    
  
}

-(void)scrollContentHeightIncrease:(CGFloat)height{
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width,height);
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)atc_back:(id)sender {
    
    
    KTPOP(true);
}
- (IBAction)Atc_euinI:(id)sender {
    
       [[SharedUtility sharedInstance]showAlertViewWithTitle:KTMessage withMessage:@"I/We hereby confirm that the EUIN box has been intentionally left blank by me us as this is an 'execution-only' transaction without any interaction or advice by any personnel of the above distributor or notwithstanding the advice of in-appropriateness, if any, provided by any personnel of the distributor and the distributor has not charged any advisory fees on this transaction. "];
}
#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == txt_amount) {
        
        
        if (textField.text.length >= MAX_LENGTH && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        
        
        else
        {return YES;}
    }
    
    {return YES;}
}


- (IBAction)Atc_Submit:(id)sender{
    
    
    
        
        if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
            
            if ([str_selectedFundID length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund"];
            }
            else if ([txt_category.text length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Catergory"];
            }
            else if ([selectedSecheme length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Secheme"];
            }
            else if ( [txt_arnCode.text   isEqualToString:@"ARN-" ]){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter ARN  Code"];
                
            }
            else if ( [txt_arnCode.text   isEqualToString:txt_subarn.text] ){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"  ARN  Code  and  sub ARN code  Should not be Same "];
                
            }
            else  if ([btn_nEuin.imageView.image isEqual:[UIImage imageNamed:@"radio-on"]]) {
                if ([txt_euin.text length] == 0){
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the EUIN No"];
                    
                }
                else if ([tf_payoutBank.text length] == 0){
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the  Pay out Bank"];
                }
                else if ([txt_amount.text length] == 0){
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount"];
                    
                }else{
                    
                    int miniAmountvalue = [miniAmount intValue];
                    
                    if (miniAmountvalue > [txt_amount.text intValue ] ) {
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount greater than Minimum Amount"];
                        
                    }
                    else{
                        
                        
                        if (![btn_selectNomiee.imageView.image isEqual: [UIImage imageNamed:@"uncheck"]])
                        {
                            //         [self purchaseurl];

                            [self NewPurchaseSumbitAPI];

                        }else{
                            if (arr_nomieerefence.count == 0  ) {
                                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Add at least one nominee "];

                            }else{
                       
                                if (arr_nomieerefence.count == 1 ) {
                                    if ([tf_nomieesPer1.text length] == 0) {
                                          [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                                    }else if ([tf_nomieesPer1.text intValue ]  ==  100 ){
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];

                                    }
                            }
                                else if (arr_nomieerefence.count == 2){
                                    if ([tf_nomieesPer1.text length] == 0) {
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];

                                    }
                                else    if ([tf_nomieesPer2.text length] == 0) {
                                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee two Percentage"];

                                        
                                    }else if ([tf_nomieesPer1.text integerValue ] + [tf_nomieesPer2.text integerValue ] ==  100 ){
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];

                                    }
                                }
                                else if (arr_nomieerefence.count == 3){
                                    if ([tf_nomieesPer1.text length] == 0) {
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];

                                    }
                                 else   if ([tf_nomieesPer2.text length] == 0) {
                                     [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee two Percentage"];
                                    }
                                 else   if ([tf_nomieesPer3.text length] == 0) {
                                     [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee three Percentage"];

                                 }else if ([tf_nomieesPer1.text floatValue ] + [tf_nomieesPer2.text floatValue ]  + [tf_nomieesPer3.text floatValue ]  ==  100 ){
                                                       [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                                    }
                                }else{
                                    
                                }
                            
                        }
                        
                        NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                        NSLog(@"fund  %@",schemmeDic);
                        }
                    }
                }
                
            }else{
                if ([txt_amount.text length] == 0){
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount"];
                    
                }else{
                    
                    int miniAmountvalue = [miniAmount intValue];
                    
                    if (miniAmountvalue > [txt_amount.text intValue ] ) {
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount greater than Minimum Amount"];
                        
                    }
                    else{
                        
                        
                        if (![btn_selectNomiee.imageView.image isEqual: [UIImage imageNamed:@"uncheck"]])
                        {
                            
                            [self NewPurchaseSumbitAPI];
                            NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                            NSLog(@"fund  %@",schemmeDic);
                            
                            
                        }else{
                            if (arr_nomieerefence.count == 0  ) {
                                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Add at least one nominee "];
                                
                            }else{
                                
                                if (arr_nomieerefence.count == 1 ) {
                                    if ([tf_nomieesPer1.text length] == 0) {
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                                    }else if ([tf_nomieesPer1.text intValue ]  !=  100 ){
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                                        
                                    }
                                    else{
                                        
                                        [self NewPurchaseSumbitAPI];
                                        NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                                        NSLog(@"fund  %@",schemmeDic);
                                    }
                                }
                                else if (arr_nomieerefence.count == 2){
                                    if ([tf_nomieesPer1.text length] == 0) {
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                                        
                                    }
                                    else    if ([tf_nomieesPer2.text length] == 0) {
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee two Percentage"];
                                        
                                        
                                    }else if ([tf_nomieesPer1.text floatValue ] + [tf_nomieesPer2.text floatValue ] !=  100 ){
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                                        
                                    }
                                    else{
                                        
                                        [self NewPurchaseSumbitAPI];
                                        NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                                        NSLog(@"fund  %@",schemmeDic);
                                    }
                                }
                                else if (arr_nomieerefence.count == 3){
                                    if ([tf_nomieesPer1.text length] == 0) {
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                                        
                                    }
                                    else   if ([tf_nomieesPer2.text length] == 0) {
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee two Percentage"];
                                    }
                                    else   if ([tf_nomieesPer3.text length] == 0) {
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee three Percentage"];
                                        
                                    }else if ([tf_nomieesPer1.text floatValue ] + [tf_nomieesPer2.text floatValue ]  + [tf_nomieesPer3.text floatValue ]  !=  100 ){
                                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                                    }
                                    else{
                                        
                                        [self NewPurchaseSumbitAPI];
                                        NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                                        NSLog(@"fund  %@",schemmeDic);
                                    }
                                }else{
                                    
                                    [self NewPurchaseSumbitAPI];
                                    NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                                    NSLog(@"fund  %@",schemmeDic);
                                }
                                
                            }
                            
           
                        }
                    }
                }
            }
        }
        else{
            if ([str_selectedFundID length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund"];
            }
            else if ([txt_category.text length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Catergory"];
            }
            else if ([selectedSecheme length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Secheme"];
            }   else if ([tf_payoutBank.text length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the  Pay out Bank"];
            }
            
            else if ([txt_amount.text length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount"];
                
            }
            else{
                
                int miniAmountvalue = [miniAmount intValue];
                
                if (miniAmountvalue > [txt_amount.text intValue ] ) {
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount greater than Minimum Amount"];
                    
                }
                else{
                    
                    
                    if (![btn_selectNomiee.imageView.image isEqual: [UIImage imageNamed:@"uncheck"]])
                    {
                        
                        [self NewPurchaseSumbitAPI];
                        NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                        NSLog(@"fund  %@",schemmeDic);
                        
                    }else{
                        if (arr_nomieerefence.count == 0  ) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Add at least one nominee "];
                            
                        }else{
                            
                            if (arr_nomieerefence.count == 1 ) {
                                if ([tf_nomieesPer1.text length] == 0) {
                                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                                }else if ([tf_nomieesPer1.text intValue ]  !=  100 ){
                                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                                    
                                }else{
                                    
                                    [self NewPurchaseSumbitAPI];
                                    NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                                    NSLog(@"fund  %@",schemmeDic);
                                }
                            }
                            else if (arr_nomieerefence.count == 2){
                                if ([tf_nomieesPer1.text length] == 0) {
                                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                                    
                                }
                                else    if ([tf_nomieesPer2.text length] == 0) {
                                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee two Percentage"];
                                    
                                    
                                }else if ([tf_nomieesPer1.text intValue ] + [tf_nomieesPer2.text intValue ] !=  100 ){
                                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                                    
                                }else{
                                    
                                    [self NewPurchaseSumbitAPI];
                                    NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                                    NSLog(@"fund  %@",schemmeDic);
                                }
                            }
                            else if (arr_nomieerefence.count == 3){
                                if ([tf_nomieesPer1.text length] == 0) {
                                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                                    
                                }
                                else   if ([tf_nomieesPer2.text length] == 0) {
                                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee two Percentage"];
                                }
                                else   if ([tf_nomieesPer3.text length] == 0) {
                                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee three Percentage"];
                                    
                                }else if ([tf_nomieesPer1.text floatValue ] + [tf_nomieesPer2.text floatValue ]  + [tf_nomieesPer3.text floatValue ]  !=  100 ){
                                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                                }
                                
                                else{
                                    
                                    [self NewPurchaseSumbitAPI];
                                    NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                                    NSLog(@"fund  %@",schemmeDic);
                                }
                            }else{
                                
                                [self NewPurchaseSumbitAPI];
                                NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                                NSLog(@"fund  %@",schemmeDic);
                            }
                            
                        }
                        
               
                    }
                }
            }
        }
        
        
        
    
}
- (IBAction)btn_allowNomiee:(id)sender {
    
    if ([btn_selectNomiee.imageView.image isEqual: [UIImage imageNamed:@"uncheck"]])
    {
        
        
        [view_addNominee setHidden:YES];
        
        [view_Nominee1 setHidden:YES];
        [view_Nominee2 setHidden:YES];
        [view_Nominee3 setHidden:YES];
        [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
        
        [btn_selectNomiee setImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }else{
        [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
        
        [view_addNominee setHidden:NO];
        if (arr_nomieerefence.count  >= 4) {
            NSLog(@"%@",arr_nomieerefence);
            [view_Nominee1 setHidden:YES];
            [view_Nominee2 setHidden:YES];
            [view_Nominee3 setHidden:YES];
            [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
            
        }else{
            NSLog(@"%@",arr_nomieerefence);
            tf_nomieesPer1.userInteractionEnabled =true;
            tf_nomieesPer2.userInteractionEnabled =true;
            tf_nomieesPer2.userInteractionEnabled =true;
            
            if (arr_nomieerefence.count == 1 ) {
                
                
                [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
                
                
                tf_nomieesPer1.text =@"100";
                [view_Nominee1 setHidden:NO];
                [view_Nominee2 setHidden:YES];
                [view_Nominee3 setHidden:YES];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                
            }else if (arr_nomieerefence.count == 2 ){
                [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
                
                [lbl_nomiee2 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[1][@"kn_NomName"]] forState:UIControlStateNormal];
                
                tf_nomieesPer1.text =@"50";
                tf_nomieesPer2.text =@"50";
                [view_Nominee1 setHidden:NO];
                [view_Nominee2 setHidden:NO];
                [view_Nominee3 setHidden:YES];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
            }
            else if (arr_nomieerefence.count == 3 ){
                [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
                
                [lbl_nomiee2 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[1][@"kn_NomName"]] forState:UIControlStateNormal];
                [lbl_nomiee3 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[2][@"kn_NomName"]] forState:UIControlStateNormal];
                
                tf_nomieesPer2.text =@"33.333";
                tf_nomieesPer3.text =@"33.333";
                tf_nomieesPer1.text =@"33.333";
                [view_Nominee1 setHidden:NO];
                [view_Nominee2 setHidden:NO];
                [view_Nominee3 setHidden:NO];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                
            }
            [btn_selectNomiee setImage: [UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
            
            
        }
        
    }
}
- (IBAction)Atc_addNominee:(id)sender {
    arr_checkUncheckRec =[[NSMutableArray alloc]init];
    tf_nomieesPer2.userInteractionEnabled =true;
    tf_nomieesPer1.userInteractionEnabled =true;
    tf_nomieesPer3.userInteractionEnabled =true;
    arr_nomieerefence =[[NSMutableArray alloc]init];
    for (int i=0; i<nomieeDetailsArr.count; i++) {
        [arr_checkUncheckRec addObject:@"Uncheck"];
    }
    [view_nomiee setHidden:NO];
    
    [nomieeTableView reloadData];
    
}
- (IBAction)Atc_YesEuin:(id)sender {
    
    
    txt_euin.text =nil;
    
    [view_euin setHidden:YES];
    
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    txt_euin.userInteractionEnabled = NO;
    
    [btn_yesEuin setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_nEuin setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    
    
    
}
- (IBAction)Atc_NoEuin:(id)sender {
    
    [view_euin setHidden:NO];
    txt_euin.text =nil;
    
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    txt_euin.userInteractionEnabled = YES;
    [ btn_nEuin setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [    btn_yesEuin setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    
}
- (IBAction)Atc_Distri:(id)sender {
    
    str_driect =@"Regular";
    
    
       txt_arnCode.text =@"ARN-";
       txt_subarn.text =@"ARN-";
    txt_sub.text =nil;
    txt_category.text = nil;
        tf_payoutBank.text = nil;
    txt_schemme.text = nil;

    //    else{
    //        [view_category setHidden:NO];
    //
    //    }
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    [view_arn setHidden:NO];
    [view_euin setHidden:YES];
    [btn_driect setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_distri setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_nEuin setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_yesEuin setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
///    [self newSchmemListApi];
    
}
- (IBAction)Atc_driect:(id)sender {
    
    str_driect =@"Driect";
    txt_arnCode.text =@"ARN-";
    txt_subarn.text =@"ARN-";
    txt_sub.text =nil;
        txt_euin.text =nil;
    [view_arn setHidden:YES];
    [view_euin setHidden:YES];
    
    txt_category.text = nil;
    txt_schemme.text = nil;
    

    
    
    
    
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];

    [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_nEuin setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_yesEuin setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    
 //   [self newSchmemListApi];
    
}

#pragma mark - Get  Nomiee List Details API

-(void)getNomineeDetails{
    
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_pan=[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedPan];
    
    NSString *str_url = [NSString stringWithFormat:@"%@GetNomineeDetailsbyPAN?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&PAN=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_pan];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
               [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            self->nomieeDetailsArr = responce[@"Table"];
            [self getSIPFunds];
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - validate ARN API
-(void)validateARNAPI{
        [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    // NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_o_ErrNo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_subarn.text];
    
    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_arnCode.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@ValidateBrokercode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&AgentCd=%@&SubAgentCd=%@o_ErrNo&=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,Str_AgentCd,str_SubAgentCd,str_o_ErrNo];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
           [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            if ([responce[@"DtData"] count]  != 0) {
                self->subEArnarray= [[NSMutableArray alloc]init];
                if (self->subEArnarray.count == 0) {
                    self->subEArnarray = responce[@"DtData"];
                    self->txt_euin.inputView = self->picker_dropDown;
                    [self->picker_dropDown reloadAllComponents];
                    
                    if ([self->btn_yesEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]) {
                        [self->txt_euin becomeFirstResponder];
                        
                    }
                }
                self->subEArnarray = responce[@"DtData"];
            }
            else{
                self->txt_arnCode.text =@"ARN-";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Please  Check ARN code"];
            }
            
            NSLog(@"%@",self->subEArnarray);
            
            
        }
        else{
            
            self->txt_arnCode.text =@"ARN-";
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTextField=textField;
    
    if (txt_currentTextField==txt_fund) {
        txt_fund.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        if ([txt_fund.text  length] == 0) {
            txt_fund.text= [NSString stringWithFormat:@"%@",sipFunddetailsarr[0][@"amc_name"]];
            
            str_selectedFundID=[NSString stringWithFormat:@"%@",sipFunddetailsarr[0][@"amc_code"]];
        }
    }
 else   if (txt_currentTextField==txt_category) {
        txt_category.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        if ([txt_category.text  length] == 0) {
            txt_category.text= [NSString stringWithFormat:@"%@",categoryArr[0][@"CatDesc"]];

            
        }
    }
    else   if (txt_currentTextField==txt_schemme) {
        txt_schemme.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        if ([txt_schemme.text  length] == 0) {
            txt_schemme.text= [NSString stringWithFormat:@"%@",newschemeArr[0][@"Scheme_Desc"]];
            
            newSchemmeDic = newschemeArr[0];
            txt_schemme.text=[NSString stringWithFormat:@"%@",newSchemmeDic[@"Scheme_Desc"]];
            selectedSecheme=[NSString stringWithFormat:@"%@",newSchemmeDic[@"Scheme_Desc"]];
            miniAmount=[NSString stringWithFormat:@"%@",newSchemmeDic[@"MinAmt"]];
            lbl_MiniAmunt.text =[NSString stringWithFormat:@"%@",miniAmount];;
            str_iScheme =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_scheme"]];;
            str_plan =[NSString stringWithFormat:@"%@",newSchemmeDic[@"Scheme_Plan"]];;
            str_option =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_option"]];;
            str_driect =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_plnmode"]];;
            
        }
    }
  else  if (txt_currentTextField==tf_payoutBank) {
        
        tf_payoutBank.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
      
      if ([tf_payoutBank.text  length] == 0) {
          NSDictionary *rec_fund=paymentModeArr[0];
          paymentBankDic =paymentModeArr[0];
          tf_payoutBank.text=[NSString stringWithFormat:@"%@  %@",rec_fund[@"kb_BankName"],rec_fund[@"kb_BankAcNo"]];
      }
    }
else    if (txt_currentTextField==tf_payoutBank) {
        
        tf_payoutBank.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [txt_currentTextField resignFirstResponder];
    if (txt_currentTextField==txt_fund) {
        if ([txt_fund.text length] == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund Type"];
            
        }
        else{
            [self categoryListApi];
            
        }
        
    }
    else  if (txt_currentTextField==tf_payoutBank) {
        
        if ([tf_payoutBank.text length] == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund Type"];
            
        }else{
            
            NSLog(@"%@",paymentBankDic);
            

            if ([paymentBankDic[@"gb_bankcode"]  length ]== 0) {

                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Payout Bank"
                                              message:@"select bank Internet bank is not Available"
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"Procced"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                         tf_payoutBank.text = nil;
                                
                                         //                                     [self  confKOTM:responce[@"Table1"][0][@"GM_UMRNNo"]];
                                         
                                     }];
                [alert addAction:ok];
                UIAlertAction* cancel = [UIAlertAction
                                         actionWithTitle:@"Cancel"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action){
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                             
                                         }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
                

            }

            
        }
//        tf_payoutBank.inputView=picker_dropDown;
//        [picker_dropDown reloadAllComponents];
//
//        if ([tf_payoutBank.text  length] == 0) {
//            NSDictionary *rec_fund=paymentModeArr[0];
//            paymentBankDic =paymentModeArr[0];
//            tf_payoutBank.text=[NSString stringWithFormat:@"%@  %@",rec_fund[@"kb_BankName"],rec_fund[@"kb_BankAcNo"]];
//        }
    }
    
else    if (txt_currentTextField==txt_category) {
        if ([txt_fund.text length] == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Category Type"];
            
        }
        else{
            [self  newSchmemListApi];
            
        }
    
    }
else    if (txt_currentTextField==txt_schemme) {
    if ([txt_schemme.text length] == 0) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Schemme Type"];
        
    }
    else{
        txt_amount.userInteractionEnabled =YES;
        [self  payOutbankAPi];
        
    }
    
}
else    if (textField==txt_arnCode ) {
        
        if ([txt_arnCode.text isEqualToString:@"ARN-"]   ) {
            
            if ([txt_arnCode.text length ] == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the ARN- Code "];
                
            }
        } else {
            [self validateARNAPI];

            
        }
    }
else    if (textField==txt_subarn ) {
    
     if ([txt_subarn.text isEqualToString:@"ARN-"]   ) {

        
    }
else {

            [self validateSubARNAPI];
               ;
}

        
        
    }
    
}

#pragma  mark Picker datasouce  and Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    long int newcount = 0;
    if (txt_currentTextField==txt_fund) {
        
        newcount  = sipFunddetailsarr.count;
    }
    else if  (txt_currentTextField==txt_category) {
        
        newcount  = categoryArr.count;
    }
    else if  (txt_currentTextField==txt_schemme) {
        
        newcount  = newschemeArr.count;
    }
  else  if (txt_currentTextField== tf_payoutBank) {
        newcount= paymentModeArr.count;
    }
  else    if (txt_currentTextField==txt_euin) {
        newcount= subEArnarray.count;
    }
    
    return newcount;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str_title;
    
    
    if (txt_currentTextField==txt_fund) {
        str_title = [NSString stringWithFormat:@"%@",sipFunddetailsarr[row][@"amc_name"]];
        
        
    }
    else if  (txt_currentTextField==txt_category) {
        str_title = [NSString stringWithFormat:@"%@",categoryArr[row][@"CatDesc"]];

        

    }
    else if  (txt_currentTextField==txt_schemme) {
        str_title = [NSString stringWithFormat:@"%@",newschemeArr[row][@"Scheme_Desc"]];
        
        
        
    }
else    if (txt_currentTextField==txt_euin) {
        NSDictionary *rec_fund=subEArnarray[row];
      str_title=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
    
    }
else  if (txt_currentTextField== tf_payoutBank) {
            NSDictionary *rec_fund=paymentModeArr[row];
        str_title=[NSString stringWithFormat:@"%@  %@",rec_fund[@"kb_BankName"],rec_fund[@"kb_BankAcNo"]];

}
    return str_title;
    
}
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 100;
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//
//    UILabel *label = [[UILabel alloc] init];
//    CGRect frame = CGRectMake(0,0,265,40);
//    label.backgroundColor =  [UIColor whiteColor];;
////    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18 ];
//    label.textAlignment = NSTextAlignmentCenter;
//
//
//
//
//
//        label.text = @"efwrfrewferwhgerkghergrengrdngnefgeflgnertogetogengedgnegetrggergetrgetriogtergioetrghet";
//    label.lineBreakMode = UILineBreakModeWordWrap;
//    label.numberOfLines = 0;
//    return label;
//}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    if (txt_currentTextField==txt_fund) {
     
        // [categoryArr  removeAllObjects];
        
        
        
        txt_fund.text= [NSString stringWithFormat:@"%@",sipFunddetailsarr[row][@"amc_name"]];
    
        str_selectedFundID=[NSString stringWithFormat:@"%@",sipFunddetailsarr[row][@"amc_code"]];
        
        

                txt_schemme.text = nil;
        txt_schemme.userInteractionEnabled =false;

        tf_payoutBank.text = nil;
           tf_payoutBank.userInteractionEnabled =false;
      

        txt_euin.userInteractionEnabled =false;
        txt_arnCode.userInteractionEnabled =false;
        txt_sub.userInteractionEnabled =false;
        txt_subarn.userInteractionEnabled =false;
        txt_subarn.text =@"ARN-";
        txt_arnCode.text =@"ARN-";
         txt_sub.text =@"";
        txt_euin.text =nil;
        
        
    }
    else if  (txt_currentTextField==txt_category) {
        
        txt_category.text= [NSString stringWithFormat:@"%@",categoryArr[row][@"CatDesc"]];
        

        txt_schemme.text = nil;

        
        tf_payoutBank.text = nil;
        tf_payoutBank.userInteractionEnabled =false;

        txt_subarn.text =@"ARN-";
        txt_arnCode.text =@"ARN-";
        txt_sub.text =@"";
        txt_euin.text =nil;
        txt_euin.userInteractionEnabled =false;
        txt_arnCode.userInteractionEnabled =false;
        txt_sub.userInteractionEnabled =false;
        txt_subarn.userInteractionEnabled =false;
        
        
    }
    else if  (txt_currentTextField==txt_schemme) {
        
        txt_schemme.text= [NSString stringWithFormat:@"%@",newschemeArr[row][@"Scheme_Desc"]];
        
        newSchemmeDic = newschemeArr[row];
        txt_schemme.text=[NSString stringWithFormat:@"%@",newSchemmeDic[@"Scheme_Desc"]];
        selectedSecheme=[NSString stringWithFormat:@"%@",newSchemmeDic[@"Scheme_Desc"]];
        miniAmount=[NSString stringWithFormat:@"%@",newSchemmeDic[@"MinAmt"]];
        lbl_MiniAmunt.text =[NSString stringWithFormat:@"%@",miniAmount];;
        str_iScheme =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_scheme"]];;
        str_plan =[NSString stringWithFormat:@"%@",newSchemmeDic[@"Scheme_Plan"]];;
        str_option =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_option"]];;
        str_driect =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_plnmode"]];;
        
 
        
        tf_payoutBank.text = nil;
        tf_payoutBank.userInteractionEnabled =false;
     
        
        txt_euin.userInteractionEnabled =true;

        txt_arnCode.userInteractionEnabled =true;
        txt_sub.userInteractionEnabled =true;
    txt_subarn.userInteractionEnabled =true;
        
    }
else    if (txt_currentTextField==txt_euin) {
        NSDictionary  *rec_fund=subEArnarray[row];
        // [categoryArr  removeAllObjects];
        txt_euin.text=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
        str_EuinNo =[NSString stringWithFormat:@"%@",rec_fund[@"abm_name"]];
    }
else  if (txt_currentTextField== tf_payoutBank) {
    NSDictionary *rec_fund=paymentModeArr[row];
    paymentBankDic =paymentModeArr[row];
    tf_payoutBank.text=[NSString stringWithFormat:@"%@  %@",rec_fund[@"kb_BankName"],rec_fund[@"kb_BankAcNo"]];
    
}
    }

#pragma mark - pay out Bank Api

-(void)payOutbankAPi{
    
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedPan];
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@GetBankDetailsbyPAN?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&PAN=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_opt];
    
    NSLog(@"%@",str_url);
    
    
    
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            self->paymentModeArr = responce[@"Table"];
            self->tf_payoutBank.text=nil;
            self->tf_payoutBank.userInteractionEnabled =true;
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SIPSumbitAPI API
//-(void)SIPSumbitAPI{
//
//
//
//    NSLog(@"%@",str_driect);
//
//
//    NSString *str_enIscheme ;
//    NSString *str_enopton;
//
//    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
//    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
//    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
//    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
//    str_enIscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_iScheme];
//    str_enopton =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_option];
//    NSString *str_enfolio ;
//    if ([selectSIPtypeInt isEqualToString:@"1"]) {
//        str_enfolio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
//
//
//    }else{
//        str_enfolio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
//
//    }
//
//    NSString *str_eni_Plan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_plan];
//    NSString *str_enAmount =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_Sipamount.text];
//
//    NSString *str_i_RedFlg =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//    NSString *str_i_oldihno = @"MA";
//    NSString *str_i_InvDistFlag =@"RA";
//    NSString *Subbroker;
//    NSString *i_arn;
//    NSString *SubbrokerArn;
//    NSString *EUINFlag ;
//    NSString *EuinCode;
//
//    if ([str_driect  isEqualToString:@"Regular"]){
//        i_arn =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_Arn.text];
//        SubbrokerArn = [XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_subBroker.text];
//        Subbroker=[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_SubArn.text];
//        if ([btn_yesEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
//            EUINFlag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"N"];
//        }else{
//            EUINFlag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"Y"];
//        }
//
//        if ([str_EuinNo  length] == 0) {
//            EuinCode  =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//        }else{
//            EuinCode  =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_EuinNo];
//
//
//        }
//
//    }else{
//
//        EUINFlag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"Y"];
//
//        i_arn =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"000000-0"];
//        SubbrokerArn = [XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//        Subbroker=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//
//        //     EUINFlag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//        EuinCode  =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//    }
//    NSString *i_Userid =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
//    NSString *i_Useremail =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserEmailID]];
//
//
//
//
//    NSString *desci  =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"yes~I~"];
//
//
//    NSString *str_pan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedPan];
//    NSString *str_sipstartday =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_sipStartDay.text];
//    NSString *str_sipendday =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_sipStartDay.text];
//
//
//    NSString *trtype =@"UA";
//
//
//    NSString *nomiee1,*nomiee2,*nomiee3;
//    NSString *nomieepay1,*nomieepay2,*nomieepay3;
//
//    if (arr_nomieerefence.count == 0 ) {
//
//
//        [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
//
//        nomiee1 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: @""];
//
//        nomieepay1=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"" ];
//
//
//        nomiee2 =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//
//        nomieepay2=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @"" ];
//        nomiee3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @""];
//
//        nomieepay3=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//
//
//    }
//    else if (arr_nomieerefence.count == 1 ) {
//
//
//        [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
//
//        nomiee1 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee1.currentTitle];
//
//        nomieepay1=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee1.text ];
//
//
//        nomiee2 =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//
//        nomieepay2=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @"" ];
//        nomiee3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @""];
//
//        nomieepay3=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//
//
//    }else if (arr_nomieerefence.count == 2 ){
//        nomiee1 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee1.currentTitle];
//
//        nomieepay1=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee1.text ];
//        nomiee2 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee2.currentTitle];
//
//        nomieepay2=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee2.text ];
//        nomiee3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @""];
//
//        nomieepay3=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//    }
//    else if (arr_nomieerefence.count == 3 ){
//        nomiee1 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee1.currentTitle];
//
//        nomieepay1=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee1.text ];
//        nomiee2 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee2.currentTitle];
//
//        nomieepay2=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee2.text ];
//        nomiee3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee3.currentTitle];
//
//        nomieepay3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee3.text ];
//
//    }
//    NSString *str_invAmount;
//    NSString *str_payvalMode;
//    NSString *  Str_Bank;
//    NSString * Str_BankID;
//    NSString *  Bank;
//    NSString * BankID;
//    if ([selectSIPtypeInt isEqualToString:@"1"]) {
//
//        Str_BankID=  [XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//        Str_Bank = [XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//        str_payvalMode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_modeRe.text];
//        str_invAmount        =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_Sipamount.text];
//    }else{
//        str_payvalMode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_modeRe.text];
//        str_invAmount =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//        BankID=[NSString stringWithFormat:@"%@~%@", paymentBankDic[@"gb_bankcode"],paymentBankDic[@"kb_Accounttype"]];
//        Bank=[NSString stringWithFormat:@"~%@",paymentBankDic[@"kb_BankAcNo"]];
//        Str_BankID=  [XTAPP_DELEGATE convertToBase64StrForAGivenString:BankID];
//        Str_Bank = [XTAPP_DELEGATE convertToBase64StrForAGivenString:Bank];
//
//
//    }
//
//
//
//    NSString *str_url = [NSString stringWithFormat:@"%@SentpurchasemailRed?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&i_Fund=%@&i_Scheme=%@&i_Plan=%@&i_Option=%@&i_Acno=%@&i_RedFlg=%@&i_UntAmtFlg=%@&i_UntAmtValue=%@&i_Userid=%@&i_Tpin=%@&i_Mstatus=%@&i_oldihno=%@&i_InvDistFlag=%@&i_Tfund=%@&i_Tscheme=%@&i_Tplan=%@&i_Toption=%@&i_Tacno=%@&i_Agent=%@&i_Mapinid=%@&i_entby=%@&ARNCode=%@&EUINFlag=%@&Subbroker=%@&SubbrokerArn=%@&EuinCode=%@&EuinValid=%@&o_ErrNo=%@&Otp=%@&trtype=%@&PanNo=%@&Desci=%@&IMEINO=%@&Bankid=%@%@&upiid=%@&paymenttype=%@&nom1=%@&nom2=%@&nom3=%@&nomper1=%@&nomper2=%@&nomper3=%@&sipfrequency=%@&sipstartdt=%@&sipenddt=%@&sipamount=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_enIscheme,str_eni_Plan,str_enopton,str_enfolio,str_i_RedFlg,str_i_RedFlg,str_enAmount,i_Userid,str_i_RedFlg,str_i_RedFlg,str_i_oldihno,str_i_InvDistFlag,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,i_Useremail,i_arn,EUINFlag,Subbroker,SubbrokerArn,EuinCode,EUINFlag,str_i_RedFlg,str_i_RedFlg,trtype,str_pan,desci,unique_UDID,Str_BankID,Str_Bank,str_i_RedFlg,str_payvalMode,nomiee1,nomiee2,nomiee3,nomieepay1,nomieepay2,nomieepay3,str_i_RedFlg,str_sipstartday,str_sipendday,str_invAmount];
//
//    NSLog(@"%@",str_url);
//    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
//        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
//
//        if (error_statuscode==0) {
//
//            self->str_referId = responce[@"DtData"][0][@"ID"];
//            SIPComfVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SIPComfVC"];
//            destination.str_pan= self->selectedPan;
//
//            if ([self->selectSIPtypeInt isEqualToString:@"1"]) {
//                if ([self->btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]){
//                    destination.str_schemmeType = @"Yes";
//
//                    destination.schemmeDetialsDic =self->newSchemmeDic;
//                    destination.str_folio =self->tf_folio.text;
//
//                }else{
//                    destination.str_schemmeType = @"No";
//
//                    destination.schemeDic =self->schemmeDic;
//                }
//
//
//            }else{
//                destination.str_schemmeType = @"Yes";
//
//                destination.schemmeDetialsDic =self->newSchemmeDic;
//
//            }
//            destination.  str_Category =  self->str_Category;
//            destination.str_folio =self->tf_folio.text;
//            destination.str_tat =self->str_tat;
//            destination.str_Fund =self->tf_fund.text;
//            destination.str_Secheme =self->tf_scheme.text;
//            destination.str_Amount =self->tf_Sipamount.text;
//            destination.str_referId =self->str_referId;
//            destination.paymentModeArray =self->paymentModeArr;
//            destination.str_selectedFundID = self->str_selectedFundID;
//
//
//            destination.sipType =self->selectSIPtypeInt;
//            destination.famliyStr= @"famliyStr";
//
//            destination.str_installments=self->tf_noodIns.text;
//            destination.str_investment =self->tf_investment.text;
//            destination.str_SipStartDay =self->tf_sipStartDay.text;
//            destination.str_SipEndDay =self->tf_SipEndDay.text;
//            destination.sipday = self->tf_days.text;
//            KTPUSH(destination,YES);
//            //     [self paymentModeApi];
//        }
//
//        else{
//            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
//            });
//        }
//    } failure:^(NSError *error) {
//
//    }];
//}
#pragma mark - validateSubARN API

-(void)validateSubARNAPI{
  [ [APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    // NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_o_ErrNo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_subarn.text];
    
    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_arnCode.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@ValidateBrokercode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&AgentCd=%@&SubAgentCd=%@o_ErrNo&=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,Str_AgentCd,str_SubAgentCd,str_o_ErrNo];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            if ([responce[@"DtData"] count]  != 0) {
                self->subEArnarray= [[NSMutableArray alloc]init];
                if (self->subEArnarray.count == 0) {
                    self->subEArnarray = responce[@"DtData"];
                    self->txt_euin.inputView = self->picker_dropDown;
                    [self->picker_dropDown reloadAllComponents];
                    
                    if ([self->btn_yesEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]) {
                        [self->txt_euin becomeFirstResponder];
                        
                    }
                }
                self->subEArnarray = responce[@"DtData"];
            }
            else{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Please  Check ARN code"];
            }
            
            NSLog(@"%@",self->subEArnarray);
            
            
        }
        else{
            
            self->txt_subarn.text =@"ARN-";
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - TableView Delegate and Data Source delegate starts

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nomieeDetailsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NomieetableCell *cell=(NomieetableCell*)[tableView dequeueReusableCellWithIdentifier:@"NomieetableCell"];
    if (cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NomieetableCell" owner:self options:nil];
        cell = (NomieetableCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.NomieeName.text=[NSString stringWithFormat:@"%@",nomieeDetailsArr[indexPath.row][@"kn_NomName"]];
    if([[arr_checkUncheckRec objectAtIndex:indexPath.row] isEqualToString:@"Uncheck"]){
        [cell.checkBtn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }else{
        [cell.checkBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    [cell.checkBtn addTarget:self action:@selector(radioBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.borderColor = [UIColor whiteColor].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(0, 10, tableView.frame.size.width, 40);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = KTButtonBackGroundBlue;
    headerLabel.font = [UIFont boldSystemFontOfSize:20.0];
    headerLabel.text = @"Select Nominee";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];
    
    // 5. Finally return
    return headerView;
}
-(void)radioBtnTapped:(UIButton*)sender{
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:nomieeTableView];
    NSIndexPath *indexPath = [nomieeTableView indexPathForRowAtPoint:touchPoint];
    if([[arr_checkUncheckRec objectAtIndex:indexPath.row] isEqualToString:@"Uncheck"]){
        
        
        
        [sender setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [arr_checkUncheckRec replaceObjectAtIndex:indexPath.row withObject:@"Check"];
    }
    else{
        
        
        [sender setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [arr_checkUncheckRec replaceObjectAtIndex:indexPath.row withObject:@"Uncheck"];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 00.0f;
}
- (IBAction)Atc_Done:(id)sender {
    
    arr_nomieerefence =[[NSMutableArray alloc]init];
    
    for (int i=0; i<arr_checkUncheckRec.count; i++) {
        
        
        if ([arr_checkUncheckRec[i] isEqualToString:@"Check"]) {
            NSLog(@"%@",arr_checkUncheckRec[i]);
            
            
            [arr_nomieerefence addObject:nomieeDetailsArr[i]];
        }else{
            NSLog(@"%@",arr_checkUncheckRec[i]);
        }
    }
    if (arr_nomieerefence.count  >= 4) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Maximum 3 Nominees are Allowed"];
        NSLog(@"%@",arr_nomieerefence);
        [view_Nominee1 setHidden:YES];
        [view_Nominee2 setHidden:YES];
        [view_Nominee3 setHidden:YES];
        [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
        
    }else{
        NSLog(@"%@",arr_nomieerefence);
        lbl_nomiee1.userInteractionEnabled =true;
        lbl_nomiee2.userInteractionEnabled =true;
        lbl_nomiee3.userInteractionEnabled =true;
        
        if (arr_nomieerefence.count == 1 ) {
            
            
            [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
            
            
            tf_nomieesPer1.text =@"100";
            [view_Nominee1 setHidden:NO];
            [view_Nominee2 setHidden:YES];
            [view_Nominee3 setHidden:YES];
            [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
            
            [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
            
        }else if (arr_nomieerefence.count == 2 ){
            [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
            
            [lbl_nomiee2 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[1][@"kn_NomName"]] forState:UIControlStateNormal];
            
            tf_nomieesPer1.text =@"50";
            tf_nomieesPer2.text =@"50";
            [view_Nominee1 setHidden:NO];
            [view_Nominee2 setHidden:NO];
            [view_Nominee3 setHidden:YES];
            [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
        }
        else if (arr_nomieerefence.count == 3 ){
            [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
            
            [lbl_nomiee2 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[1][@"kn_NomName"]] forState:UIControlStateNormal];
            [lbl_nomiee3 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[2][@"kn_NomName"]] forState:UIControlStateNormal];
            
            tf_nomieesPer1.text =@"33.333";
            tf_nomieesPer2.text =@"33.333";
            tf_nomieesPer3.text =@"33.333";
            [view_Nominee1 setHidden:NO];
            [view_Nominee2 setHidden:NO];
            [view_Nominee3 setHidden:NO];
            [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
            
        }
        
        
        [view_nomiee setHidden:YES];
        
    }
    
}



# pragma mark   Fund
-(void)getSIPFunds
{
    
    [ [APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_opt = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@"A"];
    NSString *str_fundcode = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@""];
    NSString *str_schmtype = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterSIP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_opt,str_fundcode,str_schmtype];
    NSLog(@"fund url is %@",str_url);
    
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        self->sipFunddetailsarr = responce[@"Dtinformation"];
        if (self->sipFunddetailsarr.count>1) {
            txt_fund.inputView=picker_dropDown;
            [self->picker_dropDown reloadAllComponents];
                        self->txt_fund.userInteractionEnabled = true;
        }
        else{
            self->txt_fund.userInteractionEnabled = true;
            
            self->txt_fund.inputView=self->picker_dropDown;
            [self->picker_dropDown reloadAllComponents];
        }
        NSLog(@"%@",self->sipFunddetailsarr);
    } failure:^(NSError *error) {
        
    }];
    
    
    
}
#pragma mark - categoryListApi
-(void)categoryListApi{
    
    [ [APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_url = [NSString stringWithFormat:@"%@GetAssetclass?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&schemetype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_folio];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            self->categoryArr= [[NSMutableArray alloc]init];
            
            self->txt_category.userInteractionEnabled =true;
            if (self->categoryArr.count == 0) {
                self->categoryArr = responce[@"DtData"];
                self->txt_category.inputView = self->picker_dropDown;
                [self->picker_dropDown reloadAllComponents];
                [self->txt_category becomeFirstResponder];
                
                
            }
            
            self->categoryArr = responce[@"DtData"];
            
            NSLog(@"%@",self->categoryArr);
            
            
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - get Profile Percentage

-(void)getProfilePercentageAPI{
    [ [APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_url = [NSString stringWithFormat:@"%@Profilepercentage?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&userid=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
                      [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            NSString *str_per=[NSString stringWithFormat:@"%@",responce[@"Dtdata"][0][@"Percentage"]];
            CGFloat cent=[str_per floatValue]/100;
            if (cent>0.0000000) {
                
            }
            else{
            }
            if ([str_per intValue]<100) {
                [[SharedUtility sharedInstance]showAlertWithTitle:KTSuccessMsg forMessage:[NSString stringWithFormat:@"Your profile is not 100%% complete. Do you want to complete your profile to transact smoothly?"] andAction1:@"YES" andAction2:@"NO" andAction1Block:^{
                    int navigateScreen=[responce[@"Table1"][0][@"Screen"] intValue];
                    
                            NSLog(@"%@",str_per);
                } andCancelBlock:^{
                    
                }];
            }else
            {
                NSLog(@"%@",str_per);
            }
            
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - NewSchemeListApi
-(void)newSchmemListApi{
    
    
    
    [ [APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_folio;

        str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
    

    
    
    NSString *str_enCategory =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_category.text];
NSString *str_trantype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"S"];

    NSString *  investflag ;
    if ([btn_driect.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
        investflag   = @"Regular";
        
    }else{
        
        investflag = @"Direct";
        
    }
    NSString *str_investflag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:investflag];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&schemetype=%@&opt=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_enCategory,str_trantype,str_investflag];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            if ([responce[@"Dtinformation"] count]  != 0) {
                
                self->newschemeArr= [[NSMutableArray alloc]init];
                self->txt_schemme.userInteractionEnabled =true;
                
                self->newschemeArr =  responce[@"Dtinformation"];
                self->txt_schemme.inputView=self->picker_dropDown;
                [self->txt_schemme becomeFirstResponder];
                if (self->newschemeArr.count == 0) {
                    
                    self->newschemeArr =  responce[@"Dtinformation"];
                    self->txt_schemme.inputView=self->picker_dropDown;
                    [self->txt_schemme becomeFirstResponder];
               
                    
                    self->txt_schemme.userInteractionEnabled =false;
                    
                    
                }else{
                    self->newschemeArr =  responce[@"Dtinformation"];
                           txt_schemme.inputView=picker_dropDown;
                    [self->txt_schemme becomeFirstResponder];
                    [self->txt_schemme becomeFirstResponder];
             
                }
                
                
                
                NSLog(@"%@",responce);
            }else{
                
                [self->txt_schemme resignFirstResponder];;
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No new schemes Found"];
            }
            
            
            
            
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SIPSumbitAPI API
-(void)NewPurchaseSumbitAPI{
    
    [ [APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    
    NSLog(@"%@",str_driect);
    
    
    NSString *str_enIscheme ;
    NSString *str_enopton;
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    str_enIscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_iScheme];
    str_enopton =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_option];
    NSString *str_enfolio  = [XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];

    
    NSString *str_eni_Plan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_plan];
    NSString *str_enAmount =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_amount.text];
    
    NSString *str_i_RedFlg =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_i_oldihno = @"MA";
    NSString *str_i_InvDistFlag =@"RA";
    NSString *Subbroker;
    NSString *i_arn;
    NSString *SubbrokerArn;
    NSString *EUINFlag ;
    NSString *EuinCode;
    
if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
        i_arn =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_arnCode.text];
        SubbrokerArn = [XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_sub.text];
        Subbroker=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_subarn.text];
        if ([btn_yesEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
            EUINFlag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"N"];
        }else{
            EUINFlag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"Y"];
        }
        
        if ([str_EuinNo  length] == 0) {
            EuinCode  =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
        }else{
            EuinCode  =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_EuinNo];
            
            
        }
        
    }else{
        
        EUINFlag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"Y"];
        
        i_arn =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"000000-0"];
        SubbrokerArn = [XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
        Subbroker=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
        
        //     EUINFlag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
        EuinCode  =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    }
    NSString *i_Userid =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *i_Useremail =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserEmailID]];
    
    
    
    
    NSString *desci  =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"yes~I~"];
    
    
    NSString *str_pan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedPan];
  
    
    
    NSString *trtype =@"UA";
    
    
    NSString *nomiee1,*nomiee2,*nomiee3;
    NSString *nomieepay1,*nomieepay2,*nomieepay3;
    
    if (arr_nomieerefence.count == 0 ) {
        
        
        [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
        
        nomiee1 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: @""];
        
        nomieepay1=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"" ];
        
        
        nomiee2 =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
        
        nomieepay2=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @"" ];
        nomiee3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @""];
        
        nomieepay3=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
        
        
    }
    else if (arr_nomieerefence.count == 1 ) {
        
        
        [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
        
        nomiee1 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee1.currentTitle];
        
        nomieepay1=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomieesPer1.text ];
        
        
        nomiee2 =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
        
        nomieepay2=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @"" ];
        nomiee3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @""];
        
        nomieepay3=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
        
        
    }else if (arr_nomieerefence.count == 2 ){
        nomiee1 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee1.currentTitle];
        
        nomieepay1=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomieesPer1.text ];
        nomiee2 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee2.currentTitle];
        
        nomieepay2=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomieesPer1.text ];
        nomiee3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @""];
        
        nomieepay3=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    }
    else if (arr_nomieerefence.count == 3 ){
        nomiee1 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee1.currentTitle];
        
        nomieepay1=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomieesPer1.text ];
        nomiee2 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee2.currentTitle];
        
        nomieepay2=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomieesPer2.text ];
        nomiee3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee3.currentTitle];
        
        nomieepay3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomieesPer3.text ];
        
    }
    NSString *str_invAmount;
    NSString *str_payvalMode;
    NSString *  Str_Bank;
    NSString * Str_BankID;
    NSString *  Bank;
    NSString * BankID;

//str_payvalMode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_modeRe.text];
        str_invAmount =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
        BankID=[NSString stringWithFormat:@"%@~%@", paymentBankDic[@"gb_bankcode"],paymentBankDic[@"kb_Accounttype"]];
        Bank=[NSString stringWithFormat:@"~%@",paymentBankDic[@"kb_BankAcNo"]];
        Str_BankID=  [XTAPP_DELEGATE convertToBase64StrForAGivenString:BankID];
        Str_Bank = [XTAPP_DELEGATE convertToBase64StrForAGivenString:Bank];
        
        
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@SentpurchasemailRed?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&i_Fund=%@&i_Scheme=%@&i_Plan=%@&i_Option=%@&i_Acno=%@&i_RedFlg=%@&i_UntAmtFlg=%@&i_UntAmtValue=%@&i_Userid=%@&i_Tpin=%@&i_Mstatus=%@&i_oldihno=%@&i_InvDistFlag=%@&i_Tfund=%@&i_Tscheme=%@&i_Tplan=%@&i_Toption=%@&i_Tacno=%@&i_Agent=%@&i_Mapinid=%@&i_entby=%@&ARNCode=%@&EUINFlag=%@&Subbroker=%@&SubbrokerArn=%@&EuinCode=%@&EuinValid=%@&o_ErrNo=%@&Otp=%@&trtype=%@&PanNo=%@&Desci=%@&IMEINO=%@&Bankid=%@%@&upiid=%@&paymenttype=%@&nom1=%@&nom2=%@&nom3=%@&nomper1=%@&nomper2=%@&nomper3=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_enIscheme,str_eni_Plan,str_enopton,str_enfolio,str_i_RedFlg,str_i_RedFlg,str_enAmount,i_Userid,str_i_RedFlg,str_i_RedFlg,str_i_oldihno,str_i_InvDistFlag,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,i_Useremail,i_arn,EUINFlag,Subbroker,SubbrokerArn,EuinCode,EUINFlag,str_i_RedFlg,str_i_RedFlg,trtype,str_pan,desci,unique_UDID,Str_BankID,Str_Bank,str_i_RedFlg,str_payvalMode,nomiee1,nomiee2,nomiee3,nomieepay1,nomieepay2,nomieepay3];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        
        if (error_statuscode==0) {
            
            self->str_referId = responce[@"DtData"][0][@"ID"];
            NewPurchaseConfVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"NewPurchaseConfVC"];
            destination.str_pan= self->selectedPan;

//paymentBankDic
            NSMutableArray * arr = [[NSMutableArray alloc]initWithObjects:paymentBankDic, nil];
            
            
                destination.schemmeDetialsDic =self->newSchemmeDic;
            destination.str_pan =self->selectedPan;
            destination.str_Fund =self->txt_fund.text;
            destination.str_Secheme =self->txt_schemme.text;
            destination.str_Amount =self->txt_amount.text;
            destination.str_referId =self->str_referId;
            destination.paymentBantArr =arr;
            destination.str_selectedFundID = self->str_selectedFundID;
                NSArray *minorRecordDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='P' "]];
                KT_TABLE12 *pan_rec=minorRecordDetails[0];
            destination.str_name =pan_rec.invName ;
            if ([self->str_driect  isEqualToString:@"Regular"] || [self->str_driect  isEqualToString:@"REGULAR"]){
                destination.str_arn =self->txt_arnCode.text ;
                destination.str_subarn =self->txt_subarn.text ;
            }else{
                destination.str_arn =@"-";
                destination.str_subarn =@"-";
                
            }


            destination.famliyStr= @"Primary";

                 KTPUSH(destination,YES);

            //     [self paymentModeApi];
        }
        
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
