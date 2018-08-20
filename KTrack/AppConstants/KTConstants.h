//
//  KTConstants.h
//  KTrack
//
//  Created by mnarasimha murthy on 10/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#ifndef KTConstants_h
#define KTConstants_h
#define STRING_NO_INTERNET                      @"No Internet Connection!"

#define XTAPP_NAME                                @"KTrack"

#ifdef __OBJC__
#import "AppDelegate.h"
#define XTAPP_DELEGATE         ((AppDelegate*)[[UIApplication sharedApplication]delegate])
#endif

#define KTBorderColor            [UIColor colorWithHexString:@"#035D97"]
#define KTButtonBackGroundBlue   [UIColor colorWithHexString:@"#0168AA"]
#define KTClearColor             [UIColor clearColor]
#define KTWhiteColor             [UIColor whiteColor]
#define KTDarkGreyColor          [UIColor darkGrayColor]
#define KTPieChartLiquidColor    [UIColor colorWithHexString:@"#8AAC48"]
#define KTPieChartEquityColor    [UIColor colorWithHexString:@"#AC3A38"]
#define KTPieChartDebtColor      [UIColor colorWithHexString:@"#3970B1"]
#define KTButtonNotSelectedColor [UIColor colorWithHexString:@"#E9EAEB"]
#define KT_TopStatusBar          [UIColor colorWithHexString:@"#004878"]

#define KTTableHeaderColor       [UIColor colorWithHexString:@"#C7C7C7"]
#define KTButtonBorderColorDiff  [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25]
#define KTProgressUnFill         [UIColor whiteColor]

// Depricated UIAertView

#define KTTextColorGreen         [UIColor colorWithHexString:@"#8AAC41"]
#define KTTextColorBrown         [UIColor colorWithHexString:@"#B03835"]
#define KTIncompleteStatusColor  [UIColor colorWithHexString:@"#FF0000"]


#define XTALERT(title, detail)        [[[UIAlertView alloc] initWithTitle:title \
message:detail \
delegate:nil \
cancelButtonTitle:@"OK" \
otherButtonTitles:nil] show]

// Font style type constant

#define KTOpenSansSemiBold             @"OpenSans-SemiBold"
#define KTOpenSansRegular              @"OpenSans-Regular"

// Screen height and width

#define KTScreenHeight fabs((double)[[UIScreen mainScreen]bounds].size.height)
#define KTScreenWidth fabs((double)[[UIScreen mainScreen]bounds].size.width)

// Check whether device is iPad

#define KTiPad  [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad

// Status bar height

#define KTStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//NavigationBar Height
#define KTNavigationBarHeight self.navigationController.navigationBar.bounds.size.height

// UIFonts Size along with font family

#define KTFontFamilySize(fFamily,fSize) [UIFont fontWithName:fFamily size:fSize]

// Check System Version

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// DateFormat

#define XTDateFormat                       @"yyyy-MM-dd'T'HH:mm:ss"
#define XTOnlyDateFormat                   @"MM/dd/yyyy"
#define XTOnlyTimeFormat                   @"HH:mm"
#define XTOnlyMonthYearFormat              @"MMM-yyyy"
#define XTServerDateFormat                 @"dd/mm/yyyy"

#define KTPUSH(controller,animate)            [self.navigationController pushViewController:controller animated:animate]
#define KTPOP_ROOT(animate)                   [self.navigationController popToRootViewControllerAnimated:animate]
#define KTPOP(animated)                       [self.navigationController popViewControllerAnimated:animated]
#define KTHIDE_NAV                            self.navigationController.navigationBarHidden = YES
#define KTHIDEREMOVEVIEW                      [self.view removeFromSuperview];
#define KTPRESENTDISMISS(animated)            [self dismissViewControllerAnimated:animated completion:nil]
#define KTPRESENTVIEW(controller,animate)     [self.navigationController presentViewController:controller animated:animate completion:nil]
#define KTHomeStoryboard(storyboardname)      [UIStoryboard storyboardWithName:storyboardname bundle:nil]

#define KTLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define END_EDITING                         [self.view endEditing:YES]
#define TRIMWHITESPACE(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

//Base url

#define KTLiveBase_URL                           @""
#define KTLocalBase_URL                          @"https://api.karvymfs.com/22New/SmartService.svc/"

