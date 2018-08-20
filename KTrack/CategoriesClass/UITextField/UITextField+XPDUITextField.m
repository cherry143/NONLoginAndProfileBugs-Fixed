//
//  UITextField+XPDUITextField.m
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 28/07/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import "UITextField+XPDUITextField.h"

@implementation UITextField (XPDUITextField)

+(void)withoutRoundedCornerTextField:(UITextField *)txtField forCornerRadius:(CGFloat)cornerRadius forBorderWidth:(CGFloat)borderWidth{
    [txtField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    txtField.layer.sublayerTransform=CATransform3DMakeTranslation(10, 0, 0);
    txtField.layer.borderColor=[UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1.0].CGColor;
    txtField.layer.cornerRadius =cornerRadius;
    txtField.layer.borderWidth=borderWidth;
    txtField.layer.masksToBounds = YES;
    UIView *leftViewModeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,txtField.frame.size.height, txtField.frame.size.height)];
    txtField.rightView =leftViewModeView;
    txtField.rightViewMode = UITextFieldViewModeAlways;
}

@end
