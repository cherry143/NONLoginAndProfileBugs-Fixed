//
//  PinPatternSetupVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 16/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "PinPatternSetupVC.h"

@interface PinPatternSetupVC ()<SCPinViewControllerCreateDelegate, SCPinViewControllerDataSource, SCPinViewControllerValidateDelegate,LockScreenDelegate>{
    __weak IBOutlet UIView *view_patternGround;
    __weak IBOutlet UIView *view_pinView;
    __weak IBOutlet UIButton *btn_pattern;
    __weak IBOutlet UIButton *btn_pin;
    __weak IBOutlet UIView *view_pattern;
    __weak IBOutlet UILabel *lbl_infoPattern;
}

@end

@implementation PinPatternSetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialiseMainView];
    [self inheritPatternView];
    [self addPatterntpView];
    [view_patternGround setHidden:YES];
    [view_pinView setHidden:NO];
    [view_pinView bringSubviewToFront:self.view];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"PinPatternSetUp"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialise View

-(void)initialiseMainView{
    [UIButton roundedCornerButtonWithoutBackground:btn_pin forCornerRadius:KTiPad?25.0f:btn_pin.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTWhiteColor];
    [UIButton roundedCornerButtonWithoutBackground:btn_pattern forCornerRadius:KTiPad?25.0f:btn_pattern.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
}

#pragma mark - adding view PIN View as a child of parent

-(void)inheritPatternView{
    SCPinAppearance *appearance = [SCPinAppearance defaultAppearance];
    SCPinViewController *vc;
    appearance.titleText = @"Set your 4 digit PIN to access KTrack instantly";
    [SCPinViewController setNewAppearance:appearance];
    vc = [[SCPinViewController alloc] initWithScope:SCPinViewControllerScopeCreate];
    vc.createDelegate = self;
    [self addChildViewController:vc];
    [view_pinView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
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
                [self LoginApiWithLoginMode:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginTypeKey] forUserName:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername] forPassword:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginPassword] forInvestorType:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginInvestor]];
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
    _infoLabelStatus = InfoStatusFirstTimeSetting;
    [self updateOutlook];
    [view_patternGround setHidden:NO];
    [view_pinView setHidden:YES];
    [btn_pin setBackgroundColor:KTButtonBackGroundBlue];
    [btn_pattern setBackgroundColor:KTWhiteColor];
    [btn_pin setTitleColor:KTWhiteColor forState:UIControlStateNormal];
    [btn_pattern setTitleColor:KTButtonBackGroundBlue forState:UIControlStateNormal];
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
                [XTAPP_DELEGATE deleteExistingTableRecords];
                [XTAPP_DELEGATE insertRecordIntoRespectiveTables:responce];
                [self moveToDashboard];
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
    KTPOP(YES);
}

#pragma mark - View Did Unload

- (void)viewDidUnload {
    // [ lbl_infoPattern:nil];
    [self setLockScreenView:nil];
    [super viewDidUnload];
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
                    [self LoginApiWithLoginMode:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginTypeKey] forUserName:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername] forPassword:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginPassword] forInvestorType:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginInvestor]];
                });
                
            }
            else {
                self.infoLabelStatus = InfoStatusFailedConfirm;
                [self updateOutlook];
            }
            break;
        case  InfoStatusNormal:
            if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPattern]]) {
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

#pragma mark - updateOutLook

- (void)updateOutlook {
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

#pragma mark - addPatternView

-(void)addPatterntpView{
    self.lockScreenView = [[SPLockScreen alloc]initWithFrame:CGRectMake(10, 20, view_pattern.bounds.size.width-10, view_pattern.bounds.size.width-20)];
    view_pattern .center = _lockScreenView .center;
    self.lockScreenView.delegate = self;
    self.lockScreenView.autoresizingMask = UIViewAutoresizingFlexibleHeight|
    UIViewAutoresizingFlexibleWidth;
    //  self.lockScreen.backgroundColor = [UIColor redColor];
    [view_pattern addSubview:self.lockScreenView];
    _infoLabelStatus = InfoStatusFirstTimeSetting;
    [self updateOutlook];
}

#pragma mark - back button Tapped

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

@end
