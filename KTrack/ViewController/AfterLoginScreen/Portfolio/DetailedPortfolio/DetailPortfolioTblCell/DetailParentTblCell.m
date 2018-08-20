//
//  DetailParentTblCell.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 22/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "DetailParentTblCell.h"

@implementation DetailParentTblCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [UIImageView portFolioRoundedCornerImageHalf:_img_bankImage];
}

@end
