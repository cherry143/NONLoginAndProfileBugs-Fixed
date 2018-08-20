//
//  AddPurchaseFamilyVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 04/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "AddPurchaseFamilyVC.h"

@interface AddPurchaseFamilyVC ()<UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>{
    
    __weak IBOutlet UITextField *txt_family;
    __weak IBOutlet UITextField *txt_paymentBank;
    __weak IBOutlet UITextField *txt_paymentMode;
    __weak IBOutlet UITextField *txt_amount;
    __weak IBOutlet UITextField *txt_EUINNo;
    __weak IBOutlet UITextField *txt_SubARN;
    __weak IBOutlet UITextField *txt_broker;
    __weak IBOutlet UITextField *txt_Arn;
    __weak IBOutlet UITextField *txt_Scheme;
    __weak IBOutlet UITextField *txt_fund;
    __weak IBOutlet UITextField *txt_Folio;
    __weak IBOutlet UITextField *txt_Category;
    
    
    
    __weak IBOutlet UIButton *btn_ExistingScheme;
    __weak IBOutlet UIButton *btn_NewScheme;
    __weak IBOutlet UIButton *btn_Distributor;
    __weak IBOutlet UIButton *btn_Direct;
    __weak IBOutlet UIButton *Btn_EuinNo;
    __weak IBOutlet UIButton *Btn_EuinYes;
    __weak IBOutlet UIButton *btn_submit;
    
    __weak IBOutlet UIView *view_subca;

    __weak IBOutlet UIView *view_fund;
    __weak IBOutlet UIView *view_Category;
    
    __weak IBOutlet UILabel *lbl_miniAmount;
    __weak IBOutlet UIView *view_payment;
    __weak IBOutlet UIView *view_scheme;
    __weak IBOutlet UIView *view_arnCode;
    __weak IBOutlet UIView *view_Euin;
    
    
    UIPickerView *picker_dropDown;
    UITextField *txt_currentTextField;
    
    ///// height constant
    
    
    __weak IBOutlet NSLayoutConstraint *cont_Schemehieht;// 70
    __weak IBOutlet NSLayoutConstraint *cont_EuinHieght;  //62
    __weak IBOutlet NSLayoutConstraint *cont_AnrHeight;  //  254
    __weak IBOutlet NSLayoutConstraint *cont_categoryHieght; //120
    __weak IBOutlet UIScrollView *scrollView;
    
    
    // Array
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
    
    NSString *str_referId;
}

@end

@implementation AddPurchaseFamilyVC



