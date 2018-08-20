//
//  UIColor+HexColors.h
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 28/07/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColors)

+(UIColor *)colorWithHexString:(NSString *)hexString;
+(NSString *)hexValuesFromUIColor:(UIColor *)color;

-(CGFloat)red;
-(CGFloat)green;
-(CGFloat)blue;
-(CGFloat)alpha;

@end
