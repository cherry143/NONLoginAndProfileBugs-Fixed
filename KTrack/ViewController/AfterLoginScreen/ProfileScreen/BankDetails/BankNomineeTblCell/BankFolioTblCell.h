//
//  BankFolioTblCell.h
//  KTrack
//
//  Created by Ramakrishna.M.V on 24/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankFolioTblCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_common;
@property (weak, nonatomic) IBOutlet UILabel *lbl_common;
@property (weak, nonatomic) IBOutlet UILabel *lbl_commonDetail;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete;

@end
