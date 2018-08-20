//
//  SCPinAppearance.m
//  SCPinViewController
//
//  Created by Maxim Kolesnik on 16.07.16.
//  Copyright © 2016 Sugar and Candy. All rights reserved.
//

#import "SCPinAppearance.h"

@implementation SCPinAppearance


+ (instancetype)defaultAppearance {
    SCPinAppearance *defaultAppearance = [[SCPinAppearance alloc]init];
    return defaultAppearance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDefaultAppearance];
    }
    return self;
}

-(void)setupDefaultAppearance {
    UIColor *defaultColor = [UIColor colorWithRed:58.0f / 255.0f green:145.0f / 255.0f blue:200.0f / 255.0f alpha:1];
    UIFont *defaultFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f];
    self.numberButtonColor = defaultColor;
    self.numberButtonTitleColor = [UIColor whiteColor];
    self.numberButtonStrokeColor = defaultColor;
    self.numberButtonStrokeWitdh = 0.0f;
    self.numberButtonstrokeEnabled = YES;
    self.numberButtonFont = defaultFont;
    
    self.deleteButtonColor = [UIColor whiteColor];
    
    self.pinFillColor = defaultColor;
    self.pinHighlightedColor = [UIColor whiteColor];
    self.pinStrokeColor = defaultColor;
    self.pinStrokeWidth = 0.8f;
    self.pinSize = CGSizeMake(18.0f,18.0f);
    
    self.touchIDButtonEnabled = YES;
    self.touchIDButtonColor = defaultColor;
    
    self.titleText = @"Enter Pin";
    self.titleTextFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
    self.titleTextColor = [UIColor colorWithRed:165.0f/255.0f green:194.0f/255.0f blue:223.0f/255.0f alpha:1];
    self.confirmText = @"CONFIRM YOUR PIN";
    self.supportText = nil;
    self.supportTextFont = defaultFont;
    self.supportTextColor = defaultColor;
    
    self.cancelButtonEnabled = NO;
    self.cancelButtonText = @"SIGN IN USING USERNAME";
    self.cancelButtonTextFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f];;
    self.cancelButtonTextColor = defaultColor;
}


@end
