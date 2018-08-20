//
//  EasySmsVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 11/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "EasySmsVC.h"

@interface EasySmsVC ()<UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate>{
    __weak IBOutlet UITextView *txtview_displayMsg;
}
@end

@implementation EasySmsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [txtview_displayMsg setText:KTSendEasySmsMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - easy sms

- (IBAction)btn_easySmsClicked:(id)sender {
    [self sendSMS];
}

#pragma mark - MFMessageComposeDelegate Method

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:KTSMSSendFailureMsg];
            });
            break;
        }
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backAtc:(id)sender {
    KTPOP(YES);

    
}

#pragma mark - send SMS

-(void)sendSMS{
    if(![MFMessageComposeViewController canSendText]) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:KTSMSNotSupportedMsg];
        });
        return;
    }
    NSArray *recipents = @[@"09212993399"];
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [self presentViewController:messageController animated:YES completion:nil];
}

@end
