//
//  DBManagerModelClass.h
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 06/10/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KT_TABLE2 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *fundDesc;
@property (nonatomic,retain) NSString *sch;
@property (nonatomic,retain) NSString *schDesc;
@property (nonatomic,retain) NSString *pln;
@property (nonatomic,retain) NSString *plnDesc;
@property (nonatomic,retain) NSString *opt;
@property (nonatomic,retain) NSString *optDesc;
@property (nonatomic,retain) NSString *Acno;
@property (nonatomic,retain) NSString *balUnits;
@property (nonatomic,retain) NSString *lastNAV;
@property (nonatomic,retain) NSString *curValue;
@property (nonatomic,retain) NSString *lastNavDate;
@property (nonatomic,retain) NSString *pFlag;
@property (nonatomic,retain) NSString *rFlag;
@property (nonatomic,retain) NSString *sFlag;
@property (nonatomic,retain) NSString *minAmt;
@property (nonatomic,retain) NSString *schType;
@property (nonatomic,retain) NSString *Kyc1;
@property (nonatomic,retain) NSString *pModeValue;
@property (nonatomic,retain) NSString *pModeDesc;
@property (nonatomic,retain) NSString *mobile;
@property (nonatomic,retain) NSString *pSchFlg;
@property (nonatomic,retain) NSString *rSchFlg;
@property (nonatomic,retain) NSString *sSchFlg;
@property (nonatomic,retain) NSString *schDesc1;
@property (nonatomic,retain) NSString *taxSaverFlag;
@property (nonatomic,retain) NSString *aadharFlag;
@property (nonatomic,retain) NSString *brokercd;
@property (nonatomic,retain) NSString *subbrokercd;
@property (nonatomic,retain) NSString *sipFlag;
@property (nonatomic,retain) NSString *subCategory;
@property (nonatomic,retain) NSString *investment_Flag;
@property (nonatomic,retain) NSString *PAN;
@property (nonatomic,retain) NSString *costValue;
@property (nonatomic,retain) NSString *gainValue;
@property (nonatomic,retain) NSString *redMinAmt;
@property (nonatomic,retain) NSString *sipSchFlg;
@property (nonatomic,retain) NSString *notallowed_flag;
@property (nonatomic,retain) NSString *fund_CostValue;
@property (nonatomic,retain) NSString *fund_CurValue;
@property (nonatomic,retain) NSString *fund_GainValue;

@end

@interface KT_TABLE3 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *fundDesc;
@property (nonatomic,retain) NSString *Acno;
@property (nonatomic,retain) NSString *invName;
@property (nonatomic,retain) NSString *add1;
@property (nonatomic,retain) NSString *add2;
@property (nonatomic,retain) NSString *add3;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *state;
@property (nonatomic,retain) NSString *telPhone;
@property (nonatomic,retain) NSString *mobile;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *PAN;

@end

@interface KT_TABLE4 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *y;
@property (nonatomic,retain) NSString *color;
@property (nonatomic,retain) NSString *currentValue;
@property (nonatomic,retain) NSString *gainVal;
@property (nonatomic,retain) NSString *gain;
@property (nonatomic,retain) NSString *costValue;
@property (nonatomic,retain) NSString * percentage;
@property (nonatomic,retain) NSString *PAN;
@property (nonatomic,retain) NSString *todayGain;
@property (nonatomic,retain) NSString *totpercent;
@property (nonatomic,retain) NSString *gainPercent;

@end

@interface KT_TABLE5 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *fundDesc;
@property (nonatomic,retain) NSString * percentage;
@property (nonatomic,retain) NSString *PAN;
@property (nonatomic,retain) NSString *totpercent;

@end

@interface KT_TABLE6 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *fundDesc;
@property (nonatomic,retain) NSString *currentValue;
@property (nonatomic,retain) NSString *gainVal;
@property (nonatomic,retain) NSString *gain;
@property (nonatomic,retain) NSString *costValue;
@property (nonatomic,retain) NSString * percentage;
@property (nonatomic,retain) NSString *PAN;
@property (nonatomic,retain) NSString *todayGain;
@property (nonatomic,retain) NSString *totpercent;
@property (nonatomic,retain) NSString *gainPercent;

@end

