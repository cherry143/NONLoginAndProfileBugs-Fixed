//
//  PinPatternVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 18/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "PinPatternVC.h"

@interface PinPatternVC ()<SCPinViewControllerCreateDelegate, SCPinViewControllerDataSource, SCPinViewControllerValidateDelegate,LockScreenDelegate>{
    __weak IBOutlet UIButton *btn_signInUsername;
    __weak IBOutlet UIView *view_patternGround;
    __weak IBOutlet UIButton *btn_nonLogin;
    __weak IBOutlet UIView *view_pinView;
    __weak IBOutlet UIButton *btn_pattern;
    __weak IBOutlet UIButton *btn_pin;
    __weak IBOutlet UIView *view_pattern;
    __weak IBOutlet UILabel *lbl_infoPattern;
}

@end

@implementation PinPatternVC
@synthesize str_fromScreen;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseMainView];
    [self inheritPatternView];
    [self addPatterntpView];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:KTViewControllerPin];
    if ([pin length]!=0) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kCurrentPattern] !=0){
            [view_patternGround setHidden:YES];
            [view_pinView setHidden:NO];
            [view_pinView bringSubviewToFront:self.view];
        }else{
             [btn_pattern setHidden:YES];
             [view_patternGround setHidden:YES];
        }
    }else{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kCurrentPattern] !=0){
            [btn_signInUsername setHidden:NO];
            [btn_nonLogin setHidden:NO];
            [btn_pin setHidden:YES];
            [view_pinView setHidden:YES];
            [view_patternGround setHidden:NO];
            [btn_pattern setBackgroundColor:KTWhiteColor];
            [btn_pattern setTitleColor:KTButtonBackGroundBlue forState:UIControlStateNormal];
    
        }else{
            [btn_signInUsername setHidden:YES];
            [view_patternGround setHidden:YES];
            [view_pinView setHidden:NO];
            [view_pinView bringSubviewToFront:self.view];
        }
    }
    
    NSString *userName = [[SharedUtility sharedInstance]readStringUserPreference:KTLoginShowPatternPin];
    if (userName.length!=0) {
        [btn_signInUsername setHidden:NO];
    }
    else{
        [btn_nonLogin setAttributedTitle:[UIButton underlineForButton:@"SKIP PIN/PATTERN" forAttributedColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn_signInUsername setHidden:YES];
    }
}

#pragma mark - viewWillLayoutSubviews

-(void)viewWillLayoutSubviews{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark - Initialise View

-(void)initialiseMainView{
    [UIButton roundedCornerButtonWithoutBackground:btn_pin forCornerRadius:KTiPad?25.0f:btn_pin.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTWhiteColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_pattern forCornerRadius:KTiPad?25.0f:btn_pattern.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
}

#pragma mark - adding view PIN View as a child of parent

-(void)inheritPatternView{
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:KTViewControllerPin];
    if ([pin length]==0) {
        [btn_signInUsername setHidden:YES];
        SCPinAppearance *appearance = [SCPinAppearance defaultAppearance];
        SCPinViewController *vc;
        appearance.titleText = @"Set your 4 digit PIN to access KTrack instantly";
        appearance.titleTextFont=KTFontFamilySize(KTOpenSansRegular,12);
        appearance.titleTextColor=[UIColor whiteColor];
        [SCPinViewController setNewAppearance:appearance];
        vc = [[SCPinViewController alloc] initWithScope:SCPinViewControllerScopeCreate];
        vc.createDelegate = self;
        [self addChildViewController:vc];
        [view_pinView addSubview:vc.view];
        [vc didMoveToParentViewController:self];
    }
    else{
        [btn_signInUsername setHidden:NO];
        [btn_nonLogin setHidden:NO];
        SCPinViewController *vc;
        SCPinAppearance *appearance = [SCPinAppearance defaultAppearance];
        appearance.numberButtonstrokeEnabled = NO;
        appearance.titleText = @"Enter 4 Digits Login PIN";
        appearance.titleTextFont=KTFontFamilySize(KTOpenSansRegular,12);
        appearance.titleTextColor=[UIColor whiteColor];
        [SCPinViewController setNewAppearance:appearance];
        vc = [[SCPinViewController alloc] initWithScope:SCPinViewControllerScopeValidate];
        vc.dataSource = self;
        vc.validateDelegate = self;
        [self addChildViewController:vc];
        [view_pinView addSubview:vc.view];
        [vc didMoveToParentViewController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pinViewController:(SCPinViewController *)pinViewController didSetNewPin:(NSString *)pin {
    NSLog(@"pinViewController: %@",pinViewController);
    [[NSUserDefaults standardUserDefaults] setObject:pin forKey:KTViewControllerPin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[SharedUtility sharedInstance]writeStringUserPreference:KTLoginShowPatternPin value:@"LoggedIn"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SharedUtility sharedInstance]showAlertWithTitle:@"Message" forMessage:@"Do you want to set pattern" andAction1:@"YES" andAction2:@"NO" andAction1Block:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [view_patternGround setHidden:NO];
                [view_pinView setHidden:YES];
                [btn_pin setBackgroundColor:KTButtonBackGroundBlue];
                [btn_pattern setBackgroundColor:KTWhiteColor];
                [btn_pin setTitleColor:KTWhiteColor forState:UIControlStateNormal];
                [btn_pattern setTitleColor:KTButtonBackGroundBlue forState:UIControlStateNormal];
            });
        } andCancelBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_group_t group = dispatch_group_create();
                dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XTAPP_DELEGATE deleteExistingTableRecords];
                        [XTAPP_DELEGATE insertRecordIntoRespectiveTables:_dic_response];
                        dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self moveToDashboard];
                            });
                        });
                    });
                });
            });
        }];
    });
}


