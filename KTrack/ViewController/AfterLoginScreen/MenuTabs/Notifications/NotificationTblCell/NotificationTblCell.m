//
//  NotificationTblCell.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 29/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "NotificationTblCell.h"

@implementation NotificationTblCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [UIView roundedCornerEnableForView:_view_notificationView forCornerRadius:10.0f forBorderWidth:0.0f forApplyShadow:NO];
}

@end
