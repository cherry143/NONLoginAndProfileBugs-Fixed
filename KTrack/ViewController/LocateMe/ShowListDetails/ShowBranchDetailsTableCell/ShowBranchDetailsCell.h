//
//  ShowBranchDetailsCell.h
//  KTrack
//
//  Created by mnarasimha murthy on 11/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowBranchDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_contactPerson;
@property (weak, nonatomic) IBOutlet UILabel *lbl_emailID;
@property (weak, nonatomic) IBOutlet UILabel *lbl_branchName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_address1;
@property (weak, nonatomic) IBOutlet UILabel *lbl_address2;
@property (weak, nonatomic) IBOutlet UILabel *lbl_address3;
@property (weak, nonatomic) IBOutlet UILabel *lbl_zipCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_route;
@property (weak, nonatomic) IBOutlet UIButton *btn_call;

@end
