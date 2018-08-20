//
//  DetailPortfolioMiddleCollCell.h
//  KTrack
//
//  Created by mnarasimha murthy on 14/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPortfolioMiddleCollCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_units;
@property (weak, nonatomic) IBOutlet UILabel *lbl_costValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_currentValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_appr;
@property (weak, nonatomic) IBOutlet UILabel *lbl_planDesc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_currentNAV;
@property (weak, nonatomic) IBOutlet UIButton *btn_latestNav;

@end
