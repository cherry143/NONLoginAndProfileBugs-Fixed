//
//  UITextView+XPDUITextView.h
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 28/07/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UITextView (XPDUITextView)

+(void)withoutRoundedCornerTextFieldView:(UITextView *)txtField forCornerRadius:(CGFloat)cornerRadius forBorderWidth:(CGFloat)borderWidth;

@end
