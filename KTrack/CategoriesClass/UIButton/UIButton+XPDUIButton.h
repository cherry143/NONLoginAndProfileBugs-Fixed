//
//  UIButton+XPDUIButton.h
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 28/07/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIButton (XPDUIButton)

+(void)roundedCornerWithTwoLineText:(UIButton*)button;
+(void)roundedCornerButtonWithoutBackground:(UIButton*)button forCornerRadius:(CGFloat)corderRadius forBorderWidth:(CGFloat)borderWidth forBorderColor:(UIColor *)color forBackGroundColor:(UIColor *)backGroundColor;
+(NSMutableAttributedString *)underlineForButton:(NSString *)string forAttributedColor:(UIColor *)color;

@end
