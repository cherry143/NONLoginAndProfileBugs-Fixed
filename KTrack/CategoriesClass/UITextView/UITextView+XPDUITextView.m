//
//  UITextView+XPDUITextView.m
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 28/07/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import "UITextView+XPDUITextView.h"

@implementation UITextView (XPDUITextView)

+(void)withoutRoundedCornerTextFieldView:(UITextView *)txtField forCornerRadius:(CGFloat)cornerRadius forBorderWidth:(CGFloat)borderWidth{
    txtField.layer.sublayerTransform=CATransform3DMakeTranslation(5, 0, 0);
    txtField.layer.borderColor=[UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1.0].CGColor;
    txtField.layer.cornerRadius =cornerRadius;
    txtField.layer.borderWidth=borderWidth;
    txtField.layer.masksToBounds = YES;
}

@end
