//
//  RedemptonVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 26/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "RedemptonWithFamliy.h"

@interface RedemptonWithFamliy ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>{
    /// label
    __weak IBOutlet UILabel *_lbl_NavDate;
    __weak IBOutlet UILabel *lbl_amount;
    __weak IBOutlet UILabel *lbl_Current;
    __weak IBOutlet UILabel *lbl_balance;
    
    /// TextField
    __weak IBOutlet UITextField *tf_bank;
    __weak IBOutlet UITextField *txt_famliy;
    __weak IBOutlet UITextField *tf_folio;
    __weak IBOutlet UITextField *tF_fund;
    __weak IBOutlet UITextField *tF_Scheme;
    __weak IBOutlet UITextField *tF_reValue;
    
    /// button
    __weak IBOutlet UIButton *btn_partial;
    __weak IBOutlet UIButton *btn_full;
    __weak IBOutlet UIButton *btn_units;
    __weak IBOutlet UIButton *btn_amount;
    __weak IBOutlet UIButton *btn_generateotp;
    
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

@implementation RedemptonWithFamliy

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addElements];
    // Do any additional setup after loading the view.
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
        
        tF_fund.text=[NSString stringWithFormat:@"%@",_selected_Rec.fundDesc];
        str_selectedFundID =  [NSString stringWithFormat:@"%@",_selected_Rec.fund];
        
        tf_folio.text = [NSString stringWithFormat:@"%@",_selected_Rec.Acno];
        selectedfolio  = [NSString stringWithFormat:@"%@",_selected_Rec.Acno];
        tF_Scheme.text =[NSString stringWithFormat:@"%@",_selected_Rec.schDesc];
        
        
        schemmeDic= _selected_Rec;;
        tF_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
        lbl_balance.text = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
        lbl_Current.text = [NSString stringWithFormat:@"%@",schemmeDic.curValue];
        
        _lbl_NavDate.text = [NSString stringWithFormat:@"%@",schemmeDic.lastNAV];
        lbl_amount.text = [NSString stringWithFormat:@"%@",schemmeDic.minAmt];
        
        miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
        str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
        lastNavStr = schemmeDic.lastNAV;
        
        
        str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
        
        paymentBantArr = [[DBManager sharedDataManagerInstance]FetchAllRecordFromTable8:[NSString stringWithFormat:@"SELECT * FROM TABLE8_BANKACCOUNT  where fund='%@' and foliono ='%@'", str_selectedFundID,selectedfolio]]; tf_bank.delegate  = self;
        tf_bank.userInteractionEnabled = YES;
        tf_bank.inputView = picker_dropDown;
        [picker_dropDown reloadAllComponents];
        picker_dropDown=[[UIPickerView alloc]init];
        picker_dropDown.delegate=self;
        picker_dropDown.dataSource=self;
        picker_dropDown.backgroundColor=[UIColor whiteColor];
        tf_bank.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
               txt_famliy.userInteractionEnabled = NO;
        tf_folio.userInteractionEnabled = NO;
        tF_fund.userInteractionEnabled = NO;
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
        tF_fund.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        txt_famliy.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
        tf_bank.delegate  = self;
        NSArray *minorRecordDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='P' "]];
        KT_TABLE12 *pan_rec=minorRecordDetails[0];
        selectedPan=pan_rec.PAN;
        fundDetails = [[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT distinct fundDesc,fund FROM TABLE2_DETAILS where PAN='%@' and rFlag='Y' and rSchFlg='Y' order By FundDesc",selectedPan]];
        NSLog(@"%@",fundDetails);
        picker_dropDown=[[UIPickerView alloc]init];
        picker_dropDown.delegate=self;
        picker_dropDown.dataSource=self;
        picker_dropDown.backgroundColor=[UIColor whiteColor];
        tF_fund.inputView=picker_dropDown;
        [picker_dropDown reloadAllComponents];
    }

    str_redType =@"Units";

    txt_famliy.delegate  = self;
    ttrtype=@"P";
    
    tF_Scheme.delegate  = self;
    tF_fund.delegate  = self;
    tf_folio.delegate  = self;
    tF_reValue.delegate  = self;

    [btn_units.layer setCornerRadius:15.0f];
    [btn_units.layer setMasksToBounds:YES];
    [UITextField withoutRoundedCornerTextField:tF_fund forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_folio forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tF_Scheme forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:txt_famliy forCornerRadius:5.0f forBorderWidth:1.5f];
    [UITextField withoutRoundedCornerTextField:tf_bank forCornerRadius:5.0f forBorderWidth:1.5f];
    
    [btn_generateotp.layer setCornerRadius:15.0f];
    [btn_generateotp.layer setMasksToBounds:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)atc_GenerateOtp:(id)sender {
    
    NSLog(@"str_redType %@ ttrtype %@ ",str_redType,ttrtype);
    
    if ([tF_fund.text length] == 0) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund"];
        
    } else if ([tf_folio.text length] == 0) {
        
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio"];
        
    } else if ([tF_Scheme.text length] == 0) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Scheme"];
        
        
    } else if ([tF_reValue.text length] == 0) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Redemption Value"];
        
        
    }
    else if ([str_redType isEqualToString:@"Amount"] && [tF_reValue.text length] == 0 ) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Valid Amount"];
        
    } else if ([str_redType isEqualToString:@"Uints"] && [tF_reValue.text length] == 0) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Valid Units"];
        
    }
  
    else if ([tf_bank.text length] == 0) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please select  Bank  detials"];
    }
    
