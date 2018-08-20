//
//  KtoMConVC.m
//  KTrack
//
//  Created by  ramakrishna.MV on 11/07/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "KtoMConVC.h"

@interface KtoMConVC (){
    
    __weak IBOutlet UILabel *lbl_ktom;
    
    __weak IBOutlet UIButton *btn_done;
}

@end

@implementation KtoMConVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [btn_done .layer setCornerRadius:btn_done.frame.size.height/2];
    [btn_done.layer setMasksToBounds:YES];
        lbl_ktom.text = self.refStr;

    // Do any additional setup after loading the view.
}
- (IBAction)backAtc:(id)sender {
    
    [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:[[self.navigationController viewControllers] count]-4] animated:NO];

}
- (IBAction)atc_done:(id)sender {
    [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:[[self.navigationController viewControllers] count]-4] animated:NO];

    
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
