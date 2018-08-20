//
//  PaymentModeCell.h
//  KTrack
//
//  Created by Ramakrishna MV on 07/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentModeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_paymentModeDesc;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImage;

@end