//    else if ([str_redType isEqualToString:@"Amount"] && ( [lbl_Current.text floatValue]  < [tF_reValue.text floatValue] )) {
//        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Does'nt have enough Balance  to Redeem!"]];
//        
//    }
    
    else if ([str_redType isEqualToString:@"Amount"] && ([tF_reValue.text floatValue]  <  [lbl_amount.text floatValue])) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:[NSString stringWithFormat:@"Minimum amount Should be  Amount:%@",lbl_amount.text]];
        
    } else if ([str_redType isEqualToString:@"Units"] && [ttrtype isEqualToString:@"P"] && ([tF_reValue.text floatValue]*  [lastNavStr floatValue]) <   [lbl_amount.text intValue]) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please Enter Minimum Units To Redeem !"];
    } else if ([str_redType isEqualToString:@"Units"] && [ttrtype isEqualToString:@"P"]  && [tF_reValue.text floatValue] > [lbl_balance.text floatValue]) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"You don't have enough Units To Redeem!"];
    }else{
        
        [self exitloadcalcAPI];
        
    }
    
    
}

#pragma mark - validate ARN API
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
    NSString *str_ENredType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"R"];
    
    NSString *  amountVal,*unitsVal;
    
    amountVal  =@"";
    unitsVal  =@"";
    
    if ([str_redType isEqualToString:@"Amount"]) {
        amountVal= tF_reValue.text;
        unitsVal=@"0"; //modified by badari on 15/05/2018.
    }else{
        unitsVal= tF_reValue.text;
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
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                         RedemptionConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"RedemptionConVC"];
                                         destination.str_pan= selectedPan;
                                         
                                         destination.schemeDic =schemmeDic;
                                         
                                         destination.str_Fund =tF_fund.text;
                                         destination.str_folio =tf_folio.text;
                                         destination.str_Secheme =tF_Scheme.text;
                                         destination.str_Amount =tF_reValue.text;
                                         destination.str_referId =str_referId;
                                         destination.paymentModeArray = [responce[@"Dtinformation"] mutableCopy];
                                         destination.str_selectedFundID = str_selectedFundID;
                                         destination.str_selectedFundID = str_selectedFundID;
                                         destination.ttrtype = ttrtype;
                                         destination.str_redType = str_redType;
                                         destination.lastNavStr = lastNavStr;
                                         destination.selectedBank =selectedBank;
                                         
                                         destination.str_name = txt_famliy.text;
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
                                         
                                         RedemptionConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"RedemptionConVC"];
                                         destination.str_pan= selectedPan;
                                         
                                         destination.schemeDic =schemmeDic;
                                         
                                         destination.str_Fund =tF_fund.text;
                                         destination.str_folio =tf_folio.text;
                                         destination.str_Secheme =tF_Scheme.text;
                                         destination.str_Amount =tF_reValue.text;
                                         destination.str_referId =str_referId;
                                         destination.paymentModeArray = [responce[@"Dtinformation"] mutableCopy];
                                         destination.str_selectedFundID = str_selectedFundID;
                                         destination.str_selectedFundID = str_selectedFundID;
                                         destination.ttrtype = ttrtype;
                                         destination.str_redType = str_redType;
                                         destination.lastNavStr = lastNavStr;
                                         destination.selectedBank =selectedBank;
                                         destination.str_name = txt_famliy.text;

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
                      
                  }
                  else{
                      if ([str_redType isEqualToString:@"Amount"]) {

                          
                          RedemptionConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"RedemptionConVC"];
                          destination.str_pan= selectedPan;
                          
                          destination.schemeDic =schemmeDic;
                          
                          destination.str_Fund =tF_fund.text;
                          destination.str_folio =tf_folio.text;
                          destination.str_Secheme =tF_Scheme.text;
                          destination.str_Amount =tF_reValue.text;
                          destination.str_referId =str_referId;
                          destination.paymentModeArray = [responce[@"Dtinformation"] mutableCopy];
                          destination.str_selectedFundID = str_selectedFundID;
                          destination.str_selectedFundID = str_selectedFundID;
                          destination.ttrtype = ttrtype;
                          destination.str_redType = str_redType;
                          destination.lastNavStr = lastNavStr;
                          destination.selectedBank =selectedBank;
                          destination.str_name = txt_famliy.text;

                          KTPUSH(destination,YES);
                      }else{
                          RedemptionConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"RedemptionConVC"];
                          destination.str_pan= selectedPan;
                          
                          destination.schemeDic =schemmeDic;
                          
                          destination.str_Fund =tF_fund.text;
                          destination.str_folio =tf_folio.text;
                          destination.str_Secheme =tF_Scheme.text;
                          destination.str_Amount =tF_reValue.text;
                          destination.str_referId =str_referId;
                          destination.paymentModeArray = [responce[@"Dtinformation"] mutableCopy];
                          destination.str_selectedFundID = str_selectedFundID;
                          destination.str_selectedFundID = str_selectedFundID;
                          destination.ttrtype = ttrtype;
                          destination.str_redType = str_redType;
                          destination.lastNavStr = lastNavStr;
                          destination.selectedBank =selectedBank;
                          destination.str_name = txt_famliy.text;

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