// Common Strings that are used in the application
#define KtInvsertorType  @"i"
#define KTInternetConnectionFailure              @"Connection Error"
#define KTInternetConnectionFailureMsg           @"Please check the internet connectivity"
#define KTSelectCity                             @"Select City"
#define KTMissedCall                             @"Missed Call"
#define KTEasySms                                @"Easy SMS"
#define KTSendEasySmsMsg                         @"Click here to send an sms to get your investment details as SMS, if this mobile number is registered with us for your investments."
#define KTMissedCallMsg                          @"Click here to give a missed call to us to get your investment details as SMS (free of cost), if this mobile number is registered with us, for your investments."
#define KTError                                  @"Error"
#define KTDeviceDoesnotSupportCalls              @"This device doesn't support making of calls"
#define KTSMSSendFailureMsg                      @"Failed to send SMS."
#define KTSMSNotSupportedMsg                     @"Your device doesn't support SMS."
#define KTSuccessMsg                             @"Success"
#define KTMessage                                @"Message"
#define KTNoFoliosAssociatedMsg                  @"There are no folios associated with login email ID. Do you want to fetch your folios using mobile number?"
#define KTEnteryourmobileNumber                  @"Enter your mobile number."
#define KTNoDataFoundMsg                         @"No data found."
#define KTOTPNumberMsg                           @"OTP Number"
#define KTCancelMsg                              @"Cancel"
#define KTSubmitMsg                              @"Submit"
#define KTNoPortfolioHoldingMsg                  @"Currently there are no Investments"
#define KTConsolidatedStatementMsg               @"You can use this service to receive a consolidated statement of account at your registered email address, if you have registered a commom email id across folios and funds serviced by Karvy, CAMS, FT MAIL and Sundaram."

#define KTUniqueUDID        [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define KTOperationSystem                        @"IOS"
#define KTAppVersion        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// Contact String

#define KTGoogleClientID                         @"329652861039-0uvl2bm5qpocj0ifktcehh1jabm770vj.apps.googleusercontent.com"

// ViewController StoryBoardNames
#
#define KTLocateMeViewController                    @"LocateMeVC"
#define KTMissedCallMessageViewController           @"MissedCallMessageVC"
#define KTEasySMSViewController                     @"EasySmsVC"
#define KTShowBranchDetailsListViewController       @"ShowBranchDetailsListVC"
#define KTForgotUserIDViewController                @"ForgotUserIDVC"
#define KTKnowYourTransactionVC                     @"KnowYourTransactionVC"
#define KTForGotPasswordViewController              @"forgotPasswordVC"

#define KTCommonAccountStatementViewController      @"CASVC"
#define KTDetailedPortfolioViewController           @"DetailedPortfolioVC"

#define KTLoginTypeKey                          @"LoginType"
#define KTLoginUsername                         @"UserName"
#define KTLoginPassword                         @"LoginPassword"
#define KTLoginUserEmailID                      @"LoginEmail"
#define KTLoginUserNameKey                      @"LoginUserName"
#define KTLoginInvestor                         @"Investor"
#define KTLoginShowPatternPin                   @"ShowPatternPinButton"

// TableView and Collection View ResuseIdenfier

#define KTBranchDetailsCell                         @"BranchDetailsCell"
#define KTKYTDetailsCell                            @"KYTDetailsCell"

#define KTViewControllerPin                         @"kViewControllerPin"

// API Base Url

#define KTBaseurl                                   @"https://api.karvymfs.com/25/SmartService.svc/"

#define kCurrentPattern                             @"KeyForCurrentPatternToUnlock"
#define kCurrentPatternTemp                         @"KeyForCurrentPatternToUnlockTemp"

#define KTFetchFolioThroughMobileNo                 @"NoFolioOnMobileNumber"
#define KTOncePinPatternSkipped                     @"SkippedPinPattern"

#define KTParentView                                @"Parent"
#define KTChildView                                 @"ChildView"
#define KTSubChildView                              @"FolioView"

#define KTAadhaarValidationSuccess                  @"https://www.karvymfs.com/ckyc/success.aspx"
#define KTAadhaarValidationFailure                  @"https://www.karvymfs.com/ckyc/failure.aspx"

#define KTImageBase_url                             @"https://www.karvymfs.com/karvy"
#define MAX_LENGTH 15

#endif /* KTConstants_h */



