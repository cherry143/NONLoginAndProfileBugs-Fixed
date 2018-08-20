//
//  KnowYourTransactionDetailsTblCell.h
//  KTrack
//
//  Created by mnarasimha murthy on 11/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KnowYourTransactionDetailsTblCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_typeFund;
@property (weak, nonatomic) IBOutlet UILabel *lbl_dateOfPurchase;
@property (weak, nonatomic) IBOutlet UILabel *lbl_transactionTypeTxt;
@property (weak, nonatomic) IBOutlet UILabel *lbl_priceApplied;
@property (weak, nonatomic) IBOutlet UILabel *lbl_transactionStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbl_volumeCost;
@property (weak, nonatomic) IBOutlet UILabel *lbl_transactStatusMSg;
@property (weak, nonatomic) IBOutlet UILabel *lbl_transactType;
@property (weak, nonatomic) IBOutlet UIView *view_mainView;

@end
