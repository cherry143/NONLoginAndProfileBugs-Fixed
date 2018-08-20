//
//  UIView+KTView.m
//  KTrack
//
//  Created by mnarasimha murthy on 12/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "UIView+KTView.h"

@implementation UIView (KTView)

+(void)roundedCornerEnableForView:(UIView *)view forCornerRadius:(CGFloat)radius forBorderWidth:(CGFloat)borderWidth forApplyShadow:(BOOL)applyShadow{
    if (applyShadow==YES) {
        view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(2.5, 2.5);
        view.layer.shadowOpacity = 0.5f;
        view.layer.shadowRadius = 1.0;
    }
    view.layer.cornerRadius=radius;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth=borderWidth;
    if (view.tag==10000){
        view.layer.borderColor=[UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1.0].CGColor;
    }
    else{
        view.layer.borderColor=KTBorderColor.CGColor;
    }
}

@end
