//
//  PinPatternVC.h
//  KTrack
//
//  Created by mnarasimha murthy on 18/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinPatternVC : UIViewController
typedef enum {
    InfoStatusFirstTimeSetting = 0,
    InfoStatusConfirmSetting,
    InfoStatusFailedConfirm,
    InfoStatusNormal,
    InfoStatusFailedMatch,
    InfoStatusSuccessMatch
}   InfoStatus;

@property (strong, nonatomic) IBOutlet SPLockScreen *lockScreenView;
@property (nonatomic) InfoStatus infoLabelStatus;
@property (nonatomic,strong) NSString *str_fromScreen;
@property (nonatomic,strong) NSDictionary *dic_response;

@end

