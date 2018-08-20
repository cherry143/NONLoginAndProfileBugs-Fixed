//
//  UILabel+XPDUILabel.m
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 28/07/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import "UILabel+XPDUILabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation UILabel (XPDUILabel)

- (void) boldRange: (NSRange) range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range:range];
    self.attributedText = attributedText;
}

- (void) boldSubstring: (NSString*) substring {
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}

- (NSMutableAttributedString *)boldSubstringForLabel:(UILabel *)label forFirstString:(NSString*)firstString forSecondString:(NSString *)secondString{
    NSRange range = [self.text rangeOfString:firstString];
    [self boldRange:range];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:label.attributedText];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:NSMakeRange(0,firstString.length)];
    [text addAttribute:NSFontAttributeName
                 value:KTFontFamilySize(KTOpenSansSemiBold,KTiPad?22:16)
                 range:NSMakeRange(firstString.length,secondString.length+1)];
    return text;
}

-(NSMutableAttributedString *)underLineTextString:(NSString *)string{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    return attributeString;
}

- (NSMutableAttributedString *)differentBoldSubstringForLabel:(UILabel *)label forFirstString:(NSString*)firstString forSecondString:(NSString *)secondString{
    NSRange range = [self.text rangeOfString:firstString];
    [self boldRange:range];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:label.attributedText];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:NSMakeRange(0,firstString.length)];
    [text addAttribute:NSFontAttributeName
                 value:KTFontFamilySize(KTOpenSansSemiBold,KTiPad?16:12)
                 range:NSMakeRange(firstString.length,secondString.length+1)];
    return text;
}
@end
