//
//  BankDetailsVC.h
//  KTrack
//
//  Created by mnarasimha murthy on 18/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankDetailsVC : UIViewController

@property (nonatomic,strong) NSString *str_selectedPrimaryPan,*str_fromScreen;
@property (nonatomic,strong) NSDictionary *dic_selectedBankRec;

@end
