//
//  LoginVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 10/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "LoginVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface LoginVC ()<GIDSignInDelegate,GIDSignInUIDelegate,floatMenuDelegate>{
    __weak IBOutlet UIButton *btn_custSupport;
    NSString * randaomStr;
    __weak IBOutlet UIView *view_supportView;
    __weak IBOutlet NSLayoutConstraint *constrait_patpinBtnHeight;
    __weak IBOutlet NSLayoutConstraint *constraint_patpinbtnTop;
}
@property (strong, nonatomic) VCFloatingActionButton *addButton;
@end

@implementation LoginVC
@synthesize addButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addElements];
    if ([[[SharedUtility sharedInstance]readStringUserPreference:@"SwitchState"] isEqual:@"ON"]) {
         self.passwordTF.text=[[SharedUtility sharedInstance]readStringUserPreference:@"Password"];
         self.userNameTF.text=[[SharedUtility sharedInstance]readStringUserPreference:@"Email"];
         [_rememberBtn setImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    else{
         self.passwordTF.text=@"";
         self.userNameTF.text=@"";
        [_rememberBtn setImage: [UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width-44-15, [UIScreen mainScreen].bounds.size.height-40,35,35);
    addButton = [[VCFloatingActionButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"CustSupport"] andPressedImage:[UIImage imageNamed:@"CustSupport"] withScrollview:nil];
    addButton.imageArray = @[@"SupportCall",@"SupportQuery"];
    addButton.labelArray = @[@"Call Us",@"Raise A Query"];
    addButton.hideWhileScrolling = YES;
    addButton.delegate = self;
    [self.view addSubview:addButton];
    [self setTitle];
}

-(void)setTitle{
    [UIButton roundedCornerButtonWithoutBackground:_generateotpBtn forCornerRadius:KTiPad?25.0f:_generateotpBtn.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:KTViewControllerPin];
    BOOL isPatternSet = ([[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPattern]) ? YES: NO;
    if((isPatternSet==YES) && pin.length>0){
        [_signBypinBtn setTitle:@"LOGIN IN USING PIN/PATTERN" forState:UIControlStateNormal];
    }
    else if (pin.length>0) {
        [_signBypinBtn setTitle:@"LOGIN IN USING PIN" forState:UIControlStateNormal];
    }
    else{
        [_signBypinBtn setTitle:@"LOGIN IN USING PATTERN" forState:UIControlStateNormal];
    }
}

#pragma mark - viewWillLayoutSubviews

-(void)viewWillLayoutSubviews{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    NSString *str_loggedIn=[[SharedUtility sharedInstance]readStringUserPreference:KTLoginShowPatternPin];
    if (str_loggedIn.length!=0) {
        
    }
    else{
       [self.signBypinBtn setHidden:YES];
       [self increaseFrameHeight:0.0f];
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
#pragma mark Add  Elements

-(void)addElements{
    [view_supportView setHidden:YES];
    self.signupView.hidden = YES;
    self.signInAtc.hidden = NO;
    self.otpView.hidden = YES;

    [self.signInAtc.layer setCornerRadius:20.0f];
    [self.signInAtc.layer setMasksToBounds:YES];
    
    [self.signBypinBtn.layer setCornerRadius:20.0f];
    [self.signBypinBtn.layer setMasksToBounds:YES];

    [self.generateotpBtn.layer setCornerRadius:13.0f];
    [self.generateotpBtn.layer setMasksToBounds:YES];
    [self.enterOTPBtn.layer setCornerRadius:13.0f];
    [self.enterOTPBtn.layer setMasksToBounds:YES];
    [self.segmentControl.layer setCornerRadius:20.0f];
    self.segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
    self.segmentControl.layer.borderWidth = 2.0f;
    [self.segmentControl.layer setMasksToBounds:YES];
    
    [self.nonloginBtn.layer setCornerRadius:20.0f];
    self.nonloginBtn.layer.borderColor = [UIColor colorWithRed:0.01 green:0.36 blue:0.59 alpha:1.0].CGColor;
    self.nonloginBtn.layer.borderWidth = 2.0f;
    [self.nonloginBtn.layer setMasksToBounds:YES];
    
    [_passwordTF setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_emailTF setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_userNameTF setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [_fullNameTF setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [_signUppasswordTF setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [_signupReenterPasswordTF setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
}
#pragma mark Login  with  FaceBook

- (IBAction)faceBookLoginAtc:(id)sender {
    AppDelegate *delegateManager=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateManager.str_loginSocio=@"Facebook";
    [self fbLogin];
}

#pragma mark Login  with  Google

- (IBAction)googleLoginAtc:(id)sender {
    AppDelegate *delegateManager=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegateManager.str_loginSocio=@"Google";
    [self  googlePlusSign];
}

#pragma mark Forgot ID

- (IBAction)forgotIDAtc:(id)sender {
    ForgotUserIDVC * nonLogin =[self.storyboard instantiateViewControllerWithIdentifier:KTForgotUserIDViewController];
    KTPUSH(nonLogin, YES);
}



#pragma mark Forgot Password

- (IBAction)forgotPasswordAtc:(id)sender {
    forgotPasswordVC * nonLogin =[self.storyboard instantiateViewControllerWithIdentifier:KTForGotPasswordViewController];
    KTPUSH(nonLogin, YES);
    
    
}
#pragma mark Remember Me
- (IBAction)rememberAtc:(id)sender {
    if ([_rememberBtn.imageView.image isEqual: [UIImage imageNamed:@"uncheck"]])
    {
        [_rememberBtn setImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];

    }else{
        
        [_rememberBtn setImage: [UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    
}

#pragma mark Sign In 

- (IBAction)signInAtc:(id)sender {
    if ([self.userNameTF.text length] == 0 && [self.passwordTF.text length] == 0 ) {
        [self.userNameTF becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter Used ID/Email ID"];
    }
    else if ([self.userNameTF.text length] == 0) {
        [self.userNameTF becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter Used ID/Email ID"];
    }
    else if ([self.passwordTF.text length]==0) {
        [self.passwordTF becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter password"];
    }
    else{
        [self LoginApiWithLoginMode:@"" emailId:self.userNameTF.text];
    }
}

-(void)LoginApiWithLoginMode :(NSString*)loginMode emailId:(NSString *)email {
    [self.userNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    END_EDITING;
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_invertorType =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KtInvsertorType];
    NSString *str_userId =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:email];
    NSString *str_password;
    NSString *Str_LoginMode =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:loginMode];
    if ([loginMode isEqualToString:@"facebook"] || [loginMode isEqualToString:@"google"]) {
        str_password =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@""];
        [self insertValuesIntoUserDeafalutsForLoginType:loginMode forUserName:email forPassword:@"" forInvestor:KtInvsertorType];
    } else {
        
        if ([_rememberBtn.imageView.image isEqual: [UIImage imageNamed:@"uncheck"]]){
            [[SharedUtility sharedInstance]writeStringUserPreference:@"SwitchState" value:@"OFF"];
        }
        else{
            [[SharedUtility sharedInstance]writeStringUserPreference:@"SwitchState" value:@"ON"];
        }
        
        str_password =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:_passwordTF.text];
        [self insertValuesIntoUserDeafalutsForLoginType:loginMode forUserName:email forPassword:_passwordTF.text forInvestor:KtInvsertorType];
    }
    NSString *str_url = [NSString stringWithFormat:@"%@GetUserLoginnew_v17?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&username=%@&Password=%@&ReqBy=%@&loginMode=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_password,str_invertorType,Str_LoginMode];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error_statuscode==0) {
                [[APIManager sharedManager]hideHUD];
                 if ([loginMode isEqualToString:@"facebook"] || [loginMode isEqualToString:@"google"]) {
                      [self moveToDashboard:responce];
                 }
                 else{
                     [self checkUserIsAlreadyRegistered:responce];
                 }
            }
            else{
                [[APIManager sharedManager]hideHUD];
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                self.userNameTF.text=@"";
                _passwordTF.text=@"";
                [self.userNameTF becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:XTAPP_NAME withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Google SignIn

-(void)googlePlusSign{
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [[GIDSignIn sharedInstance] signIn];
}


- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        
    }
    else{
        [[GIDSignIn sharedInstance] signOut];
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        [self LoginApiWithLoginMode:@"google" emailId:email];
        NSLog(@"userID is %@;\nIdToken is %@;\nFullName is %@;\nGivenName is %@,\nFamilyName is %@,\nEmail is %@",userId,idToken,fullName,givenName,familyName,email);
    }
}

#pragma mark - Facebook Login

-(void)fbLogin{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithReadPermissions:@[@"public_profile",@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error){
            NSLog(@"Process error");
        }
        else if (result.isCancelled){
            NSLog(@"Process error");
        }
        if ([result.grantedPermissions containsObject:@"email"]){
            if ([FBSDKAccessToken currentAccessToken])
            {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me?fields=age_range,birthday,email,first_name,hometown,id,last_name,location,name,picture.type(large)" parameters:nil]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error){
                         NSLog(@"%@",result);
                         [self LoginApiWithLoginMode:@"facebook" emailId:result[@"email"]];
                     
                 }];
            }
        }
    }];
}
#pragma Mark Segment Atc
- (IBAction)SegmentControlAtc:(id)sender {
    if (_segmentControl.selectedSegmentIndex == 0){
        [addButton setHidden:NO];
        if ([[[SharedUtility sharedInstance]readStringUserPreference:@"SwitchState"] isEqual:@"ON"]) {
            
            
        }else{
            self.userNameTF.text =@"";
            self.passwordTF.text=@"";
        }
        self.signupView.hidden = YES;
        self.signINView.hidden =NO;
        self.otpView.hidden= YES;
        [self.signupView  bringSubviewToFront:self.view];
    }else{
        [addButton setHidden:YES];
        self.enterOTPTf.text =@"";
        self.signUppasswordTF.text =@"";
        self.signupReenterPasswordTF.text =@"";
        self.fullNameTF.text =@"";
        self.emailTF.text =@"";
        self.signINView.hidden = YES;
        self.signupView.hidden =NO;
        self.otpView.hidden= YES;
        [self.signupView  bringSubviewToFront:self.view];
    }
}

#pragma Mark locate Us Action

- (IBAction)locateUsAtc:(id)sender {
    LocateMeVC *destinyVC=[self.storyboard instantiateViewControllerWithIdentifier:KTLocateMeViewController];
    KTPUSH(destinyVC, YES);
    

}
#pragma Mark Missed call  Us Action
- (IBAction)missedCallAtc:(id)sender {
    MissedCallMessageVC *destinyVC=[self.storyboard instantiateViewControllerWithIdentifier:KTMissedCallMessageViewController];
    KTPUSH(destinyVC, YES);

}
#pragma Mark More  Action


- (IBAction)generateOTPAtc:(id)sender {
    NSString *Regex = @"[A-Za-z0-9^]*";
    NSPredicate *TestResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    BOOL validatepassword =[[SharedUtility sharedInstance]passwordIsValid:self.signUppasswordTF.text];
    NSCharacterSet *whitespace1 = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "];
    NSString *trimstr = [self.fullNameTF.text stringByTrimmingCharactersInSet:whitespace1];
    if([self.emailTF.text length] == 0){
        [self.emailTF becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter Email ID"];
    }
    else if ([[SharedUtility sharedInstance]validateEmailWithString:self.emailTF.text]!=YES) {
        [self.emailTF becomeFirstResponder];
        self.emailTF.text=@"";
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter valid Email ID"];
    }
    else if ([[SharedUtility sharedInstance]doesString:self.emailTF.text containString:@"@rediffmail.com"]==YES){
        [self.emailTF becomeFirstResponder];
        self.emailTF.text=@"";
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Currently rediffmail is not supported in the app. Kindly sign up with a different email ID."];
    }
    else if ([self.signUppasswordTF.text length] ==  0 ) {
        _signUppasswordTF.text=@"";
        [_signUppasswordTF becomeFirstResponder];
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter Password"];
    }
    else if ([_signUppasswordTF.text length]<8 ){
        [_signUppasswordTF becomeFirstResponder];
        _signUppasswordTF.text=@"";
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Password should contain atleast 8 characters"];
    }
    else if (validatepassword!= YES){
        [_signUppasswordTF becomeFirstResponder];
        _signUppasswordTF.text=@"";
        [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please Enter valid password"];
    }
    else if ([[SharedUtility sharedInstance]passwordIsValid:self.signUppasswordTF.text]==YES){
        BOOL conditionFailed=[TestResult evaluateWithObject:self.signUppasswordTF.text];
        if (conditionFailed==YES) {
            [self.signUppasswordTF becomeFirstResponder];
            [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please enter atleast one special character."];
        }
        else{
            if ( [self.signupReenterPasswordTF.text length] == 0){
                [self.signupReenterPasswordTF becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Please Re-enter  Password"];
            }
            else if (![self.signUppasswordTF.text isEqualToString:self.signupReenterPasswordTF.text]){
                [self.signupReenterPasswordTF becomeFirstResponder];
                [self.signupReenterPasswordTF setText:@""];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Password and Confirm Password should be same"];
            }
            else if ([self.fullNameTF.text length] == 0){
                [self.fullNameTF becomeFirstResponder];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@" Please Enter FullName"];
            }    else if ((!([trimstr length] == 0))){
                [self.fullNameTF becomeFirstResponder];
                self.fullNameTF.text=@"";
                [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Error" withMessage:@"Full name should not contain special characters"];
            }  else{
                [self SignUpAPIforSendiingOTP];
            }
        }
    }
}

-(void)SignUpAPIforSendiingOTP{
    END_EDITING;
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:self.emailTF.text];
    randaomStr= [NSString stringWithFormat:@"%d", [self getRandomNumberBetween:100000 to:900000]];
    NSLog(@"%@",randaomStr);
    NSString *str_otp =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:randaomStr];
    NSString *str_url = [NSString stringWithFormat:@"%@GetemailOtp_New?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&email=%@&otp=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_otp];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
             NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"DtData"][0][@"Error_Message"]];
                UIAlertController *altcontrol = [UIAlertController alertControllerWithTitle:KTSuccessMsg message:error_message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"ok"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {
                                                                     self.otpView.hidden= NO;
                                                                     self.signupView.hidden =YES;
                                                                     
                                                                     [self.enterOTPTf becomeFirstResponder];
                                                                     
                                                                     
                                                                 }];
                [altcontrol addAction:okaction];
                [self presentViewController:altcontrol animated:YES completion:nil];
                
               
            
                NSLog(@"%@",responce);
        
                
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:XTAPP_NAME withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

- (IBAction)signPinAtc:(id)sender {
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:KTViewControllerPin];
    PinPatternVC * destinationVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PinPatternVC"];
    if (pin.length==0) {
        destinationVC.str_fromScreen=@"CREATE";
    }
    else{
        destinationVC.str_fromScreen=@"SET";
    }
    [self.navigationController pushViewController:destinationVC animated:YES];
}

- (IBAction)enterOtpAtc:(id)sender {
    if([self.enterOTPTf.text length] == 0){
           [[SharedUtility sharedInstance]showAlertViewWithTitle:XTAPP_NAME withMessage:@"Please enter OTP"];
    }else if (![randaomStr isEqualToString:_enterOTPTf.text]){
        [[SharedUtility sharedInstance]showAlertViewWithTitle:XTAPP_NAME withMessage:@"Invalid OTP"];
    }else{
        [self submitOTP];
    }
}

-(void)submitOTP{
    END_EDITING;
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:self.emailTF.text];
    NSString *str_fullName =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:self.fullNameTF.text];
    NSString *str_password =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:self.signupReenterPasswordTF.text];
    NSString *str_pan =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@RegisterUser_Viaemailotp_New?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fname=%@&pwd=%@&mailid=%@&userid=%@&pan=%@&Lname=%@&Hintqstn=%@&HintAns=%@&dob=%@&mobile=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fullName,str_password,str_userId,str_userId,str_pan,str_pan,str_pan,str_pan,str_pan,str_pan];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                
                UIAlertController *altcontrol = [UIAlertController alertControllerWithTitle:KTSuccessMsg message:error_message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"ok"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {
                                                                     self.signupView.hidden = YES;
                                                                     self.signINView.hidden =NO;
                                                                     self.otpView.hidden= YES;
                                                                     self.emailTF.text =@"";
                                                                     self.signupReenterPasswordTF.text =@"";
                                                                     self.signUppasswordTF.text =@"";
                                                                     _fullNameTF.text =@"";
                                                                     _enterOTPTf.text =@"";
                                                                     self.segmentControl.selectedSegmentIndex =0;
                                           }];
                [altcontrol addAction:okaction];
                [self presentViewController:altcontrol animated:YES completion:nil];
                NSLog(@"%@",responce);
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:XTAPP_NAME withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (IBAction)regenerataAtc:(id)sender {
    
    self.enterOTPTf.text =@"";
       [self SignUpAPIforSendiingOTP];
    
}
- (IBAction)nonloginAtc:(id)sender {
    NonLoginVC * nonLogin =[self.storyboard instantiateViewControllerWithIdentifier:@"NonLoginVC"];
    KTPUSH(nonLogin, YES);
}

- (IBAction)agreetc:(id)sender {
    
    TermsVC * nonLogin =[self.storyboard instantiateViewControllerWithIdentifier:@"TermsVC"];
    KTPUSH(nonLogin, YES);
}

#pragma mark - Keep username password and login type

-(void)insertValuesIntoUserDeafalutsForLoginType:(NSString *)loginType forUserName:(NSString *)username forPassword:(NSString *)password forInvestor:(NSString *)investor{
    [[SharedUtility sharedInstance]writeStringUserPreference:KTLoginTypeKey value:loginType];
    [[SharedUtility sharedInstance]writeStringUserPreference:KTLoginUsername value:username];
    [[SharedUtility sharedInstance]writeStringUserPreference:KTLoginPassword value:password];
    [[SharedUtility sharedInstance]writeStringUserPreference:KTLoginInvestor value:investor];
}

#pragma mark - Increase Table height

-(void)increaseFrameHeight:(CGFloat)height {
    constraint_patpinbtnTop.active = YES;
    constraint_patpinbtnTop.constant =height;
    constrait_patpinBtnHeight.active = YES;
    constrait_patpinBtnHeight.constant =height;
}

#pragma mark - move to DashBoard

-(void)moveToDashboard:(NSDictionary *)dicResponse{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XTAPP_DELEGATE deleteExistingTableRecords];
            [XTAPP_DELEGATE insertRecordIntoRespectiveTables:dicResponse];
            dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dashBoardScreen];
                });
            });
        });
    });
}

