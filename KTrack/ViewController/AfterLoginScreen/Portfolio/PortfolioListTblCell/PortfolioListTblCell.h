//
//  PortfolioListTblCell.h
//  KTrack
//
//  Created by mnarasimha murthy on 25/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortfolioListTblCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_sideDrop;
@property (weak, nonatomic) IBOutlet UIButton *btn_fundCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbl_costValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_currentValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_absoluteGain;

@end
