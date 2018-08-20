//
//  PaymentModeVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 07/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "PaymentModeVC.h"
#import "PaymentModeCell.h"

@interface PaymentModeVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>{
    __weak IBOutlet UILabel *lbl_fund;
    __weak IBOutlet UILabel *lbl_folio;
    __weak IBOutlet UILabel *lbl_payment;
    __weak IBOutlet UILabel *lbl_scheme;
    __weak IBOutlet UILabel *lbl_arn;
    __weak IBOutlet UILabel *lbl_SubArn;
    
    __weak IBOutlet UIView *view_background;
    __weak IBOutlet UITableView *paymentModeTable;
    __weak IBOutlet UILabel *lbl_pan;
    __weak IBOutlet UILabel *lbl_name;
    NSArray  *paymentBantArr;
      UIPickerView *picker_dropDown;
    NSString *paymentModeStr;

    NSString *title_BankID,*title_Bank;
}
@property (weak, nonatomic) IBOutlet UIView *detailsView;

@end

@implementation PaymentModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.str_folio);
    
    lbl_pan.text = self.str_pan;
    lbl_scheme.text = self.str_Secheme;
    lbl_folio.text = self.str_folio;
    lbl_fund.text = self.str_Fund;
     lbl_payment.text = [NSString stringWithFormat:@"%@/-    ",self.str_Amount];
    [[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername];
//    [_detailsView .layer setCornerRadius:15.0f];
//    [_detailsView.layer setMasksToBounds:YES];
    [view_background .layer setCornerRadius:15.0f];
    [view_background.layer setMasksToBounds:YES];
    paymentModeTable.delegate =self;
    paymentModeTable.dataSource =self;
    
    _paymentModeArray =[[NSMutableArray alloc]init];
    
    NSDictionary * dicts = @{ @"Pay_Mode" : @"Net Banking", @"Pay_Mode_Val" : @"DCB",@"Yes":@"no"};
    NSDictionary *         dict = @{ @"Pay_Mode" : @"KOTM", @"Pay_Mode_Val" : @"KOTM",@"Yes":@"no"};
    NSDictionary *   dictsaa = @{ @"Pay_Mode" : @"Debit Card", @"Pay_Mode_Val" : @"DC",@"Yes":@"no"};
    NSDictionary *  dictsa = @{ @"Pay_Mode" : @"UPI", @"Pay_Mode_Val" : @"UPI",@"Yes":@"no"};
    
    [_paymentModeArray addObject:dicts];
    [_paymentModeArray addObject:dict];
    [_paymentModeArray addObject:dictsa];
    [_paymentModeArray addObject:dictsaa];
    picker_dropDown=[[UIPickerView alloc]init];
    paymentBantArr = [[DBManager sharedDataManagerInstance]FetchAllRecordFromTable8:[NSString stringWithFormat:@"SELECT * FROM TABLE8_BANKACCOUNT  where fund='%@' and foliono ='%@'",_str_selectedFundID,_str_folio]];
        [self PayModeApi];
    lbl_name.text  = self.str_name;
    lbl_arn.text  = self.str_arn;
   lbl_SubArn.text  = self.str_subarn;
    NSLog(@"%@",_paymentModeArray);
        NSLog(@"%@",_schemmeDetialsDic);
    NSLog(@"%@",_schemeDic.optDesc);
       NSLog(@"%@",self.str_referId);


    

    picker_dropDown.frame=CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width , 250);
    
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    [picker_dropDown setHidden:YES];
    
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.frame=CGRectMake(0,0,self.view.frame.size.width ,44);
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    
    UIBarButtonItem* CancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStyleDone target:self
                                                                    action:@selector(cancelClicked:)];
    
    
    
    [toolbar setItems:[NSArray arrayWithObjects:CancelButton,flexibleSpaceLeft, doneButton, nil]];
    
    
    ///[picker_dropDown addSubview:toolbar];
    [self.view addSubview:picker_dropDown];// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paymentModeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentModeCell *cell=(PaymentModeCell*)[tableView dequeueReusableCellWithIdentifier:@"PaymentMode"];
    if (cell==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentModeCell" owner:self options:nil];
        cell = (PaymentModeCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    
    NSDictionary * dic =  self.paymentModeArray[indexPath.row];
    
    
    
    if ([dic[@"Pay_Mode"]isEqualToString:@"Net Banking"] ) {
        cell.lbl_paymentModeDesc.text = [NSString stringWithFormat:@"%@",dic[@"Pay_Mode"]];
        cell.leftImage.image =[UIImage imageNamed:@"netBank"];
        
        cell.dropDownImage.image =[UIImage imageNamed:@"shape1"];
        
        
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            
            cell.backView.backgroundColor =[UIColor whiteColor];
        }else{
            cell.backView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        }
        
    }
    if ([dic[@"Pay_Mode"]isEqualToString:@"Debit Card"]) {
        cell.lbl_paymentModeDesc.text = [NSString stringWithFormat:@"%@",dic[@"Pay_Mode"]];
        cell.leftImage.image =[UIImage imageNamed:@"debitCrad"];
        cell.dropDownImage.image =[UIImage imageNamed:@"debitCradDorp"];
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            
            cell.backView.backgroundColor =[UIColor whiteColor];
        }else{
            cell.backView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        }
    }
    if ([dic[@"Pay_Mode"]isEqualToString:@"UPI"]) {
        cell.lbl_paymentModeDesc.text = [NSString stringWithFormat:@"%@",dic[@"Pay_Mode"]];
        cell.leftImage.image =[UIImage imageNamed:@"upi"];
        cell.dropDownImage.image =[UIImage imageNamed:@"shape1Copy12"];
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            
            cell.backView.backgroundColor =[UIColor whiteColor];
        }else{
            cell.backView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        }
    }
    
    if ([dic[@"Pay_Mode"]isEqualToString:@"KOTM"]) {
        cell.lbl_paymentModeDesc.text = [NSString stringWithFormat:@"%@",dic[@"Pay_Mode"]];
        cell.leftImage.image =[UIImage imageNamed:@"kotm"];
        cell.dropDownImage.image =[UIImage imageNamed:@"Ktom"];
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            
            cell.backView.backgroundColor =[UIColor whiteColor];
        }else{
            cell.backView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        }
        
        
    }
    
    cell.lbl_paymentModeDesc.text = [NSString stringWithFormat:@"%@",dic[@"Pay_Mode"]];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    
    
    NSDictionary * dic =  self.paymentModeArray[indexPath.row];
    
    
    
    if ([dic[@"Pay_Mode"]isEqualToString:@"Net Banking"] ) {
            paymentModeStr =dic[@"Pay_Mode_Val"];
//        [picker_dropDown setHidden:NO];
//        [picker_dropDown reloadAllComponents];
        
        
        
   
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            if (paymentBantArr.count == 0) {
                     [[SharedUtility sharedInstance]showAlertViewWithTitle:KTMessage withMessage:@"No Bank is associated with this Folio "];
            }else{
                paymentModeStr =dic[@"Pay_Mode_Val"];
                [picker_dropDown setHidden:NO];
                [picker_dropDown reloadAllComponents];
            }
            

        }else{
        }
        
    }
    if ([dic[@"Pay_Mode"]isEqualToString:@"Debit Card"]) {
        
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            paymentModeStr =dic[@"Pay_Mode_Val"];
            
            title_BankID=[NSString stringWithFormat:@"~"];
            title_Bank=[NSString stringWithFormat:@"~"];
            [self SaveDTRWeb];

        }else{
            
            
        }
    }
    if ([dic[@"Pay_Mode"]isEqualToString:@"UPI"]) {
        
        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            paymentModeStr =dic[@"Pay_Mode_Val"];
            
        }else{
            
            
        }
    }
    
    if ([dic[@"Pay_Mode"]isEqualToString:@"KOTM"]) {
//            paymentModeStr =dic[@"Pay_Mode_Val"];

        if ([dic[@"Yes"]isEqualToString:@"yes"] ) {
            paymentModeStr =dic[@"Pay_Mode_Val"];
            [self validateKOTM];
        }else{
            
            
        }
        
        
    }
    
}
#pragma mark - PayModeApi
-(void)PayModeApi{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_otpType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"PM"];
    NSString *str_fundq =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_folioa =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_pan];
    NSString *str_plntype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@getMasterNewpur?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&opt=%@&fund=%@&schemetype=%@&plntype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_otpType,str_fundq,str_folioa,str_plntype];
    
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            self->_saepaymentModeArr  = responce[@"Dtinformation"];
            
                        NSLog(@"%@",self.paymentModeArray);
            
            
            
            for (int i=0; i<self.saepaymentModeArr.count; i++) {
                NSDictionary * dica =  self.saepaymentModeArr[i];
                NSLog(@"%@",dica);
                
                
                
                NSDictionary *dicts ;
                NSDictionary *dict;
                NSDictionary *dictsaa;
                NSDictionary *dictsa;
  
                     if ([dica[@"Pay_Mode"]isEqualToString:@"Net Banking"] ) {
                
                if ([dica[@"Pay_Mode"]isEqualToString:@"Net Banking"] ) {
                    
               
                    
                    
                    dicts = @{ @"Pay_Mode" : @"Net Banking", @"Pay_Mode_Val" : @"DCB",@"Yes":@"yes"};
                    [self.paymentModeArray replaceObjectAtIndex:0 withObject:dicts];
                    
                    
                    

                }else{
                    
                    
                    
                    dicts = @{ @"Pay_Mode" : @"Net Banking", @"Pay_Mode_Val" : @"DCB",@"Yes":@"no"};
             
                    
                    [self.paymentModeArray replaceObjectAtIndex:0 withObject:dicts];


                    
                    
                    
                }
                     }
            
       else    if   ([dica[@"Pay_Mode"]isEqualToString:@"Debit Card"]) {
                
                
                           if ([dica[@"Pay_Mode"]isEqualToString:@"Debit Card"]) {
                if ([dica[@"Pay_Mode"]isEqualToString:@"Debit Card"]) {
                    
                    dictsaa = @{ @"Pay_Mode" : @"Debit Card", @"Pay_Mode_Val" : @"DC",@"Yes":@"yes"};
                    
                                        [self.paymentModeArray replaceObjectAtIndex:3 withObject:dictsaa];

                }else{
                    dictsaa = @{ @"Pay_Mode" : @"Debit Card", @"Pay_Mode_Val" : @"DC",@"Yes":@"no"};
                    [self.paymentModeArray replaceObjectAtIndex:3 withObject:dictsaa];


                }
                               
                           }
                               
                           }
                
         else       if ([dica[@"Pay_Mode"]isEqualToString:@"UPI"]) {
                    
                if ([dica[@"Pay_Mode"]isEqualToString:@"UPI"]) {
                    
                    dictsa = @{ @"Pay_Mode" : @"UPI", @"Pay_Mode_Val" : @"UPI",@"Yes":@"yes"};

                    [self.paymentModeArray replaceObjectAtIndex:2 withObject:dictsa];

                }
                               
                           
                else{
                    
                    
                    dictsa = @{ @"Pay_Mode" : @"UPI", @"Pay_Mode_Val" : @"UPI",@"Yes":@"no"};
                    [self.paymentModeArray replaceObjectAtIndex:2 withObject:dictsa];

                }
             
         }
            else    if ([dica[@"Pay_Mode"]isEqualToString:@"KOTM"]) {
                if ([dica[@"Pay_Mode"]isEqualToString:@"KOTM"]) {
                    
                    dict = @{ @"Pay_Mode" : @"KOTM", @"Pay_Mode_Val" : @"KOTM",@"Yes":@"yes"};
                    [self.paymentModeArray replaceObjectAtIndex:1 withObject:dict];

                    
                }else{
                    dict = @{ @"Pay_Mode" : @"KOTM", @"Pay_Mode_Val" : @"KOTM",@"Yes":@"no"};
                    [self.paymentModeArray replaceObjectAtIndex:1 withObject:dict];

                }
                
            }else{
            
                NSLog(@"%@",self.paymentModeArray);

                
            }
                
                
                
            }
            NSLog(@"%@",self.paymentModeArray);


            [self->paymentModeTable reloadData];
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

