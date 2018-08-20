//
//  CommonPopupVC.h
//  KTrack
//
//  Created by mnarasimha murthy on 30/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol commonCustomDelegate
@optional
-(void)PanSuccessMethod:(NSString *)str_pan;
-(void)otpSuccessMethod;
-(void)cancelButtonTapped;
-(void)familyFolioSuccess;
-(void)demoGrpahicSuccess;
@end

@interface CommonPopupVC : UIViewController

@property (weak,nonatomic) id <commonCustomDelegate>commondelegate;
@property (nonatomic,strong) NSString *str_fromScreen;
@property (nonatomic,strong) NSString *str_panEntered;
@property (nonatomic,strong) NSString *str_referenceGen;

@end
