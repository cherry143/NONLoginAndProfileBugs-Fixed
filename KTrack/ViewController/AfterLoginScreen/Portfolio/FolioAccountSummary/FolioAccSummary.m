//
//  FolioAccSummary.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 24/07/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "FolioAccSummary.h"

@interface FolioAccSummary (){
    __weak IBOutlet UIWebView *webview_accountSummary;
}

@end

@implementation FolioAccSummary
@synthesize str_pdfFilePathUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:str_pdfFilePathUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webview_accountSummary loadRequest:urlRequest];
    webview_accountSummary.scalesPageToFit=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Back Button option

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *requestURL = [ request URL];
    if (([[requestURL scheme] isEqualToString: @"http"] || [[requestURL scheme] isEqualToString: @"https"]) && (navigationType == UIWebViewNavigationTypeLinkClicked)){
        // Your method when tap on url found in PDF
    }
    return YES;
}
@end
