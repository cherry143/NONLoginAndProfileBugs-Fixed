//
//  DetailPortfolioMiddleChildTblCell.h
//  KTrack
//
//  Created by mnarasimha murthy on 14/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NAVChildCustomDelegate
@required
-(void)netAssetValueCustomDelegate:(KT_TABLE14 *)resultantdic;
@end

@interface DetailPortfolioMiddleChildTblCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_bank;
@property (weak, nonatomic) IBOutlet UILabel *lbl_schemeDesc;
@property (weak, nonatomic) IBOutlet UICollectionView *coll_subChild;
@property (nonatomic,strong) NSDictionary *dic_childRec;
@property (nonatomic,strong) NSMutableArray *arr_recChild;

@property (nonatomic,assign)  id <NAVChildCustomDelegate> navCustomdelegate;

@end
