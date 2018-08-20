//
//  SwitchVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 26/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "SwitchWithfamliyVC.h"

@interface SwitchWithfamliyVC ()<UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    /// TextField
    
    __weak IBOutlet UITextField *tF_Fund;
    __weak IBOutlet UITextField *tf_folio;
    __weak IBOutlet UITextField *tF_Scheme;
    __weak IBOutlet UITextField *tf_category;
    __weak IBOutlet UITextField *tf_SwtichInscheme;
    __weak IBOutlet UITextField *tf_ArnCode;
    __weak IBOutlet UITextField *tf_broker;
    __weak IBOutlet UITextField *tf_SubARN;
    __weak IBOutlet UITextField *tf_switchUnit;
    
    __weak IBOutlet UITextField *tf_EuinNo;
    
    __weak IBOutlet UITextField *txt_famliy;

    /// Label
    __weak IBOutlet UILabel *lbl_baalanceUnits;
    __weak IBOutlet UILabel *lbl_currentLabel;
    __weak IBOutlet UILabel *lbl_navDate;
    __weak IBOutlet UILabel *lbl_miniAccount;
    
    
    //// button
    
    __weak IBOutlet UIButton *btn_distr;
    __weak IBOutlet UIButton *btn_direct;
    __weak IBOutlet UIButton *btn_YesEun;
    __weak IBOutlet UIButton *btn_NoEun;
    __weak IBOutlet UIButton *btn_partial;
    __weak IBOutlet UIButton *btn_full;
    __weak IBOutlet UIButton *btn_units;
    __weak IBOutlet UIButton *btn_Amount;
    __weak IBOutlet UIButton *btn_submit;
    
    //////   view
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *view_category;
    __weak IBOutlet UIView *view_scheme;
    __weak IBOutlet UIView *view_fund;  //527
    __weak IBOutlet UIView *view_redemption;
    __weak IBOutlet UIView *view_Arn;   /// 254
    __weak IBOutlet UIView *viewEUNNo;  ///62
    __weak IBOutlet UIView *view_switch;
    
    NSArray *subEArnarray;
    NSArray *fundDetails;
    NSArray *folioArray;
    NSArray *   PanDetials;
    NSArray *existingArr;
    NSArray *paymentBantArr;
    NSMutableArray * categoryArr;
    NSMutableArray *newschemeArr;
    NSMutableArray  *paymentModeArray;
    
    KT_TABLE2 *schemmeDic;
    KT_TABLE8 *selectedBank;
    NSMutableDictionary *newSchemmeDic;
    
    /// String
    NSString *str_selectedFundID;
    NSString *selectedPan;
    NSString *selectedfolio,*selectedSecheme,*miniAmount;
    NSString *str_PaymentBank;
    NSString *str_Category;
    NSString*str_folioDmart;
    NSString*str_EuinNo,*str_iScheme;
    NSString*str_plan;
    NSString*str_option;
    NSString *EUINFlag;
    NSString *str_driect;
    UIPickerView *picker_dropDown;
    UITextField *txt_currentTextField;
    NSString *str_referId,*str_redType,*ttrtype,* lastNavStr;
    
    
}

@end