- (IBAction)atc_partial:(id)sender {
    
    if ([tF_Scheme.text length] == 0 ) {
        [tF_fund becomeFirstResponder];
        
    }else
        
        tF_reValue.text  =nil;
    ttrtype= @"P";
    tF_reValue.userInteractionEnabled = true;
    
    if  ([btn_partial.imageView.image isEqual:[UIImage imageNamed:@"radio-off"]]){
        [btn_partial setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_full setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        ttrtype= @"P";

    }
}

- (IBAction)atc_Full:(id)sender {
    
    if ([tF_Scheme.text length] == 0 ) {
        [tF_fund becomeFirstResponder];
        
    }else{

    ttrtype= @"F";
    
    if  ([btn_full.imageView.image isEqual:[UIImage imageNamed:@"radio-off"]]){
                if ([btn_amount.imageView.image isEqual:[UIImage imageNamed:@"radio-on"]]) {
            [btn_amount setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
            [btn_units setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
            tF_reValue.placeholder =@"Units";
            str_redType =@"Units";
          
            
        }
        tF_reValue.placeholder =@"Units";
        str_redType =@"Units";
        
        tF_reValue.text  = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
        
        tF_reValue.userInteractionEnabled = false;
        
        tF_reValue.text  = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
        
        
            [btn_full setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
            [btn_partial setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        }
    }
    
    }
    
    

- (IBAction)atc_Units:(id)sender {
    if ([tF_Scheme.text length] == 0 ) {
        [tF_fund becomeFirstResponder];
        
    }else
    
    tF_reValue.placeholder =@"Units";
    str_redType =@"Units";
    
    tF_reValue.text  =nil;

    tF_reValue.userInteractionEnabled = true;
    
    if  ([btn_units.imageView.image isEqual:[UIImage imageNamed:@"radio-off"]]){
        [btn_units setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_amount setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)atc_ammount:(id)sender {
    if ([tF_Scheme.text length] == 0 ) {
        [tF_fund becomeFirstResponder];
        
    }else
    tF_reValue.placeholder =@"Amount";
    str_redType =@"Amount";
    tF_reValue.text  =nil;
    
    tF_reValue.userInteractionEnabled = true;
    if ([btn_full.imageView.image isEqual:[UIImage imageNamed:@"radio-on"]]) {
        [btn_full setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        [btn_partial setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        
    }
    if  ([btn_amount.imageView.image isEqual:[UIImage imageNamed:@"radio-off"]]){
        [btn_amount setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_units setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
    }
}

- (IBAction)back:(id)sender {
    
    KTPOP(YES);
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    long int newcount = 0;
    
    if (txt_currentTextField==txt_famliy) {
            newcount= PanDetials.count;
        }
    if (txt_currentTextField==tf_bank) {
        newcount= paymentBantArr.count;
    }
    if (txt_currentTextField==tF_fund) {
        newcount= fundDetails.count;
    }
    //    if (txt_currentTextField==txt_family) {
    //        newcount= PanDetials.count;
    //    }
    if (txt_currentTextField==tf_folio) {
        newcount= folioArray.count;
    }
    
    if (txt_currentTextField==tF_Scheme) {
        
        
        
        newcount= existingArr.count;
    }
    

    
    return newcount;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str_title;
  
    if (txt_currentTextField==txt_famliy) {
            KT_TABLE12 *rec_fund=PanDetials[row];
            str_title=[NSString stringWithFormat:@"%@",rec_fund.invName];
        }
    if (txt_currentTextField==tF_fund) {
        KT_Table2RawQuery *rec_fund=fundDetails[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund.fundDesc];
    }
    if (txt_currentTextField==tf_bank) {
        KT_TABLE8 *rec_fund=paymentBantArr[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund.bnkname];
    }
    
    //    if (txt_currentTextField==txt_family) {
    //        KT_TABLE12 *rec_fund=PanDetials[row];
    //        str_title=[NSString stringWithFormat:@"%@",rec_fund.invName];
    //    }
    
    if (txt_currentTextField==tf_folio) {
        KT_TABLE2 *rec_fund=folioArray[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund.Acno];
    }
    if (txt_currentTextField==tF_Scheme) {
        
        
        KT_TABLE2 *rec_fund=existingArr[row];
        str_title=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
        str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
        
        
    }
    
    return str_title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    if (txt_currentTextField==txt_famliy) {
            KT_TABLE12 *rec_fund=PanDetials[row];
        txt_famliy.text=[NSString stringWithFormat:@"%@",rec_fund.invName];
        selectedPan=[NSString stringWithFormat:@"%@",rec_fund.PAN];

        tF_fund.text=nil;

            tf_folio.text=nil;
        tf_bank.text =nil;
        
            tF_Scheme.text=nil;
            tF_Scheme.text=nil;
            lbl_balance.text = nil;
            lbl_Current.text = nil;
                    tf_bank.text =nil;
            _lbl_NavDate.text =nil;
            lbl_amount.text = nil;
           tF_reValue.text=nil;
        [btn_partial setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_full setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        }
    if (txt_currentTextField==tF_fund) {
        KT_Table2RawQuery *rec_fund=fundDetails[row];
        tF_fund.text=[NSString stringWithFormat:@"%@",rec_fund.fundDesc];
        str_selectedFundID=[NSString stringWithFormat:@"%@",rec_fund.fund];
        tf_folio.text=nil;
        tF_Scheme.text=nil;
        tF_Scheme.text=nil;
        lbl_balance.text = nil;
        lbl_Current.text = nil;
        tf_bank.text =nil;
        _lbl_NavDate.text =nil;
        lbl_amount.text = nil;
        tF_reValue.text=nil;
        [btn_partial setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateNormal];
        [btn_full setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        folioArray = [[DBManager sharedDataManagerInstance]uniqueFolioFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT (Acno), notallowed_flag FROM TABLE2_DETAILS where fund ='%@' and PAN='%@'  and rSchFlg='Y'",str_selectedFundID,selectedPan]];
        if (folioArray.count == 1) {
            KT_TABLE2 *rec_fund=folioArray[0];
            NSLog(@"%@",rec_fund.notallowed_flag);
            tf_folio.text=[NSString stringWithFormat:@"%@",rec_fund.Acno];
            selectedfolio =[NSString stringWithFormat:@"%@",rec_fund.Acno];
            [tf_folio setUserInteractionEnabled:NO];
            tf_bank.text = nil;
            
            existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and BalUnits != 0 and rSchFlg='Y' ",str_selectedFundID,selectedfolio]];
            if (existingArr.count  == 0) {
            }
            else{
                if (existingArr.count == 1) {
                    tf_bank.text = nil;
                    
                    schemmeDic=existingArr[0];
                    
                    tF_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
                    lbl_balance.text = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
                    lbl_Current.text = [NSString stringWithFormat:@"%@",schemmeDic.curValue];
                    
                    _lbl_NavDate.text = [NSString stringWithFormat:@"%@",schemmeDic.lastNAV];
                    lbl_amount.text = [NSString stringWithFormat:@"%@",schemmeDic.minAmt];
                    
                    miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
                    str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
                    lastNavStr = schemmeDic.lastNAV;
                    
                    tf_bank.text = nil;
                    
                    
                    str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
                    [self atc_Units:btn_units];
                    [self atc_partial:self];
                    [self atc_Units:btn_units];
                }else{
                    [tF_Scheme setUserInteractionEnabled:YES];
                    tF_Scheme.inputView = picker_dropDown;
                    [picker_dropDown reloadAllComponents];
                }
            }
            
        }else{
            [tf_folio setUserInteractionEnabled:YES];
            tf_folio.inputView = picker_dropDown;
            [picker_dropDown reloadAllComponents];
        }
        
        [self atc_partial:self];
        [self atc_Units:btn_units];
        
    }
    
    if (txt_currentTextField==tf_folio) {
        KT_TABLE2 *rec_fund=folioArray[row];
        existingArr =[[NSMutableArray alloc]init];
        tF_Scheme.text=nil;
        tF_Scheme.text=nil;
        lbl_balance.text = nil;
        lbl_Current.text = nil;
        tf_bank.text =nil;
        _lbl_NavDate.text =nil;
        lbl_amount.text = nil;
        tF_reValue.text=nil;
        tf_folio.text=[NSString stringWithFormat:@"%@",rec_fund.Acno];
        selectedfolio=[NSString stringWithFormat:@"%@",rec_fund.Acno];
        str_folioDmart=[NSString stringWithFormat:@"%@",rec_fund.notallowed_flag];
        str_iScheme =[NSString stringWithFormat:@"Minimum Amount (%@)",rec_fund.sch];;
        lastNavStr = rec_fund.lastNAV;
        
        tf_bank.text = nil;
        
        str_plan =[NSString stringWithFormat:@"Minimum Amount (%@)",rec_fund.pln];;
        
        NSLog(@"%@",rec_fund.notallowed_flag);
        existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and BalUnits != 0 and rSchFlg='Y' ",str_selectedFundID,selectedfolio]];
        if (existingArr.count  == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No Scheme found"];
        }
        else{
            if (existingArr.count == 1) {
                schemmeDic=existingArr[0];
                [self atc_partial:self];
                tf_bank.text = nil;
                
                
                tF_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
                lbl_balance.text = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
                lbl_Current.text = [NSString stringWithFormat:@"%@",schemmeDic.curValue];
                
                _lbl_NavDate.text = [NSString stringWithFormat:@"%@",schemmeDic.lastNAV];
                lbl_amount.text = [NSString stringWithFormat:@"%@",schemmeDic.minAmt];
                
                miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
                str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
                lastNavStr = schemmeDic.lastNAV;
                
                
                tf_bank.text = nil;
                
                
                
                str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
                [tF_Scheme setUserInteractionEnabled:NO];
                
                
                
            }else{
                [tF_Scheme setUserInteractionEnabled:YES];
                tF_Scheme.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
                
                
            }
        }
        
        [self atc_partial:self];
        [self atc_Units:btn_units];
        
    }
    if (txt_currentTextField==tF_Scheme) {
        
        schemmeDic=existingArr[row];
        
        tF_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
        lbl_balance.text = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
        lbl_Current.text = [NSString stringWithFormat:@"%@",schemmeDic.curValue];
        
        _lbl_NavDate.text = [NSString stringWithFormat:@"%@",schemmeDic.lastNAV];
        lbl_amount.text = [NSString stringWithFormat:@"%@",schemmeDic.minAmt];
        
        miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
        str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
        lastNavStr = schemmeDic.lastNAV;
        tf_bank.text = nil;
        
        str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
        
        [self atc_Units:btn_units];
        [self atc_partial:self];
        
        
        
        
    }
    
    if (txt_currentTextField==tf_bank) {
        selectedBank=paymentBantArr[row];
        tf_bank.text= [NSString stringWithFormat:@"%@",selectedBank.bnkname];
    }

    
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tF_reValue) {
        
        
        if (textField.text.length >= MAX_LENGTH && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        
        
        else
        {return YES;}
    }
    
    {return YES;}
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    txt_currentTextField=textField;
    if (textField==txt_famliy) {
        [picker_dropDown reloadAllComponents];
        [txt_famliy becomeFirstResponder];
    }
    
  else  if (textField==tF_fund) {
      
      if ([txt_famliy.text length] == 0 ) {
          [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Famliy Member"];
//      /    [tF_fund becomeFirstResponder];
          
      }else{
            fundDetails = [[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT distinct fundDesc,fund FROM TABLE2_DETAILS where PAN='%@' and rFlag='Y' and rSchFlg='Y' order By FundDesc",selectedPan]];
          [picker_dropDown reloadAllComponents];
          [tF_fund becomeFirstResponder];
      }
      
    }
    else if  (textField==tf_folio) {
        if ([tF_fund.text length] == 0 ) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Fund"];
            [tF_fund becomeFirstResponder];
            
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
        if ([tF_fund.text length] == 0 ) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Folio"];
            [tF_fund becomeFirstResponder];
            
        }
        else{
            
            if (existingArr.count  == 0) {
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No Scheme found"];
            }else{
                
                
                if (existingArr.count == 1) {
                    KT_TABLE2 *rec_fund=existingArr[0];
                    
                    schemmeDic=existingArr[0];
                    
                    tF_Scheme.text=[NSString stringWithFormat:@"%@",schemmeDic.schDesc];
                    lbl_balance.text = [NSString stringWithFormat:@"%@",schemmeDic.balUnits ];
                    lbl_Current.text = [NSString stringWithFormat:@"%@",schemmeDic.curValue];
                    
                    _lbl_NavDate.text = [NSString stringWithFormat:@"%@",schemmeDic.lastNAV];
                    lbl_amount.text = [NSString stringWithFormat:@"%@",schemmeDic.minAmt];
                    
                    miniAmount=[NSString stringWithFormat:@"%@",schemmeDic.minAmt];
                    str_plan =[NSString stringWithFormat:@"%@",schemmeDic.pln];;
                    lastNavStr = schemmeDic.lastNAV;
                    
                    
                    str_iScheme =[NSString stringWithFormat:@"%@",schemmeDic.sch];;
                    NSLog(@"%@",rec_fund.notallowed_flag);
                    tF_Scheme.text=[NSString stringWithFormat:@"%@",rec_fund.schDesc];
                    selectedSecheme =[NSString stringWithFormat:@"%@",rec_fund.schDesc];
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
    else if (textField  == tf_bank){
        
        
        if ([tF_Scheme.text length] == 0 ) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please  select the Scheme"];
            [tF_fund becomeFirstResponder];
            
        }else{
            paymentBantArr = [[DBManager sharedDataManagerInstance]FetchAllRecordFromTable8:[NSString stringWithFormat:@"SELECT * FROM TABLE8_BANKACCOUNT  where fund='%@' and foliono ='%@'", str_selectedFundID,selectedfolio]];
            
            if (paymentBantArr.count == 1) {
                selectedBank=paymentBantArr[0];
                tf_bank.text=[NSString stringWithFormat:@"%@",selectedBank.bnkname];
                tf_bank.userInteractionEnabled = NO;
            }else{
                tf_bank.inputView = picker_dropDown;
                [picker_dropDown reloadAllComponents];
            }
            
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [txt_currentTextField resignFirstResponder];
    
    if (textField == tf_folio) {
        existingArr = [[DBManager sharedDataManagerInstance]fetchRecordFromTable2:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS  where fund ='%@' and Acno='%@' and BalUnits != 0 and rSchFlg='Y' ",str_selectedFundID,selectedfolio]];
        if (existingArr.count  == 0) {
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No Scheme found"];
        }
        
    }
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
