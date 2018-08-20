//
//  AadhaarValidateVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 05/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "AadhaarValidateVC.h"

@interface AadhaarValidateVC (){
    __weak IBOutlet UIWebView *webview_aadhaarValidate;
}
@end

@implementation AadhaarValidateVC
@synthesize str_aadhaarValidateURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUrlInWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Back  Button Action

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

-(void)loadUrlInWebView{
    NSURL *url = [NSURL URLWithString:str_aadhaarValidateURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webview_aadhaarValidate loadRequest:requestObj];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = [request URL];
    if ([URL.absoluteString rangeOfString:KTAadhaarValidationSuccess].location != NSNotFound) {
        NSRange range = [URL.absoluteString rangeOfString:@"=" options: NSBackwardsSearch];
        NSString *newString = [URL.absoluteString substringFromIndex:(range.location+1)];
        NSDictionary *dic=@{@"OriginalUrl":URL.absoluteString,@"ReferenceNo":newString,@"Response":@"Success"};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ValidateAadhaar" object:dic];
        KTPOP(YES);
    } else if ([URL.absoluteString rangeOfString:KTAadhaarValidationFailure].location != NSNotFound) {
        NSDictionary *dic=@{@"Response":@"Failure"};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ValidateAadhaar" object:dic];
        KTPOP(YES);
    }
    return YES;
}

#pragma mark - viewDidDisappear

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ValidateAadhaar" object:nil];
}

@end
