//
//  DetailParentTblCell.h
//  KTrack
//
//  Created by Ramakrishna.M.V on 22/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailParentTblCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_bankImage;
@property (weak, nonatomic) IBOutlet UILabel *lbl_schemeName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_units;
@property (weak, nonatomic) IBOutlet UILabel *lbl_costValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_currentValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_apprPercent;
@property (weak, nonatomic) IBOutlet UIImageView *img_gainImage;

@end
