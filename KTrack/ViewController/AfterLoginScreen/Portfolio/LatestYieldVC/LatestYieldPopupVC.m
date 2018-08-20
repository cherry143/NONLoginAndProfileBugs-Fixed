//
//  LatestYieldPopupVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 18/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "LatestYieldPopupVC.h"

@interface LatestYieldPopupVC (){
    __weak IBOutlet UIButton *btn_ok;
    __weak IBOutlet UIView *view_backView;
    __weak IBOutlet UILabel *lbl_xirrValue;
    __weak IBOutlet UILabel *lbl_annualizedReturn;
    __weak IBOutlet UILabel *lbl_absReturn;
}
@end

@implementation LatestYieldPopupVC
@synthesize latestYieldRec;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self applyButtonCornersToFields];
    [self loadValuesIntoFields:latestYieldRec];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load values into fields

-(void)loadValuesIntoFields:(NSDictionary *)responseDic{
    lbl_absReturn.text=[NSString stringWithFormat:@": %@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",responseDic[@"Absolute_Return"]]]];
    lbl_annualizedReturn.text=[NSString stringWithFormat:@": %@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",responseDic[@"Annualized_Return"]]]];
    lbl_xirrValue.text=[NSString stringWithFormat:@": %@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@", responseDic[@"XIRR"]]]];
}

#pragma mark - Button Corner

-(void)applyButtonCornersToFields{
    [UIButton roundedCornerButtonWithoutBackground:btn_ok forCornerRadius:KTiPad?25.0f:btn_ok.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIView roundedCornerEnableForView:view_backView forCornerRadius:10.0f forBorderWidth:1.5f forApplyShadow:NO];
    view_backView.layer.borderColor=[UIColor whiteColor].CGColor;
}

#pragma mark - ok button tapped

- (IBAction)btn_okTappe:(id)sender {
    KTHIDEREMOVEVIEW;
}

@end