- (void)viewDidLoad {
    [super viewDidLoad];
    [self addElements];
    newSchemmeDic  =[NSMutableDictionary new];
    [newSchemmeDic mutableCopy];
    
    
    // Do any additional setup after loading the view.
}
-(void)addElements{
    
    if ([self.str_fromScreen isEqualToString:@"details"]) {
        selectedPan=_selected_Rec.PAN;
        
        NSArray *pan= [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE  PAN ='%@'",selectedPan]];
        if(pan.count == 1)
        {
            
            KT_TABLE12 *rec_fund=pan[0];
            txt_family.text=[NSString stringWithFormat:@"%@",rec_fund.invName];
            selectedPan=[NSString stringWithFormat:@"%@",rec_fund.PAN];
            
        }
        txt_fund.text=[NSString stringWithFormat:@"%@",_selected_Rec.fundDesc];
        str_selectedFundID =  [NSString stringWithFormat:@"%@",_selected_Rec.fund];
        
        txt_Folio.text = [NSString stringWithFormat:@"%@",_selected_Rec.Acno];
        selectedfolio  = [NSString stringWithFormat:@"%@",_selected_Rec.Acno];
        txt_Scheme.text =[NSString stringWithFormat:@"%@",_selected_Rec.schDesc];

        schemmeDic= _selected_Rec;;
        
        txt_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
        selectedSecheme=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
        
        miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
        lbl_miniAmount.text =[NSString stringWithFormat:@"Minimum Amount (%@)",miniAmount];;
        str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
        str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
        str_option =[NSString stringWithFormat:@"%@",schemmeDic.opt];
        str_driect =[NSString stringWithFormat:@"%@",schemmeDic.schType];
        
        picker_dropDown=[[UIPickerView alloc]init];
        picker_dropDown.delegate=self;
        picker_dropDown.dataSource=self;
        picker_dropDown.backgroundColor=[UIColor whiteColor];
        txt_Folio.userInteractionEnabled = NO;
             txt_family.userInteractionEnabled = NO;
        txt_fund.userInteractionEnabled = NO;
        txt_Scheme.userInteractionEnabled = NO;
    }
    else{
        
        PanDetials = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE Not flag='P' "]];
       
        if(PanDetials.count == 1)
        {
            
            KT_TABLE12 *rec_fund=PanDetials[0];
            txt_family.text=[NSString stringWithFormat:@"%@",rec_fund.invName];
            selectedPan=[NSString stringWithFormat:@"%@",rec_fund.PAN];
            
        }
        fundDetails = [[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT distinct fundDesc,fund FROM TABLE2_DETAILS where PAN='%@' and pFlag='Y'  order By FundDesc",selectedPan]];
        NSLog(@"%@",fundDetails);
        picker_dropDown=[[UIPickerView alloc]init];
        picker_dropDown.delegate=self;
        picker_dropDown.dataSource=self;
        picker_dropDown.backgroundColor=[UIColor whiteColor];
        txt_family.inputView=picker_dropDown;
               [picker_dropDown reloadAllComponents];
        
    }
    txt_family.delegate  = self;

    txt_paymentBank.delegate  = self;
    txt_paymentMode.delegate  = self;
    txt_amount.delegate  = self;
    txt_EUINNo.delegate  = self;
    txt_SubARN.delegate  = self;
    txt_broker.delegate  = self;
    txt_Arn.delegate  = self;
    txt_Scheme.delegate  = self;
    txt_fund.delegate  = self;
    txt_Folio.delegate  = self;
    txt_Category.delegate  = self;
    txt_amount.delegate  = self;
    
    txt_Arn.text =@"ARN-";
    txt_SubARN.text =@"ARN-";
    [view_subca setHidden:YES];
    [view_Category setHidden:YES];
    [view_arnCode setHidden:YES];
    [view_Euin setHidden:YES];
    
    [UITextField withoutRoundedCornerTextField:txt_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_Folio forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_Scheme forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_Category forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_EUINNo forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_paymentBank forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_family forCornerRadius:5.0f forBorderWidth:1.5f];

    [UITextField withoutRoundedCornerTextField:txt_paymentMode forCornerRadius:5.0f forBorderWidth:1.5f];
    [btn_submit.layer setCornerRadius:15.0f];
    [btn_submit.layer setMasksToBounds:YES];
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    scrollView.delegate =self;
    [self.view layoutIfNeeded];
}

-(void)viewDidAppear:(BOOL)animated{
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width,view_payment.frame.origin.y +view_payment.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)atc_existing:(id)sender {
    
    
    if ([self.str_fromScreen isEqualToString:@"details"]) {
        [self addElements];
        [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
        [btn_NewScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        
    }else{
        txt_Scheme.userInteractionEnabled = YES;
        [view_subca setHidden:YES];
        [view_Category setHidden:YES];
        [view_arnCode setHidden:YES];
        [view_Euin setHidden:YES];
        [self.view layoutIfNeeded];
        txt_Scheme.userInteractionEnabled = YES;
        [self.view updateConstraints];
        [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
        [btn_NewScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    }


    
}
- (IBAction)atc_submi:(id)sender {
    
    if ([btn_ExistingScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]){
        
        if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
            
            if ([str_selectedFundID length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund"];
            }
            else if ([selectedfolio length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio"];
            }
            else if ([selectedSecheme length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Secheme"];
            }
            else if ( [txt_Arn.text   isEqualToString:@"ARN-" ]){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter ARN  Code"];
                
            }
            else if ( [txt_Arn.text   isEqualToString:txt_SubARN.text] ){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"  ARN  Code  and  sub ARN code  Should not be Same "];
                
            }
            else  if ([Btn_EuinNo.imageView.image isEqual:[UIImage imageNamed:@"radio-on"]]) {
                if ([txt_EUINNo.text length] == 0){
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the EUIN No"];
                    
                }
                else if ([txt_amount.text length] == 0){
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount"];
                    
                }else{
                    
                    int miniAmountvalue = [miniAmount intValue];
                    
                    if (miniAmountvalue > [txt_amount.text intValue ] ) {
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount greater than Minimum Amount"];
                        
                    }else{
                        [self purchaseurl];
                        
                        NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                        NSLog(@"fund  %@",schemmeDic);
                        
                    }
                }
                
            }else{
                if ([txt_amount.text length] == 0){
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount"];
                    
                }else{
                    
                    int miniAmountvalue = [miniAmount intValue];
                    
                    if (miniAmountvalue > [txt_amount.text intValue ] ) {
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount greater than Minimum Amount"];
                        
                    }else{
                        [self purchaseurl];
                        
                        NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                        NSLog(@"fund  %@",schemmeDic);
                        
                    }
                }
            }
        }
        else{
            if ([str_selectedFundID length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund"];
            }
            else if ([selectedfolio length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio"];
            }
            else if ([selectedSecheme length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Secheme"];
            }
            
            else if ([txt_amount.text length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount"];
                
            }else{
                
                int miniAmountvalue = [miniAmount intValue];
                
                
                if (miniAmountvalue > [txt_amount.text intValue ] ) {
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount greater than Minimum Amount"];
                    
                }else{
                    [self purchaseurl];
                    
                    NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                    NSLog(@"fund  %@",schemmeDic);
                    
                }
            }
        }
        
        
        
    }else if ([btn_NewScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]])
    {
        if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
            
            if ([str_selectedFundID length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund"];
            }
            else if ([selectedfolio length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio"];
            }
            else if ([txt_Category.text length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Category"];
            }
            else if ([selectedSecheme length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Secheme"];
            }
            else if ( [txt_Arn.text   isEqualToString:@"ARN-" ]){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter ARN  Code"];
                
            }
            else if ( [txt_Arn.text   isEqualToString:txt_SubARN.text] ){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"  ARN  Code  and  sub ARN code  Should not be Same "];
                
            }
            else  if ([Btn_EuinNo.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                if ([txt_EUINNo.text length] == 0){
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the EUIN No"];
                    
                }
                
                
                else if ([txt_amount.text length] == 0){
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount"];
                    
                }else{
                    
                    int miniAmountvalue = [miniAmount intValue];
                    
                    if (miniAmountvalue > [txt_amount.text intValue ] ) {
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount greater than Minimum Amount"];
                        
                    }else{
                        [self purchaseurl];
                        
                        NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                        NSLog(@"fund  %@",schemmeDic);
                        
                    }
                }
                
            }else{
                if ([txt_amount.text length] == 0){
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount"];
                    
                }else{
                    
                    int miniAmountvalue = [miniAmount intValue];
                    
                    if (miniAmountvalue > [txt_amount.text intValue ] ) {
                        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount greater than Minimum Amount"];
                        
                    }else{
                        [self purchaseurl];
                        
                        NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                        NSLog(@"fund  %@",schemmeDic);
                        
                    }
                }
            }
        }
        
        else{
            if ([str_selectedFundID length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund"];
            }
            else if ([selectedfolio length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio"];
            }
            else if ([txt_Category.text length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Category"];
            }
            else if ([selectedSecheme length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Secheme"];
            }
            
            else if ([txt_amount.text length] == 0){
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount"];
                
            }else{
                
                int miniAmountvalue = [miniAmount intValue];
                
                if (miniAmountvalue > [txt_amount.text intValue ] ) {
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount greater than Minimum Amount"];
                    
                }else{
                    [self purchaseurl];
                    
                    NSLog(@"fund  %@ folio %@  SelectSeheme %@ pan %@  %@ %@ %@  %@  ",str_selectedFundID,selectedfolio,selectedSecheme,selectedPan,str_PaymentBank,txt_amount.text,str_Category, str_EuinNo);
                    NSLog(@"fund  %@",schemmeDic);
                    
                }
            }
        }
        
        
        
        
    }
    
}



- (IBAction)atc_NewScheme:(id)sender {
    existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and pSchFlg='Y'",str_selectedFundID,selectedfolio]];
    txt_Scheme.userInteractionEnabled = YES;
     txt_Scheme.userInteractionEnabled = YES;
    [view_arnCode setHidden:YES];
    [view_Euin setHidden:YES];
    [view_subca setHidden:NO];
    [view_Category setHidden:NO];
    
     txt_Scheme.userInteractionEnabled = YES;
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
    [btn_NewScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_Direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_Distributor setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    txt_Scheme.text= nil;
    txt_paymentBank.text = nil;
    txt_Scheme.text= nil;
    selectedSecheme= nil;
    
    miniAmount= nil;
    txt_amount.text= nil;
    lbl_miniAmount.text =[NSString stringWithFormat:@"Minimum Amount "];
    
    
}

- (IBAction)atc_Distributor:(id)sender {
    str_driect =@"Regular";
    
    txt_Scheme.text =nil;

    [view_arnCode setHidden:NO];
    [view_subca setHidden:NO];
    [view_Category setHidden:NO];
    [view_Euin setHidden:NO];
    
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
    [btn_NewScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_Direct setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_Distributor setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [Btn_EuinNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [Btn_EuinYes setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [self newSchmemListApi];
}

- (IBAction)atc_Direct:(id)sender {
    
    str_driect =@"Driect";
    
    [view_arnCode setHidden:NO];
    [view_Euin setHidden:NO];
    [view_subca setHidden:NO];
    [view_Category setHidden:YES];
    txt_Scheme.text =nil;

    cont_AnrHeight.constant = 0;
    cont_EuinHieght.constant = 0;
    cont_categoryHieght.constant = 120;
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
    [btn_NewScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [btn_Direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [btn_Distributor setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [Btn_EuinNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [Btn_EuinYes setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    
    [self newSchmemListApi];
    
}
- (IBAction)atc_YesEuin:(id)sender {
    
    [view_Euin setHidden:YES];
    cont_categoryHieght.constant = 120;
    cont_AnrHeight.constant = 254;
    cont_EuinHieght.constant = 0;
    txt_EUINNo.text =nil;

    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
    
    [Btn_EuinNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [Btn_EuinYes setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    subEArnarray  = [[NSArray alloc]init];
    
    
    //    txt_Arn.text =@"ARN-";
    //    txt_SubARN.text =@"ARN-";
    //    txt_broker.text =nil;
    
    
}

- (IBAction)back:(id)sender {
    
    KTPOP(YES);
}

- (IBAction)atc_NoEUIN:(id)sender {
    [Btn_EuinNo setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
    [Btn_EuinYes setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    [view_Euin setHidden:NO];
    //    txt_Arn.text =@"ARN-";
    //    txt_SubARN.text =@"ARN-";
    //    txt_broker.text =nil;
    subEArnarray  = [[NSArray alloc]init];
    
    txt_EUINNo.text =nil;

    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
    
  
    //    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)]];
    
    
}






//-(void)backgroundTap:(UITapGestureRecognizer *)tapGR{
//    END_EDITING;
//}
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

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTextField=textField;
        if (textField==txt_family) {
            [picker_dropDown reloadAllComponents];
            [textField becomeFirstResponder];
        }
        else if (textField==txt_fund) {
            if ([txt_family.text length] == 0 ) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Family Memeber "];
                [txt_family becomeFirstResponder];
    
            }else{
    
                fundDetails = [[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT distinct fundDesc,fund FROM TABLE2_DETAILS where PAN='%@' and pFlag='Y'  order By FundDesc",selectedPan]];
                NSLog(@"%@",fundDetails);
                txt_fund.inputView=picker_dropDown;
    
                [picker_dropDown reloadAllComponents];
                [textField becomeFirstResponder];
    
    
            }
        }
    else if (textField==txt_Folio) {
        
        if ([txt_fund.text length] == 0 ) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund"];
            [txt_fund becomeFirstResponder];
            
        }
        else{
            
            
            
            folioArray = [[DBManager sharedDataManagerInstance]uniqueFolioFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (Acno), notallowed_flag FROM TABLE2_DETAILS where fund ='%@' and PAN='%@'",str_selectedFundID,selectedPan]];
            if (folioArray.count == 1) {
                KT_TABLE2 *rec_fund=folioArray[0];
                NSLog(@"%@",rec_fund.notallowed_flag);
                txt_Folio.text=[NSString stringWithFormat:@"%@",rec_fund.Acno];
                selectedfolio =[NSString stringWithFormat:@"%@",rec_fund.Acno];
                txt_Folio.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
                
            }else{
                [txt_currentTextField becomeFirstResponder];
                txt_Folio.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
            }
            
        }
        
    }
    
    else if (textField==txt_Category) {
        
        
        if ([str_folioDmart isEqualToString:@"D"]  ) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Demat folio is not eligible for purchase"];
            txt_Scheme.inputView = picker_dropDown;
            [picker_dropDown reloadAllComponents];
            [txt_Category becomeFirstResponder];
            
            
        } else if ( [str_folioDmart isEqualToString:@"J"]){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Join folio is not eligible for purchase"];
            txt_Scheme.inputView = picker_dropDown;
            [picker_dropDown reloadAllComponents];
            [txt_Category becomeFirstResponder];
            
            
        }else{
            
            if ([txt_Folio.text length] == 0){
                
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio"];
                
            }else{
                if (categoryArr.count == 0) {
                    
                    [self  categoryListApi];
                    [txt_Category resignFirstResponder];
                    txt_Category.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                    
                }else{
                    [self  categoryListApi];
                    [txt_Category becomeFirstResponder];
                    txt_Category.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                }
            }
            
            
        }
        
    }
    else if (textField==txt_Scheme) {
        
        
        if ([str_folioDmart isEqualToString:@"D"]  ) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Demat folio is not eligible for purchase"];
            txt_Scheme.inputView = picker_dropDown;
            [picker_dropDown reloadAllComponents];
            [txt_Scheme becomeFirstResponder];
            
            
        } else if ( [str_folioDmart isEqualToString:@"J"]){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Join folio is not eligible for purchase"];
            txt_Scheme.inputView = picker_dropDown;
            [picker_dropDown reloadAllComponents];
            [txt_Scheme becomeFirstResponder];
            
            
        }
        else{
            
            if ([btn_ExistingScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
                
                
                if ([txt_Category.text length] == 0){
                    [txt_Scheme resignFirstResponder];
                    
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Category"];
                    
                }else{
                    
                    if (newschemeArr.count == 0) {
                        [self  newSchmemListApi];
                        [txt_Scheme resignFirstResponder];
                        txt_Scheme.inputView = picker_dropDown;
                        [picker_dropDown reloadAllComponents];
                        
                    }
                    else{
                        [txt_Scheme becomeFirstResponder];
                        txt_Scheme.inputView = picker_dropDown;
                        [picker_dropDown reloadAllComponents];
                        
                        
                    }
                    
                    
                }
            }
            else{
                
                
                if ([txt_Folio.text length] == 0){
                    [txt_Scheme resignFirstResponder];
                    
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio"];
                    
                }else{
                    
                    existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and pSchFlg='Y'",str_selectedFundID,selectedfolio]];
                    if (existingArr.count == 1) {
                        
                        KT_TABLE2 *rec_fund=existingArr[0];
                        txt_Scheme.text=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                        miniAmount=[NSString stringWithFormat:@"%@",rec_fund.minAmt];
                        selectedSecheme =[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                        lbl_miniAmount.text =[NSString stringWithFormat:@"Minimum Amount (%@)",miniAmount];;
                        str_iScheme =[NSString stringWithFormat:@"%@",rec_fund.sch];;
                        str_option =[NSString stringWithFormat:@"%@",rec_fund.opt];;
                        str_driect =[NSString stringWithFormat:@"%@",rec_fund.schType];
                        
                        str_plan =[NSString stringWithFormat:@"%@",rec_fund.pln];;
                        txt_Scheme.inputView = picker_dropDown;
                        [picker_dropDown reloadAllComponents];
                    }else{
                        [txt_Scheme becomeFirstResponder];
                        txt_Scheme.inputView = picker_dropDown;
                        [picker_dropDown reloadAllComponents];
                    }
                }
            }
        }
    }
    
    else if (textField==txt_EUINNo) {
        
        if ([txt_Arn.text   isEqualToString:@"ARN-" ]) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the ARN-"];
            [txt_EUINNo becomeFirstResponder];
            
        }else{
            if (subEArnarray.count == 0) {
                [txt_EUINNo resignFirstResponder];
                [self  validateARNAPI];
                
            }else{
                // [self  categoryListApi];
                
                if (subEArnarray.count == 1) {
                    
                    NSDictionary *rec_fund=subEArnarray[0];
                    
                    NSLog(@"%@",rec_fund[@"abm_agent"]);
                    
                    txt_EUINNo.text=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
                    str_EuinNo =[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
                    [txt_EUINNo becomeFirstResponder];
                    txt_EUINNo.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                }else{
                    [txt_EUINNo becomeFirstResponder];
                    txt_EUINNo.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                }
            }
        }
        
    }
    
    
    //    else if (textField==txt_paymentBank) {
    //        paymentBantArr = [[DBManager sharedDataManagerInstance]FetchAllRecordFromTable8:[NSString stringWithFormat:@"SELECT * FROM TABLE8_BANKACCOUNT  where fund='%@' and foliono ='%@'",str_selectedFundID,selectedfolio]];
    //        if (paymentBantArr.count == 1) {
    //
    //            KT_TABLE8*rec_fund=paymentBantArr[0];
    //            txt_paymentBank.text=[NSString stringWithFormat:@"%@",rec_fund.bnkname];
    //         str_PaymentBank=[NSString stringWithFormat:@"%@",rec_fund.bnkname];
    //            [txt_paymentBank becomeFirstResponder];
    //            txt_paymentBank.inputView = picker_dropDown;
    //            [picker_dropDown reloadAllComponents];
    //        }else{
    //            [txt_paymentBank becomeFirstResponder];
    //            txt_paymentBank.inputView = picker_dropDown;
    //            [picker_dropDown reloadAllComponents];
    //        }
    //
    //    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [txt_currentTextField resignFirstResponder];
    
    if (textField==txt_Arn ) {
        
        if ([txt_Arn.text isEqualToString:@"ARN-"]) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the ARN- Code "];
        } else {
            txt_broker.text=nil;
            txt_SubARN.text =@"ARN-";
            [self atc_YesEuin:nil];
            [self validateARNAPI];
            
        }
    }
    if (textField==txt_SubARN ) {
      
        [view_Euin setHidden:YES];
        [self validateSubARNAPI];
        
        
    }
    
    else if (textField==txt_amount) {
        int miniAmountvalue = [miniAmount intValue];
        
        if (miniAmountvalue > [txt_amount.text intValue ] ) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please enter the amount greater than Minimum Amount"];
            [txt_amount becomeFirstResponder];
        }
        
    }
    
    else if (textField==txt_Folio) {
        
        if ([str_folioDmart isEqualToString:@"D"]  ) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Demat folio is not eligible for purchase"];
            txt_Scheme.inputView = picker_dropDown;
            [picker_dropDown reloadAllComponents];
            [txt_Folio becomeFirstResponder];
        } else if ( [str_folioDmart isEqualToString:@"J"]){
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Join folio is not eligible for purchase"];
            txt_Scheme.inputView = picker_dropDown;
            [picker_dropDown reloadAllComponents];
            [txt_Folio becomeFirstResponder];
            
            
        }
    }
    else if (textField==txt_fund) {
        [txt_fund resignFirstResponder];
        
        //modified by badari
        
        //modified by badari
        
        
    } else if (textField==txt_Folio) {
        
        [txt_Folio resignFirstResponder];
        
        
    }
    else if (textField==txt_Scheme) {
        
        if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
            if ([btn_NewScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                [view_subca setHidden:NO];
                [view_Category setHidden:NO];
                [view_arnCode setHidden:NO];
                [view_Euin setHidden:YES];
                [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                [btn_NewScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_Direct setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_Distributor setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
            }else{
                [view_subca setHidden:YES];
                [view_Category setHidden:YES];
                [view_arnCode setHidden:NO];
                [view_Euin setHidden:YES];
                [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                [btn_NewScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_Direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_Distributor setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
            }
            
            
            
            
        }else{
            
            
            if ([btn_NewScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                [view_subca setHidden:NO];
                [view_Category setHidden:NO];
                [view_arnCode setHidden:YES];
                [view_Euin setHidden:YES];
                [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                [btn_NewScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_Direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_Distributor setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
            }else{
                [view_subca setHidden:YES];
                [view_Category setHidden:YES];
                [view_arnCode setHidden:YES];
                [view_Euin setHidden:YES];
                [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                [btn_NewScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_Direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                [btn_Distributor setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
            }
            
            
        }
        
    }
    
    
}
// copy paste
// if implemented, called in place of textFieldDidEndEditing:



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

#pragma mark - TouchEvents

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    END_EDITING;
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - scrollView Content Increase Method

-(void)scrollContentHeightIncrease:(CGFloat)height{
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width,height);
}


#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    long int newcount = 0;
    
    if (txt_currentTextField==txt_family) {
                newcount= PanDetials.count;
            }
    if (txt_currentTextField==txt_fund) {
        newcount= fundDetails.count;
    }
    if (txt_currentTextField==txt_Folio) {
        newcount= folioArray.count;
    }
    
    if (txt_currentTextField==txt_Scheme) {
        
        if ([btn_ExistingScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
            
            newcount= newschemeArr.count;
        }else{
            newcount= existingArr.count;
        }
        
        
    }
    if (txt_currentTextField==txt_paymentBank) {
        newcount= paymentBantArr.count;
    }
    if (txt_currentTextField==txt_Category) {
        newcount= categoryArr.count;
    }
    
    if (txt_currentTextField==txt_EUINNo) {
        newcount= subEArnarray.count;
    }
    return newcount;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str_title;
    if (txt_currentTextField==txt_family) {
                KT_TABLE12 *rec_fund=PanDetials[row];
                str_title=[NSString stringWithFormat:@"%@",rec_fund.invName];
            }
    if (txt_currentTextField==txt_fund) {
        KT_Table2RawQuery *rec_fund=fundDetails[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund.fundDesc];
    }
    if (txt_currentTextField==txt_Folio) {
        KT_TABLE2 *rec_fund=folioArray[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund.Acno];
    }
    if (txt_currentTextField==txt_Scheme) {
        
        if ([btn_ExistingScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
            
            NSDictionary *rec_fund=newschemeArr[row];
            str_title=[NSString stringWithFormat:@"%@",rec_fund[@"fm_schdesc"]];
        }else{
            KT_TABLE2 *rec_fund=existingArr[row];
            str_title=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
        }
        
    }
    if (txt_currentTextField==txt_paymentBank) {
        KT_TABLE8 *rec_fund=paymentBantArr[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund.bnkname];
    }
    if (txt_currentTextField==txt_Category) {
        NSDictionary  *rec_fund=categoryArr[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];
    }
    if (txt_currentTextField==txt_EUINNo) {
        NSDictionary *rec_fund=subEArnarray[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
    }
    
    return str_title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    
        if (txt_currentTextField==txt_family) {
            KT_TABLE12 *rec_fund=PanDetials[row];
            txt_family.text=[NSString stringWithFormat:@"%@",rec_fund.invName];
    
            txt_Folio.text=nil;
            txt_amount .text = nil;
            txt_paymentBank .text = nil;
            txt_paymentMode .text = nil;
            selectedfolio =nil;
            categoryArr   =[[NSMutableArray alloc]init];
            newschemeArr =[[NSMutableArray alloc]init];
            txt_Scheme.text  =nil;
            txt_Category.text  =nil;
            selectedSecheme =nil;
            str_Category  =nil;
            txt_broker.text=nil;
            txt_Arn.text =@"ARN-";
            txt_SubARN.text =@"ARN-";
            [Btn_EuinNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
            [Btn_EuinYes setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
             [view_Euin setHidden:YES];
            selectedPan=[NSString stringWithFormat:@"%@",rec_fund.PAN];
        }
    if (txt_currentTextField==txt_fund) {
        KT_Table2RawQuery *rec_fund=fundDetails[row];
        txt_fund.text=[NSString stringWithFormat:@"%@",rec_fund.fundDesc];
        NSLog(@"folioarr is %lu",folioArray.count);
        txt_Folio.text=nil;
        txt_amount .text = nil;
        txt_paymentBank .text = nil;
        txt_paymentMode .text = nil;
        selectedfolio =nil;
        categoryArr   =[[NSMutableArray alloc]init];
        newschemeArr =[[NSMutableArray alloc]init];
        txt_Scheme.text  =nil;
        txt_Category.text  =nil;
        selectedSecheme =nil;
        str_Category  =nil;
        txt_broker.text=nil;
        txt_Arn.text =@"ARN-";
        txt_SubARN.text =@"ARN-";
        [Btn_EuinNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        [Btn_EuinYes setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [view_Euin setHidden:YES];
        str_selectedFundID=[NSString stringWithFormat:@"%@",rec_fund.fund];
        
        folioArray = [[DBManager sharedDataManagerInstance]uniqueFolioFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (Acno), notallowed_flag FROM TABLE2_DETAILS where fund ='%@' and PAN='%@'",str_selectedFundID,selectedPan]];
        if (folioArray.count == 1) {
            KT_TABLE2 *rec_fund=folioArray[0];
            NSLog(@"%@",rec_fund.notallowed_flag);
            txt_Folio.text=[NSString stringWithFormat:@"%@",rec_fund.Acno];
            selectedfolio =[NSString stringWithFormat:@"%@",rec_fund.Acno];
            [txt_Folio setUserInteractionEnabled:NO];
            if ([btn_ExistingScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
            }
            else{
                existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and pSchFlg='Y'",str_selectedFundID,selectedfolio]];
                if (existingArr.count == 1) {
                    KT_TABLE2 *rec_fund=existingArr[0];
                    txt_Scheme.text=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                    miniAmount=[NSString stringWithFormat:@"%@",rec_fund.minAmt];
                    selectedSecheme =[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                    lbl_miniAmount.text =[NSString stringWithFormat:@"Minimum Amount (%@)",miniAmount];;
                    str_iScheme =[NSString stringWithFormat:@"%@",rec_fund.sch];;
                    str_option =[NSString stringWithFormat:@"%@",rec_fund.opt];;
                    str_driect =[NSString stringWithFormat:@"%@",rec_fund.schType];
                    str_plan =[NSString stringWithFormat:@"%@",rec_fund.pln];;
                    
                    if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
                        if ([btn_NewScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                            [view_subca setHidden:NO];
                            [view_Category setHidden:NO];
                            [view_arnCode setHidden:NO];
                            [view_Euin setHidden:YES];
                            [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                            [btn_NewScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            [btn_Direct setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            [btn_Distributor setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                        }else{
                            [view_subca setHidden:YES];
                            [view_Category setHidden:YES];
                            [view_arnCode setHidden:NO];
                            [view_Euin setHidden:YES];
                            [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                            [btn_NewScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_Direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_Distributor setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        }
                        
                        
                        
                        
                    }else{
                        
                        
                        if ([btn_NewScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                            [view_subca setHidden:NO];
                            [view_Category setHidden:NO];
                            [view_arnCode setHidden:YES];
                            [view_Euin setHidden:YES];
                            [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                            [btn_NewScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            [btn_Direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_Distributor setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        }else{
                            [view_subca setHidden:YES];
                            [view_Category setHidden:YES];
                            [view_arnCode setHidden:YES];
                            [view_Euin setHidden:YES];
                            [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                            [btn_NewScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                            [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_Direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                            [btn_Distributor setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        }
                        
                        
                    }
                    
                  //  [txt_Scheme setUserInteractionEnabled:NO];
                    
                }else{
                    [txt_Scheme setUserInteractionEnabled:YES];
                    txt_Scheme.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                }
            }
            
        }else{
            [txt_Folio setUserInteractionEnabled:YES];
            [txt_Scheme setUserInteractionEnabled:YES];
          
            txt_Folio.inputView = picker_dropDown;
            [picker_dropDown reloadAllComponents];
        }
        
        //To autofill Schemes for one value
        
        
        
        
        //To autofill schemes for one value
        
    }
    if (txt_currentTextField==txt_Folio) {
        KT_TABLE2 *rec_fund=folioArray[row];
        categoryArr   =[[NSMutableArray alloc]init];
        newschemeArr =[[NSMutableArray alloc]init];
        txt_Scheme.text  =nil;
        txt_Category.text  =nil;
        selectedSecheme =nil;
        str_Category  =nil;
        txt_broker.text=nil;
        txt_Arn.text =@"ARN-";
        txt_SubARN.text =@"ARN-";
        [Btn_EuinNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        [Btn_EuinYes setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [view_Euin setHidden:YES];
        txt_Folio.text=[NSString stringWithFormat:@"%@",rec_fund.Acno];
        selectedfolio=[NSString stringWithFormat:@"%@",rec_fund.Acno];
        str_folioDmart=[NSString stringWithFormat:@"%@",rec_fund.notallowed_flag];
        str_iScheme =[NSString stringWithFormat:@"Minimum Amount (%@)",rec_fund.sch];;
        
        str_plan =[NSString stringWithFormat:@"Minimum Amount (%@)",rec_fund.pln];;
        
        NSLog(@"%@",rec_fund.notallowed_flag);
        if ([btn_ExistingScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
        }
        else{
            existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and pSchFlg='Y'",str_selectedFundID,selectedfolio]];
            if (existingArr.count == 1) {
                KT_TABLE2 *rec_fund=existingArr[0];
                txt_Scheme.text=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                miniAmount=[NSString stringWithFormat:@"%@",rec_fund.minAmt];
                selectedSecheme =[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                lbl_miniAmount.text =[NSString stringWithFormat:@"Minimum Amount (%@)",miniAmount];;
                str_iScheme =[NSString stringWithFormat:@"%@",rec_fund.sch];;
                str_option =[NSString stringWithFormat:@"%@",rec_fund.opt];;
                str_driect =[NSString stringWithFormat:@"%@",rec_fund.schType];
                str_plan =[NSString stringWithFormat:@"%@",rec_fund.pln];;
                if ([str_driect  isEqualToString:@"Regular"] || [str_driect  isEqualToString:@"REGULAR"]){
                    if ([btn_NewScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                        [view_subca setHidden:NO];
                        [view_Category setHidden:NO];
                        [view_arnCode setHidden:NO];
                        [view_Euin setHidden:YES];
                        [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                        [btn_NewScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                        [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        [btn_Direct setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        [btn_Distributor setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                    }else{
                        [view_subca setHidden:YES];
                        [view_Category setHidden:YES];
                        [view_arnCode setHidden:NO];
                        [view_Euin setHidden:YES];
                        [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                        [btn_NewScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                        [btn_Direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                        [btn_Distributor setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                    }
                    
                    
                    
                    
                }else{
                    
                    
                    if ([btn_NewScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]) {
                        [view_subca setHidden:NO];
                        [view_Category setHidden:NO];
                        [view_arnCode setHidden:YES];
                        [view_Euin setHidden:YES];
                        [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                        [btn_NewScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                        [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        [btn_Direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                        [btn_Distributor setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                    }else{
                        [view_subca setHidden:YES];
                        [view_Category setHidden:YES];
                        [view_arnCode setHidden:YES];
                        [view_Euin setHidden:YES];
                        [self scrollContentHeightIncrease:view_payment.frame.origin.y +view_payment.frame.size.height];
                        [btn_NewScheme setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        [btn_ExistingScheme setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                        [btn_Direct setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
                        [btn_Distributor setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                    }
                    
                    
                }
                
               // [txt_Scheme setUserInteractionEnabled:NO];
                
            }else{
                [txt_Scheme setUserInteractionEnabled:YES];
                txt_Scheme.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
            }
        }
        
        
        
        
    }
    if (txt_currentTextField==txt_Scheme) {
        txt_broker.text=nil;
        txt_Arn.text =@"ARN-";
        txt_SubARN.text =@"ARN-";
        [view_Euin setHidden:YES];
        [Btn_EuinNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        [Btn_EuinYes setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        if ([btn_ExistingScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
            newSchemmeDic=newschemeArr[row];
            
            txt_Scheme.text=[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_schdesc"]];
            selectedSecheme=[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_schdesc"]];
            miniAmount=[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_newpur"]];
            lbl_miniAmount.text =[NSString stringWithFormat:@"Minimum Amount (%@)",miniAmount];;
            str_iScheme =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_scheme"]];;
            str_plan =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_plan"]];;
            str_option =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_option"]];;
            str_driect =[NSString stringWithFormat:@"%@",newSchemmeDic[@"fm_plnmode"]];;
            //   lbl_miniAmount.text = =
            
        }else{
            
            schemmeDic=existingArr[row];
            
            txt_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
            selectedSecheme=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
            
            miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
            lbl_miniAmount.text =[NSString stringWithFormat:@"Minimum Amount (%@)",miniAmount];;
            str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
            str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
            str_option =[NSString stringWithFormat:@"%@",schemmeDic.opt];
            str_driect =[NSString stringWithFormat:@"%@",schemmeDic.schType];
            
        }
        
    }
    
    if (txt_currentTextField==txt_paymentBank) {
        KT_TABLE8 *rec_fund=paymentBantArr[row];
        txt_paymentBank.text=[NSString stringWithFormat:@"%@",rec_fund.bnkname];
        str_PaymentBank=[NSString stringWithFormat:@"%@",rec_fund.bnkname];
        
        
    }
    if (txt_currentTextField==txt_Category) {
        NSDictionary  *rec_fund=categoryArr[row];
        // [categoryArr  removeAllObjects];
        newschemeArr =[[NSMutableArray alloc]init];
        txt_Scheme.text  =nil;
        txt_broker.text=nil;
        txt_Arn.text =@"ARN-";
        txt_SubARN.text =@"ARN-";
        [view_Euin setHidden:YES];
        txt_Category.text=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];
        str_Category=[NSString stringWithFormat:@"%@",rec_fund[@"CatValue"]];
        [Btn_EuinNo setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        [Btn_EuinYes setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        
        
    }
    if (txt_currentTextField==txt_EUINNo) {
        NSDictionary  *rec_fund=subEArnarray[row];
        // [categoryArr  removeAllObjects];
        txt_EUINNo.text=[NSString stringWithFormat:@"%@",rec_fund[@"abm_agent"]];
        str_EuinNo =[NSString stringWithFormat:@"%@",rec_fund[@"abm_name"]];
    }
    
}
- (IBAction)atc_euinI:(id)sender {
    
    
       [[SharedUtility sharedInstance]showAlertViewWithTitle:KTMessage withMessage:@"I/We hereby confirm that the EUIN box has been intentionally left blank by me us as this is an 'execution-only' transaction without any interaction or advice by any personnel of the above distributor or notwithstanding the advice of in-appropriateness, if any, provided by any personnel of the distributor and the distributor has not charged any advisory fees on this transaction. "];
}

#pragma mark - paymentModeApi
-(void)paymentModeApi{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_otpType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"PM"];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_plntype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_otpType,str_fund,str_folio,str_plntype];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            PaymentModeVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"PaymentModeVC"];
            destination.str_pan= selectedPan;
            if ([btn_NewScheme.imageView.image isEqual: [UIImage imageNamed:@"radio-on"]]){
                
                destination.schemmeDetialsDic =newSchemmeDic;
            }else{
                destination.schemeDic =schemmeDic;
            }
            destination.str_Fund =txt_fund.text;
            destination.str_folio =selectedfolio;
            destination.str_Secheme =txt_Scheme.text;
            destination.str_Amount =txt_amount.text;
            destination.str_referId =str_referId;
            destination.paymentModeArray = [responce[@"Dtinformation"] mutableCopy];
            destination.str_selectedFundID = str_selectedFundID;
            destination.str_selectedFundID = str_selectedFundID;
            
            destination.str_name =txt_family.text ;
            if ([self->str_driect  isEqualToString:@"Regular"] || [self->str_driect  isEqualToString:@"REGULAR"]){
                destination.str_arn =self->txt_Arn.text ;
                destination.str_subarn =self->txt_SubARN.text ;
            }else{
                destination.str_arn =@"-";
                destination.str_subarn =@"-";
                
            }
            
            KTPUSH(destination,YES);
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
            if (self->categoryArr.count == 0) {
                self->categoryArr = responce[@"DtData"];
                self->txt_Category.inputView = self->picker_dropDown;
                [self->picker_dropDown reloadAllComponents];
                [self->txt_Category becomeFirstResponder];
                
                
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
    NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_enCategory =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_Category.text];
    NSString *str_trantype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"P"];
    NSString *str_divflg =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *  investflag ;
    if ([btn_Direct.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
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
                
                self->newschemeArr= [[NSMutableArray alloc]init];
                
                if (self->newschemeArr.count == 0) {
                    
                    self->newschemeArr =  responce[@"DtData"];
                    self->txt_Scheme.inputView = self->picker_dropDown;
                    [self->picker_dropDown reloadAllComponents];
                    [self->txt_Scheme becomeFirstResponder];
                    
                    
                    
                }
                
                
                self->newschemeArr =  responce[@"DtData"];
                NSLog(@"%@",responce);
            }else{
                
                [self->txt_Scheme resignFirstResponder];;
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
    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_SubARN.text];
    
    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_Arn.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@ValidateBrokercode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&AgentCd=%@&SubAgentCd=%@o_ErrNo&=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,Str_AgentCd,str_SubAgentCd,str_o_ErrNo];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            if ([responce[@"DtData"] count]  != 0) {
                self->subEArnarray= [[NSMutableArray alloc]init];
                if (self->subEArnarray.count == 0) {
                    subEArnarray = responce[@"DtData"];
                    txt_EUINNo.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                    
                    if ([Btn_EuinYes.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]) {

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
            
            txt_Arn.text =@"ARN-";
            txt_SubARN.text =@"ARN-";
            txt_EUINNo.text =nil;

            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - purchaseurl
-(void)purchaseurl{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSLog(@"%@",str_driect);
    
    
    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    NSString *str_enIscheme =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_iScheme];
    NSString *str_enopton =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_option];
    NSString *str_enfolio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    
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
    if ([str_driect  isEqualToString:@"Regular"]){
        i_arn =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_Arn.text];
        SubbrokerArn = [XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_broker.text];
        Subbroker=[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_SubARN.text];
        if ([Btn_EuinYes.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]){
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
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@SentpurchasemailRed?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&i_Fund=%@&i_Scheme=%@&i_Plan=%@&i_Option=%@&i_Acno=%@&i_RedFlg=%@&i_UntAmtFlg=%@&i_UntAmtValue=%@&i_Userid=%@&i_Tpin=%@&i_Mstatus=%@&i_oldihno=%@&i_InvDistFlag=%@&i_Tfund=%@&i_Tscheme=%@&i_Tplan=%@&i_Toption=%@&i_Tacno=%@&i_Agent=%@&i_Mapinid=%@&i_entby=%@&ARNCode=%@&EUINFlag=%@&Subbroker=%@&SubbrokerArn=%@&EuinCode=%@&EuinValid=%@&o_ErrNo=%@&Otp=%@&trtype=%@&PanNo=%@&Desci=%@&IMEINO=%@&Bankid=%@&upiid=%@&paymenttype=%@&nom1=%@&nom2=%@&nom3=%@&nomper1=%@&nomper2=%@&nomper3=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_enIscheme,str_eni_Plan,str_enopton,str_enfolio,str_i_RedFlg,str_i_RedFlg,str_enAmount,i_Userid,str_i_RedFlg,str_i_RedFlg,str_i_oldihno,str_i_InvDistFlag,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,i_Useremail,i_arn,EUINFlag,Subbroker,SubbrokerArn,EuinCode,EUINFlag,str_i_RedFlg,str_i_RedFlg,trtype,str_pan,desci,unique_UDID,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg,str_i_RedFlg];
    
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        
        if (error_statuscode==0) {
            
            str_referId = responce[@"DtData"][0][@"ID"];
            
            [self paymentModeApi];
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

-(void)validateSubARNAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:str_selectedFundID];
    // NSString *str_folio =[XTAPP_DELEGATE convertToBase64StrForAGivenString:selectedfolio];
    NSString *str_o_ErrNo =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_SubAgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_SubARN.text];
    
    NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_Arn.text];
    
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@ValidateBrokercode?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&AgentCd=%@&SubAgentCd=%@o_ErrNo&=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,Str_AgentCd,str_SubAgentCd,str_o_ErrNo];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            if ([responce[@"DtData"] count]  != 0) {
                subEArnarray= [[NSMutableArray alloc]init];
                if (subEArnarray.count == 0) {
                    subEArnarray = responce[@"DtData"];
                    txt_EUINNo.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                    
                    if ([Btn_EuinYes.imageView.image isEqual: [UIImage imageNamed:@"radio-off"]]) {
                        [txt_EUINNo becomeFirstResponder];
                        
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
            
            txt_SubARN.text =@"ARN-";
            txt_EUINNo.text =nil;

            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

@end