@implementation SwitchWithfamliyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addElements];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [viewEUNNo setHidden:YES];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width,view_switch.frame.origin.y +view_switch.frame.size.height);
    
}
-(void)addElements{
    
    
    
    if ([self.str_fromScreen isEqualToString:@"details"]) {
        selectedPan=_selected_Rec.PAN;
        NSArray *pan= [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE  PAN ='%@'",selectedPan]];
        if(pan.count == 1)
        {
            
            KT_TABLE12 *rec_fund=pan[0];
            txt_famliy.text=[NSString stringWithFormat:@"%@",rec_fund.invName];
            selectedPan=[NSString stringWithFormat:@"%@",rec_fund.PAN];
            
        }
        
        tF_Fund.text=[NSString stringWithFormat:@"%@",_selected_Rec.fundDesc];
        str_selectedFundID =  [NSString stringWithFormat:@"%@",_selected_Rec.fund];
        
        tf_folio.text = [NSString stringWithFormat:@"%@",_selected_Rec.Acno];
        selectedfolio  = [NSString stringWithFormat:@"%@",_selected_Rec.Acno];
        tF_Scheme.text =[NSString stringWithFormat:@"%@",_selected_Rec.schDesc];
        
        
        schemmeDic= _selected_Rec;;
        tF_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
        lbl_baalanceUnits.text = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
        lbl_currentLabel.text = [NSString stringWithFormat:@"%@",schemmeDic.curValue];
        
        lbl_navDate.text = [NSString stringWithFormat:@"%@",schemmeDic.lastNAV];
        lbl_miniAccount.text = [NSString stringWithFormat:@"%@",schemmeDic.minAmt];
        
        miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
        str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
        lastNavStr = schemmeDic.lastNAV;
        
        
        str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
        
  
        [picker_dropDown reloadAllComponents];
        picker_dropDown=[[UIPickerView alloc]init];
        picker_dropDown.delegate=self;
        picker_dropDown.dataSource=self;
        picker_dropDown.backgroundColor=[UIColor whiteColor];
        [picker_dropDown reloadAllComponents];
        txt_famliy.userInteractionEnabled = NO;
        tf_folio.userInteractionEnabled = NO;
        tF_Fund.userInteractionEnabled = NO;
        tF_Scheme.userInteractionEnabled = NO;
    }
    else{
        PanDetials = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE  Not flag='P'"]];
        
        
        if(PanDetials.count == 1)
        {
            
            KT_TABLE12 *rec_fund=PanDetials[0];
            txt_famliy.text=[NSString stringWithFormat:@"%@",rec_fund.invName];
            selectedPan=[NSString stringWithFormat:@"%@",rec_fund.PAN];
            
        }
        NSLog(@"%@",fundDetails);
        picker_dropDown=[[UIPickerView alloc]init];
        picker_dropDown.delegate=self;
        picker_dropDown.dataSource=self;
        picker_dropDown.backgroundColor=[UIColor whiteColor];
        tF_Fund.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        txt_famliy.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        NSArray *minorRecordDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='P' "]];
        KT_TABLE12 *pan_rec=minorRecordDetails[0];
        selectedPan=pan_rec.PAN;
        fundDetails = [[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT distinct fundDesc,fund FROM TABLE2_DETAILS where PAN='%@' and rFlag='Y' and rSchFlg='Y' order By FundDesc",selectedPan]];
        NSLog(@"%@",fundDetails);
        [self.view updateConstraints];
        [self.view layoutIfNeeded];
        PanDetials = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE  Not flag='P'"]];
        if(PanDetials.count == 1)
        {
            
            KT_TABLE12 *rec_fund=PanDetials[0];
            txt_famliy.text=[NSString stringWithFormat:@"%@",rec_fund.invName];
            selectedPan=[NSString stringWithFormat:@"%@",rec_fund.PAN];
            
        }
        
        NSLog(@"%@",fundDetails);
        picker_dropDown=[[UIPickerView alloc]init];
        picker_dropDown.delegate=self;
        picker_dropDown.dataSource=self;
        picker_dropDown.backgroundColor=[UIColor whiteColor];
        tF_Fund.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        txt_famliy.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        tf_SwtichInscheme.inputView=picker_dropDown;
        
        [picker_dropDown reloadAllComponents];
        picker_dropDown=[[UIPickerView alloc]init];
        picker_dropDown.delegate=self;
        picker_dropDown.dataSource=self;
        picker_dropDown.backgroundColor=[UIColor whiteColor];
        tF_Fund.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }


    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [scrollView addGestureRecognizer:singleTap];

    str_redType =@"Units";
    NSString *  amountVal,*unitsVal;
    
    amountVal  =@"";
    unitsVal  =@"";
    tf_ArnCode.text =@"ARN-";
    tf_SubARN.text =@"ARN-";
  str_driect =@"Regular";
    if ([str_redType isEqualToString:@"Amount"]) {
        amountVal= tf_switchUnit.text;
        unitsVal=@"0"; //modified by badari on 15/05/2018.
    }else{
        unitsVal= tf_switchUnit.text;
        amountVal=@"0";  //modified by badari on 15/05/2018.
    }
    ttrtype= @"P"; //Modified by badari on 15/05/2018.
    tF_Scheme.delegate  = self;
    tF_Fund.delegate  = self;
    tf_folio.delegate  = self;
    tf_SubARN.delegate  = self;
    tf_ArnCode.delegate  = self;
    tf_broker.delegate  = self;
    tf_EuinNo.delegate  = self;
    tf_switchUnit.delegate  = self;
    txt_famliy.delegate  = self;

    str_EuinNo= @"";
    tf_SwtichInscheme.delegate  = self;
    tf_category.delegate  = self;
    [btn_units.layer setCornerRadius:15.0f];
    [btn_units.layer setMasksToBounds:YES];
    [UITextField withoutRoundedCornerTextField:tF_Fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_folio forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tF_Scheme forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_category forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_EuinNo forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_famliy forCornerRadius:5.0f forBorderWidth:1.5f];

    [UITextField withoutRoundedCornerTextField:tf_SwtichInscheme forCornerRadius:5.0f forBorderWidth:1.5f];
    
    [btn_submit.layer setCornerRadius:15.0f];
    [btn_submit.layer setMasksToBounds:YES];
    
    scrollView.delegate =self;
}

#pragma mark - scrollView Content Increase Method

-(void)scrollContentHeightIncrease:(CGFloat)height{
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width,height);
}
- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
- (IBAction)atc_direct:(id)sender {
    str_driect =@"Driect";
    
    tf_ArnCode.text =@"ARN-";
    tf_SubARN.text =@"ARN-";
    tf_broker.text =nil;
    tf_EuinNo.text =nil;
    [viewEUNNo setHidden:YES];
    [view_Arn setHidden:YES];
    
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_switch.frame.origin.y +view_switch.frame.size.height];
    [btn_direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_distr setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    
    [self newSchmemListApi];
    
}
- (IBAction)atc_distr:(id)sender {
    
    str_driect =@"Regular";
    [viewEUNNo setHidden:YES];
    [view_Arn setHidden:NO];
    tf_ArnCode.text =@"ARN-";
    tf_SubARN.text =@"ARN-";
    tf_broker.text =nil;
    tf_EuinNo.text =nil;
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [btn_YesEun setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_NoEun setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];

    [self scrollContentHeightIncrease:view_switch.frame.origin.y +view_switch.frame.size.height];
    [btn_direct setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_distr setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [self newSchmemListApi];
    
}
- (IBAction)atc_euinI:(id)sender {
    
       [[SharedUtility sharedInstance]showAlertViewWithTitle:KTMessage withMessage:@"I/We hereby confirm that the EUIN box has been intentionally left blank by me us as this is an 'execution-only' transaction without any interaction or advice by any personnel of the above distributor or notwithstanding the advice of in-appropriateness, if any, provided by any personnel of the distributor and the distributor has not charged any advisory fees on this transaction. "];
}

- (IBAction)atc_YesEuin:(id)sender {
    
    tf_EuinNo.text =nil;
    
    [viewEUNNo setHidden:YES];
    
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_switch.frame.origin.y +view_switch.frame.size.height];
    
    [btn_NoEun setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_YesEun setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    subEArnarray  = [[NSArray alloc]init];
    
    
    //    txt_Arn.text =@"ARN-";
    //    txt_SubARN.text =@"ARN-";
    //    txt_broker.text =nil;
    
    
}


- (IBAction)atc_NoEUIN:(id)sender {
    
    [viewEUNNo setHidden:NO];

    tf_EuinNo.text =nil;
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_switch.frame.origin.y +view_switch.frame.size.height];
    
    [ btn_YesEun setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [   btn_NoEun setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    //    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)]];
    
    
}

- (IBAction)atc_partial:(id)sender {
    
    if ([tf_SwtichInscheme.text length] == 0 ) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Scheme"];
        [tf_SwtichInscheme becomeFirstResponder];
        
    }else
        
        tf_switchUnit.text  =nil;
    
    tf_switchUnit.userInteractionEnabled = true;
    
    if  ([btn_partial.imageView.image isEqual:[UIImage imageNamed:@"radio-off"]]){
        [btn_partial setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_full setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        ttrtype= @"P";
        
    }
    
}
- (IBAction)atc_full:(id)sender {
    
    if ([tf_SwtichInscheme.text length] == 0 ) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Scheme"];
        [tf_SwtichInscheme becomeFirstResponder];
        
    }else{
        
        ttrtype= @"F";
        
        if  ([btn_full.imageView.image isEqual:[UIImage imageNamed:@"radio-off"]]){
            if ([btn_Amount.imageView.image isEqual:[UIImage imageNamed:@"radio-on"]]) {
                [btn_Amount setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_units setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                tf_switchUnit.placeholder =@"Units";
                str_redType =@"Units";
                
                
            }
            tf_switchUnit.placeholder =@"Units";
            str_redType =@"Units";
            
            tf_switchUnit.text  = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
            
            tf_switchUnit.userInteractionEnabled = false;
            
            tf_switchUnit.text  = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
            
            
            [btn_full setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
            [btn_partial setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        }
    }
    
}
- (IBAction)atc_units:(id)sender {
    
    if ([tf_SwtichInscheme.text length] == 0 ) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Scheme"];
        [tf_SwtichInscheme becomeFirstResponder];
        
    }else
        
        tf_switchUnit.placeholder =@"Units";
    str_redType =@"Units";
    
    tf_switchUnit.text  =nil;
    
    tf_switchUnit.userInteractionEnabled = true;
    
    if  ([btn_units.imageView.image isEqual:[UIImage imageNamed:@"radio-off"]]){
        [btn_units setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_Amount setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    }
    
    
}
- (IBAction)atc_Amount:(id)sender {
    if ([tf_SwtichInscheme.text length] == 0 ) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Scheme"];
        [tf_SwtichInscheme becomeFirstResponder];
        
    }else
        tf_switchUnit.placeholder =@"Amount";
    str_redType =@"Amount";
    tf_switchUnit.text  =nil;
    
    tf_switchUnit.userInteractionEnabled = true;
    if ([btn_full.imageView.image isEqual:[UIImage imageNamed:@"radio-on"]]) {
        [btn_full setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        [btn_partial setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        
    }
    if  ([btn_Amount.imageView.image isEqual:[UIImage imageNamed:@"radio-off"]]){
        [btn_Amount setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_units setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)atc_Submit:(id)sender {
    if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
        
        
        if (tF_Fund.text.length == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Fund"];
        }
        else if (tf_folio.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Folio"];
        }
        else if(tF_Scheme.text.length == 0)
        {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Scheme"];
        }
        else if(tf_SwtichInscheme.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Scheme"];
        }
        else if (tf_category.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Category"];
        }
        else if (tf_ArnCode.text.length == 0  || [ tf_ArnCode.text   isEqualToString:@"ARN-" ]){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select ARN Code"];
        }
        else if ( [tf_ArnCode.text   isEqualToString:tf_SubARN.text] ){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"  ARN  Code  and  sub ARN code  Should not be Same "];
            
        }
        else if ([btn_NoEun .imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
            if (tf_EuinNo.text.length == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Select  EUIN Number"];
                
            }
            else if ([str_redType isEqualToString:@"Amount"] && [tf_switchUnit.text length] == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Switch Amount"];
                
                
            }else if ([str_redType isEqualToString:@"Units"] && [tf_switchUnit.text length] == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Switch Units"];
                
                
            }
            //            else if ([str_redType isEqualToString:@"Amount"] && ( [lbl_currentLabel.text floatValue]  < [tf_switchUnit.text floatValue] )) {
            //                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Does'nt have enough Balance  to Redeem!"]];
            //
            //            }
            
            else if ([str_redType isEqualToString:@"Amount"] && ([tf_switchUnit.text floatValue]  <  [lbl_miniAccount .text floatValue])) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Minimum amount Should be  Amount:%@",lbl_miniAccount.text]];
                
            } else if ([str_redType isEqualToString:@"Units"] && [ttrtype isEqualToString:@"P"] && ([tf_switchUnit.text floatValue]*  [lastNavStr floatValue]) <   [lbl_baalanceUnits.text intValue]) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Minimum Units To Redeem !"];
            } else if ([str_redType isEqualToString:@"Units"] && [ttrtype isEqualToString:@"P"]  && [tf_switchUnit.text floatValue] > [lbl_baalanceUnits.text floatValue]) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"You don't have enough Units To Redeem!"];
                
            }else{
                [self exitloadcalcAPI];
                
            }
            
            
        }else{
            if ([str_redType isEqualToString:@"Amount"] && [tf_switchUnit.text length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Switch Amount"];
                
            }
            else if ([str_redType isEqualToString:@"Units"] && [tf_switchUnit.text length] == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Switch Units"];
                
                
            }
            
            else if ([str_redType isEqualToString:@"Amount"] && [tf_switchUnit.text length] == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Switch Amount"];
                
                
            }else if ([str_redType isEqualToString:@"Units"] && [tf_switchUnit.text length] == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Switch Units"];
                
                
            }
            //            else if ([str_redType isEqualToString:@"Amount"] && ( [lbl_currentLabel.text floatValue]  < [tf_switchUnit.text floatValue] )) {
            //                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Does'nt have enough Balance  to Redeem!"]];
            //
            //            }
            //
            else if ([str_redType isEqualToString:@"Amount"] && ([tf_switchUnit.text floatValue]  <  [lbl_miniAccount .text floatValue])) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Minimum amount Should be  Amount:%@",lbl_miniAccount.text]];
                
            } else if ([str_redType isEqualToString:@"Units"] && [ttrtype isEqualToString:@"P"] && ([tf_switchUnit.text floatValue]*  [lastNavStr floatValue]) <   [lbl_baalanceUnits.text intValue]) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Minimum Units To Redeem !"];
            } else if ([str_redType isEqualToString:@"Units"] && [ttrtype isEqualToString:@"P"]  && [tf_switchUnit.text floatValue] > [lbl_baalanceUnits.text floatValue]) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"You don't have enough Units To Redeem!"];
                
            }
            else{
                [self exitloadcalcAPI];
                
            }
        }
        
    }else{
        if (tF_Fund.text.length == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Fund"];
        }
        else if (tf_folio.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Folio"];
        }
        else if(tF_Scheme.text.length == 0)
        {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Scheme"];
        }
        else if(tf_SwtichInscheme.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Scheme"];
        }
        else if (tf_category.text.length == 0){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select the Category"];
        }
        else if ([str_redType isEqualToString:@"Amount"] && [tf_switchUnit.text length] == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter switch Amount"];
            
            
        }else if ([str_redType isEqualToString:@"Units"] && [tf_switchUnit.text length] == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter switch Units"];
            
            
        }
        //        else if ([str_redType isEqualToString:@"Amount"] && ( [lbl_currentLabel.text floatValue]  < [tf_switchUnit.text floatValue] )) {
        //            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Does'nt have enough Balance  to Redeem!"]];
        //
        //        }
        //
        else if ([str_redType isEqualToString:@"Amount"] && ([tf_switchUnit.text floatValue]  <  [lbl_miniAccount .text floatValue])) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Minimum amount Should be  Amount:%@",lbl_miniAccount.text]];
            
        } else if ([str_redType isEqualToString:@"Units"] && [ttrtype isEqualToString:@"P"] && ([tf_switchUnit.text floatValue]*  [lastNavStr floatValue]) <   [lbl_baalanceUnits.text intValue]) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Minimum Units To Redeem !"];
        } else if ([str_redType isEqualToString:@"Units"] && [ttrtype isEqualToString:@"P"]  && [tf_switchUnit.text floatValue] > [lbl_baalanceUnits.text floatValue]) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"You don't have enough Units To Redeem!"];
            
        }else
        {
            [self exitloadcalcAPI];
            
        }
        
    }
    
    
    
    
    
    
    
}


