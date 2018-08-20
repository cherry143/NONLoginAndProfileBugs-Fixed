//
//  KnowYourTransactionDetailsTblCell.m
//  KTrack
//
//  Created by mnarasimha murthy on 11/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "KnowYourTransactionDetailsTblCell.h"

@implementation KnowYourTransactionDetailsTblCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [UIView roundedCornerEnableForView:self.view_mainView forCornerRadius:10.0f forBorderWidth:0.0f forApplyShadow:NO];
    self.lbl_transactionTypeTxt.text=@"Transaction Type";
    self.lbl_priceApplied.text=@"Price Applied";
    self.lbl_transactionStatus.text=@"Transaction Status";
}

@end
