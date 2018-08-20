//
//  KYTDetailsCell.h
//  KTrack
//
//  Created by Ramakrishna MV on 23/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYTDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_trasactType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_scheme;
@property (weak, nonatomic) IBOutlet UIButton *btn_transact;

@end
