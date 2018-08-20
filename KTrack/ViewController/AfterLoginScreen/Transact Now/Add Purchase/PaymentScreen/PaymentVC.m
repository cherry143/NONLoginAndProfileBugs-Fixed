//
//  PaymentVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 10/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "PaymentVC.h"

@interface PaymentVC ()
@property (weak, nonatomic) IBOutlet UIWebView *paymentView;

@end

@implementation PaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *En_referId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%@", self.str_referId]];
    NSString *str_url = [NSString stringWithFormat:@"https://www.karvymfs.com/karvy/InvestorServices/OnlinePurchase/mobilePurchaseConfirmation_new.aspx?Mob=%@&qparam=%@",@"UA==",En_referId];
    NSLog(@"%@",str_url);
    NSURL *websiteUrl = [NSURL URLWithString:str_url];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.paymentView loadRequest:urlRequest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    
      [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:[[self.navigationController viewControllers] count]-4] animated:NO];
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