-(void)validateKOTM{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ensfund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_Fund];
    NSString *str_enpan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_pan];
    
    
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
                                     
                                     title_BankID=[NSString stringWithFormat:@"~"];
                                     title_Bank=[NSString stringWithFormat:@"~"];
                                     [self SaveDTRWebKtom];
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
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Table"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)confKOTM:(NSString *)KtomString{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ensfund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_enpan =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KtomString];
    
    
    // NSString *Str_AgentCd =[XTAPP_DELEGATE convertToBase64StrForAGivenString:txt_Arn.text];
    
    //
    //
    //    p.setParam("APKVer", enc_AppVer);
    //    p.setParam("Fund", enc_FundCode);
    //    p.setParam("Appno", enc_dataAppNo);
    
    NSString *str_url = [NSString stringWithFormat:@"%@AddPurConfirmKOTM?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&Appno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_ensfund,str_enpan];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Table"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            
            NSLog(@"%@",responce[@"Table1"][0][@"Msg"]);
            KtoMConVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"KtoMConVC"];
            
            destination.refStr =[NSString stringWithFormat:@"%@",responce[@"Table1"][0][@"Msg"]];
            KTPUSH(destination,YES);
            
            
            
//            UIAlertController * alert=   [UIAlertController
//                                          alertControllerWithTitle:@"KOTM"
//                                          message:responce[@"Table1"][0][@"Msg"]
//                                          preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* ok = [UIAlertAction
//                                 actionWithTitle:@"Procced"
//                                 style:UIAlertActionStyleDefault
//                                 handler:^(UIAlertAction * action){
//                                     [alert dismissViewControllerAnimated:YES completion:nil];
//
//                                 }];
//            [alert addAction:ok];
//            UIAlertAction* cancel = [UIAlertAction
//                                     actionWithTitle:@"Cancel"
//                                     style:UIAlertActionStyleDefault
//                                     handler:^(UIAlertAction * action){
//                                         [alert dismissViewControllerAnimated:YES completion:nil];
//
//
//                                     }];
//            [alert addAction:cancel];
//            [self presentViewController:alert animated:YES completion:nil];
//
//
            
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


