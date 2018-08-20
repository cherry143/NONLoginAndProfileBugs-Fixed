//
//  UIView+KTView.h
//  KTrack
//
//  Created by mnarasimha murthy on 12/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KTView)

+(void)roundedCornerEnableForView:(UIView *)view forCornerRadius:(CGFloat)radius forBorderWidth:(CGFloat)borderWidth forApplyShadow:(BOOL)applyShadow;

@end