-(NSInteger)lengthForPin {
    return 4;
}

-(NSString *)codeForPinViewController:(SCPinViewController *)pinViewController {
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:KTViewControllerPin];
    return pin;
}

-(BOOL)hideTouchIDButtonIfFingersAreNotEnrolled {
    return YES;
}

-(BOOL)showTouchIDVerificationImmediately {
    return NO;
}

-(void)pinViewControllerDidSetWrongPin:(SCPinViewController *)pinViewController {

}

-(void)pinViewControllerDidSetСorrectPin:(SCPinViewController *)pinViewController{
    [self LoginApiWithLoginMode:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginTypeKey] forUserName:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername] forPassword:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginPassword] forInvestorType:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginInvestor]];
}

- (void)pinViewControllerDidCancel:(SCPinViewController *)pinViewController {
    
}

#pragma mark Pattern

-(void)addPatternToView{
    
}

#pragma mark - Pin Action

- (IBAction)btn_pinTapped:(id)sender {
    [view_pinView setHidden:NO];
    [view_patternGround setHidden:YES];
    [btn_pin setBackgroundColor:KTWhiteColor];
    [btn_pattern setBackgroundColor:KTButtonBackGroundBlue];
    [btn_pin setTitleColor:KTButtonBackGroundBlue forState:UIControlStateNormal];
    [btn_pattern setTitleColor:KTWhiteColor forState:UIControlStateNormal];
}

- (IBAction)btn_patternTapped:(id)sender {
    BOOL isPatternSet = ([[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPattern]) ? YES: NO;
    if( isPatternSet){
        _infoLabelStatus = InfoStatusNormal;
    }else{
        _infoLabelStatus = InfoStatusFirstTimeSetting;
        
    }
    [self updateOutlook];
    [view_patternGround setHidden:NO];
    [view_pinView setHidden:YES];
    [btn_pin setBackgroundColor:KTButtonBackGroundBlue];
    [btn_pattern setBackgroundColor:KTWhiteColor];
    [btn_pin setTitleColor:KTWhiteColor forState:UIControlStateNormal];
    [btn_pattern setTitleColor:KTButtonBackGroundBlue forState:UIControlStateNormal];
}

- (IBAction)btn_nonLogicServicesTapped:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"NON-LOGIN SERVICES"]) {
        NonLoginVC * nonLogin =[self.storyboard instantiateViewControllerWithIdentifier:@"NonLoginVC"];
        KTPUSH(nonLogin, YES);
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]writeStringUserPreference:KTOncePinPatternSkipped value:@"Skipped"];
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XTAPP_DELEGATE deleteExistingTableRecords];
                    [XTAPP_DELEGATE insertRecordIntoRespectiveTables:_dic_response];
                    dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self moveToDashboard];
                        });
                    });
                });
            });
        });
    }
}

- (IBAction)btn_signInUserNameTapped:(UIButton *)sender {
    LoginVC *destination=[KTHomeStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"LoginVC"];
    KTPUSH(destination,YES);
}

- (void)updateOutlook
{
    switch (self.infoLabelStatus) {
        case InfoStatusFirstTimeSetting:
         lbl_infoPattern.text = @"Create  Your Pattern !";
            break;
        case InfoStatusConfirmSetting:
            lbl_infoPattern.text = @"Confirm Your Pattern !";
            break;
        case InfoStatusFailedConfirm:
        lbl_infoPattern.text = @"Failed to confirm, please retry";
            break;
        case InfoStatusNormal:
          lbl_infoPattern.text = @"Draw pattern to go in";
            break;
        case InfoStatusFailedMatch:
          lbl_infoPattern.text = @"Worng Pattern ";
            break;
        case InfoStatusSuccessMatch:
            lbl_infoPattern.text = @"";
            break;
            
        default:
            break;
    }
}

#pragma Mark AddPatternView
    