-(void)dashBoardScreen{
    PortfolioVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"PortfolioVC"];
    KTPUSH(destination,YES);
}

-(void)checkUserIsAlreadyRegistered:(NSDictionary *)responce{
    NSString *emailID=[[SharedUtility sharedInstance]removeNullFromStr:[[SharedUtility sharedInstance]readStringUserPreference:@"Email"]];
    emailID=TRIMWHITESPACE(emailID);
    NSString *str_userEnterEmail=TRIMWHITESPACE(self.userNameTF.text);
    if([emailID compare:str_userEnterEmail
             options: NSCaseInsensitiveSearch] == NSOrderedSame){
        [self moveToDashboard:responce];
    }
    else{
        [[SharedUtility sharedInstance]clearStringFromUserPreference:KTOncePinPatternSkipped];
        [[SharedUtility sharedInstance]clearStringFromUserPreference:KTViewControllerPin];
        [[SharedUtility sharedInstance]clearStringFromUserPreference:kCurrentPattern];
        [[SharedUtility sharedInstance]clearStringFromUserPreference:KTLoginShowPatternPin];
        NSString *skipped=[[SharedUtility sharedInstance]readStringUserPreference:KTOncePinPatternSkipped];
        if ([skipped isEqualToString:@"Skipped"] || [skipped isEqual:@"Skipped"]) {
            [self moveToDashboard:responce];
        }
        else{
            [[SharedUtility sharedInstance]writeStringUserPreference:@"Email" value:_userNameTF.text];
            [[SharedUtility sharedInstance]writeStringUserPreference:@"Password" value:_passwordTF.text];
            NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:KTViewControllerPin];
            PinPatternVC * destinationVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PinPatternVC"];
            if (pin.length==0) {
                destinationVC.str_fromScreen=@"CREATE";
                destinationVC.dic_response=responce;
            }
            else{
                destinationVC.str_fromScreen=@"SET";
            }
            [self.navigationController pushViewController:destinationVC animated:YES];
        }
    }
}

