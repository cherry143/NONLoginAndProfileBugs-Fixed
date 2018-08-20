//
//  CancelSTConfirmationVC.h
//  KTrack
//
//  Created by Ramakrishna.M.V on 01/08/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancelSTConfirmationVC : UIViewController

@property (nonatomic,strong) NSDictionary *dic_cancellationRecord;
@property (nonatomic,strong) NSString *str_investorName;
@property (nonatomic,strong) NSString *str_selectedPAN;
@property (nonatomic,strong) NSString *str_showSTP;
@property (nonatomic,strong) NSString *str_fromScreen;

@end
