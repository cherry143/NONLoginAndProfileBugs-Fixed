//
//  NotificationTblCell.h
//  KTrack
//
//  Created by Ramakrishna.M.V on 29/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTblCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *view_notificationView;
@property (weak, nonatomic) IBOutlet UIImageView *img_typeNotification;
@property (weak, nonatomic) IBOutlet UILabel *lbl_notifinationName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_notificationDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_notificationDescription;

@end
