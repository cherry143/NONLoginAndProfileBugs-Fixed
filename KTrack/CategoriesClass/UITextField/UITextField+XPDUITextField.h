//
//  UITextField+XPDUITextField.h
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 28/07/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (XPDUITextField)

+(void)withoutRoundedCornerTextField:(UITextField *)txtField forCornerRadius:(CGFloat)cornerRadius forBorderWidth:(CGFloat)borderWidth;

@end

