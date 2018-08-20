//
//  SystematicTransferPlanVC.h
//  KTrack
//
//  Created by Ramakrishna.M.V on 06/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystematicTransferPlanVC : UIViewController
@property NSString *str_Fund,*str_pan,*str_folio,*str_Secheme,*str_Amount,*str_referId,*str_selectedFundID,*famliyStr,*str_tat,*str_Category,*str_name,*str_arn,*str_subarn,*str_PayModeVal,*str_EuinCode;
@property KT_TABLE2 *schemeDic;
@property  NSMutableDictionary * payoutBankDic;
@property  NSMutableArray * paymentModeArray,*paymentBantArr;
@property NSMutableArray *saepaymentModeArr;

@property  NSMutableDictionary * schemmeDetialsDic;
@property NSString *str_installments,*str_SipStartDay,*str_SipEndDay,*sipday,*sipType,*str_investment,*str_schemmeType;
@end
