//
//  DetailPortfolioSubChildTblCell.h
//  KTrack
//
//  Created by mnarasimha murthy on 14/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol folioCellCustomDelegate
@required
-(void)aditionalPurchaseCustomDelegate:(KT_TABLE2 *)resultantdic;
-(void)redemptionCustomDelegate:(KT_TABLE2 *)resultantdic;
-(void)switchCustomDelegate:(KT_TABLE2 *)resultantDic;
-(void)latestYieldCustomDelegate:(KT_TABLE2 *)resultantDic;
-(void)downloadStatementDelegate:(KT_TABLE2 *)resultantDic;
@end

@interface DetailPortfolioSubChildTblCell : UITableViewCell<UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *lbl_folioNumber;
@property (weak, nonatomic) IBOutlet UICollectionView *coll_subChild;
@property (nonatomic,strong) NSDictionary *dic_subChildList;
@property (nonatomic,strong) NSMutableArray *arr_recSubChild;

@property (nonatomic,assign)  id <folioCellCustomDelegate> folioCustomdelegate;

@end
