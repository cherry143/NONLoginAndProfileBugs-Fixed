//
//  LinkAadhaarVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 01/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "LinkAadhaarVC.h"

@interface LinkAadhaarVC (){
    __weak IBOutlet UIWebView *webview_aadhaarLink;
}
@end

@implementation LinkAadhaarVC

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
    NSString *urlAddress = @"https://vas.karvymfs.com/karvysplproducts/Aadhaarlinking_individual.aspx";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webview_aadhaarLink loadRequest:requestObj];
}

#pragma mark - Back Tapped Action

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

@end
