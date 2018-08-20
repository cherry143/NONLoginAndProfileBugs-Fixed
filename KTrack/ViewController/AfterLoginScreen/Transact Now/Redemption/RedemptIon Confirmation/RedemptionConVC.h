
//
//  RedemptionConVC.h
//  KTrack
//
//  Created by Ramakrishna MV on 16/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedemptionConVC : UIViewController
@property NSString *str_Fund,*str_pan,*str_folio,*str_Secheme,*str_Amount,*str_referId,*str_selectedFundID,*str_name;
@property KT_TABLE2 *schemeDic;

@property KT_TABLE8 *selectedBank;

@property  NSMutableArray * paymentModeArray;

@property  NSMutableDictionary * schemmeDetialsDic;
@property NSString *str_redType,*ttrtype,* lastNavStr,*famliyStr;

@end