-(void)addPatterntpView{
        self.lockScreenView = [[SPLockScreen alloc]initWithFrame:CGRectMake(10, 20, view_pattern.bounds.size.width-10, view_pattern.bounds.size.width-20)];
        view_pattern .center = _lockScreenView .center;
        self.lockScreenView.delegate = self;
        self.lockScreenView.autoresizingMask = UIViewAutoresizingFlexibleHeight|
        UIViewAutoresizingFlexibleWidth;
        //  self.lockScreen.backgroundColor = [UIColor redColor];
        [view_pattern addSubview:self.lockScreenView];
        BOOL isPatternSet = ([[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPattern]) ? YES: NO;
        if( isPatternSet){
            _infoLabelStatus = InfoStatusNormal;
        }else{
            _infoLabelStatus = InfoStatusFirstTimeSetting;

        }
        [self updateOutlook];
}

#pragma -LockScreenDelegatePatternVC

- (void)lockScreen:(SPLockScreen *)lockScreen didEndWithPattern:(NSNumber *)patternNumber
{
    NSUserDefaults *stdDefault = [NSUserDefaults standardUserDefaults];
    switch (self.infoLabelStatus) {
        case InfoStatusFirstTimeSetting:
            [stdDefault setValue:patternNumber forKey:kCurrentPatternTemp];
            self.infoLabelStatus = InfoStatusConfirmSetting;
            [self updateOutlook];
            break;
        case InfoStatusFailedConfirm:
            [stdDefault setValue:patternNumber forKey:kCurrentPatternTemp];
            self.infoLabelStatus = InfoStatusConfirmSetting;
            [self updateOutlook];
            break;
        case InfoStatusConfirmSetting:
            if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPatternTemp]]) {
            [stdDefault setValue:patternNumber forKey:kCurrentPattern];
            self.infoLabelStatus = InfoStatusSuccessMatch;
            [self updateOutlook];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[SharedUtility sharedInstance]writeStringUserPreference:KTLoginShowPatternPin value:@"LoggedIn"];
                    dispatch_group_t group = dispatch_group_create();
                    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [XTAPP_DELEGATE deleteExistingTableRecords];
                            [XTAPP_DELEGATE insertRecordIntoRespectiveTables:_dic_response];
                            dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self moveToDashboard];
                                });
                            });
                        });
                    });
                });
                
            }
            else {
                self.infoLabelStatus = InfoStatusFailedConfirm;
                [self updateOutlook];
            }
            break;
        case  InfoStatusNormal:
            if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPattern]])
            {
               
                self.infoLabelStatus = InfoStatusSuccessMatch;;
                 [self updateOutlook];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self LoginApiWithLoginMode:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginTypeKey] forUserName:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername] forPassword:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginPassword] forInvestorType:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginInvestor]];
                                    
                });
            }
            else {
                self.infoLabelStatus = InfoStatusFailedMatch;
                self.infoLabelStatus = InfoStatusFailedMatch;;
                [self updateOutlook];
             
            }
            break;
        case InfoStatusFailedMatch:
            if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPattern]]) {
                [self updateOutlook];
                self.infoLabelStatus = InfoStatusSuccessMatch;;
                [self updateOutlook];
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self LoginApiWithLoginMode:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginTypeKey] forUserName:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername] forPassword:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginPassword] forInvestorType:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginInvestor]];
                });
              
            }
            else {
                
                self.infoLabelStatus = InfoStatusFailedMatch;
                [self updateOutlook];
            }
            break;
        
          
            
        default:
            break;
    }
}

- (void)viewDidUnload {
   // [ lbl_infoPattern:nil];
    [self setLockScreenView:nil];
    [super viewDidUnload];
}

#pragma mark - call LoginAPI

-(void)LoginApiWithLoginMode:(NSString*)loginType forUserName:(NSString *)username forPassword:(NSString *)password forInvestorType:(NSString *)investorType {
    END_EDITING;
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_invertorType =[XTAPP_DELEGATE convertToBase64StrForAGivenString:investorType];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:username];
    NSString *str_LoginMode =[XTAPP_DELEGATE convertToBase64StrForAGivenString:loginType];
    NSString *str_password=[XTAPP_DELEGATE convertToBase64StrForAGivenString:password];
    NSString *str_url = [NSString stringWithFormat:@"%@GetUserLoginnew_v17?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&username=%@&Password=%@&ReqBy=%@&loginMode=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId,str_password,str_invertorType,str_LoginMode];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                dispatch_group_t group = dispatch_group_create();
                dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XTAPP_DELEGATE deleteExistingTableRecords];
                        [XTAPP_DELEGATE insertRecordIntoRespectiveTables:responce];
                        dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self moveToDashboard];
                            });
                        });
                    });
                });
            });
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:XTAPP_NAME withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Move To DashBoard

-(void)moveToDashboard{
    PortfolioVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"PortfolioVC"];
    KTPUSH(destination,YES);
}

@end