#pragma mark - Button Actions

- (IBAction)btn_raiseQueryTapped:(UIButton *)sender {
    [btn_custSupport setSelected:NO];
    [view_supportView setHidden:YES];
    RaiseQueryNonLoginVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"RaiseQueryNonLoginVC"];
    KTPUSH(destination,YES);
}

- (IBAction)btn_custSupport:(UIButton *)sender {
    if ([sender isSelected]==YES) {
        [view_supportView setHidden:YES];
        [sender setSelected:NO];
    }else{
        [view_supportView setHidden:NO];
        [sender setSelected:YES];
    }
}

- (IBAction)btn_callUsTapped:(id)sender {
    
}

-(void) didSelectMenuOptionAtIndex:(NSInteger)row {
    if (row==0) {
        [btn_custSupport setSelected:NO];
        [view_supportView setHidden:YES];
        NSString *phoneNumber=@"18004197744";
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
    else if (row==1){
        RaiseQueryNonLoginVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"RaiseQueryNonLoginVC"];
        KTPUSH(destination,YES);
    }
}

#pragma mark - Back Button Tapped

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==_enterOTPTf) {
        if (_enterOTPTf.text.length>=6 && range.length == 0){
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

// return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

// called when clear button pressed. return NO to ignore (no notifications)

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextField Delegate Ends
@end
