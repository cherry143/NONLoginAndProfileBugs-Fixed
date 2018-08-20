//
//  TransactionHistoryTblCell.h
//  KTrack
//
//  Created by mnarasimha murthy on 15/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionHistoryTblCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_transactType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_schemeName;
@property (weak, nonatomic) IBOutlet UIButton *lbl_status;
@property (weak, nonatomic) IBOutlet UILabel *lbl_amount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_folioNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbl_lastNav;
@property (weak, nonatomic) IBOutlet UILabel *lbl_units;

@end
