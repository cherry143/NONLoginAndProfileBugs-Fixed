//
//  PaymentModeVC.h
//  KTrack
//
//  Created by Ramakrishna MV on 07/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManagerModelClass.h"

@interface PaymentModeVC : UIViewController
@property NSString *str_Fund,*str_pan,*str_folio,*str_Secheme,*str_Amount,*str_referId,*str_selectedFundID,*str_name,*str_arn,*str_subarn,*famliyStr;
@property KT_TABLE2 *schemeDic;
@property  NSMutableArray * paymentModeArray;
@property NSMutableArray *saepaymentModeArr;

@property  NSMutableDictionary * schemmeDetialsDic;

@end
