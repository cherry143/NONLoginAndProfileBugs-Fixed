//
//  SharedUtility.h
//  Ktrack
//
//  Created by Ramakrishna MV on 05/04/18.
//  Copyright © 2018 Ramakrishna MV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedUtility : NSObject

+(SharedUtility *)sharedInstance;

-(BOOL)validateNetWorthIntegerValue:(NSString *)numericNumber;
-(BOOL)validateIFSCCodeWithString:(NSString *)ifscCodeNumber;
-(BOOL)validateOnlyIntegerValue:(NSString *)numericNumber;
-(BOOL)validateZipCodeWithString:(NSString *)phoneNumber;
-(BOOL)validateOnlyAlphabets: (NSString *)alpha;
-(BOOL)validateAadhaarWithString:(NSString *)aadhaarNumber;
-(NSString *)checkForNullString:(id)string;
- (BOOL)validateEmailWithString:(NSString*)emailAddress;
-(BOOL)validateMobileWithString:(NSString *)phoneNumber;
-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message;

#pragma mark - Date Format Methods

- (NSString *)stringFromDateWithFormat :(NSString *)formatString date:(NSDate *)date;
- (NSDate *)changeDateFormatWithFormatterString:(NSString *)formatterString date:(NSString *)dateString;
- (NSDate *)changeDateFormatFromDate:(NSString *)formatterString date:(NSDate *)date;
- (NSArray *)stringFromDateWithFormatFromServer :(NSString *)formatString date:(NSString *)dateStr;

#pragma mark - NSUserDefaults Saving and clear and reading and removing
-(void) writeStringUserPreference:(NSString *) key value:(NSString *) value;
-(void) clearStringFromUserPreference:(NSString *) key;
-(NSString *) readStringUserPreference:(NSString *) key;
-(void)removeUserDefaults;

#pragma mark - Password Validation
- (BOOL)passwordIsValid:(NSString *)password;

#pragma mark - Regular Expression validation
+ (BOOL)validateString:(NSString*)stringToValidate regularExpression:(NSString*)regularExpression;

#pragma mark - Removing Null From Dictionary
-(NSMutableDictionary*)stripNulls:(NSDictionary*)dict;

#pragma mark - image Store and Delete from Local Directory
- (void)saveImage:(UIImage *)image forName:(NSString*)imageName;
-(void)deleteFilesFromLocalPathForModelName:(NSString *)imageName;

#pragma mark - Calculate number of days from given Date
-(NSString *)removeNullFromStr:(NSString *)givenStr;

#pragma mark - to get AM PM
- (NSString *)stringFromDateWithFormatForDate:(NSString *)dateStr;

#pragma mark - to get AM PM and Month Format also changes
- (NSArray *)stringFromDateWithFormatFromServerWithAMPMMonthFormat:(NSString *)formatString date:(NSString *)dateStr;

#pragma mark - Store Image Data into Local Path
- (void)saveImageData:(NSData*)imageData forName:(NSString*)imageName;

#pragma mark - Check Todate greater than from date
- (BOOL)isToDateIsGreaterFromDate:(NSString *)fromDate  forToDateTime:(NSString *)toDateTime;

#pragma mark - IEEE Dateformat
-(NSArray *)getweekDaYMonthYearFromString:(NSString *)str;

#pragma mark - this method to written
- (NSDate *)changeDateFormatWithFormatterStringInBookNow:(NSString *)formatterString date:(NSString *)dateString;

#pragma mark - AlertView With Actions

-(void)showAlertWithTitle:(NSString *)msgTitle forMessage:(NSString*)message andAction1:(NSString*)action1 andAction2:(NSString*)action2 andAction1Block:(void (^)(void))action1Block andCancelBlock:(void (^)(void))cancelBlock;

-(void)showAlertWithTitleWithSingleAction:(NSString *)msgTitle forMessage:(NSString*)message andAction1:(NSString*)action1 andAction1Block:(void (^)(void))action1Block;

#pragma mark - Convert To Base64Str
-(NSString *)convertToBase64StrForAGivenString:(NSString *)givenStr;
- (UIImage*)rotateImage:(UIImage*)sourceImage;
- (BOOL)doesString:(NSString*)string containString:(NSString*)otherString;

@end

