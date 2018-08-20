//
//  SWPConfirmationVC.h
//  KTrack
//
//  Created by Ramakrishna.M.V on 12/07/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWPConfirmationVC : UIViewController

@property (nonatomic,strong) NSDictionary *selected_swpDetails;
@property (nonatomic,assign) BOOL hideAmountView;
@property (nonatomic,strong) NSString *str_fromScreen;

@end
