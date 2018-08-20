
//
//  SIPWithpanVC.m
//  KTrack
//
//  Created by  ramakrishna.MV on 04/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "SIPWithPPanVC.h"

@interface SIPWithPPanVC ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    /// view
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *view_type;
    __weak IBOutlet UIView *view_foilo;
    __weak IBOutlet UIView *view_category;
    __weak IBOutlet UIView *view_schemeType;
    __weak IBOutlet UIView *view_repemetionType;
    __weak IBOutlet UIView *view_scheme;
    __weak IBOutlet UIView *view_arn;
    __weak IBOutlet UIView *view_EUIN;
    __weak IBOutlet UIView *view_installments;
    __weak IBOutlet UIView *view_paymentAmount;
    __weak IBOutlet UIView *view_addNominee;
    __weak IBOutlet UIView *view_checkNominee;
    __weak IBOutlet UIView *view_Nominee1;
    __weak IBOutlet UIView *view_Nominee2;
    __weak IBOutlet UIView *view_Nominee3;
    __weak IBOutlet UIView *view_submit;
    __weak IBOutlet UIView *view_nomiee;
    
    __weak IBOutlet UIView *view_sipAmount;
    __weak IBOutlet UITableView *nomieeTableView;
    
    /////  text Field
    __weak IBOutlet UITextField *tf_paymentbank;
    __weak IBOutlet UITextField *tf_SIPType;
    __weak IBOutlet UITextField *tf_fund;
    __weak IBOutlet UITextField *tf_folio;
    __weak IBOutlet UITextField *tf_category;
    __weak IBOutlet UITextField *tf_scheme;
    __weak IBOutlet UITextField *tf_Arn;
    __weak IBOutlet UITextField *tf_subBroker;
    __weak IBOutlet UITextField *tf_SubArn;
    __weak IBOutlet UITextField *tf_euin;
    __weak IBOutlet UITextField *tf_investment;
    __weak IBOutlet UITextField *tf_noodIns;
    __weak IBOutlet UITextField *tf_days;
    __weak IBOutlet UITextField *tf_sipStartDay;
    __weak IBOutlet UITextField *tf_SipEndDay;
    __weak IBOutlet UITextField *tf_Sipamount;
    __weak IBOutlet UITextField *tf_modeRe;
    __weak IBOutlet UITextField *tf_miniAmount;
    __weak IBOutlet UITextField *tf_nomiee1;
    __weak IBOutlet UITextField *tf_nomiee2;
    __weak IBOutlet UITextField *tf_nomiee3;
    
    
    /// label
    __weak IBOutlet UIButton *lbl_nomiee1;
    __weak IBOutlet UIButton *lbl_nomiee2;
    __weak IBOutlet UIButton *lbl_nomiee3;
    
    __weak IBOutlet UILabel *lbl_SIPAmount;
    __weak IBOutlet UILabel *lbl_MiniAmunt;
    __weak IBOutlet UILabel *lbl_installments;
    
    
    ////btn
    
    __weak IBOutlet UIButton *btn_addNomiee;
    __weak IBOutlet UIButton *btn_yesEuin;
    __weak IBOutlet UIButton *btn_nEuin;
    __weak IBOutlet UIButton *btn_distri;
    __weak IBOutlet UIButton *btn_driect;
    __weak IBOutlet UIButton *btn_newScheme;
    __weak IBOutlet UIButton *btn_exitSeheme;
    
    __weak IBOutlet UIButton *btn_submit;
    __weak IBOutlet UIButton *btn_selectNomiee;
    
    ////  Atc
    
    // Array
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
NSMutableArray *modeofRegisArr;
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

@implementation SIPWithPPanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addElements];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addElements{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [scrollView addGestureRecognizer:singleTap];
    tf_fund.userInteractionEnabled =false;
    nomieeTableView.delegate =self;;
    nomieeTableView.dataSource =self;;
    view_nomiee.hidden = YES;
tf_folio.userInteractionEnabled =false;
    tf_paymentbank.userInteractionEnabled =false;
 tf_category.userInteractionEnabled =false;
    tf_scheme.userInteractionEnabled =false;
 tf_Arn.userInteractionEnabled =false;
tf_subBroker.userInteractionEnabled =false;
tf_SubArn.userInteractionEnabled =false;
tf_euin.userInteractionEnabled =false;
tf_investment.userInteractionEnabled =false;
tf_noodIns.userInteractionEnabled =false;
tf_days.userInteractionEnabled =false;
tf_sipStartDay.userInteractionEnabled =false;
tf_SipEndDay.userInteractionEnabled =false;
tf_Sipamount.userInteractionEnabled =false;
   tf_modeRe.userInteractionEnabled =false;
  tf_miniAmount.userInteractionEnabled =false;
tf_nomiee1.userInteractionEnabled =false;
    tf_nomiee2.userInteractionEnabled =false;
tf_nomiee3.userInteractionEnabled =false;
    /// selection Pan   // Sip Type
    NSArray *minorRecordDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='P' "]];
    KT_TABLE12 *pan_rec=minorRecordDetails[0];
    selectedPan=pan_rec.PAN;
    Siptype =[[NSArray alloc]initWithObjects:@"Existing Folio-SIP Registration ", @"New Folio-SIP Registration",@"New Folio-SIP Registration with Payment",nil];
    SiptypeDicArray =[[NSArray alloc]initWithObjects:@"1", @"2",@"3",nil];
    [self getNomineeDetails];
    
    [UIButton roundedCornerButtonWithoutBackground:btn_submit forCornerRadius:KTiPad?25.0f:btn_submit.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];

    
    NSLog(@"%@",fundDetails);
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    tf_SIPType.inputView=picker_dropDown;
    [picker_dropDown reloadAllComponents];
    tf_folio.delegate =self;
    paymentBankDic =[[NSMutableDictionary alloc]init];
  
    scrollView.delegate = self;
    [UITextField withoutRoundedCornerTextField:tf_paymentbank forCornerRadius:5.0f forBorderWidth:1.5f];
   [UITextField withoutRoundedCornerTextField:tf_investment forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_SIPType forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_folio forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_category forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_scheme forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_euin forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_days forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_modeRe forCornerRadius:5.0f forBorderWidth:1.5f];

    [view_Nominee1 setHidden:YES];
    [view_Nominee2 setHidden:YES];
    [view_Nominee3 setHidden:YES];

    [view_sipAmount setHidden:YES];

[self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];


}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
#pragma mark - scrollView Content Increase Method

