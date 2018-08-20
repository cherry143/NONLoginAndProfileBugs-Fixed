//
//  forgotPasswordVC.h
//  KTrack
//
//  Created by Ramakrishna MV on 12/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgotPasswordVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *EmailTf;
@property (weak, nonatomic) IBOutlet UITextField *otpTf;
@property (weak, nonatomic) IBOutlet UIButton *regenerateOtpBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *generateOtpBtn;
- (IBAction)generateAtc:(id)sender;
- (IBAction)submitAtc:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *otpViewline;
- (IBAction)regenerateotpAtc:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *otpView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UITextField *confPasswordTf;
- (IBAction)passwordSubmitAtc:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *chanagePasswordView;
@property (weak, nonatomic) IBOutlet UIButton *passSubmitBtn;
@end
