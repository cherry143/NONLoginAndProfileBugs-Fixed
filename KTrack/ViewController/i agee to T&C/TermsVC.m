\
//
//  TermsVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 21/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "TermsVC.h"

@interface TermsVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *websiteUrl = [NSURL URLWithString:@"https://www.karvymfs.com/karvy/Generalpages/Ktrack_termsconditions.aspx"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];
    // Do any additional setup after loading the view.
}
- (IBAction)backAtc:(id)sender {
    KTPOP(YES);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
