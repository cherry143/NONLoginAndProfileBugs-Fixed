//
//  DetailPortfolioSubChildTblCell.m
//  KTrack
//
//  Created by mnarasimha murthy on 14/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "DetailPortfolioSubChildTblCell.h"

@implementation DetailPortfolioSubChildTblCell

@synthesize coll_subChild,arr_recSubChild;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [coll_subChild registerNib:[UINib nibWithNibName:@"DetailPortfolioSubChildCollCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SubChildCollCell"];
    coll_subChild.backgroundColor=[UIColor clearColor];
    coll_subChild.showsHorizontalScrollIndicator=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setDic_subChildList:(NSDictionary *)dic_subChildList{
    _dic_subChildList=[dic_subChildList copy];
    arr_recSubChild=[NSMutableArray new];
    [arr_recSubChild addObject:_dic_subChildList];
    [coll_subChild reloadData];
}

#pragma mark - CollectionView Delegate Methods Implementation

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arr_recSubChild.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailPortfolioSubChildCollCell *cell= (DetailPortfolioSubChildCollCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"SubChildCollCell" forIndexPath:indexPath];
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
    return CGSizeMake(766,60);
}

#pragma mark - Configuring the currentbooking cell with the details

-(void)configure:(DetailPortfolioSubChildCollCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    KT_TABLE2 *rec=arr_recSubChild[indexPath.item][@"Content"];
    cell.lbl_units.text=[NSString stringWithFormat:@"%.3f",[rec.balUnits floatValue]];
    cell.lbl_costValue.text=[NSString stringWithFormat:@"%@",rec.costValue];
    cell.lbl_currentValue.text=[NSString stringWithFormat:@"%@",rec.curValue];
    NSString *gainPercent=[NSString stringWithFormat:@"%@",rec.gainValue];
    NSArray *gainArray = [gainPercent componentsSeparatedByString:@"~"];
    @try{
        cell.lbl_appr.text=[NSString stringWithFormat:@"%@\n%@",gainArray[0],gainArray[1]];
    }
    @catch(NSException *ex){
        cell.lbl_appr.text=[NSString stringWithFormat:@"%@",gainPercent];
    }
    cell.lbl_planDesc.text=[NSString stringWithFormat:@"%@",rec.plnDesc];
    [cell.btn_latestYield addTarget:self action:@selector(latestYieldTapped:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat zeroBalUnits=[rec.balUnits floatValue];
    if (zeroBalUnits==0) {
        NSString *str_additionalPur=[NSString stringWithFormat:@"%@",rec.pSchFlg];
        if ([str_additionalPur isEqualToString:@"N"] || [str_additionalPur isEqual:@"N"]) {
            [cell.btn_additionalPurchase setHidden:YES];
        }
        else{
            [cell.btn_additionalPurchase setHidden:NO];
        }
        [cell.btn_redemption setHidden:YES];
        [cell.btn_switch setHidden:YES];
    }
    else{
        NSString *str_additionalPur=[NSString stringWithFormat:@"%@",rec.pSchFlg];
        if ([str_additionalPur isEqualToString:@"N"] || [str_additionalPur isEqual:@"N"]) {
            [cell.btn_additionalPurchase setHidden:YES];
        }
        else{
            [cell.btn_additionalPurchase setHidden:NO];
        }
        NSString *str_redemption=[NSString stringWithFormat:@"%@",rec.rSchFlg];
        if ([str_redemption isEqualToString:@"N"] || [str_redemption isEqual:@"N"]) {
            [cell.btn_redemption setHidden:YES];
        }
        else{
            [cell.btn_redemption setHidden:NO];
        }
        NSString *str_switch=[NSString stringWithFormat:@"%@",rec.sSchFlg];
        if ([str_switch isEqualToString:@"N"] || [str_switch isEqual:@"N"]) {
            [cell.btn_switch setHidden:YES];
        }
        else{
            [cell.btn_switch setHidden:NO];
        }
    }
    [cell.btn_additionalPurchase addTarget:self action:@selector(additionalPurchaseTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_redemption addTarget:self action:@selector(btnRedemptionTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_switch addTarget:self action:@selector(btnSwitchTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_download addTarget:self action:@selector(btnStatementDownloadTapped:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Button Tapped

-(void)latestYieldTapped:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:coll_subChild];
    NSIndexPath *indexPath = [coll_subChild indexPathForItemAtPoint:buttonPosition];
    KT_TABLE2 *selectedRecordDic=arr_recSubChild[indexPath.item][@"Content"];
    [_folioCustomdelegate latestYieldCustomDelegate:selectedRecordDic];
}

-(void)additionalPurchaseTapped:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:coll_subChild];
    NSIndexPath *indexPath = [coll_subChild indexPathForItemAtPoint:buttonPosition];
    KT_TABLE2 *selectedRecordDic=arr_recSubChild[indexPath.item][@"Content"];
    [_folioCustomdelegate aditionalPurchaseCustomDelegate:selectedRecordDic];
}

-(void)btnRedemptionTapped:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:coll_subChild];
    NSIndexPath *indexPath = [coll_subChild indexPathForItemAtPoint:buttonPosition];
    KT_TABLE2 *selectedRecordDic=arr_recSubChild[indexPath.item][@"Content"];
    [_folioCustomdelegate redemptionCustomDelegate:selectedRecordDic];
}

-(void)btnSwitchTapped:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:coll_subChild];
    NSIndexPath *indexPath = [coll_subChild indexPathForItemAtPoint:buttonPosition];
    KT_TABLE2 *selectedRecordDic=arr_recSubChild[indexPath.item][@"Content"];
    [_folioCustomdelegate switchCustomDelegate:selectedRecordDic];
}

-(void)btnStatementDownloadTapped:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:coll_subChild];
    NSIndexPath *indexPath = [coll_subChild indexPathForItemAtPoint:buttonPosition];
    KT_TABLE2 *selectedRecordDic=arr_recSubChild[indexPath.item][@"Content"];
    [_folioCustomdelegate downloadStatementDelegate:selectedRecordDic];
}

@end
