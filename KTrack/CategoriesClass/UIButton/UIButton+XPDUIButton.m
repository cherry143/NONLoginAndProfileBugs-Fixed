//
//  UIButton+XPDUIButton.m
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 28/07/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import "UIButton+XPDUIButton.h"

@implementation UIButton (XPDUIButton)

+(void)roundedCornerWithTwoLineText:(UIButton*)button{
    button.layer.cornerRadius = 2.0f;
    button.layer.masksToBounds = YES;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
}

+(void)roundedCornerButtonWithoutBackground:(UIButton*)button forCornerRadius:(CGFloat)corderRadius forBorderWidth:(CGFloat)borderWidth forBorderColor:(UIColor *)color forBackGroundColor:(UIColor *)backGroundColor{
    button.backgroundColor=backGroundColor;
    button.layer.cornerRadius =corderRadius;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth=borderWidth;
    button.layer.borderColor=color.CGColor;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
}

+(NSMutableAttributedString *)underlineForButton:(NSString *)string forAttributedColor:(UIColor *)color{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] init];
    [attriString appendAttributedString:[[NSAttributedString alloc] initWithString:string
                                                                        attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}]];
    NSMutableAttributedString *highlightedAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attriString];
    [highlightedAttributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[string length])];
    return highlightedAttributedString;
}

@end
