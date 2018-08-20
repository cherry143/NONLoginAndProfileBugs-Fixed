//
//  CancelSIPSWPTblCell.h
//  KTrack
//
//  Created by Ramakrishna.M.V on 01/08/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancelSIPSWPTblCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_folio;
@property (weak, nonatomic) IBOutlet UILabel *lbl_registrationDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_scheme;
@property (weak, nonatomic) IBOutlet UILabel *lbl_fromDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_toDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_frequency;
@property (weak, nonatomic) IBOutlet UILabel *lbl_amount;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;

@end