@interface KT_TABLE7 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *scheme;
@property (nonatomic,retain) NSString *plan;
@property (nonatomic,retain) NSString *fundName;
@property (nonatomic,retain) NSString *schemeName;
@property (nonatomic,retain) NSString *Acno;
@property (nonatomic,retain) NSString *invName;
@property (nonatomic,retain) NSString *unitBalance;
@property (nonatomic,retain) NSString *navDate;
@property (nonatomic,retain) NSString *Nav;
@property (nonatomic,retain) NSString *currentValue;
@property (nonatomic,retain) NSString *curValue;
@property (nonatomic,retain) NSString *costValue;
@property (nonatomic,retain) NSString *avgAgeDays;
@property (nonatomic,retain) NSString *annualizYield;
@property (nonatomic,retain) NSString *dividendValue;
@property (nonatomic,retain) NSString *schemeClass;
@property (nonatomic,retain) NSString *appreciationValue;
@property (nonatomic,retain) NSString *pSchFlg;
@property (nonatomic,retain) NSString *rSchFlg;
@property (nonatomic,retain) NSString *sSchFlg;
@property (nonatomic,retain) NSString *PAN;
@property (nonatomic,retain) NSString *sipSchFlg;

@end

@interface KT_TABLE8 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *foliono;
@property (nonatomic,retain) NSString *bnkcode;
@property (nonatomic,retain) NSString *bnkname;
@property (nonatomic,retain) NSString *bnkactype;
@property (nonatomic,retain) NSString *bnkacno;

@end

@interface KT_TABLE9 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *Acno;
@property (nonatomic,retain) NSString *sch;
@property (nonatomic,retain) NSString *pln;
@property (nonatomic,retain) NSString *schPln;
@property (nonatomic,retain) NSString *nomDetails;

@end

@interface KT_TABLE10 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *Acno;
@property (nonatomic,retain) NSString *sch;
@property (nonatomic,retain) NSString *pln;
@property (nonatomic,retain) NSString *schPln;
@property (nonatomic,retain) NSString *bankDetails;

@end

@interface KT_TABLE11 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *scheme;
@property (nonatomic,retain) NSString *pln;
@property (nonatomic,retain) NSString *Acno;
@property (nonatomic,retain) NSString *trdt;
@property (nonatomic,retain) NSString *Nav;
@property (nonatomic,retain) NSString *trtype;
@property (nonatomic,retain) NSString *navdt;
@property (nonatomic,retain) NSString *amount;
@property (nonatomic,retain) NSString *units;
@property (nonatomic,retain) NSString *fundDesc;
@property (nonatomic,retain) NSString *schemeDesc;
@property (nonatomic,retain) NSString *planDesc;
@property (nonatomic,retain) NSString *trtypeDesc;
@property (nonatomic,retain) NSString *Pop;
@property (nonatomic,retain) NSString *trdt1;
@property (nonatomic,retain) NSString *invName;

@end

@interface KT_TABLE12 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *PAN;
@property (nonatomic,retain) NSString *flag;
@property (nonatomic,retain) NSString *invName;
@property (nonatomic,retain) NSString *KYC;
@property (nonatomic,retain) NSString *minor;

@end

@interface KT_TABLE13 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *fundDesc;
@property (nonatomic,retain) NSString *schemeClass;
@property (nonatomic,retain) NSString *currentValue;
@property (nonatomic,retain) NSString *costValue;
@property (nonatomic,retain) NSString *gainValue;
@property (nonatomic,retain) NSString *gainPercent;
@property (nonatomic,retain) NSString *PAN;
@property (nonatomic,retain) NSString *imagePath;

@end

@interface KT_TABLE14 : NSObject

@property (nonatomic) int row_id;
@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *fundDesc;
@property (nonatomic,retain) NSString *schemeClass;
@property (nonatomic,retain) NSString *currentValue;
@property (nonatomic,retain) NSString *costValue;
@property (nonatomic,retain) NSString *gainValue;
@property (nonatomic,retain) NSString *gainPercent;
@property (nonatomic,retain) NSString *PAN;
@property (nonatomic,retain) NSString *schDesc;
@property (nonatomic,retain) NSString *plnDesc;
@property (nonatomic,retain) NSString *units;
@property (nonatomic,retain) NSString *sch;
@property (nonatomic,retain) NSString *pln;
@property (nonatomic,retain) NSString *lastNAV;

@end

@interface KT_Table2RawQuery : NSObject

@property (nonatomic,retain) NSString *fund;
@property (nonatomic,retain) NSString *fundDesc;

@end