-(void)showAlertWithTitle:(NSString *)strTitle forMessage:(NSString *)strMessage{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:strTitle
                                  message:strMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             KTPOP(YES);
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return paymentBantArr.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    KT_TABLE8 *table_rec=paymentBantArr[row];
    NSString *title_str=[NSString stringWithFormat:@"%@",table_rec.bnkname];
    return title_str ;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
        KT_TABLE8 *table_rec=paymentBantArr[row];
         title_BankID=[NSString stringWithFormat:@"%@~%@",table_rec.bnkcode,table_rec.bnkactype];
     title_Bank=[NSString stringWithFormat:@"~%@",table_rec.bnkacno];
    
        [picker_dropDown setHidden:YES];
    NSLog(@"%@",title_BankID);
    [self SaveDTRWeb];
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

-(void)SaveDTRWebKtom{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ensfund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
    NSString *str_BankID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:title_BankID];
    NSString *str_Bank =[XTAPP_DELEGATE convertToBase64StrForAGivenString:title_Bank];
    NSString *str_Trtype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"P"];
    
    NSString *En_referId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@", self.str_referId]];
    NSLog(@"%@",title_BankID);
    NSString *En_paymentModeStr =[XTAPP_DELEGATE convertToBase64StrForAGivenString:paymentModeStr];
    
    NSLog(@"%@",paymentModeStr);
    
    
    
    NSString *str_url = [NSString stringWithFormat:@"%@SaveDTRWeb?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&Refno=%@&Bankid=%@%@&PaymentType=%@&Trtype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_ensfund,En_referId,str_BankID,str_Bank,En_paymentModeStr,str_Trtype];
    
    NSLog(@"%@",str_url);
    
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {
            
            [self confKOTM:responce[@"DtData"][0][@"dd_appno"]];
            
            

//            PaymentVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"PaymentVC"];
//
//            destination.str_referId =[NSString stringWithFormat:@"%@", self.str_referId];
//            KTPUSH(destination,YES);
//
//
            
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
-(void)SaveDTRWeb{
    
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];

    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_ensfund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:_str_selectedFundID];
NSString *str_BankID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:title_BankID];
    NSString *str_Bank =[XTAPP_DELEGATE convertToBase64StrForAGivenString:title_Bank];
    NSString *str_Trtype =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@"P"];

    NSString *En_referId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@", self.str_referId]];
    NSLog(@"%@",title_BankID);
NSString *En_paymentModeStr =[XTAPP_DELEGATE convertToBase64StrForAGivenString:paymentModeStr];
    
    NSLog(@"%@",paymentModeStr);

    
    
    NSString *str_url = [NSString stringWithFormat:@"%@SaveDTRWeb?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&fund=%@&Refno=%@&Bankid=%@%@&PaymentType=%@&Trtype=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_ensfund,En_referId,str_BankID,str_Bank,En_paymentModeStr,str_Trtype];
    
    NSLog(@"%@",str_url);
    
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        [[APIManager sharedManager]hideHUD];

        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {
            
            PaymentVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"PaymentVC"];
            
            destination.str_referId =[NSString stringWithFormat:@"%@", self.str_referId];
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
- (IBAction)backAtc:(id)sender {
    
    KTPOP(true);
}

-(void)doneClicked:(id)sender {
    picker_dropDown.hidden = YES;
    
    [self SaveDTRWeb];
}

-(void)cancelClicked:(id)sender {
    picker_dropDown.hidden = NO;
}
@end
