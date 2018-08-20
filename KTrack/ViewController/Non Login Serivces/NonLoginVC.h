//
//  NonLoginVC.h
//  KTrack
//
//  Created by Ramakrishna MV on 11/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NonLoginVC : UIViewController
- (IBAction)easySMS:(id)sender;
- (IBAction)CommomAtc:(id)sender;
- (IBAction)transcationSAtc:(id)sender;
- (IBAction)backAtc:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *smsView;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callAtc:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *callView;
@property (weak, nonatomic) IBOutlet UIButton *smsBtn;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;


@end
