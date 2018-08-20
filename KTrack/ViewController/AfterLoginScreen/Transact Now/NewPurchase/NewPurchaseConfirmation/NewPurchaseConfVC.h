//
//  NewPurchaseConfVC.h
//  KTrack
//
//  Created by  ramakrishna.MV on 27/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPurchaseConfVC : UIViewController
@property NSString *str_Fund,*str_pan,*str_folio,*str_Secheme,*str_Amount,*str_referId,*str_selectedFundID,*str_name,*str_arn,*str_subarn,*famliyStr;
@property KT_TABLE2 *schemeDic;
@property  NSMutableDictionary * payoutBankDic;
@property NSMutableArray *paymentModeArr;
@property NSMutableArray *saepaymentModeArr;
@property NSArray  *paymentBantArr;

@property  NSMutableDictionary * schemmeDetialsDic;
@end
