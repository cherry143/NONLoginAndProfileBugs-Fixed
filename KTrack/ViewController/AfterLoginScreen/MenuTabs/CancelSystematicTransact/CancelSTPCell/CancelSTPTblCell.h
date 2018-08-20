//
//  CancelSTPTblCell.h
//  KTrack
//
//  Created by Ramakrishna.M.V on 01/08/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancelSTPTblCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_folioNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbl_registrationDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_switchOutScheme;
@property (weak, nonatomic) IBOutlet UILabel *lbl_switchInScheme;
@property (weak, nonatomic) IBOutlet UILabel *lbl_fromDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_toDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_frequency;
@property (weak, nonatomic) IBOutlet UILabel *lbl_amount;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete;

@end