#pragma mark - exitloadcalcAPI API
-(void)exitloadcalcAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:XTOnlyDateFormat];
    NSString *datestamp = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",datestamp);
    
    
    NSLog(@"%@",str_redType);
    NSLog(@"%@",ttrtype);
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_scheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_iScheme];
    NSString *str_enplan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_plan];
    
    NSString *str_trdt =[XTAPP_DELEGATE convertToBase64StrForAGivenString:datestamp];
    NSString *str_ENredType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:ttrtype];
    
    NSString *  amountVal,*unitsVal;
    
    amountVal  =@"";
    unitsVal  =@"";
    
    if ([str_redType isEqualToString:@"Amount"]) {
        amountVal= tf_switchUnit.text;
        unitsVal=@"0"; //modified by badari on 15/05/2018.
    }else{
        unitsVal= tf_switchUnit.text;
        amountVal=@"0";  //modified by badari on 15/05/2018.
    }
    
    NSString *str_amountVale =[XTAPP_DELEGATE convertToBase64StrForAGivenString:amountVal];
    
    NSString *str_unitsVal =[XTAPP_DELEGATE convertToBase64StrForAGivenString:unitsVal];
    
    NSString *str_url = [NSString stringWithFormat:@"%@exitloadcalc?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&scheme=%@&plan=%@&acno=%@&units=%@&amount=%@&trdt=%@&ttrtype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_scheme,str_enplan,str_folio,str_unitsVal,str_amountVale,str_trdt,str_ENredType];
    NSLog(@"%@",str_url);
    
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        
        if (error_statuscode==0) {
            
            float error_redamt=[responce[@"Dtdata"][0][@"Red. Amount"]floatValue];
            NSLog(@"redamt is %f",error_redamt);
            float error_loadamt=[responce[@"Dtdata"][0][@"LoadAmount"]floatValue];
            NSLog(@"loadamt is %f",error_loadamt);
            if (error_loadamt  != 0.0000) {
                
                if ([str_redType isEqualToString:@"Amount"]) {
                    NSString *msg =[NSString stringWithFormat:@"Your redemption transaction is subject to exit load of Rs. %f",error_loadamt];
                    NSString *redmsg = [NSString stringWithFormat:@"and net redemption value will be Rs. %f",error_redamt];
                    NSString *postapp = [NSString stringWithFormat:@"post application of STT."];
                    
                    NSString *concstr = [NSString stringWithFormat:@"%@ %@ %@", msg,redmsg,postapp];
                    NSLog(@"concat string is %@",concstr);
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Redemption"
                                                  message:concstr
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"Procced"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action){
                                             SwitchCnfVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SwitchCnfVC"];
                                             destination.str_pan= selectedPan;
                                             
                                             destination.schemeDic =schemmeDic;
                                             
                                             destination.str_Fund =tF_Fund.text;
                                             destination.str_folio =tf_folio.text;
                                             destination.str_Secheme =tF_Scheme.text;
                                                destination.str_Sechemein =tf_SwtichInscheme.text;
                                             
                                             destination.str_Amount =tf_switchUnit.text;
                                             destination.str_referId =str_referId;
                                             destination.paymentModeArray = [responce[@"Dtinformation"] mutableCopy];
                                             destination.str_selectedFundID = str_selectedFundID;
                                             destination.str_selectedFundID = str_selectedFundID;
                                             destination.ttrtype = ttrtype;
                                             destination.str_redType = str_redType;
                                             destination.lastNavStr = lastNavStr;
                                             destination.selectedBank =selectedBank;
                                             destination.famliyStr =@"bj";
                                             destination.NewSchemmeDic =newSchemmeDic;
                                             
                                             destination.Str_name  = txt_famliy.text;
                                             if ([tf_ArnCode.text isEqualToString:@"" ]  &&  [tf_ArnCode. text isEqualToString:@"ARN-"]) {
                                                 destination.str_euinflag =@" Y";
                                                 destination.Str_arncode  = @"";
                                                 
                                                 
                                             }else{
                                                 destination.str_euinflag =@" N";
                                                 destination.Str_arncode = tf_ArnCode.text;
                                                 destination.str_EuinNo        =       str_EuinNo;
                                                 
                                             }
                                             if ([tf_SubARN.text isEqualToString:@"" ]  &&  [tf_ArnCode. text isEqualToString:@"ARN-"]) {
                                                 destination.Str_subarncode  = @"";
                                                 
                                                 
                                             }else{
                                                 destination.Str_subarncode  = tf_SubARN.text;
                                                 
                                             }
                                             
                                             
                                             KTPUSH(destination,YES);
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
                }else{
                    NSString *msg =[NSString stringWithFormat:@"Your redemption transaction is subject to an approximate exit load of Rs. %f",error_loadamt];
                    NSString *redmsg = [NSString stringWithFormat:@"and net redemption value will be Rs. %f",error_redamt];
                    NSString *postapp = [NSString stringWithFormat:@"post application of STT. The actual values will be based on applicable NAV"];
                    NSString *constr2 = [NSString stringWithFormat:@"%@ %@ %@",msg,redmsg,postapp];
                    NSLog(@"constr2 is %@",constr2);
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Redemption"
                                                  message:constr2
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"Procced"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action){
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                             SwitchCnfVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SwitchCnfVC"];
                                             destination.str_pan= selectedPan;
                                             
                                             destination.schemeDic =schemmeDic;
                                             
                                             destination.str_Fund =tF_Fund.text;
                                             destination.str_folio =tf_folio.text;
                                             destination.str_Secheme =tF_Scheme.text;
                                             destination.str_Amount =tf_switchUnit.text;
                                             destination.str_referId =str_referId;
                                             destination.paymentModeArray = [responce[@"Dtinformation"] mutableCopy];
                                             destination.str_selectedFundID = str_selectedFundID;
                                             destination.str_selectedFundID = str_selectedFundID;
                                             destination.ttrtype = ttrtype;
                                             destination.str_redType = str_redType;
                                             destination.lastNavStr = lastNavStr;
                                             destination.selectedBank =selectedBank;
                                             destination.str_Sechemein =tf_SwtichInscheme.text;

                                             destination.famliyStr =@"h";
                                                                destination.Str_name  = txt_famliy.text;
                                             destination.NewSchemmeDic =newSchemmeDic;
                                             if ([tf_ArnCode.text isEqualToString:@"" ]  &&  [tf_ArnCode. text isEqualToString:@"ARN-"]) {
                                                 destination.str_euinflag =@" Y";
                                                 destination.Str_arncode  = @"";
                                                 
                                                 
                                             }else{
                                                 destination.str_euinflag =@" N";
                                                 destination.Str_arncode = tf_EuinNo.text;
                                                 destination.str_EuinNo        =       str_EuinNo;
                                                 
                                             }
                                             if ([tf_SubARN.text isEqualToString:@"" ]  &&  [tf_ArnCode. text isEqualToString:@"ARN-"]) {
                                                 destination.Str_subarncode  = @"";
                                                 
                                                 
                                             }else{
                                                 destination.Str_subarncode  = tf_SubARN.text;
                                                 
                                             }
                                             
                                             
                                             KTPUSH(destination,YES);
                                             
                                             
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
                
            }else{
                
                
                if ([str_redType isEqualToString:@"Amount"]) {
                    
                    SwitchCnfVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SwitchCnfVC"];
                    destination.str_pan= selectedPan;
                    
                    destination.schemeDic =schemmeDic;
                    
                    destination.str_Fund =tF_Fund.text;
                    destination.str_folio =tf_folio.text;
                    destination.str_Secheme =tF_Scheme.text;
                    destination.str_Amount =tf_switchUnit.text;
                    destination.str_referId =str_referId;
                    destination.paymentModeArray = [responce[@"Dtinformation"] mutableCopy];
                    destination.str_selectedFundID = str_selectedFundID;
                    destination.str_selectedFundID = str_selectedFundID;
                    destination.ttrtype = ttrtype;
                    destination.str_Sechemein =tf_SwtichInscheme.text;

                    destination.str_redType = str_redType;
                    destination.lastNavStr = lastNavStr;
                    destination.selectedBank =selectedBank;
                    destination.famliyStr =@"h";
                                       destination.Str_name  = txt_famliy.text;
                    destination.NewSchemmeDic =newSchemmeDic;
                    if ([tf_ArnCode.text isEqualToString:@"" ]  &&  [tf_ArnCode. text isEqualToString:@"ARN-"]) {
                        destination.str_euinflag =@" Y";
                        destination.Str_arncode  = @"";
                        
                        
                    }else{
                        destination.str_euinflag =@" N";
                        destination.Str_arncode = tf_EuinNo.text;
                        destination.str_EuinNo        =       str_EuinNo;
                        
                    }
                    if ([tf_SubARN.text isEqualToString:@"" ]  &&  [tf_ArnCode. text isEqualToString:@"ARN-"]) {
                        destination.Str_subarncode  = @"";
                        
                        
                    }else{
                        destination.Str_subarncode  = tf_SubARN.text;
                        
                    }
                    
                    
                    KTPUSH(destination,YES);
                    
                }else{
                    
                    
                    SwitchCnfVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SwitchCnfVC"];
                    destination.str_pan= selectedPan;
                    
                    destination.schemeDic =schemmeDic;
                    
                    destination.str_Fund =tF_Fund.text;
                    destination.str_folio =tf_folio.text;
                    destination.str_Secheme =tF_Scheme.text;
                    destination.str_Amount =tf_switchUnit.text;
                    destination.str_referId =str_referId;
                    destination.paymentModeArray = [responce[@"Dtinformation"] mutableCopy];
                    destination.str_selectedFundID = str_selectedFundID;
                    destination.str_selectedFundID = str_selectedFundID;
                    destination.ttrtype = ttrtype;
                    destination.str_Sechemein =tf_SwtichInscheme.text;

                    destination.str_redType = str_redType;
                    destination.lastNavStr = lastNavStr;
                    destination.selectedBank =selectedBank;
                    destination.famliyStr =@"h";
                                       destination.Str_name  = txt_famliy.text;
                    destination.NewSchemmeDic =newSchemmeDic;
                    if ([tf_ArnCode.text isEqualToString:@"" ]  &&  [tf_ArnCode. text isEqualToString:@"ARN-"]) {
                        destination.str_euinflag =@" Y";
                        destination.Str_arncode  = @"";
                        
                        
                    }else{
                        destination.str_euinflag =@" N";
                        destination.Str_arncode = tf_EuinNo.text;
                        destination.str_EuinNo        =       str_EuinNo;
                        
                    }
                    if ([tf_SubARN.text isEqualToString:@"" ]  &&  [tf_ArnCode. text isEqualToString:@"ARN-"]) {
                        destination.Str_subarncode  = @"";
                        
                        
                    }else{
                        destination.Str_subarncode  = tf_SubARN.text;
                        
                    }
                    
                    
                    KTPUSH(destination,YES);
                    
                }
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
- (IBAction)back:(id)sender {
    
    KTPOP(YES);
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    long int newcount = 0;
    
    if (txt_currentTextField==tF_Fund) {
        newcount= fundDetails.count;
    }
    if (txt_currentTextField==txt_famliy) {
            newcount= PanDetials.count;
        }
    if (txt_currentTextField==tf_folio) {
        newcount= folioArray.count;
    }
    
    if (txt_currentTextField==tF_Scheme) {
        
        
        
        newcount= existingArr.count;
    }
    if (txt_currentTextField==tf_SwtichInscheme) {
        
        
        newcount= newschemeArr.count;
        
        
        
    }
    if (txt_currentTextField==tf_category) {
        newcount= categoryArr.count;
    }
    if (txt_currentTextField==tf_EuinNo) {
        newcount= subEArnarray.count;
    }
    return newcount;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str_title;
    if (txt_currentTextField==tF_Fund) {
        KT_Table2RawQuery *rec_fund=fundDetails[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund.fundDesc];
    }
    
    
    if (txt_currentTextField==txt_famliy) {
            KT_TABLE12 *rec_fund=PanDetials[row];
            str_title=[NSString stringWithFormat:@"%@",rec_fund.invName];
        }
    
    if (txt_currentTextField==tf_folio) {
        KT_TABLE2 *rec_fund=folioArray[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund.Acno];
    }
    if (txt_currentTextField==tf_category) {
        NSDictionary  *rec_fund=categoryArr[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];
    }
    if (txt_currentTextField==tF_Scheme) {
        
        
        KT_TABLE2 *rec_fund=existingArr[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
        str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
        
        
    }
    if (txt_currentTextField==tf_SwtichInscheme) {
        
        
        NSDictionary *rec_fund=newschemeArr[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund[@"fm_schdesc"]];
        
        
    }
    
    if (txt_currentTextField==tf_EuinNo) {
        NSDictionary *rec_fund=subEArnarray[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
    }
    return str_title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    if (txt_currentTextField==txt_famliy) {
        KT_TABLE12 *rec_fund=PanDetials[row];
        txt_famliy.text=[NSString stringWithFormat:@"%@",rec_fund.invName];
        tF_Fund.text=nil;
        
        tf_folio.text=nil;
        tF_Scheme.text=nil;
        tF_Scheme.text=nil;
        lbl_baalanceUnits.text = nil;
        lbl_currentLabel.text = nil;
        
        lbl_navDate.text =nil;
        lbl_miniAccount.text = nil;
        tf_category.text=nil;
        tf_SwtichInscheme.text=nil;
        tf_ArnCode.text =@"ARN-";
        tf_SubARN.text =@"ARN-";
        tf_broker.text=nil;
        tf_switchUnit.text=nil;
        [self atc_YesEuin:nil];
        //[self atc_partial:nil];
        //        [btn_NoEun setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        //        [btn_YesEun setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        //         [viewEUNNo setHidden:YES];
        [btn_partial setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_full setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        selectedPan=[NSString stringWithFormat:@"%@",rec_fund.PAN];
    }
    if (txt_currentTextField==tF_Fund) {
        KT_Table2RawQuery *rec_fund=fundDetails[row];
        tF_Fund.text=[NSString stringWithFormat:@"%@",rec_fund.fundDesc];
        str_selectedFundID=[NSString stringWithFormat:@"%@",rec_fund.fund];
        tf_folio.text=nil;
        tF_Scheme.text=nil;
        tF_Scheme.text=nil;
        lbl_baalanceUnits.text = nil;
        lbl_currentLabel.text = nil;
        
        lbl_navDate.text =nil;
        lbl_miniAccount.text = nil;
        tf_category.text=nil;
        tf_SwtichInscheme.text=nil;
        tf_broker.text=nil;
        tf_ArnCode.text =@"ARN-";
        tf_SubARN.text =@"ARN-";
        [btn_NoEun setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        [btn_YesEun setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_partial setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_full setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        tf_switchUnit.text=nil;
        [viewEUNNo setHidden:YES];
        
        folioArray = [[DBManager sharedDataManagerInstance]uniqueFolioFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (Acno), notallowed_flag FROM TABLE2_DETAILS where fund ='%@' and PAN='%@' and BalUnits != 0.0 and rSchFlg='Y'",str_selectedFundID,selectedPan]];
        if (folioArray.count == 1) {
            KT_TABLE2 *rec_fund=folioArray[0];
            NSLog(@"%@",rec_fund.notallowed_flag);
            tf_folio.text=[NSString stringWithFormat:@"%@",rec_fund.Acno];
            selectedfolio =[NSString stringWithFormat:@"%@",rec_fund.Acno];
            tf_folio.inputView = picker_dropDown;
            [picker_dropDown reloadAllComponents];
            
            existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and BalUnits != 0 and rSchFlg='Y' ",str_selectedFundID,selectedfolio]];
            if (existingArr.count == 1) {
                KT_TABLE2 *rec_fund=existingArr[0];
                NSLog(@"%@",rec_fund.notallowed_flag);
                tF_Scheme.text=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                selectedSecheme =[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                
                schemmeDic=existingArr[0];
                
                tF_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
                lbl_baalanceUnits.text = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
                lbl_currentLabel.text = [NSString stringWithFormat:@"%@",schemmeDic.curValue];
                
                lbl_navDate.text = [NSString stringWithFormat:@"%@",schemmeDic.lastNAV];
                lbl_miniAccount.text = [NSString stringWithFormat:@"%@",schemmeDic.minAmt];
                
                miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
                str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
                lastNavStr = schemmeDic.lastNAV;
                
                
                str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
                tF_Scheme.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
                
                
            }else{
                [txt_currentTextField becomeFirstResponder];
                tF_Scheme.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
            }
            
        }else{
            [txt_currentTextField becomeFirstResponder];
            tf_folio.inputView = picker_dropDown;
            [picker_dropDown reloadAllComponents];
        }
        
        
        
    }
    if (txt_currentTextField==tf_category) {
        NSDictionary  *rec_fund=categoryArr[row];
        // [categoryArr  removeAllObjects];
        newschemeArr =[[NSMutableArray alloc]init];
        tf_SwtichInscheme.text  =nil;
        [btn_partial setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_full setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        // [self atc_partial:nil];
        tf_category.text=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];
        str_Category=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];
        
        
    }
    if (txt_currentTextField==tf_folio) {
        KT_TABLE2 *rec_fund=folioArray[row];
        existingArr =[[NSMutableArray alloc]init];
        tF_Scheme.text=nil;
        tF_Scheme.text=nil;
        lbl_baalanceUnits.text = nil;
        lbl_currentLabel.text = nil;
        
        lbl_navDate.text =nil;
        lbl_miniAccount.text = nil;
        tf_category.text=nil;
        tf_SwtichInscheme.text=nil;
        tf_ArnCode.text =@"ARN-";
        tf_SubARN.text =@"ARN-";
        tf_broker.text=nil;
        //        [btn_NoEun setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        //        [btn_YesEun setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [self atc_YesEuin:nil];
        //[self atc_partial:nil];
        
        [btn_partial setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_full setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        tf_folio.text=[NSString stringWithFormat:@"%@",rec_fund.Acno];
        selectedfolio=[NSString stringWithFormat:@"%@",rec_fund.Acno];
        str_folioDmart=[NSString stringWithFormat:@"%@",rec_fund.notallowed_flag];
        str_iScheme =[NSString stringWithFormat:@"Minimum Amount (%@)",rec_fund.sch];;
        lastNavStr = rec_fund.lastNAV;
        
        str_plan =[NSString stringWithFormat:@"Minimum Amount (%@)",rec_fund.pln];;
        
        existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and BalUnits != 0 and rSchFlg='Y' ",str_selectedFundID,selectedfolio]];
        if (existingArr.count == 1) {
            KT_TABLE2 *rec_fund=existingArr[0];
            NSLog(@"%@",rec_fund.notallowed_flag);
            tF_Scheme.text=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
            selectedSecheme =[NSString stringWithFormat:@"%@",rec_fund.schDesc];
            
            schemmeDic=existingArr[0];
            
            tF_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
            lbl_baalanceUnits.text = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
            lbl_currentLabel.text = [NSString stringWithFormat:@"%@",schemmeDic.curValue];
            
            lbl_navDate.text = [NSString stringWithFormat:@"%@",schemmeDic.lastNAV];
            lbl_miniAccount.text = [NSString stringWithFormat:@"%@",schemmeDic.minAmt];
            
            miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
            str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
            lastNavStr = schemmeDic.lastNAV;
            
            
            str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
            tF_Scheme.inputView = picker_dropDown;
            
            lbl_baalanceUnits.text = nil;
            lbl_currentLabel.text = nil;
            
            //by satya
            lbl_navDate.text =nil;
            lbl_miniAccount.text = nil;
            tf_category.text=nil;
            tf_SwtichInscheme.text=nil;
            tf_ArnCode.text =@"ARN-";
            tf_SubARN.text =@"ARN-";
            tf_broker.text=nil;
            tf_switchUnit.text=nil;
            [self atc_YesEuin:nil];
            // [self atc_partial:nil];
            //by satya
            [picker_dropDown reloadAllComponents];
            
            
        }else{
            [txt_currentTextField becomeFirstResponder];
            tF_Scheme.inputView = picker_dropDown;
            
            //by satya
            tf_SwtichInscheme.text=nil;
            tf_ArnCode.text =@"ARN-";
            tf_SubARN.text =@"ARN-";
            tf_broker.text=nil;
            tf_switchUnit.text = nil;
            [self atc_YesEuin:nil];
            //[self atc_partial:nil];
            //by satya
            
            [picker_dropDown reloadAllComponents];
        }
        
        NSLog(@"%@",rec_fund.notallowed_flag);
    }
    if (txt_currentTextField==tF_Scheme) {
        
        
        
        
        
        schemmeDic=existingArr[row];
        
        tF_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
        lbl_baalanceUnits.text = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
        lbl_currentLabel.text = [NSString stringWithFormat:@"%@",schemmeDic.curValue];
        
        lbl_navDate.text = [NSString stringWithFormat:@"%@",schemmeDic.lastNAV];
        lbl_miniAccount.text = [NSString stringWithFormat:@"%@",schemmeDic.minAmt];
        
        miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
        str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
        lastNavStr = schemmeDic.lastNAV;
        
        
        str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
        
        
        
        
    }
    if (txt_currentTextField==tf_SwtichInscheme) {
        
        
        
        newSchemmeDic=newschemeArr[row];
        
        tf_SwtichInscheme.text=[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_schdesc"]];
        tf_ArnCode.text =@"ARN-";
        tf_SubARN.text =@"ARN-";
        tf_broker.text=nil;
        tf_switchUnit.text = nil;
        [self atc_YesEuin:nil];
        //  [self atc_partial:nil];
        //        selectedSecheme=[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_schdesc"]];
        //        miniAmount=[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_newpur"]];
        //        ///  lbl_miniAmount.text =[NSString stringWithFormat:@"Minimum Amount (%@)",miniAmount];;
        // //       str_iScheme =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_scheme"]];;
        //        str_plan =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_plan"]];;
        //        str_option =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_option"]];;
        //        str_driect =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_plnmode"]];;
        
        
    }
    
    
    if (txt_currentTextField==tf_EuinNo) {
        NSDictionary  *rec_fund=subEArnarray[row];
        // [categoryArr  removeAllObjects];
        
        
        
        tf_EuinNo.text=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
        str_EuinNo =[NSString stringWithFormat:@"%@",rec_fund[@"abm_name"]];
    }
    
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTextField=textField;
    
    if (textField==txt_famliy) {
        [picker_dropDown reloadAllComponents];
        [txt_famliy becomeFirstResponder];
    }
    
    
    else  if (textField==tF_Fund) {
        
        if ([txt_famliy.text length] == 0 ) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Famliy Member"];
            //      /    [tF_fund becomeFirstResponder];
            
        }else{
            fundDetails = [[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT distinct fundDesc,fund FROM TABLE2_DETAILS where PAN='%@' and rFlag='Y' and rSchFlg='Y' order By FundDesc",selectedPan]];
            [picker_dropDown reloadAllComponents];
            [tF_Fund becomeFirstResponder];
        }
        
    }
    else if  (textField==tf_folio) {
        if ([tF_Fund.text length] == 0 ) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund"];
            [tf_folio becomeFirstResponder];
            
        }
        else{
            
            
            
            folioArray = [[DBManager sharedDataManagerInstance]uniqueFolioFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (Acno), notallowed_flag FROM TABLE2_DETAILS where fund ='%@' and PAN='%@' and BalUnits != 0.0 and rSchFlg='Y'",str_selectedFundID,selectedPan]];
            if (folioArray.count == 1) {
                KT_TABLE2 *rec_fund=folioArray[0];
                NSLog(@"%@",rec_fund.notallowed_flag);
                tf_folio.text=[NSString stringWithFormat:@"%@",rec_fund.Acno];
                selectedfolio =[NSString stringWithFormat:@"%@",rec_fund.Acno];
                tf_folio.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
                
            }else{
                [txt_currentTextField becomeFirstResponder];
                tf_folio.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
            }
            
        }
        
    }
    
    else if  (textField==tF_Scheme) {
        
        if ([tF_Fund.text length] == 0 ) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio"];
            [tF_Fund becomeFirstResponder];
            
        }
        else{
            
            if (existingArr.count  == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No Scheme found"];
            }else{
                
                //by satya
                tf_category.text=@"";
                tf_SwtichInscheme.text=@"";
                tf_ArnCode.text =@"ARN-";
                tf_SubARN.text =@"ARN-";
                tf_broker.text=nil;
                tf_switchUnit.text = nil;
                [self atc_YesEuin:nil];
                //[self atc_partial:nil];
                //by satya
                
                if (existingArr.count == 1) {
                    
                    
                    schemmeDic=existingArr[0];
                    
                    tF_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
                    lbl_baalanceUnits.text = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
                    lbl_currentLabel.text = [NSString stringWithFormat:@"%@",schemmeDic.curValue];
                    
                    lbl_navDate.text = [NSString stringWithFormat:@"%@",schemmeDic.lastNAV];
                    lbl_miniAccount.text = [NSString stringWithFormat:@"%@",schemmeDic.minAmt];
                    
                    miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
                    str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
                    lastNavStr = schemmeDic.lastNAV;
                    
                    
                    str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
                    tF_Scheme.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                    
                }else{
                    [txt_currentTextField becomeFirstResponder];
                    tF_Scheme.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                }
                
            }
        }
        
        
    }
    else if (textField==tf_EuinNo) {
        
        if ([tf_ArnCode.text   isEqualToString:@"ARN-" ]) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the ARN-"];
            [tf_EuinNo becomeFirstResponder];
            
        }else{
            if (subEArnarray.count == 0) {
                [tf_EuinNo resignFirstResponder];
                
                
                
                [self  validateARNAPI];
                
            }else{
                // [self  categoryListApi];
                
                if (subEArnarray.count == 1) {
                    
                    NSDictionary *rec_fund=subEArnarray[0];
                    
                    NSLog(@"%@",rec_fund[@"abm_agent"]);
                    
                    tf_EuinNo.text=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
                    str_EuinNo =[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
                    [tf_EuinNo becomeFirstResponder];
                    tf_EuinNo.inputView = picker_dropDown;
                    
                    
                    //by satya
                    tf_ArnCode.text =@"ARN-";
                    tf_SubARN.text =@"ARN-";
                    tf_broker.text=nil;
                    tf_switchUnit.text = nil;
                    [self atc_YesEuin:nil];
                   // [self atc_partial:nil];
                    //by satya
                    
                    [picker_dropDown reloadAllComponents];
                }else{
                    [tf_EuinNo becomeFirstResponder];
                    tf_EuinNo.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                }
            }
        }
        
    }
    else if (textField==tf_category) {
        
        
        //        if ([str_folioDmart isEqualToString:@"D"]  ) {
        //            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Demat folio is not eligible for purchase"];
        //            tF_Scheme.inputView = picker_dropDown;
        //            [picker_dropDown reloadAllComponents];
        //            [tf_category becomeFirstResponder];
        //
        //
        //        } else if ( [str_folioDmart isEqualToString:@"J"]){
        //            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Join folio is not eligible for purchase"];
        //            tF_Scheme.inputView = picker_dropDown;
        //            [picker_dropDown reloadAllComponents];
        //            [tf_category becomeFirstResponder];
        //
        //
        //        }else{
        
        //by satya
        tf_ArnCode.text =@"ARN-";
        tf_SubARN.text =@"ARN-";
        tf_broker.text=nil;
        tf_switchUnit.text = nil;
        [self atc_YesEuin:nil];
        
        //by satya
        
        if ([tF_Scheme.text length] == 0){
            
            
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Scheme"];
            
        }else{
            if (categoryArr.count == 0) {
                
                [self  categoryListApi];
                
            }else{
                [tf_category becomeFirstResponder];
                tf_category.inputView = picker_dropDown;
               
                [picker_dropDown reloadAllComponents];
            }
        }
        
        
        //  }
        
    }    else if (textField==tf_SwtichInscheme) {
        
        
        //        if ([str_folioDmart isEqualToString:@"D"]  ) {
        //            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Demat folio is not eligible for purchase"];
        //            txt_Scheme.inputView = picker_dropDown;
        //            [picker_dropDown reloadAllComponents];
        //            [txt_Scheme becomeFirstResponder];
        //
        //
        //        } else if ( [str_folioDmart isEqualToString:@"J"]){
        //            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Join folio is not eligible for purchase"];
        //            txt_Scheme.inputView = picker_dropDown;
        //            [picker_dropDown reloadAllComponents];
        //            [txt_Scheme becomeFirstResponder];
        //
        //
        //        }else{
        
        
        
        
        if ([tf_category.text length] == 0){
            [tf_SwtichInscheme resignFirstResponder];
            
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Category"];
            
        }else{
            
            if (newschemeArr.count == 0) {
                [self  newSchmemListApi];
                
            }else{
                [tf_SwtichInscheme becomeFirstResponder];
                tf_SwtichInscheme.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];                }
            
            
        }
        
        if (textField==tf_EuinNo) {
            
            if ([tf_ArnCode.text   isEqualToString:@"ARN-" ]) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the ARN-"];
                [tf_EuinNo becomeFirstResponder];
                
            }else{
                if (subEArnarray.count == 0) {
                    [tf_EuinNo resignFirstResponder];
                    [self  validateARNAPI];
                    
                }else{
                    // [self  categoryListApi];
                    
                    if (subEArnarray.count == 1) {
                        
                        NSDictionary *rec_fund=subEArnarray[0];
                        
                        NSLog(@"%@",rec_fund[@"abm_agent"]);
                        
                        tf_EuinNo.text=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
                        str_EuinNo =[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
                        [tf_EuinNo becomeFirstResponder];
                        tf_EuinNo.inputView = picker_dropDown;
                        [picker_dropDown reloadAllComponents];
                    }else{
                        [tf_EuinNo becomeFirstResponder];
                        tf_EuinNo.inputView = picker_dropDown;
                        [picker_dropDown reloadAllComponents];
                    }
                }
            }
            
        }
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tf_switchUnit) {
        
        
        if (textField.text.length >= MAX_LENGTH && range.length == 0)
        {
            
            
            return NO; // return NO to not change text
        }
        
        
        else
        {return YES;}
    }
    
    {return YES;}
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [txt_currentTextField resignFirstResponder];
    
    if (textField == tf_folio) {
        existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and BalUnits != 0 and rSchFlg='Y' ",str_selectedFundID,selectedfolio]];
        if (existingArr.count  == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No Scheme found"];
        }
        
    }
    
    if (textField==tf_ArnCode ) {
        
        if ([tf_ArnCode.text isEqualToString:@"ARN-"]   ) {
            
            if ([tf_ArnCode.text length ] == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the ARN- Code "];
                
            }
        } else {
            [self validateARNAPI];
            
        }
    }
    if (textField==tf_SubARN ) {
        [self validateSubARNAPI];
        
        
    }
    
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
            
            categoryArr= [[NSMutableArray alloc]init];
            if (categoryArr.count == 0) {
                categoryArr = responce[@"DtData"];
                tf_category.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
                [tf_category becomeFirstResponder];
                
                
            }
            
            categoryArr = responce[@"DtData"];
            
            NSLog(@"%@",categoryArr);
            
            
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
    NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_enCategory =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_category.text];
    NSString *str_trantype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"s"];
    NSString *str_divflg =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *  investflag ;
    if ([btn_direct.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
        investflag   = @"Regular";
        
    }else{
        
        investflag = @"Direct";
        
    }
    NSString *str_investflag =[XTAPP_DELEGATE convertToBase64StrForAGivenString:investflag];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@getOtherSchemesSwitch?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fundCode=%@&acno=%@&category=%@&trantype=%@&divflg=%@&schtype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_folio,str_enCategory,str_trantype,str_divflg,str_investflag];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            if ([responce[@"DtData"] count]  != 0) {
                
                newschemeArr= [[NSMutableArray alloc]init];
                
                if (newschemeArr.count == 0) {
                    
                    newschemeArr =  responce[@"DtData"];
                    tf_SwtichInscheme.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                    [tf_SwtichInscheme becomeFirstResponder];
                    
                    
                    
                }
                newschemeArr =  responce[@"DtData"];
                NSLog(@"%@",responce);
            }else{
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
#pragma mark - validate ARN API
-(void)validateARNAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    // NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_o_ErrNo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_SubARN.text];
    
    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_ArnCode.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@ValidateBrokercode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&AgentCd=%@&SubAgentCd=%@o_ErrNo&=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,Str_AgentCd,str_SubAgentCd,str_o_ErrNo];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            if ([responce[@"DtData"] count]  != 0) {
                subEArnarray= [[NSMutableArray alloc]init];
                if (subEArnarray.count == 0) {
                    subEArnarray = responce[@"DtData"];
                    tf_EuinNo.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                    
                    if ([btn_YesEun.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]) {
                        [tf_EuinNo becomeFirstResponder];
                        
                    }
                }
                subEArnarray = responce[@"DtData"];
            }
            else{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Please  Check ARN code"];
            }
            
            NSLog(@"%@",subEArnarray);
            
            
        }
        else{
            
            tf_ArnCode.text =@"ARN-";
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)validateSubARNAPI{
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    // NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_o_ErrNo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_SubARN.text];
    
    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_ArnCode.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@ValidateBrokercode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&AgentCd=%@&SubAgentCd=%@o_ErrNo&=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,Str_AgentCd,str_SubAgentCd,str_o_ErrNo];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            if ([responce[@"DtData"] count]  != 0) {
                subEArnarray= [[NSMutableArray alloc]init];
                if (subEArnarray.count == 0) {
                    subEArnarray = responce[@"DtData"];
                    tf_EuinNo.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                    
                    if ([btn_YesEun.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]) {
                        [tf_EuinNo becomeFirstResponder];
                        
                    }
                }
                subEArnarray = responce[@"DtData"];
            }
            else{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@" Please  Check ARN code"];
            }
            
            NSLog(@"%@",subEArnarray);
            
            
        }
        else{
            
            tf_SubARN.text =@"ARN-";
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)Submit{
    
    //    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    //    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    //    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    //    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    //    // NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    //    NSString *str_o_ErrNo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    //    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_SubARN.text];
    //
    //    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_ArnCode.text];
    //
    
    //    intent.putExtra("IMEI", enc_IMEI);
    //    intent.putExtra("appVer", enc_OS);
    //    intent.putExtra("os", enc_AppVer);
    //    intent.putExtra("Desc", enc_Desc);
    //    intent.putExtra("bankId", bankId);
    //    intent.putExtra("str_fundCode", str_fundCode);
    //    intent.putExtra("str_fundName", str_fund);
    //    intent.putExtra("str_folio", str_folio);
    //    intent.putExtra("investflag", investflag);
    //    intent.putExtra("str_InschemeDesc", str_Inscheme);
    //    intent.putExtra("i_Tscheme", str_InschemeCode);
    //    intent.putExtra("i_Tplan", str_Inplan);
    //    intent.putExtra("i_Toption", str_Inoption);
    //    intent.putExtra("str_OutschemeDesc", str_scheme);
    //    intent.putExtra("str_schemeCode", str_schemeCode);
    //    intent.putExtra("str_plan", str_plan);
    //    intent.putExtra("str_option", str_option);
    //    intent.putExtra("str_arnCode", str_arnCode);
    //    intent.putExtra("str_subArnCode", str_subArnCode);
    //    intent.putExtra("str_amount", str_amount);
    //    intent.putExtra("str_euinflag", str_euinflag);
    //    intent.putExtra("str_euinNo", str_euinNo);
    //    intent.putExtra("userId", userId);
    //    intent.putExtra("usermail", usermail);
    //    intent.putExtra("mobileNumber", str_mobileNumber);
    //    intent.putExtra("redTypeKey", str_redType);
    //    intent.putExtra("ttrtype", ttrtype);
    //    intent.putExtra("panNo", str_PrimaryPAN);
    //    intent.putExtra("fromFamily", familyTransact);
    //
    //
    //    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    //    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    //    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    //    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    //    // NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    //    NSString *str_o_ErrNo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    //    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_SubARN.text];
    //
    //    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:tf_ArnCode.text];
    //    NSString *str_url = [NSString stringWithFormat:@"%@ValidateBrokercode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&AgentCd=%@&SubAgentCd=%@o_ErrNo&=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,Str_AgentCd,str_SubAgentCd,str_o_ErrNo];
}


@end
