//
//  DetailPortfolioSubChildCollCell.h
//  KTrack
//
//  Created by mnarasimha murthy on 14/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPortfolioSubChildCollCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_units;
@property (weak, nonatomic) IBOutlet UILabel *lbl_costValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_currentValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_appr;
@property (weak, nonatomic) IBOutlet UILabel *lbl_planDesc;
@property (weak, nonatomic) IBOutlet UIButton *btn_latestYield;
@property (weak, nonatomic) IBOutlet UIButton *btn_additionalPurchase;
@property (weak, nonatomic) IBOutlet UIButton *btn_redemption;
@property (weak, nonatomic) IBOutlet UIButton *btn_switch;
@property (weak, nonatomic) IBOutlet UIButton *btn_download;

@end
