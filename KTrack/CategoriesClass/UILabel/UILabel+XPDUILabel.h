//
//  UILabel+XPDUILabel.h
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 28/07/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (XPDUILabel)

- (void) boldSubstring: (NSString*) substring;
- (void) boldRange: (NSRange) range;
- (NSMutableAttributedString *)boldSubstringForLabel:(UILabel *)label forFirstString:(NSString*)firstString forSecondString:(NSString *)secondString;
-(NSMutableAttributedString *)underLineTextString:(NSString *)string;
- (NSMutableAttributedString *)differentBoldSubstringForLabel:(UILabel *)label forFirstString:(NSString*)firstString forSecondString:(NSString *)secondString;
@end
