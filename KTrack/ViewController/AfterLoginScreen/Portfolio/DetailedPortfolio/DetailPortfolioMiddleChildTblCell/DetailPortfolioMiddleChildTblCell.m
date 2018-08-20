//
//  DetailPortfolioMiddleChildTblCell.m
//  KTrack
//
//  Created by mnarasimha murthy on 14/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "DetailPortfolioMiddleChildTblCell.h"

@implementation DetailPortfolioMiddleChildTblCell
@synthesize coll_subChild,arr_recChild;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [coll_subChild registerNib:[UINib nibWithNibName:@"DetailPortfolioMiddleCollCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MiddleChildCollCell"];
    coll_subChild.backgroundColor=[UIColor clearColor];
    coll_subChild.showsHorizontalScrollIndicator=NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setDic_childRec:(NSDictionary *)dic_childRec{
    _dic_childRec=[dic_childRec copy];
    arr_recChild=[NSMutableArray new];
    [arr_recChild addObject:_dic_childRec];
    [coll_subChild reloadData];
}

#pragma mark - CollectionView Delegate Methods Implementation

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arr_recChild.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailPortfolioMiddleCollCell *cell= (DetailPortfolioMiddleCollCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"MiddleChildCollCell" forIndexPath:indexPath];
    [self configure:cell atIndexPath:indexPath];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return  CGSizeMake(565,60);
}

#pragma mark - Configuring the currentbooking cell with the details

-(void)configure:(DetailPortfolioMiddleCollCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    KT_TABLE14 *rec=arr_recChild[indexPath.item][@"Content"];
    cell.lbl_units.text=[NSString stringWithFormat:@"%.3f",[rec.units floatValue]];
    cell.lbl_costValue.text=[NSString stringWithFormat:@"%@",rec.costValue];
    cell.lbl_currentValue.text=[NSString stringWithFormat:@"%@",rec.currentValue];
    cell.lbl_appr.text=[NSString stringWithFormat:@"%@\n%@",rec.gainValue,rec.gainPercent];
    cell.lbl_planDesc.text=[NSString stringWithFormat:@"%@",rec.plnDesc];
    cell.lbl_currentNAV.text=[NSString stringWithFormat:@"NAV - ₹ %@",rec.lastNAV];
    [cell.btn_latestNav addTarget:self action:@selector(btnLatestNavTapped:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Latest NET ASSET VALUE

-(void)btnLatestNavTapped:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:coll_subChild];
    NSIndexPath *indexPath = [coll_subChild indexPathForItemAtPoint:buttonPosition];
    KT_TABLE14 *selectedRecordDic=arr_recChild[indexPath.item][@"Content"];
    [_navCustomdelegate netAssetValueCustomDelegate:selectedRecordDic];
}

@end