-(void)scrollContentHeightIncrease:(CGFloat)height{
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width,height);
}
- (IBAction)Atc_Submit:(id)sender {
 
    if ([selectSIPtypeInt isEqualToString:@"1"]) {

        
        
        if (tf_fund.text.length == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Fund"];
        }
        else if (tf_folio.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Folio"];
        }
         else if (tf_category.text.length == 0 && [btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]){

                      [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Category"];
         }else if(tf_scheme.text.length == 0)
         {
             [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Scheme"];
         }
         else if( ( [str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]  ) && [ tf_Arn.text   isEqualToString:@"ARN-" ] ){
             
             
             
             [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter ARN code "];

         }
         else if ( ( [str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]  )  &&  ! [ tf_Arn.text   isEqualToString:@"ARN-" ]  &&  ![ tf_Arn.text   isEqualToString:@"ARN-" ]     && [tf_Arn.text   isEqualToString:tf_SubArn.text] ){
             [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"  ARN  Code  and  sub ARN code  Should not be Same "];
             
         }
         else if( ( [str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]  ) &&  [btn_nEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]] && tf_euin.text.length == 0  )  {
             [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Select  EUIN  No  "];
             
         }
   
         else if (tf_investment.text.length == 0){
             [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Investment Frequency "];
         }
         else if (tf_noodIns.text.length == 0  ||  [str_installments integerValue]  >  [tf_noodIns.text   integerValue]   ||   [tf_noodIns.text   integerValue]   >500 ){
             
             
             if (tf_noodIns.text.length == 0) {
                 [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter  the No of Installments  "];

             }else if ( [str_installments integerValue]  >=   [tf_noodIns.text   integerValue] ){
                 [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Please enter  the No of  Installments  greater Than Minimum%@ ",str_installments]];
             }
             else if ([tf_noodIns.text   integerValue]   > 500){
                 [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Please Enter  the No of  Installments  Less Than Minimum:500 "]];
             }
         }
         else if (tf_days.text.length == 0){
             [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the SIP Day "];
         }
         else if (tf_sipStartDay.text.length == 0){
             [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the SIP  Start Days "];
         }
         else if (tf_SipEndDay.text.length == 0){
             [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the SIP  End Days "];
         }
         else if (tf_modeRe.text.length == 0){
             [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Mode  of  Registrantion "];
         }
//         else if (tf_paymentbank.text.length == 0){
//             [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Payment  Bank "];
//         }
         else if (tf_Sipamount.text.length == 0 ||  [miniAmount integerValue]  >  [tf_Sipamount.text    integerValue] ||   [tf_Sipamount.text    integerValue]  == 0000){
             
             if (tf_Sipamount.text.length == 0) {
                 [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter   Amount"];
                 
             
            }
             else if (    [tf_Sipamount.text    integerValue]  == 0000){
                 [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter  theAmount  greater Than  0 "];
             }
             else if ( [miniAmount integerValue]  >   [tf_Sipamount.text    integerValue] ){
                 [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Please Enter  theAmount  greater Than Minimum Amount%@  ",miniAmount]];
             }
         }
         else{
             SIPComfVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SIPComfVC"];
             destination.str_pan= self->selectedPan;
             
             if ([self->selectSIPtypeInt isEqualToString:@"1"]) {
                 if ([self->btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]){
                     destination.str_schemmeType = @"Yes";
                     destination.str_folio =self->tf_folio.text;
                     destination.schemmeDetialsDic =self->newSchemmeDic;
                     
                     
                 }else{
                     destination.str_schemmeType = @"No";
                     destination.str_folio =self->tf_folio.text;
                     
                     destination.schemeDic =self->schemmeDic;
                 }
                 
                 
             }else{
                 destination.str_schemmeType = @"Yes";
                 destination.str_folio =@"-";
                 destination.schemmeDetialsDic =self->newSchemmeDic;
                 
             }
             
             if ([self->str_driect  isEqualToString:@"Regular"] || [self->str_driect  isEqualToString:@"REGULAR"]){
                 
                 if ([tf_Arn.text isEqualToString:@"ARN-"]) {
                     destination.str_arn =@"-";
                 }else{
                     destination.str_arn =self->tf_Arn.text ;
                     
                 }
                 if ([tf_SubArn.text isEqualToString:@"ARN-"]) {
                     destination.str_subarn =@"-";
                 }else{
                     destination.str_subarn =self->tf_SubArn.text ;
                 }
                 
             }else{
                 destination.str_arn =@"-";
                 destination.str_subarn =@"-";
                 
             }
             
             destination.str_PayModeVal= tf_modeRe.text;
             destination.  str_Category =  self->str_Category;
             //            destination.str_folio =self->tf_folio.text;
             destination.str_tat =self->str_tat;
             destination.str_Amount =self->tf_Sipamount.text;
             destination.str_Fund =self->tf_fund.text;
             destination.str_Secheme =self->tf_scheme.text;
             destination.str_Amount =self->tf_Sipamount.text;
             destination.str_referId =self->str_referId;
             destination.paymentModeArray =self->paymentModeArr;
             destination.str_selectedFundID = self->str_selectedFundID;
             
             if ([str_EuinNo  length] == 0) {
                 destination.str_EuinCode =@"";
                 
             }else{
                 destination.str_EuinCode =str_EuinNo;
                 
                 
                 
             }
             
             
             NSArray *minorRecordDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='P' "]];
             KT_TABLE12 *pan_rec=minorRecordDetails[0];
             destination.str_name =pan_rec.invName ;
             
             
             destination.sipType =self->selectSIPtypeInt;
             destination.famliyStr= @"PrimaryPan";
             
             destination.str_installments=self->tf_noodIns.text;
             destination.str_investment =self->tf_investment.text;
             destination.str_SipStartDay =self->tf_sipStartDay.text;
             destination.str_SipEndDay =self->tf_SipEndDay.text;
             destination.sipday = self->tf_days.text;
             KTPUSH(destination,YES);
             
         }
        }
    else if ([selectSIPtypeInt isEqualToString:@"2"])
    {
   
        
        if (tf_fund.text.length == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Fund"];
        }
       
        else if (tf_category.text.length == 0){
            
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Category"];
        }
        else if(tf_scheme.text.length == 0)
        {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Scheme"];
        }
        else if( ( [str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]  ) && [ tf_Arn.text   isEqualToString:@"ARN-" ] ){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter ARN code "];
            
        }
        else if ( ! [ tf_Arn.text   isEqualToString:@"ARN-" ]  &&  ![ tf_Arn.text   isEqualToString:@"ARN-" ]     && [tf_Arn.text   isEqualToString:tf_SubArn.text] ){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"  ARN  Code  and  sub ARN code  Should not be Same "];
            
        }
        else if( ( [str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]  ) &&  [btn_nEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]] && tf_euin.text.length == 0  )  {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Select  EUIN  No  "];
            
        }
        
        else if (tf_investment.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Investment Frequency "];
        }
        else if (tf_noodIns.text.length == 0  ||  [str_installments integerValue]  >  [tf_noodIns.text   integerValue]   ||   [tf_noodIns.text   integerValue]   >500 ){
            
            
            if (tf_noodIns.text.length == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter  the No of Installments  "];
                
            }else if ( [str_installments integerValue]  >=   [tf_noodIns.text   integerValue] ){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Please enter  the No of  Installments  greater than Minimum%@ ",str_installments]];
            }
            else if ([tf_noodIns.text   integerValue]   > 500){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Please enter  the No of  Installments  less than Minimum:500 "]];
            }
        }
        else if (tf_paymentbank.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Payment  Bank "];
        }
        else if (tf_days.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the SIP Day "];
        }
        else if (tf_sipStartDay.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the SIP  Start Days "];
        }
        else if (tf_SipEndDay.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the SIP  End Days "];
        }
        else if (tf_modeRe.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Mode  of  Registrantion "];
        }
        else if (tf_Sipamount.text.length == 0 ||  [miniAmount integerValue]  >  [tf_Sipamount.text    integerValue] ||   [tf_Sipamount.text    integerValue]  == 0000 ){
            
            if (tf_Sipamount.text.length == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter   Amount"];
                
            }
            else if (    [tf_Sipamount.text    integerValue]  == 0000){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter  theAmount  greater Than  0 "];
            }else if ( [miniAmount integerValue]  >   [tf_Sipamount.text    integerValue] ){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Please Enter  theAmount  greater Than Minimum Amount%@  ",miniAmount]];
            }
        }else{
            
            
            if (![btn_selectNomiee.imageView.image isEqual: [UIImage imageNamed:@"uncheck"]])
            {
                //         [self purchaseurl];
                
                [self SIPSumbitAPI];
                
            }else{
                if (arr_nomieerefence.count == 0  ) {
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Add at least one nominee "];
                    
                }else{
                    
                    if (arr_nomieerefence.count == 1 ) {
                        if ([tf_nomiee1.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                        }else if ([tf_nomiee1.text intValue ]  !=  100 ){
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                            
                        }
                        else{
                            [self SIPSumbitAPI];
                            
                        }
                    }
                    else if (arr_nomieerefence.count == 2){
                        if ([tf_nomiee1.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                            
                        }
                        else    if ([tf_nomiee2.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee two Percentage"];
                            
                            
                        }else if ([tf_nomiee1.text floatValue ] + [tf_nomiee2.text floatValue ] !=  100 ){
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                            
                        }
                        else{
                            [self SIPSumbitAPI];
                            
                        }
                    }
                    else if (arr_nomieerefence.count == 3){
                        if ([tf_nomiee1.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                            
                        }
                        else   if ([tf_nomiee2.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee two Percentage"];
                        }
                        else   if ([tf_nomiee3.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee three Percentage"];
                            
                        }else if ([tf_nomiee1.text floatValue ] + [tf_nomiee2.text floatValue ]  + [tf_nomiee3.text floatValue ]  !=  100 ){
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                        }
                        else{
                            [self SIPSumbitAPI];
                            
                        }
                    }else{
                        [self SIPSumbitAPI];
                        
                    }
                    
                }
                
                NSLog(@"fund  %@",schemmeDic);
            }
        }
        
    
        
    }else if ([selectSIPtypeInt isEqualToString:@"3"]){
        
        
        if (tf_fund.text.length == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Fund"];
        }
        
        else if (tf_category.text.length == 0){
            
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Category"];
        }
        else if(tf_scheme.text.length == 0)
        {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Scheme"];
        }
        else if( ( [str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]  ) && [ tf_Arn.text   isEqualToString:@"ARN-" ] ){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter ARN code "];
            
        }
        else if ( ! [ tf_Arn.text   isEqualToString:@"ARN-" ]  &&  ![ tf_Arn.text   isEqualToString:@"ARN-" ]     && [tf_Arn.text   isEqualToString:tf_SubArn.text] ){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"  ARN  Code  and  sub ARN code  Should not be Same "];
            
        }
        else if( ( [str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]  ) &&  [btn_nEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]] && tf_euin.text.length == 0  )  {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Select  EUIN  No  "];
            
        }
        
        else if (tf_investment.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Investment Frequency "];
        }
        else if (tf_noodIns.text.length == 0  ||  [str_installments integerValue]  >  [tf_noodIns.text   integerValue]   ||   [tf_noodIns.text   integerValue]   >500 ){
            
            
            if (tf_noodIns.text.length == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter  the No of Installments  "];
                
            }else if ( [str_installments integerValue]  >=   [tf_noodIns.text   integerValue] ){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Please enter  the no of  Installments  greater than Minimum%@ ",str_installments]];
            }
            else if ([tf_noodIns.text   integerValue]   > 500){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Please Enter  the No of  Installments less than Minimum:500 "]];
            }
        }
        else if (tf_days.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the SIP Day "];
        }
        else if (tf_sipStartDay.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the SIP  Start Days "];
        }
        else if (tf_SipEndDay.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the SIP  End Days "];
        }
        else if (tf_modeRe.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Mode  of  Registrantion "];
        }
        else if (tf_Sipamount .text.length == 0 ||  [miniAmount integerValue]  >  [tf_Sipamount.text   integerValue] ||  [tf_Sipamount.text    integerValue]  == 0000 ){
            
            if (tf_Sipamount.text .length == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter   Amount"];
                
            }
            else if (    [tf_Sipamount.text    integerValue]  == 0000){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter  theAmount  greater Than  0 "];
            }
            else if ( [miniAmount integerValue]  >   [tf_Sipamount.text   integerValue] ){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Please Enter  theAmount  greater Than Minimun Amount%@  ",miniAmount]];
            }
           }
        else if (tf_miniAmount.text.length == 0 ||  [lbl_SIPAmount.text integerValue]  >  [tf_miniAmount.text   integerValue]   || [tf_miniAmount.text    integerValue]  == 0000 ){
            
            if (tf_miniAmount.text.length == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter  SIP Minimum Amount"];
                
            
            }
            else if (    [tf_miniAmount.text    integerValue]  == 0000){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter  theAmount  greater Than  0 "];
            }else if ( [lbl_SIPAmount.text integerValue]  >   [tf_miniAmount.text   integerValue] ){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Please Enter  the Amount  greater Than SIP Minimun Amount%@  ",lbl_SIPAmount.text ]];
            }
            else if (tf_paymentbank.text.length == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Payment  Bank "];
            }
        }else{
            
            
            if (![btn_selectNomiee.imageView.image isEqual: [UIImage imageNamed:@"uncheck"]])
            {
                //         [self purchaseurl];
                
                [self SIPSumbitAPI];
                
            }else{
                if (arr_nomieerefence.count == 0  ) {
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Add at least one nominee "];
                    
                }else{
                    
                    if (arr_nomieerefence.count == 1 ) {
                        if ([tf_nomiee1.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                        }else if ([tf_nomiee1.text intValue ]  !=  100 ){
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                            
                        }
                        else{
                            [self SIPSumbitAPI];
                            
                        }
                    }
                    else if (arr_nomieerefence.count == 2){
                        if ([tf_nomiee1.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                            
                        }
                        else    if ([tf_nomiee2.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee two Percentage"];
                            
                            
                        }else if ([tf_nomiee1.text floatValue ] + [tf_nomiee2.text floatValue ] !=  100 ){
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                            
                        }
                        else{
                            [self SIPSumbitAPI];
                            
                        }
                    }
                    else if (arr_nomieerefence.count == 3){
                        if ([tf_nomiee1.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee one Percentage"];
                            
                        }
                        else   if ([tf_nomiee2.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee two Percentage"];
                        }
                        else   if ([tf_nomiee3.text length] == 0) {
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the Nommiee three Percentage"];
                            
                        }else if ([tf_nomiee1.text floatValue ] + [tf_nomiee2.text floatValue ]  + [tf_nomiee3.text floatValue ]  !=  100 ){
                            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Total Percentage should be 100"];
                        }
                        else{
                            [self SIPSumbitAPI];
                            
                        }
                    }else{
                        [self SIPSumbitAPI];
                        
                    }
                    
                }
                
                NSLog(@"fund  %@",schemmeDic);
            }
        }
            
        
    }else{
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Select SIP type"];

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
            tf_nomiee1.userInteractionEnabled =true;
            tf_nomiee2.userInteractionEnabled =true;
            tf_nomiee3.userInteractionEnabled =true;
            
            if (arr_nomieerefence.count == 1 ) {
                
                
                [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
                
                
                tf_nomiee1.text =@"100";
                [view_Nominee1 setHidden:NO];
                [view_Nominee2 setHidden:YES];
                [view_Nominee3 setHidden:YES];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                
            }else if (arr_nomieerefence.count == 2 ){
                [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
                
                [lbl_nomiee2 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[1][@"kn_NomName"]] forState:UIControlStateNormal];
                
                tf_nomiee1.text =@"50";
                tf_nomiee2.text =@"50";
                [view_Nominee1 setHidden:NO];
                [view_Nominee2 setHidden:NO];
                [view_Nominee3 setHidden:YES];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
            }
            else if (arr_nomieerefence.count == 3 ){
                [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
                
                [lbl_nomiee2 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[1][@"kn_NomName"]] forState:UIControlStateNormal];
                [lbl_nomiee3 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[2][@"kn_NomName"]] forState:UIControlStateNormal];
                
                tf_nomiee3.text =@"33.333";
                tf_nomiee2.text =@"33.333";
                tf_nomiee1.text =@"33.333";
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
    
    arr_nomieerefence =[[NSMutableArray alloc]init];
    for (int i=0; i<nomieeDetailsArr.count; i++) {
        [arr_checkUncheckRec addObject:@"Uncheck"];
    }
    [view_nomiee setHidden:NO];
    
    [nomieeTableView reloadData];
    
}
- (IBAction)Atc_YesEuin:(id)sender {
    
    
    tf_euin.text =nil;
    
    [view_EUIN setHidden:YES];
    
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    tf_euin.userInteractionEnabled = NO;

    [btn_yesEuin setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_nEuin setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    
    

}
- (IBAction)Atc_NoEuin:(id)sender {

    [view_EUIN setHidden:NO];
    tf_euin.text =nil;
    
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    tf_euin.userInteractionEnabled = YES;
    [ btn_nEuin setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [    btn_yesEuin setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    
}
- (IBAction)Atc_Distri:(id)sender {
    
    str_driect =@"Regular";
    
    
    [view_arn setHidden:NO];
    [view_EUIN setHidden:NO];
    
    if (![selectSIPtypeInt isEqualToString:@"1"]) {
        [view_category setHidden:NO];
    }
//    else{
//        [view_category setHidden:NO];
//
//    }
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_driect setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_distri setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_nEuin setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_yesEuin setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [self newSchmemListApi];
    
}
- (IBAction)Atc_driect:(id)sender {
    
    str_driect =@"Driect";
    
    [view_arn setHidden:YES];
    [view_EUIN setHidden:YES];
    
    if (![selectSIPtypeInt isEqualToString:@"1"]) {
            [view_category setHidden:NO];
    }
    

    

    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_nEuin setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_yesEuin setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    
    [self newSchmemListApi];
    
}
- (IBAction)Atc_existing:(id)sender {
    
    
    tf_scheme.text= nil;

    existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and pSchFlg='Y'",str_selectedFundID,selectedfolio]];
    if (existingArr.count == 1) {
        
        KT_TABLE2 *rec_fund=existingArr[0];
        tf_scheme.text=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
        miniAmount=[NSString stringWithFormat:@"%@",rec_fund.minAmt];
        selectedSecheme =[NSString stringWithFormat:@"%@",rec_fund.schDesc];
        lbl_MiniAmunt.text =[NSString stringWithFormat:@"%@",miniAmount];;
        str_iScheme =[NSString stringWithFormat:@"%@",rec_fund.sch];;
        str_option =[NSString stringWithFormat:@"%@",rec_fund.opt];;
        str_driect =[NSString stringWithFormat:@"%@",rec_fund.schType];
        [self getInvFrequency];
        str_plan =[NSString stringWithFormat:@"%@",rec_fund.pln];;
        tf_scheme.userInteractionEnabled = false;
        if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
            if ([btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                [view_category setHidden:NO];
                [view_arn setHidden:NO];
                [view_EUIN setHidden:YES];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_driect setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_distri setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
            }else{
                [view_category setHidden:YES];
                [view_arn setHidden:NO];
                [view_EUIN setHidden:YES];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                [btn_newScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
            }
            
            
        }
        else{
            
            
            if ([btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                [view_category setHidden:NO];
                [view_arn setHidden:YES];
                [view_EUIN setHidden:YES];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
            }else{
                [view_category setHidden:YES];
                [view_arn setHidden:YES];
                [view_EUIN setHidden:YES];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                [btn_newScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
            }
            
            
        }
        
        
    }else{
        tf_scheme.userInteractionEnabled = true;
        
    }
    [view_category setHidden:YES];
    
    [view_repemetionType setHidden:YES];
    [view_arn setHidden:YES];

    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    [btn_newScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    
}
- (IBAction)Atc_newScheme:(id)sender {

    [view_category setHidden:NO];
    
    [view_repemetionType setHidden:NO];
    [view_arn setHidden:YES];


    [self  categoryListApi];
    tf_scheme.text= nil;

    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
    [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];

   
    lbl_MiniAmunt.text =[NSString stringWithFormat:@" "];
    
    
}
- (IBAction)backAtc:(id)sender {
    KTPOP(true);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tf_Sipamount  ||  textField == tf_miniAmount ) {
        
        
        if (textField.text.length >= MAX_LENGTH && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        
        
        else
        {return YES;}
    }
    
    else if (textField == tf_noodIns  ) {
        
        
        if (textField.text.length >= 3 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        
        
        else
        {return YES;}
    }
    
    {return YES;}
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTextField=textField;
    if (txt_currentTextField==tf_paymentbank) {
        
        tf_paymentbank.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }
    if (txt_currentTextField==tf_modeRe) {
        
        tf_modeRe.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }
    if (txt_currentTextField==tf_euin) {
        
        tf_euin.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }
    
    if (txt_currentTextField==tf_days) {
        
        tf_days.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }
    if (txt_currentTextField==tf_SIPType) {
   
            tf_SIPType.inputView=picker_dropDown;
            [picker_dropDown reloadAllComponents];
        }
    if (txt_currentTextField==tf_investment) {
        
        tf_investment.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }
    
    
    if (txt_currentTextField==tf_fund) {
        if ([selectSIPtypeInt length] == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the SIP Type"];
            
        }else{
            tf_fund.inputView=picker_dropDown;
            [picker_dropDown reloadAllComponents];
        }
     
        
    }
    if (txt_currentTextField==tf_folio) {
        if ([selectSIPtypeInt length] == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the  Fund"];
            
        }else{
        
        tf_folio.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        }
    }
    if (txt_currentTextField==tf_scheme) {
        

        
        tf_scheme.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        
    }
    if (txt_currentTextField==tf_category) {
        
        tf_category.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        
    }
    if (txt_currentTextField==tf_category) {
        
        tf_category.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        
    }
    
    if (txt_currentTextField==tf_modeRe) {
        
        tf_modeRe.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [txt_currentTextField resignFirstResponder];
    if (textField==tf_Arn ) {
        
        if ([tf_Arn.text isEqualToString:@"ARN-"]   ) {
            
            if ([tf_Arn.text length ] == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the ARN- Code "];
                
            }
        } else {
            [self validateARNAPI];
            
        }
    }
    if (textField==tf_SubArn ) {
        [self validateSubARNAPI];
        
        
    }
    if (txt_currentTextField==tf_SIPType) {
        if ([selectSIPtypeInt length] == 0) {
  
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the SIP Type"];

        }
        else{
            if ([selectSIPtypeInt isEqualToString:@"1"]) {
                [view_category setHidden:YES];
                [view_repemetionType setHidden:YES];
                [view_arn setHidden:YES];
                [view_EUIN setHidden:YES];
                [view_paymentAmount setHidden:YES];
                [view_schemeType setHidden:NO];
                [view_foilo setHidden:NO];
                [view_paymentAmount setHidden:YES];
    [view_sipAmount setHidden:YES];
                    [view_addNominee setHidden:YES];
                    [view_checkNominee setHidden:YES];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];

                fundDetails = [[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT distinct fundDesc,fund FROM TABLE2_DETAILS where PAN='%@' and sipFlag ='Y' order By FundDesc",selectedPan]];
                
                if (fundDetails.count == 1) {
                    KT_Table2RawQuery *rec_fund=fundDetails[0];
                    tf_fund.text=[NSString stringWithFormat:@"%@",rec_fund.fundDesc];
                    str_selectedFundID=[NSString stringWithFormat:@"%@",rec_fund.fund];
                    tf_fund.userInteractionEnabled = false;
                    
                    folioArray = [[DBManager sharedDataManagerInstance]uniqueFolioFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (Acno), notallowed_flag FROM TABLE2_DETAILS where fund ='%@' and PAN='%@' and BalUnits != 0.0 and sipFlag='Y'",str_selectedFundID,selectedPan]];
                    if (folioArray.count == 1) {
                        KT_TABLE2 *rec_fund=folioArray[0];
                        tf_folio.text=[NSString stringWithFormat:@"%@",rec_fund.Acno];
                        selectedfolio=[NSString stringWithFormat:@"%@",rec_fund.Acno];
                        str_folioDmart=[NSString stringWithFormat:@"%@",rec_fund.notallowed_flag];
                        str_iScheme =[NSString stringWithFormat:@"%@",rec_fund.sch];;
                        lastNavStr = rec_fund.lastNAV;
                        
                        str_plan =[NSString stringWithFormat:@"%@",rec_fund.pln];;
                                 tf_folio.userInteractionEnabled = false;
                        
                        
                    }else{
                        tf_folio.userInteractionEnabled = true;

                    }
                    
                    existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and pSchFlg='Y'",str_selectedFundID,selectedfolio]];
                    if (existingArr.count == 1) {
                        
                        KT_TABLE2 *rec_fund=existingArr[0];
                             schemmeDic=existingArr[0];
                        
                        tf_scheme.text=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                        miniAmount=[NSString stringWithFormat:@"%@",rec_fund.minAmt];
                        selectedSecheme =[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                        lbl_MiniAmunt.text =[NSString stringWithFormat:@"%@",miniAmount];;
                        str_iScheme =[NSString stringWithFormat:@"%@",rec_fund.sch];;
                        str_option =[NSString stringWithFormat:@"%@",rec_fund.opt];;
                        str_driect =[NSString stringWithFormat:@"%@",rec_fund.schType];
                                     [self getInvFrequency];
                        str_plan =[NSString stringWithFormat:@"%@",rec_fund.pln];;
                        tf_scheme.userInteractionEnabled = false;
                        if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
                            if ([btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                                [view_category setHidden:NO];
                                [view_arn setHidden:NO];
                                [view_EUIN setHidden:YES];
                                tf_Arn.userInteractionEnabled =true;
                                tf_subBroker.userInteractionEnabled =true;
                                tf_SubArn.userInteractionEnabled =true;
                                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                                [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                                [btn_driect setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                                [btn_distri setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            }else{
                                [view_category setHidden:YES];
                                [view_arn setHidden:NO];
                                [view_EUIN setHidden:YES];
                                tf_Arn.userInteractionEnabled =true;
                                tf_subBroker.userInteractionEnabled =true;
                                tf_SubArn.userInteractionEnabled =true;
                                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                                [btn_newScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            }
                            
                            
                        }
                        else{
                            
                            
                            if ([btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                                [view_category setHidden:NO];
                                [view_arn setHidden:YES];
                                [view_EUIN setHidden:YES];
                                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                                [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                                [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            }else{
                                [view_category setHidden:YES];
                                [view_arn setHidden:YES];
                                [view_EUIN setHidden:YES];
                                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                                [btn_newScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            }
                            
                            
                        }
                        
                        
                    }else{
                        tf_scheme.userInteractionEnabled = true;
                        
                    }
                    
                    
                }else{
                            tf_fund.userInteractionEnabled = true;
                }
   
            }
            else{
                if ([selectSIPtypeInt isEqualToString:@"2"]) {
                    [view_schemeType setHidden:YES];
                    [view_foilo setHidden:YES];

                    [view_paymentAmount setHidden:NO];

                    [view_category setHidden:NO];
                    [view_repemetionType setHidden:NO];
                    [view_arn setHidden:NO];
                    [view_EUIN setHidden:NO];
                    [view_paymentAmount setHidden:NO];
                        [view_sipAmount setHidden:YES];
                    [view_addNominee setHidden:NO];
                    [view_checkNominee setHidden:NO];
                    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];

                }else{
                    [view_schemeType setHidden:YES];
                    [view_foilo setHidden:YES];
                    [view_paymentAmount setHidden:YES];

                    [view_category setHidden:NO];
                    [view_repemetionType setHidden:NO];
                    [view_arn setHidden:NO];
                    [view_EUIN setHidden:NO];
                    [view_paymentAmount setHidden:NO];
                    [view_addNominee setHidden:NO];
                    [view_checkNominee setHidden:NO];
                          [view_sipAmount setHidden:NO];
                    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];

                }
                [self getSIPFunds ];
                
            }
        }
      
        }
        
    
    
    if (txt_currentTextField==tf_fund) {
        if ([selectSIPtypeInt length] == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund Type"];
            
        }
        else{
            if ([selectSIPtypeInt isEqualToString:@"1"]) {
             
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                folioArray = [[DBManager sharedDataManagerInstance]uniqueFolioFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (Acno), notallowed_flag FROM TABLE2_DETAILS where fund ='%@' and PAN='%@' and BalUnits != 0.0 and sipFlag='Y'",str_selectedFundID,selectedPan]];
                if (folioArray.count == 1) {
                    KT_TABLE2 *rec_fund=folioArray[0];
                    tf_folio.text=[NSString stringWithFormat:@"%@",rec_fund.Acno];
                    selectedfolio=[NSString stringWithFormat:@"%@",rec_fund.Acno];
                    str_folioDmart=[NSString stringWithFormat:@"%@",rec_fund.notallowed_flag];
                    str_iScheme =[NSString stringWithFormat:@"%@",rec_fund.sch];;
                    lastNavStr = rec_fund.lastNAV;
                    
                    str_plan =[NSString stringWithFormat:@"%@",rec_fund.pln];;
                    tf_folio.userInteractionEnabled = false;
                    
                    existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and pSchFlg='Y'",str_selectedFundID,selectedfolio]];
                    if (existingArr.count == 1) {
                        
                        KT_TABLE2 *rec_fund=existingArr[0];
                             schemmeDic=existingArr[0];
                        tf_scheme.text=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                        miniAmount=[NSString stringWithFormat:@"%@",rec_fund.minAmt];
                        selectedSecheme =[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                        lbl_MiniAmunt.text =[NSString stringWithFormat:@"%@",miniAmount];;
                        str_iScheme =[NSString stringWithFormat:@"%@",rec_fund.sch];;
                        str_option =[NSString stringWithFormat:@"%@",rec_fund.opt];;
                        str_driect =[NSString stringWithFormat:@"%@",rec_fund.schType];
                                     [self getInvFrequency];
                        str_plan =[NSString stringWithFormat:@"%@",rec_fund.pln];;
                        tf_scheme.userInteractionEnabled = false;
                        if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
                            if ([btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                                [view_category setHidden:NO];
                                [view_arn setHidden:NO];
                                [view_EUIN setHidden:YES];
                                tf_Arn.userInteractionEnabled =true;
                                tf_subBroker.userInteractionEnabled =true;
                                tf_SubArn.userInteractionEnabled =true;
                                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                                [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                                [btn_driect setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                                [btn_distri setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            }else{
                                [view_category setHidden:YES];
                                [view_arn setHidden:NO];
                                [view_EUIN setHidden:YES];
                                tf_Arn.userInteractionEnabled =true;
                                tf_subBroker.userInteractionEnabled =true;
                                tf_SubArn.userInteractionEnabled =true;
                                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                                [btn_newScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            }
                            
                            
                        }
                        else{
                            
                            
                            if ([btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                                [view_category setHidden:NO];
                                [view_arn setHidden:YES];
                                [view_EUIN setHidden:YES];
                                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                                [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                                [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            }else{
                                [view_category setHidden:YES];
                                [view_arn setHidden:YES];
                                [view_EUIN setHidden:YES];
                                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                                [btn_newScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                                [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            }
                            
                            
                        }
                        

                    }else{
                        tf_scheme.userInteractionEnabled = true;

                    }
                }else{
                    tf_folio.userInteractionEnabled = true;
                    
                }
      
            }
            else{
                if ([selectSIPtypeInt isEqualToString:@"2"]) {
     
                    [self categoryListApi];
                    
                    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                    
                }else{
                    
                    [self categoryListApi];
                    [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                    
                }

                
            }
        }
        
    }
if (textField==tf_folio) {
    
    if ([tf_folio.text length] == 0) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio Type"];

    }else{
    
       if ([selectSIPtypeInt isEqualToString:@"1"]) {
    if ([str_folioDmart isEqualToString:@"D"]  ) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Demat folio is not eligible for purchase"];
        tf_scheme.inputView = picker_dropDown;
        [picker_dropDown reloadAllComponents];
        
        
        
    } else if ( [str_folioDmart isEqualToString:@"J"]){
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Join folio is not eligible for purchase"];
        tf_scheme.inputView = picker_dropDown;
        [picker_dropDown reloadAllComponents];
        [tf_scheme becomeFirstResponder];
        
        
    }else{
        
        if ([btn_exitSeheme.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
            
            
            if ([tf_folio.text length] == 0){
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio"];
                
            }else{
                [self  categoryListApi];
    
                
                
            }
        }else{
            
            
            if ([tf_folio.text length] == 0){
                [tf_scheme resignFirstResponder];
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio"];
                
            }else{
                
                existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and pSchFlg='Y'",str_selectedFundID,selectedfolio]];
                if (existingArr.count == 1) {
                    
                    KT_TABLE2 *rec_fund=existingArr[0];
                         schemmeDic=existingArr[0];
                    tf_scheme.text=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                    miniAmount=[NSString stringWithFormat:@"%@",rec_fund.minAmt];
                    selectedSecheme =[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                    lbl_MiniAmunt.text =[NSString stringWithFormat:@"%@",miniAmount];;
                    str_iScheme =[NSString stringWithFormat:@"%@",rec_fund.sch];;
                    str_option =[NSString stringWithFormat:@"%@",rec_fund.opt];;
                    str_driect =[NSString stringWithFormat:@"%@",rec_fund.schType];
                    
                    str_plan =[NSString stringWithFormat:@"%@",rec_fund.pln];;
                    tf_scheme.userInteractionEnabled = false;
                            [self getInvFrequency];
                    if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
                        if ([btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                            [view_category setHidden:NO];
                            [view_arn setHidden:NO];
                            [view_EUIN setHidden:YES];
                            tf_Arn.userInteractionEnabled =true;
                            tf_subBroker.userInteractionEnabled =true;
                            tf_SubArn.userInteractionEnabled =true;
                            [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                            [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            [btn_driect setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            [btn_distri setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                        }else{
                            [view_category setHidden:YES];
                            [view_arn setHidden:NO];
                            [view_EUIN setHidden:YES];
                            tf_Arn.userInteractionEnabled =true;
                            tf_subBroker.userInteractionEnabled =true;
                            tf_SubArn.userInteractionEnabled =true;
                            [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                            [btn_newScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        }
                        
                        
                    }
                    else{
                        
                        
                        if ([btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                            [view_category setHidden:NO];
                            [view_arn setHidden:YES];
                            [view_EUIN setHidden:YES];
                            [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                            [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        }else{
                            [view_category setHidden:YES];
                            [view_arn setHidden:YES];
                            [view_EUIN setHidden:YES];
                            [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                            [btn_newScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        }
                        
                        
                    }

                }else{
                    tf_scheme.userInteractionEnabled = true;

                }
            }
        }
    }
       }}
    
    
}
    if (textField==tf_scheme) {
        
        if ([tf_scheme.text length] == 0){
            [tf_scheme resignFirstResponder];
            
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Scheme "];
            
        }else{
             if ([selectSIPtypeInt isEqualToString:@"1"]) {
        if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
            if ([btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                [view_category setHidden:NO];
                [view_arn setHidden:NO];
                [view_EUIN setHidden:YES];
                tf_Arn.userInteractionEnabled =true;
                tf_subBroker.userInteractionEnabled =true;
                tf_SubArn.userInteractionEnabled =true;
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_driect setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_distri setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
            }else{
                [view_category setHidden:YES];
                [view_arn setHidden:NO];
                [view_EUIN setHidden:YES];
                tf_Arn.userInteractionEnabled =true;
                tf_subBroker.userInteractionEnabled =true;
                tf_SubArn.userInteractionEnabled =true;
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                [btn_newScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
            }
            
            
        }
                 else{
                     
                     
                     if ([btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                         [view_category setHidden:NO];
                         [view_arn setHidden:YES];
                         [view_EUIN setHidden:YES];
                         [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                         [btn_newScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                         [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                         [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                         [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                     }else{
                         [view_category setHidden:YES];
                         [view_arn setHidden:YES];
                         [view_EUIN setHidden:YES];
                         [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                         [btn_newScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                         [btn_exitSeheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                         [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                         [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                     }
                     
                     
                 }
                    [self getInvFrequency];
        }
             else{
                 if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
                
                         [view_arn setHidden:NO];
                         [view_EUIN setHidden:YES];
                         [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
                     tf_Arn.userInteractionEnabled =true;
                     tf_subBroker.userInteractionEnabled =true;
                     tf_SubArn.userInteractionEnabled =true;
                         [btn_driect setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                         [btn_distri setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
               
                     
                     
                 }
                 else{
                     
                     
              
                  
                         [view_arn setHidden:YES];
                         [view_EUIN setHidden:YES];
                         [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
              
                         [btn_driect setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                         [btn_distri setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                     }
                             [self getInvFrequency];
                     
                 }
        

        
        }
        
    }
    if (textField==tf_category) {
        
        
        if ([tf_category.text length] == 0){
            [tf_category resignFirstResponder];
            
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Category "];
            
        }else{
        if ([selectSIPtypeInt isEqualToString:@"1"]) {
                    [self newSchmemListApi];
            
        }else{
                    [self newSchmemListApi];
        }

            

        }
        
        
    }
    if (txt_currentTextField== tf_investment) {
        if ([tf_investment.text length] == 0){
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Investment Frequency "];

        }else{
            tf_noodIns.userInteractionEnabled =true;

        }
    }
    if (txt_currentTextField== tf_noodIns) {
        if ([tf_noodIns.text length] == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  Enter  No of Installments "];
            
        }else{
            [self  getSIPDays];
            
            
        }
    }
    if (txt_currentTextField== tf_days) {
        if ([tf_days.text length] == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please   select the Investment Day  "];
            
        }else{
        
        lbl_SIPAmount.text = lbl_MiniAmunt.text;
        [self  SIPStartandEnddateAPi];
    }
    }
    
    if (txt_currentTextField== tf_modeRe) {
        if ([tf_days.text length] == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please   select the  Mode of  Registrantion  "];
            
        }else{
            
//            [ self validateKOTM];
            

        }
    }
}
# pragma Mark validateKOTM
-(void)validateKOTM{
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ensfund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_enpan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedPan];
    
    
    // NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_Arn.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@CheckPANKotm?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&PAN=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_ensfund,str_enpan];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Table"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"KOTM"
                                          message:responce[@"Table1"][0][@"GM_UMRNNo"]
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"Procced"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     

                                     
                            
                                     
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
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma  mark Picker datasouce  and Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    long int newcount = 0;
    if (txt_currentTextField== tf_modeRe) {
        newcount= modeofRegisArr.count;
    }
    if (txt_currentTextField== tf_paymentbank) {
        newcount= paymentModeArr.count;
    }
    if (txt_currentTextField== tf_days) {
        newcount= SIPDaysArr.count;
    }
    if (txt_currentTextField== tf_investment) {
        newcount= noInstaArr.count;
    }
    if (txt_currentTextField== tf_SIPType) {
        newcount= Siptype.count;
    }
    if (txt_currentTextField== tf_fund) {
        if ([selectSIPtypeInt isEqualToString:@"1"]) {
            
                    newcount= fundDetails.count;
        }else{
            
            newcount= sipFunddetailsarr.count;
        }
     
        
    }
    if (txt_currentTextField==tf_category) {
        newcount= categoryArr.count;
    }
    if (txt_currentTextField== tf_folio) {
        newcount= folioArray.count;
    }
    
    if (txt_currentTextField==tf_scheme) {
           if ([selectSIPtypeInt isEqualToString:@"1"]) {
        if ([btn_exitSeheme.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
            
            newcount= newschemeArr.count;
        }else{
            newcount= existingArr.count;
        }
           }else{
               newcount= newschemeArr.count;

           }
    }
    if (txt_currentTextField==tf_euin) {
        newcount= subEArnarray.count;
    }
    return newcount;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str_title;
    if (txt_currentTextField== tf_paymentbank) {
        str_title=[NSString stringWithFormat:@"%@",self->paymentModeArr[row][@"kb_BankName"]];
        

    }
    if (txt_currentTextField==tf_euin) {
        NSDictionary *rec_fund=subEArnarray[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
    }
    if (txt_currentTextField== tf_modeRe) {
        str_title=  [NSString  stringWithFormat:@"%@",self->modeofRegisArr[row][@"Pay_Mode"] ];
    }
    if (txt_currentTextField== tf_days) {
        str_title=  [NSString  stringWithFormat:@"%@",self->SIPDaysArr[row][@"sip_cycleid"] ];
    }
    if (txt_currentTextField== tf_investment) {
        str_title =self->noInstaArr[row][@"FrequencyID"] ;
    }
    if (txt_currentTextField==tf_SIPType) {
     
        str_title=[NSString stringWithFormat:@"%@",Siptype[row]];
    }
    
    if (txt_currentTextField== tf_fund) {
        if ([selectSIPtypeInt isEqualToString:@"1"]) {
            KT_Table2RawQuery *rec_fund=fundDetails[row];
            str_title=[NSString stringWithFormat:@"%@",rec_fund.fundDesc];

        }else{
            
            
                str_title=[NSString stringWithFormat:@"%@",sipFunddetailsarr[row][@"amc_name"]];
        }
    
        
        
    }
    
    if (txt_currentTextField== tf_folio) {
        KT_TABLE2 *rec_fund=folioArray[row];
    str_title=[NSString stringWithFormat:@"%@",rec_fund.Acno];


    }
  
    if (txt_currentTextField==tf_scheme) {
         if ([selectSIPtypeInt isEqualToString:@"1"]) {
            

        if ([btn_exitSeheme.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
            
            NSDictionary *rec_fund=newschemeArr[row];
            str_title=[NSString stringWithFormat:@"%@",rec_fund[@"fm_schdesc"]];
        }else{
            KT_TABLE2 *rec_fund=existingArr[row];
            str_title=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
        }
             
        
         }else{
             NSDictionary *rec_fund=newschemeArr[row];
             str_title=[NSString stringWithFormat:@"%@",rec_fund[@"fm_schdesc"]];
         }

    
    }    if (txt_currentTextField==tf_category) {
        NSDictionary  *rec_fund=categoryArr[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];
    }
    return str_title;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    
    if (txt_currentTextField== tf_modeRe) {
        tf_modeRe.text=  [NSString  stringWithFormat:@"%@",self->modeofRegisArr[row][@"Pay_Mode"] ];
    }

    if (txt_currentTextField==tf_euin) {
        NSDictionary  *rec_fund=subEArnarray[row];
        // [categoryArr  removeAllObjects];
        
        
        
        tf_euin.text=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
        str_EuinNo =[NSString stringWithFormat:@"%@",rec_fund[@"abm_name"]];
    }
    
    if (txt_currentTextField== tf_paymentbank) {
        tf_paymentbank.text=[NSString stringWithFormat:@"%@",self->paymentModeArr[row][@"kb_BankName"]];
        paymentBankDic =self->paymentModeArr[row];
        
    }
    if (txt_currentTextField== tf_days) {

        str_tat=  [NSString stringWithFormat:@"%@",SIPDaysArr[row][@"TAT"]];
        tf_days.text= [NSString stringWithFormat:@"%@",SIPDaysArr[row][@"sip_cycleid"]];
    }
    if (txt_currentTextField== tf_investment) {
        


        tf_investment.text =self->noInstaArr[row][@"FrequencyID"] ;
        
        lbl_installments.text =[NSString stringWithFormat:@"(Minimum_Instalment %@)",noInstaArr[row][@"Minimum_Instalment"]] ;
        str_installments = [NSString stringWithFormat:@"%@",noInstaArr[row][@"Minimum_Instalment"]] ;
    }
    if (txt_currentTextField==tf_SIPType) {
    
                            tf_SIPType.text=[NSString stringWithFormat:@"%@",Siptype[row]];
                            selectSIPtypeInt =[NSString stringWithFormat:@"%@",SiptypeDicArray[row]];
                            selectSIPtype =[NSString stringWithFormat:@"%@",Siptype[row]];
                            tf_fund.text= nil;
                            str_selectedFundID=nil;
                            tf_category.text= nil;
                            tf_scheme.text=nil;
                            tf_folio.text=nil;
        lbl_MiniAmunt.text =[NSString stringWithFormat:@" "];


        tf_days.text=nil;
        tf_sipStartDay.text=nil;
        tf_SipEndDay.text=nil;
        tf_modeRe.text=nil;
        tf_noodIns.text=nil;
        tf_miniAmount.text=nil;
        tf_nomiee1.text=nil;
        tf_nomiee2.text=nil;
        tf_days.text= nil;
        tf_Sipamount.text= nil;
        tf_investment.text= nil;
        tf_paymentbank.text=nil;
        
        tf_nomiee3.text=nil;
        tf_paymentbank.text=nil;


  lbl_SIPAmount.text=nil;
        lbl_installments.text=nil;
        tf_fund.userInteractionEnabled = true;
                            tf_folio.userInteractionEnabled =false;
                            tf_category.userInteractionEnabled =false;
                            tf_scheme.userInteractionEnabled =false;
                            tf_Arn.userInteractionEnabled =false;
                            tf_subBroker.userInteractionEnabled =false;
                            tf_SubArn.userInteractionEnabled =false;
                            tf_euin.userInteractionEnabled =false;
                            tf_investment.userInteractionEnabled =false;
                            tf_noodIns.userInteractionEnabled =false;
                            tf_days.userInteractionEnabled =false;
                            tf_sipStartDay.userInteractionEnabled =false;
                            tf_SipEndDay.userInteractionEnabled =false;
                            tf_Sipamount.userInteractionEnabled =false;
                            tf_modeRe.userInteractionEnabled =false;
                            tf_miniAmount.userInteractionEnabled =false;
                            tf_nomiee1.userInteractionEnabled =false;
                            tf_nomiee2.userInteractionEnabled =false;
                            tf_nomiee3.userInteractionEnabled =false;
    tf_paymentbank.userInteractionEnabled =false;
        
        [view_Nominee1 setHidden:YES];
        [view_Nominee2 setHidden:YES];
        [view_Nominee3 setHidden:YES];
}
    
    if (txt_currentTextField== tf_fund) {
        if ([selectSIPtypeInt isEqualToString:@"1"]) {
            KT_Table2RawQuery *rec_fund=fundDetails[row];
            tf_fund.text=[NSString stringWithFormat:@"%@",rec_fund.fundDesc];
            str_selectedFundID=[NSString stringWithFormat:@"%@",rec_fund.fund];
            tf_category.text= nil;

            tf_folio.text=nil;
            lbl_MiniAmunt.text =[NSString stringWithFormat:@" "];


            tf_category.text= nil;
            tf_scheme.text=nil;
            tf_folio.text=nil;
            lbl_MiniAmunt.text =[NSString stringWithFormat:@" "];
            
            tf_days.text=nil;
            tf_sipStartDay.text=nil;
            tf_SipEndDay.text=nil;
            tf_modeRe.text=nil;
       
            lbl_SIPAmount.text=nil;
            lbl_installments.text=nil;
            tf_folio.userInteractionEnabled =false;
            tf_category.userInteractionEnabled =false;
            tf_scheme.userInteractionEnabled =false;
            tf_Arn.userInteractionEnabled =false;
            tf_subBroker.userInteractionEnabled =false;
            tf_SubArn.userInteractionEnabled =false;
            tf_euin.userInteractionEnabled =false;
            tf_investment.userInteractionEnabled =false;
            tf_noodIns.userInteractionEnabled =false;
            tf_days.userInteractionEnabled =false;
            tf_sipStartDay.userInteractionEnabled =false;
            tf_SipEndDay.userInteractionEnabled =false;
            tf_Sipamount.userInteractionEnabled =false;
            tf_modeRe.userInteractionEnabled =false;
            tf_miniAmount.userInteractionEnabled =false;
            tf_nomiee1.userInteractionEnabled =false;
            tf_nomiee2.userInteractionEnabled =false;
            tf_nomiee3.userInteractionEnabled =false;
            
            tf_paymentbank.text=nil;
    tf_paymentbank.userInteractionEnabled =false;
        }else{
            
            tf_fund.text=[NSString stringWithFormat:@"%@",sipFunddetailsarr[row][@"amc_name"]];
            str_selectedFundID=[NSString stringWithFormat:@"%@",sipFunddetailsarr[row][@"amc_code"]];
            tf_category.text= nil;
            tf_scheme.text=nil;
            tf_folio.text=nil;
            lbl_MiniAmunt.text =[NSString stringWithFormat:@" "];

            tf_category.text= nil;
            tf_scheme.text=nil;
            tf_folio.text=nil;
            lbl_MiniAmunt.text =[NSString stringWithFormat:@" "];
            
           
            tf_days.text=nil;
            tf_sipStartDay.text=nil;
            tf_SipEndDay.text=nil;
            tf_modeRe.text=nil;
        
            lbl_SIPAmount.text=nil;
            lbl_installments.text=nil;
            tf_folio.userInteractionEnabled =false;
            tf_category.userInteractionEnabled =false;
            tf_scheme.userInteractionEnabled =false;
            tf_Arn.userInteractionEnabled =false;
            tf_subBroker.userInteractionEnabled =false;
            tf_SubArn.userInteractionEnabled =false;
            tf_euin.userInteractionEnabled =false;
            tf_investment.userInteractionEnabled =false;
            tf_noodIns.userInteractionEnabled =false;
            tf_days.userInteractionEnabled =false;
            tf_sipStartDay.userInteractionEnabled =false;
            tf_SipEndDay.userInteractionEnabled =false;
            tf_Sipamount.userInteractionEnabled =false;
            tf_modeRe.userInteractionEnabled =false;
            tf_miniAmount.userInteractionEnabled =false;
            tf_nomiee1.userInteractionEnabled =false;
            tf_nomiee2.userInteractionEnabled =false;
            tf_nomiee3.userInteractionEnabled =false;
            tf_paymentbank.text=nil;
    tf_paymentbank.userInteractionEnabled =false;
        }
    }
    
    if (txt_currentTextField==tf_folio) {
        KT_TABLE2 *rec_fund=folioArray[row];
        tf_folio.text=[NSString stringWithFormat:@"%@",rec_fund.Acno];
        selectedfolio=[NSString stringWithFormat:@"%@",rec_fund.Acno];
        str_folioDmart=[NSString stringWithFormat:@"%@",rec_fund.notallowed_flag];
        str_iScheme =[NSString stringWithFormat:@"%@",rec_fund.sch];;
        lastNavStr = rec_fund.lastNAV;
        lbl_MiniAmunt.text =[NSString stringWithFormat:@" "];

        str_plan =[NSString stringWithFormat:@"%@",rec_fund.pln];;
        tf_category.text= nil;
        tf_scheme.text=nil;
        tf_category.text= nil;
        tf_scheme.text=nil;
        lbl_MiniAmunt.text =[NSString stringWithFormat:@" "];
        
   
        tf_days.text=nil;
        tf_sipStartDay.text=nil;
        tf_SipEndDay.text=nil;
        tf_modeRe.text=nil;

        lbl_SIPAmount.text=nil;
        lbl_installments.text=nil;
        tf_paymentbank.text=nil;
    tf_paymentbank.userInteractionEnabled =false;
        tf_category.userInteractionEnabled =false;
        tf_scheme.userInteractionEnabled =false;
        tf_Arn.userInteractionEnabled =false;
        tf_subBroker.userInteractionEnabled =false;
        tf_SubArn.userInteractionEnabled =false;
        tf_euin.userInteractionEnabled =false;
        tf_investment.userInteractionEnabled =false;
        tf_noodIns.userInteractionEnabled =false;
        tf_days.userInteractionEnabled =false;
        tf_sipStartDay.userInteractionEnabled =false;
        tf_SipEndDay.userInteractionEnabled =false;
        tf_Sipamount.userInteractionEnabled =false;
        tf_modeRe.userInteractionEnabled =false;
        tf_miniAmount.userInteractionEnabled =false;
        tf_nomiee1.userInteractionEnabled =false;
        tf_nomiee2.userInteractionEnabled =false;
        tf_nomiee3.userInteractionEnabled =false;
        tf_paymentbank.text=nil;
    tf_paymentbank.userInteractionEnabled =false;
    }
    
    
    if (txt_currentTextField==tf_category) {
        NSDictionary  *rec_fund=categoryArr[row];
        // [categoryArr  removeAllObjects];

        tf_scheme.text  =nil;
        
        tf_category.text=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];
        str_Category=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];


        tf_scheme.text=nil;
        lbl_MiniAmunt.text =[NSString stringWithFormat:@" "];
        
        tf_days.text=nil;
        tf_sipStartDay.text=nil;
        tf_SipEndDay.text=nil;
        tf_modeRe.text=nil;

        lbl_SIPAmount.text=nil;
        lbl_installments.text=nil;
        tf_scheme.userInteractionEnabled =false;
        tf_Arn.userInteractionEnabled =false;
        tf_subBroker.userInteractionEnabled =false;
        tf_SubArn.userInteractionEnabled =false;
        tf_euin.userInteractionEnabled =false;
        tf_investment.userInteractionEnabled =false;
        tf_noodIns.userInteractionEnabled =false;
        tf_days.userInteractionEnabled =false;
        tf_sipStartDay.userInteractionEnabled =false;
        tf_SipEndDay.userInteractionEnabled =false;
        tf_Sipamount.userInteractionEnabled =false;
        tf_modeRe.userInteractionEnabled =false;
        tf_miniAmount.userInteractionEnabled =false;
        tf_nomiee1.userInteractionEnabled =false;
        tf_nomiee2.userInteractionEnabled =false;
        tf_nomiee3.userInteractionEnabled =false;
        tf_paymentbank.text=nil;
    tf_paymentbank.userInteractionEnabled =false;
    }
   
    
    if (txt_currentTextField==tf_scheme) {
         if ([selectSIPtypeInt isEqualToString:@"1"]) {
        if ([btn_exitSeheme.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
            newSchemmeDic=newschemeArr[row];
    

            
            tf_noodIns.text=nil;
            tf_days.text=nil;
            tf_sipStartDay.text=nil;
            tf_SipEndDay.text=nil;
            tf_modeRe.text=nil;
      
            lbl_SIPAmount.text=nil;
            tf_scheme.text=[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_schdesc"]];
            selectedSecheme=[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_schdesc"]];
            miniAmount=[NSString stringWithFormat:@"%@",newSchemmeDic[@"SIPminamt"]];
            lbl_MiniAmunt.text =[NSString stringWithFormat:@"%@",miniAmount];;
            str_iScheme =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_scheme"]];;
            str_plan =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_plan"]];;
            str_option =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_option"]];;
            str_driect =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_plnmode"]];;
            //   lbl_miniAmount.text = =
            lbl_SIPAmount.text = [NSString stringWithFormat:@" %@",newSchemmeDic[@"SIPminamt"]];;

        }else{
            
            schemmeDic=existingArr[row];
            
            tf_days.text=nil;
            tf_sipStartDay.text=nil;
            tf_SipEndDay.text=nil;
            tf_modeRe.text=nil;

            lbl_SIPAmount.text=nil;
            tf_scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
            selectedSecheme=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
            
            miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
            lbl_MiniAmunt.text =[NSString stringWithFormat:@"%@",miniAmount];;
            str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
            str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
            str_option =[NSString stringWithFormat:@"%@",schemmeDic.opt];
            str_driect =[NSString stringWithFormat:@"%@",schemmeDic.schType];
            
        }
        
         }else{
             newSchemmeDic=newschemeArr[row];
     ;
             tf_days.text=nil;
             tf_sipStartDay.text=nil;
             tf_SipEndDay.text=nil;
             tf_modeRe.text=nil;
    
             lbl_SIPAmount.text=nil;
             tf_scheme.text=[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_schdesc"]];
             selectedSecheme=[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_schdesc"]];
             miniAmount=[NSString stringWithFormat:@"%@",newSchemmeDic[@"SIPminamt"]];
             lbl_MiniAmunt.text =[NSString stringWithFormat:@" %@",miniAmount];;
             str_iScheme =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_scheme"]];;
             str_plan =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_plan"]];;
             str_option =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_option"]];;
             str_driect =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_plnmode"]];;
             
             lbl_SIPAmount.text = [NSString stringWithFormat:@" %@",newSchemmeDic[@"SIPminamt"]];;

            lbl_SIPAmount.text = [NSString stringWithFormat:@" %@",newSchemmeDic[@"SIPminamt"]];;
             

         }
        
        
    }


}
# pragma mark  SIP Fund
-(void)getSIPFunds
{
    
            [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
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
        sipFunddetailsarr = responce[@"Dtinformation"];
        if (sipFunddetailsarr.count>1) {
            tf_fund.inputView=picker_dropDown;
            [picker_dropDown reloadAllComponents];
        }
        else{
            tf_fund.inputView=picker_dropDown;
            [picker_dropDown reloadAllComponents];
        }
        NSLog(@"%@",sipFunddetailsarr);
    } failure:^(NSError *error) {
        
    }];
    
    
    
}
#pragma mark - categoryListApi
-(void)categoryListApi{
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

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
            
            self->tf_category.userInteractionEnabled =true;
            if (self->categoryArr.count == 0) {
                self->categoryArr = responce[@"DtData"];
                self->tf_category.inputView = self->picker_dropDown;
                [self->picker_dropDown reloadAllComponents];
                [self->tf_category becomeFirstResponder];
                
                
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
#pragma mark - NewSchemeListApi
-(void)newSchmemListApi{
    
    

    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_folio;
    if ([selectSIPtypeInt isEqualToString:@"1"]) {
str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
        
        
    }else{
str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];

        }
    
    

    NSString *str_enCategory =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_Category];
//NSString *str_trantype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"UA"];
    NSString *str_divflg =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *  investflag ;
    if ([btn_driect.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
        investflag   = @"Regular";
        
    }else{
        
        investflag = @"Direct";
        
    }
    NSString *str_investflag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:investflag];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@getOtherSchemesSwitch?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fundCode=%@&acno=%@&category=%@&trantype=%@&divflg=%@&schtype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_folio,str_enCategory,@"UA",str_divflg,str_investflag];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            if ([responce[@"DtData"] count]  != 0) {
                
                self->newschemeArr= [[NSMutableArray alloc]init];
                self->tf_scheme.userInteractionEnabled =true;
                
                self->newschemeArr =  responce[@"DtData"];
                [self->tf_scheme becomeFirstResponder];
                if (self->newschemeArr.count == 0) {
                    
                    self->newschemeArr =  responce[@"DtData"];
                    [self->tf_scheme becomeFirstResponder];
     

                    self->tf_scheme.userInteractionEnabled =false;

                    
                }else{
                    self->newschemeArr =  responce[@"DtData"];
                    [self->tf_scheme becomeFirstResponder];
                }
                
                

                NSLog(@"%@",responce);
            }else{
                
                [self->tf_scheme resignFirstResponder];;
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

#pragma mark - getInvFrequencyListApi
-(void)getInvFrequency{
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"IF"];
    NSString *str_astscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];

    NSString *str_url = [NSString stringWithFormat:@"%@getMasterSIP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&opt=%@&astscheme=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_opt,str_astscheme];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            self->noInstaArr = responce[@"Dtinformation"];
            if (self->noInstaArr.count == 1) {
                self->tf_investment.userInteractionEnabled =NO
                ;
                
                self->tf_investment.text = self->noInstaArr[0][@"FrequencyID"] ;

            }else{
         self->tf_investment.userInteractionEnabled =YES;
            
            }
            
            NSLog(@"%@",self->noInstaArr);
            
            
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



#pragma mark - SIPSDAyListApi
-(void)getSIPDays{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_opt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"D"];
    NSString *str_astscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_investment.text];
    
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterSIP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&opt=%@&astscheme=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_opt,str_astscheme];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            self->SIPDaysArr = responce[@"Dtinformation"];
            if (self->SIPDaysArr.count == 1) {
                tf_days.userInteractionEnabled =NO
                ;
                 str_tat=  [NSString stringWithFormat:@"%@",SIPDaysArr[0][@"TAT"]];
                self->tf_investment.text = [NSString  stringWithFormat:@"%@",self->SIPDaysArr[0][@"sip_cycleid"] ];
                
            }else{
                self->tf_days.userInteractionEnabled =YES;
                            [self->tf_days becomeFirstResponder];
            }

            NSLog(@"%@",self->noInstaArr);
            
            
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
#pragma mark - SIPStartandEnddate

-(void)SIPStartandEnddateAPi{
    
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_days =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_days.text];
    NSString *str_Frequency =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_investment.text];
    NSString *str_nots =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_noodIns.text];

    NSString *str_url = [NSString stringWithFormat:@"%@CalcSIPEnddt?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&StartDate=%@&Frequency=%@&Installments=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_days,str_Frequency,str_nots];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            self->tf_sipStartDay.text =  [NSString stringWithFormat:@"%@",responce[@"DtData"][0][@"SIP_StartDate"]];
            self->tf_SipEndDay.text =  [NSString stringWithFormat:@"%@",responce[@"DtData"][0][@"SIP_EndDate"]];
            self->tf_Sipamount.userInteractionEnabled =YES;
            self->tf_miniAmount.userInteractionEnabled =YES;
            [self getMasterSIPAPi];
            
            
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


#pragma mark - Mode 0f Payments

-(void)ModeofresAPi{
    
    
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
            tf_paymentbank.text=nil;
    tf_paymentbank.userInteractionEnabled =true;
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


#pragma mark - Mode of Mode SIP
    
- (IBAction)atc_euini:(id)sender {
    
       [[SharedUtility sharedInstance]showAlertViewWithTitle:KTMessage withMessage:@"I/We hereby confirm that the EUIN box has been intentionally left blank by me us as this is an 'execution-only' transaction without any interaction or advice by any personnel of the above distributor or notwithstanding the advice of in-appropriateness, if any, provided by any personnel of the distributor and the distributor has not charged any advisory fees on this transaction. "];
}
-(void)getMasterSIPAPi{
        
        
        [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

        NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
        NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
        NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
        NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
        NSString *str_otp =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"PM"];

        NSString *str_url = [NSString stringWithFormat:@"%@getMasterSIP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&opt=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_otp];
        
        NSLog(@"%@",str_url);
        [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
            [[APIManager sharedManager]hideHUD];

            int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
            if (error_statuscode==0) {
                        [self ModeofresAPi];
                
                self->modeofRegisArr = [responce[@"Dtinformation"] mutableCopy];
                
                NSDictionary * dicts = @{ @"Pay_Mode" : @"KOTM"};
                [self->modeofRegisArr  addObject:dicts];
                
      
                
                if (self->modeofRegisArr.count == 1) {
                    self->tf_modeRe.userInteractionEnabled =NO
                    ;
                    
                    self->tf_modeRe.text = [NSString  stringWithFormat:@"%@",self->modeofRegisArr[0][@"Pay_Mode"] ];
                    
                }else{
    

                    self->tf_modeRe.userInteractionEnabled =YES;
                    [self->tf_modeRe becomeFirstResponder];
                }
                
                NSLog(@"%@",self->noInstaArr);
            
                
                

     
                
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

#pragma mark - payment Bank SIP

//-(void)getpaymentBankAPI{
//
//
//        [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

//    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
//    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
//    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
//    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
//    NSString *str_otp =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedPan];
//
//    NSString *str_url = [NSString stringWithFormat:@"%@getMasterSIP?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&PAN=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_otp];
//
//    NSLog(@"%@",str_url);
//    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
//[[APIManager sharedManager]hideHUD];

//        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
//        if (error_statuscode==0) {
//
//
//            self->modeofRegisArr = responce[@"Dtinformation"];
//            if (self->modeofRegisArr.count == 1) {
//                self->tf_modeRe.userInteractionEnabled =NO
//                ;
//
//                self->tf_modeRe.text = [NSString  stringWithFormat:@"%@",self->modeofRegisArr[0][@"Pay_Mode"] ];
//
//            }else{
//
//
//                self->tf_modeRe.userInteractionEnabled =YES;
//                [self->tf_modeRe becomeFirstResponder];
//            }
//
//            NSLog(@"%@",self->noInstaArr);
//
//
//
//            [self ModeofresAPi];
//
//
//        }
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
    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_SubArn.text];
    
    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_Arn.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@ValidateBrokercode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&AgentCd=%@&SubAgentCd=%@o_ErrNo&=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,Str_AgentCd,str_SubAgentCd,str_o_ErrNo];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            if ([responce[@"DtData"] count]  != 0) {
                self->subEArnarray= [[NSMutableArray alloc]init];
                if (self->subEArnarray.count == 0) {
                    self->subEArnarray = responce[@"DtData"];
                    self->tf_euin.inputView = self->picker_dropDown;
                    [self->picker_dropDown reloadAllComponents];
                    
                    if ([self->btn_yesEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]) {
                        [self->tf_euin becomeFirstResponder];
                        
                    }
                }
                self->subEArnarray = responce[@"DtData"];
            }
            else{
                self->tf_Arn.text =@"ARN-";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Please  Check ARN code"];
            }
            
            NSLog(@"%@",self->subEArnarray);
            
            
        }
        else{
            
            self->tf_Arn.text =@"ARN-";
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Please  Check ARN code"];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SIPSumbitAPI API
-(void)SIPSumbitAPI{
    

    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSLog(@"%@",str_driect);
    
    
    NSString *str_enIscheme ;
    NSString *str_enopton;
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
str_enIscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_iScheme];
str_enopton =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_option];
    NSString *str_enfolio ;
    if ([selectSIPtypeInt isEqualToString:@"1"]) {
        str_enfolio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
        
        
    }else{
        str_enfolio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"0"];
        
    }
    
    NSString *str_eni_Plan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_plan];
    NSString *str_enAmount =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_Sipamount.text];
    
    NSString *str_i_RedFlg =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_i_oldihno = @"MA";
    NSString *str_i_InvDistFlag =@"RA";
    NSString *Subbroker;
    NSString *i_arn;
    NSString *SubbrokerArn;
    NSString *EUINFlag ;
    NSString *EuinCode;
    
    if ([str_driect  isEqualToString:@"Regular"]){
        i_arn =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_Arn.text];
        SubbrokerArn = [XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_subBroker.text];
        Subbroker=[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_SubArn.text];
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
    
    NSLog(@"%@",tf_sipStartDay.text);
    NSLog(@"%@",tf_SipEndDay.text);

    NSString *str_pan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedPan];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *startDate = [dateFormatter dateFromString:tf_sipStartDay.text];
    NSDate *endDate = [dateFormatter dateFromString:tf_SipEndDay.text];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    tf_sipStartDay.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:startDate]];
    tf_SipEndDay.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:endDate]];

    NSString *str_sipstartday =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_sipStartDay.text];
    NSString *str_sipendday =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_SipEndDay.text];


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

      nomieepay1=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee1.text ];

 
        nomiee2 =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
        
        nomieepay2=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @"" ];
        nomiee3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @""];
        
        nomieepay3=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];

        
    }else if (arr_nomieerefence.count == 2 ){
        nomiee1 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee1.currentTitle];
        
        nomieepay1=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee1.text ];
        nomiee2 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee2.currentTitle];
        
        nomieepay2=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee2.text ];
        nomiee3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: @""];
        
        nomieepay3=[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    }
    else if (arr_nomieerefence.count == 3 ){
        nomiee1 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee1.currentTitle];
        
        nomieepay1=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee1.text ];
        nomiee2 =[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee2.currentTitle];
        
        nomieepay2=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee2.text ];
        nomiee3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: lbl_nomiee3.currentTitle];
        
        nomieepay3=[XTAPP_DELEGATE convertToBase64StrForAGivenString: tf_nomiee3.text ];
        
    }
    NSString *str_invAmount;
    NSString *str_payvalMode;
    NSString *  Str_Bank;
    NSString * Str_BankID;
    NSString *  Bank;
    NSString * BankID;
        if ([selectSIPtypeInt isEqualToString:@"1"]) {
      
            Str_BankID=  [XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
            Str_Bank = [XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
str_payvalMode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_modeRe.text];
   str_invAmount        =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_Sipamount.text];
        }else{
str_payvalMode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_modeRe.text];
         str_invAmount =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
            BankID=[NSString stringWithFormat:@"%@~%@", paymentBankDic[@"gb_bankcode"],paymentBankDic[@"kb_Accounttype"]];
            Bank=[NSString stringWithFormat:@"~%@",paymentBankDic[@"kb_BankAcNo"]];
            Str_BankID=  [XTAPP_DELEGATE convertToBase64StrForAGivenString:BankID];
            Str_Bank = [XTAPP_DELEGATE convertToBase64StrForAGivenString:Bank];


        }
   
  
    
    NSString *str_url = [NSString stringWithFormat:@"%@SentpurchasemailRed?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&i_Fund=%@&i_Scheme=%@&i_Plan=%@&i_Option=%@&i_Acno=%@&i_RedFlg=%@&i_UntAmtFlg=%@&i_UntAmtValue=%@&i_Userid=%@&i_Tpin=%@&i_Mstatus=%@&i_oldihno=%@&i_InvDistFlag=%@&i_Tfund=%@&i_Tscheme=%@&i_Tplan=%@&i_Toption=%@&i_Tacno=%@&i_Agent=%@&i_Mapinid=%@&i_entby=%@&ARNCode=%@&EUINFlag=%@&Subbroker=%@&SubbrokerArn=%@&EuinCode=%@&EuinValid=%@&o_ErrNo=%@&Otp=%@&trtype=%@&PanNo=%@&Desci=%@&IMEINO=%@&Bankid=%@%@&upiid=%@&paymenttype=%@&nom1=%@&nom2=%@&nom3=%@&nomper1=%@&nomper2=%@&nomper3=%@&sipfrequency=%@&sipstartdt=%@&sipenddt=%@&sipamount=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_enIscheme,str_eni_Plan,str_enopton,str_enfolio,str_i_RedFlg,str_i_RedFlg,str_invAmount,i_Userid,str_i_RedFlg,str_i_RedFlg,str_i_oldihno,str_i_InvDistFlag,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,i_Useremail,i_arn,EUINFlag,Subbroker,SubbrokerArn,EuinCode,EUINFlag,str_i_RedFlg,str_i_RedFlg,trtype,str_pan,desci,unique_UDID,Str_BankID,Str_Bank,str_i_RedFlg,str_payvalMode,nomiee1,nomiee2,nomiee3,nomieepay1,nomieepay2,nomieepay3,str_i_RedFlg,str_sipstartday,str_sipendday,str_enAmount];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        
        if (error_statuscode==0) {
            
            self->str_referId = responce[@"DtData"][0][@"ID"];
            SIPComfVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SIPComfVC"];
            destination.str_pan= self->selectedPan;
            
            if ([self->selectSIPtypeInt isEqualToString:@"1"]) {
                if ([self->btn_newScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]){
                    destination.str_schemmeType = @"Yes";
           destination.str_folio =self->tf_folio.text;
                    destination.schemmeDetialsDic =self->newSchemmeDic;
                    
                    
                }else{
                    destination.str_schemmeType = @"No";
             destination.str_folio =self->tf_folio.text;
                    
                    destination.schemeDic =self->schemmeDic;
                }
                
                
            }else{
                destination.str_schemmeType = @"Yes";
       destination.str_folio =@"-";
                destination.schemmeDetialsDic =self->newSchemmeDic;

            }
            
            if ([self->str_driect  isEqualToString:@"Regular"] || [self->str_driect  isEqualToString:@"REGULAR"]){
                
                if ([tf_Arn.text isEqualToString:@"ARN-"]) {
                    destination.str_arn =@"-";
                }else{
                    destination.str_arn =self->tf_Arn.text ;
                    
                }
                if ([tf_SubArn.text isEqualToString:@"ARN-"]) {
                    destination.str_subarn =@"-";
                }else{
                    destination.str_subarn =self->tf_SubArn.text ;
                }
                
            }else{
                destination.str_arn =@"-";
                destination.str_subarn =@"-";
                
            }
            NSMutableArray * arr = [[NSMutableArray alloc]initWithObjects:paymentBankDic, nil];
       destination.paymentBantArr =arr;
            destination.str_PayModeVal= tf_modeRe.text;
            destination.  str_Category =  self->str_Category;
//            destination.str_folio =self->tf_folio.text;
            destination.str_tat =self->str_tat;
                        destination.str_Amount =self->tf_Sipamount.text;
            destination.str_Fund =self->tf_fund.text;
            destination.str_Secheme =self->tf_scheme.text;
            destination.str_Amount =self->tf_Sipamount.text;
            destination.str_referId =self->str_referId;
            destination.paymentModeArray =self->paymentModeArr;
            destination.str_selectedFundID = self->str_selectedFundID;
            
            if ([str_EuinNo  length] == 0) {
                destination.str_EuinCode =@"";

            }else{
                destination.str_EuinCode =str_EuinNo;

                
                
            }
            
     
            NSArray *minorRecordDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='P' "]];
            KT_TABLE12 *pan_rec=minorRecordDetails[0];
            destination.str_name =pan_rec.invName ;
            
            
            destination.sipType =self->selectSIPtypeInt;
            destination.famliyStr= @"PrimaryPan";
            
            destination.str_installments=self->tf_noodIns.text;
            destination.str_investment =self->tf_investment.text;
            destination.str_SipStartDay =self->tf_sipStartDay.text;
            destination.str_SipEndDay =self->tf_SipEndDay.text;
            destination.sipday = self->tf_days.text;
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
#pragma mark - validateSubARN API

-(void)validateSubARNAPI{
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    // NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_o_ErrNo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_SubArn.text];
    
    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_Arn.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@ValidateBrokercode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&AgentCd=%@&SubAgentCd=%@o_ErrNo&=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,Str_AgentCd,str_SubAgentCd,str_o_ErrNo];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            if ([responce[@"DtData"] count]  != 0) {
                self->subEArnarray= [[NSMutableArray alloc]init];
                if (self->subEArnarray.count == 0) {
                    self->subEArnarray = responce[@"DtData"];
                    self->tf_euin.inputView = self->picker_dropDown;
                    [self->picker_dropDown reloadAllComponents];
                    
                    if ([self->btn_yesEuin.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]) {
                        [self->tf_euin becomeFirstResponder];
                        
                    }
                }
                self->subEArnarray = responce[@"DtData"];
            }
            else{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Please  Check Sub ARN code"];
            }
            
            NSLog(@"%@",self->subEArnarray);
            
            
        }
        else{
            
            self->tf_SubArn.text =@"ARN-";
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Please  Check Sub ARN code"];
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
        tf_nomiee1.userInteractionEnabled =true;
        tf_nomiee2.userInteractionEnabled =true;
        tf_nomiee3.userInteractionEnabled =true;
        
        if (arr_nomieerefence.count == 1 ) {
            
            
            [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
            
            
            tf_nomiee1.text =@"100.00";
            [view_Nominee1 setHidden:NO];
            [view_Nominee2 setHidden:YES];
            [view_Nominee3 setHidden:YES];
            [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
            
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
            
        }else if (arr_nomieerefence.count == 2 ){
            [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
            
            [lbl_nomiee2 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[1][@"kn_NomName"]] forState:UIControlStateNormal];
     
            tf_nomiee1.text =@"50.0";
            tf_nomiee2.text =@"50.0";
            [view_Nominee1 setHidden:NO];
                        [view_Nominee2 setHidden:NO];
                          [view_Nominee3 setHidden:YES];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
        }
        else if (arr_nomieerefence.count == 3 ){
            [lbl_nomiee1 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[0][@"kn_NomName"]] forState:UIControlStateNormal];
            
            [lbl_nomiee2 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[1][@"kn_NomName"]] forState:UIControlStateNormal];
            [lbl_nomiee3 setTitle:[NSString stringWithFormat:@"%@",arr_nomieerefence[2][@"kn_NomName"]] forState:UIControlStateNormal];
            
            tf_nomiee3.text =@"33.3334";
            tf_nomiee2.text =@"33.3333";
            tf_nomiee1.text =@"33.3333";
            [view_Nominee1 setHidden:NO];
            [view_Nominee2 setHidden:NO];
            [view_Nominee3 setHidden:NO];
                [self scrollContentHeightIncrease:view_submit.frame.origin.y +view_submit.frame.size.height];
       
        }
        
        
        [view_nomiee setHidden:YES];
        
    }
    
}

#pragma mark - get Profile Percentage

-(void)getProfilePercentageAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

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
                } andCancelBlock:^{
                    
                }];
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


@end
