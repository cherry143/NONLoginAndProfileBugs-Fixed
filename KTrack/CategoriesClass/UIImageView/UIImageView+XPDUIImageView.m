//
//  UIImageView+XPDUIImageView.m
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 28/07/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import "UIImageView+XPDUIImageView.h"

@implementation UIImageView (XPDUIImageView)

+(void)roundedCornerImage:(UIImageView *)imageView{
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [[UIColor clearColor] CGColor];
}

+(void)roundedCornerImageHalf:(UIImageView *)imageView{
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.height/2;
    imageView.layer.borderColor=[[UIColor clearColor] CGColor];
    imageView.layer.borderWidth=2.5f;
    imageView.layer.borderColor=[UIColor colorWithHexString:@"#529FCF"].CGColor;
}

+(void)portFolioRoundedCornerImageHalf:(UIImageView *)imageView{
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.height/2;
    imageView.layer.borderColor=[[UIColor clearColor] CGColor];
    imageView.layer.borderWidth=1.0f;
    imageView.layer.borderColor=[UIColor whiteColor].CGColor;
}

@end
