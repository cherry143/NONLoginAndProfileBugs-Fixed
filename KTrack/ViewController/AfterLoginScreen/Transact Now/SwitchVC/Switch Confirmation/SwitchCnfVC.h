//
//  SwitchCnfVC.h
//  KTrack
//
//  Created by  ramakrishna.MV on 24/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchCnfVC : UIViewController
@property NSString *str_Fund,*str_pan,*str_folio,*str_Secheme,*str_Amount,*str_referId,*str_selectedFundID,*str_euinflag,*Str_arncode,*str_EuinNo,*Str_subarncode,*Str_name,*str_Sechemein;
@property KT_TABLE2 *schemeDic;

@property KT_TABLE8 *selectedBank;

@property  NSMutableArray * paymentModeArray;

@property  NSMutableDictionary * schemmeDetialsDic,*NewSchemmeDic;
@property NSString *str_redType,*ttrtype,* lastNavStr,*famliyStr;

@end
