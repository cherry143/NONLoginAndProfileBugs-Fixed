//
//  LinkAadhaarFamilyFolioVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 01/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "LinkAadhaarFamilyFolioVC.h"

@interface LinkAadhaarFamilyFolioVC (){
     __weak IBOutlet UIWebView *webview_aadhaarLinkFamilyFolio;
}
@end

@implementation LinkAadhaarFamilyFolioVC
@synthesize str_webURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUrlInWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load url in webview

-(void)loadUrlInWebView{
    NSURL *url = [NSURL URLWithString:str_webURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webview_aadhaarLinkFamilyFolio loadRequest:requestObj];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
#pragma mark - Back Tapped Action

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

@end
