//
//  MissedCallMessageVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 10/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "MissedCallMessageVC.h"

@interface MissedCallMessageVC (){
    __weak IBOutlet UITextView *txtview_displayMsg;
}
@end

@implementation MissedCallMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    txtview_displayMsg.text=KTMissedCallMsg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SMS or Call Action

- (IBAction)btn_callSmsClicked:(id)sender {
     [self easyCall];
}

#pragma mark - call

- (IBAction)backAtc:(id)sender {
    KTPOP(YES);
}

-(void)easyCall{
    NSString *phoneNumber=@"09212993399";
    NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:phoneNumber]];
    NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]];
    if ([UIApplication.sharedApplication canOpenURL:phoneUrl]) {
        [UIApplication.sharedApplication openURL:phoneUrl];
    }
    else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl]) {
        [UIApplication.sharedApplication openURL:phoneFallbackUrl];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:KTDeviceDoesnotSupportCalls];
        });
    }
}

@end
