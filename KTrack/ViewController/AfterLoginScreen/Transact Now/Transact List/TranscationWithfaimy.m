//
//  TranscationWithfaimy.m
//  KTrack
//
//  Created by Ramakrishna MV on 10/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "TranscationWithfaimy.h"

@interface TranscationWithfaimy (){
    __weak IBOutlet UIButton *btn_swp;
    __weak IBOutlet UIButton *btn_sip;
    __weak IBOutlet UIButton *btn_switch;
    __weak IBOutlet UIButton *btn_redemption;
    __weak IBOutlet UIButton *btn_additionalPurchase;
    __weak IBOutlet UIButton *btn_STP;
}


@end

@implementation TranscationWithfaimy


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self cornerRadiusOnViewLoad];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"TransactinFamilyFolios"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - corner Radius To button

-(void)cornerRadiusOnViewLoad{
    
    [UIButton roundedCornerButtonWithoutBackground:btn_sip forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_swp forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_switch forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_redemption forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_additionalPurchase forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
        [UIButton roundedCornerButtonWithoutBackground:btn_STP forCornerRadius:10.0f forBorderWidth:1.5f forBorderColor:KTButtonBorderColorDiff forBackGroundColor:KTClearColor];
}

#pragma mark - Button Action

- (IBAction)Atc_sip:(id)sender {
    
    
    
}
- (IBAction)Atc_AddPurchase:(id)sender {
    AddPurchaseFamilyVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"AddPurchaseFamilyVC"];
    KTPUSH(destination,YES);
}

- (IBAction)atc_Redempton:(id)sender {
    RedemptonWithFamliy *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"RedemptonWithFamliy"];
    KTPUSH(destination,YES);
}

- (IBAction)atc_Switch:(id)sender {
    SwitchWithfamliyVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SwitchWithfamliyVC"];
    KTPUSH(destination,YES);
}

- (IBAction)btn_swpTapped:(id)sender {
    FamilySWPViewController  *controller=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"FamilySWPViewController"];
    KTPUSH(controller,YES);
}

- (IBAction)atc_SIP:(id)sender {
    SIPFamilyVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"SIPFamilyVC"];
    KTPUSH(destination,YES);
} 

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

@end
