//
//  DetailPortfolioSubChildCollCell.m
//  KTrack
//
//  Created by mnarasimha murthy on 14/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "DetailPortfolioSubChildCollCell.h"

@implementation DetailPortfolioSubChildCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [UIButton roundedCornerButtonWithoutBackground:_btn_latestYield forCornerRadius:_btn_latestYield.frame.size.height/2 forBorderWidth:2.5f forBorderColor:KTWhiteColor forBackGroundColor:KTButtonBackGroundBlue];
}

@end
