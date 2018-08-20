//
//  LoginVC.h
//  KTrack
//
//  Created by Ramakrishna MV on 10/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController
- (IBAction)SegmentControlAtc:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)faceBookLoginAtc:(id)sender;
- (IBAction)googleLoginAtc:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
- (IBAction)forgotIDAtc:(id)sender;
- (IBAction)forgotPasswordAtc:(id)sender;
- (IBAction)rememberAtc:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signInAtc;
@property (weak, nonatomic) IBOutlet UIView *signINView;
- (IBAction)signInAtc:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *signupView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UIView *otpView;
@property (weak, nonatomic) IBOutlet UIButton *rememberBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *signUppasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *signupReenterPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTF;
- (IBAction)generateOTPAtc:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *generateotpBtn;
@property (weak, nonatomic) IBOutlet UIButton *enterOTPBtn;
@property (weak, nonatomic) IBOutlet UIButton *signBypinBtn;
@property (weak, nonatomic) IBOutlet UITextField *enterOTPTf;
- (IBAction)signPinAtc:(id)sender;

- (IBAction)enterOtpAtc:(id)sender;
- (IBAction)regenerataAtc:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nonloginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hieghtConst;
- (IBAction)nonloginAtc:(id)sender;
- (IBAction)agreetc:(id)sender;
@end
