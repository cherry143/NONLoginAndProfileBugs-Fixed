//
//  TransactNowVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 24/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "TransactNowVC.h"

@interface TransactNowVC (){
    __weak IBOutlet UIButton *btn_swp;
    __weak IBOutlet UIView *view_withNewPurchase;
    __weak IBOutlet UIButton *btn_newPurchaseWithoutFolio;
    __weak IBOutlet UIView *view_withoutNewPurchase;
    __weak IBOutlet UIButton *btn_sip;
    __weak IBOutlet UIButton *btn_newPurchase;
    __weak IBOutlet UIButton *btn_switch;
    __weak IBOutlet UIButton *btn_redemption;
    __weak IBOutlet UIButton *btn_additionalPurchase;
    __weak IBOutlet UIButton *btn_stp;
}

@end

@implementation TransactNowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self cornerRadiusOnViewLoad];
    [self loadOnView];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"TransactinMyFolios"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - corner Radius To button

-(void)cornerRadiusOnViewLoad{
    [UIButton roundedCornerButtonWithoutBackground:btn_sip forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_newPurchase forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_switch forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_redemption forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_additionalPurchase forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_newPurchaseWithoutFolio forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_swp forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
    
        [UIButton roundedCornerButtonWithoutBackground:btn_stp forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
}

#pragma mark - Button Action

- (IBAction)Atc_STP:(id)sender {
    
    
    
    SystematicTransferPlanVC  *controller=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SystematicTransferPlanVC"];
    KTPUSH(controller,YES);
}
- (IBAction)btn_swpTapped:(UIButton *)sender {
    SystematicWithdrawalPlanVC  *controller=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"SystematicWithdrawalPlanVC"];
    KTPUSH(controller,YES);
}

- (IBAction)Atc_AddPurchase:(id)sender {
    
    NSArray *minorRecordDetails = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='P' "]];
    
    if (minorRecordDetails.count == 0 ) {
        [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"Please set Your Primary Pan "];
    }else
    {
        AddPurchaseVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"AddPurchaseVC"];
        KTPUSH(destination,YES);
    }
}

- (IBAction)atc_Redempton:(id)sender {
    RedemptonVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"RedemptonVC"];
    KTPUSH(destination,YES);
}

- (IBAction)atc_Switch:(id)sender {
    SwitchVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SwitchVC"];
    KTPUSH(destination,YES);
}

- (IBAction)atc_NewPurchase:(id)sender {
        [self getProfilePercentageAPI];
}

- (IBAction)atc_SIP:(id)sender {
    SIPWithPPanVC  *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SIPWithPPanVC"];
    KTPUSH(destination,YES);
}

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

-(void)loadOnView{
    NSArray *arr_folioRec= [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE2_DETAILS"]];
    if (arr_folioRec.count!=0) {
        [view_withoutNewPurchase setHidden:NO];
        [view_withNewPurchase setHidden:YES];
    }else{
        [view_withoutNewPurchase setHidden:YES];
        [view_withNewPurchase setHidden:NO];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
            if (error_statuscode==0) {
                NSString *str_per=[NSString stringWithFormat:@"%@",responce[@"Dtdata"][0][@"Percentage"]];
                int navigateScreen=[responce[@"Table1"][0][@"Screen"] intValue];
                CGFloat cent=[str_per floatValue]/100;
                if (cent>0.0000000) {
                    
                }
                else{
                }
                if ([str_per intValue]<100) {
                    [[SharedUtility sharedInstance]showAlertWithTitle:KTSuccessMsg forMessage:[NSString stringWithFormat:@"Your profile is not 100%% complete. Do you want to complete your profile to transact smoothly?"] andAction1:@"YES" andAction2:@"NO" andAction1Block:^{
                        [self moveToProfileScreenNavigate:navigateScreen];
                    } andCancelBlock:^{
                        
                    }];
                }else
                {
                    NSLog(@"%@",str_per);
                    NewPurchaseVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"NewPurchaseVC"];
                    KTPUSH(destination,YES);
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

-(void)moveToProfileScreenNavigate:(int)screenStage{
    ProfileVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"ProfileVC"];
    destination.navScreenStage=screenStage;
    destination.str_fromScreen=@"NavScreen";
    KTPUSH(destination,YES);
}

@end
