//
//  CASVC.h
//  KTrack
//
//  Created by Ramakrishna MV on 12/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CASVC : UIViewController
- (IBAction)backAtc:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submtBtn;
- (IBAction)submitAtc:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emaiLTF;
@property (weak, nonatomic) IBOutlet UITextField *paswordTf;
@property (weak, nonatomic) IBOutlet UITextField *txt_confirmPassword;

@end
