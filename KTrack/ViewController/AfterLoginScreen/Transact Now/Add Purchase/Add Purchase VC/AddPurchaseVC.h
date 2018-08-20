//
//  AddPurchase.h
//  KTrack
//
//  Created by Ramakrishna MV on 25/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManagerModelClass.h"

@interface AddPurchaseVC : UIViewController

@property (nonatomic,strong) NSString *str_fromScreen;
@property (nonatomic,strong) KT_TABLE2 *selected_Rec;

@end
