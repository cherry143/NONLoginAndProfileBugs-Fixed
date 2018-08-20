//
//  TransactionHistoryTblCell.m
//  KTrack
//
//  Created by mnarasimha murthy on 15/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "TransactionHistoryTblCell.h"

@implementation TransactionHistoryTblCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    _lbl_status.titleLabel.textAlignment=NSTextAlignmentCenter;

}

@end
