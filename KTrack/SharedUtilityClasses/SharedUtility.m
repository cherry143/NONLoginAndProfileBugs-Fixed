//
//  SharedUtility.m
//  KTrack
//
//  Created by Ramakrishna MV on 05/04/18.
//  Copyright © 2018 Ramakrishna MV. All rights reserved.
//

#import "SharedUtility.h"

@implementation SharedUtility

+(SharedUtility *)sharedInstance{
    static SharedUtility *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedInstance=[SharedUtility new];
    });
    return sharedInstance;
}

-(BOOL)validateAadhaarWithString:(NSString *)aadhaarNumber{
    NSString *aahaarRegex = @"[0-9]{12}$";
    NSPredicate *aahaarTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", aahaarRegex];
    BOOL stricterFilter= [aahaarTest evaluateWithObject:aadhaarNumber];
    return stricterFilter;
}

-(BOOL)validateOnlyAlphabets: (NSString *)alpha{
    NSString *abnRegex = @"[A-Za-z ]+";
    NSPredicate *abnTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", abnRegex];
    BOOL isValid = [abnTest evaluateWithObject:alpha];
    return isValid;
}

- (BOOL)validateEmailWithString:(NSString*)emailAddress{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL stricterFilter= [emailTest evaluateWithObject:emailAddress];
    return stricterFilter;
}

-(BOOL)validateMobileWithString:(NSString *)phoneNumber{
    NSString *phoneRegex = @"[6-9]{1}[0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL stricterFilter= [phoneTest evaluateWithObject:phoneNumber];
    return stricterFilter;
}

-(BOOL)validateOnlyIntegerValue:(NSString *)numericNumber{
    NSString *phoneRegex = @"^[0-9]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL stricterFilter= [phoneTest evaluateWithObject:numericNumber];
    return stricterFilter;
}

-(BOOL)validateNetWorthIntegerValue:(NSString *)numericNumber{
    NSString *phoneRegex = @"^[0-9]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL stricterFilter= [phoneTest evaluateWithObject:numericNumber];
    return stricterFilter;
}

-(BOOL)validateZipCodeWithString:(NSString *)phoneNumber{
    NSString *phoneRegex = @"[0-9]{6}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL stricterFilter= [phoneTest evaluateWithObject:phoneNumber];
    return stricterFilter;
}

-(BOOL)validateIFSCCodeWithString:(NSString *)ifscCodeNumber{
    NSString *phoneRegex = @"[A-Za-z]{4}[0-9]{7}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL stricterFilter= [phoneTest evaluateWithObject:ifscCodeNumber];
    return stricterFilter;
}

-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [XTAPP_DELEGATE.window.rootViewController presentViewController:alert animated:YES completion:nil];
}


-(NSString *)checkForNullString:(id)string {
    if ([string isKindOfClass:[NSNull class]] || string==nil){
        return @"";
    }
    else{
        if (![string isKindOfClass:[NSString class]]){
            NSString *str= [string stringValue];
            return str;
        }
        else{
            return string;
        }
    }
}

#pragma mark Date Format Methods

- (NSString *)stringFromDateWithFormat :(NSString *)formatString date:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return  [formatter stringFromDate:date];
}

- (NSArray *)stringFromDateWithFormatFromServer :(NSString *)formatString date:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dater = [dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:XTOnlyDateFormat];
    NSString *datestamp = [dateFormatter stringFromDate:dater];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *timeStamp = [dateFormatter stringFromDate:dater];
    NSArray *dateTimeArr=@[datestamp,timeStamp];
    return dateTimeArr;
}

- (NSDate *)changeDateFormatWithFormatterString:(NSString *)formatterString date:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    return [formatter dateFromString:dateString];
}

- (NSDate *)changeDateFormatWithFormatterStringInBookNow:(NSString *)formatterString date:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

- (NSDate *)changeDateFormatFromDate:(NSString *)formatterString date:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    NSString *dateString = [formatter stringFromDate:date];
    return [formatter dateFromString:dateString];
}

#pragma mark UserDefaults Saving
-(void)writeStringUserPreference:(NSString *)key value:(NSString *)value {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

-(void)clearStringFromUserPreference:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

-(NSString *)readStringUserPreference:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return (NSString *) [userDefaults objectForKey:key];
}

-(void)removeUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefaults dictionaryRepresentation];
    for (NSString *key in [dictionary allKeys])
    {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

#pragma mark - Password Validation

- (BOOL)isValidString:(NSString *)string {
    return [string rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound &&
    [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]].location != NSNotFound &&
    [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
}

- (BOOL)passwordIsValid:(NSString *)password {
    NSRange whiteSpaceRange = [password rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![self isValidString:password]) {
        return NO;
    }
    if ([password length] < 8) {
        return NO;
    }
    if (whiteSpaceRange.location != NSNotFound) {
        return NO;
    }
    return YES;
}

#pragma mark - Removing null from Dictionary

-(NSMutableDictionary*)stripNulls:(NSDictionary*)dict{
    //creating new copy of json object
    NSMutableDictionary *returnDict = [NSMutableDictionary new];
    //object that handles all json object keys
    NSArray *allKeys = [dict allKeys];
    //object that handles all json object values
    NSArray *allValues = [dict allValues];
    //iterating for n number of keys in json object
    for (int i=0; i<[allValues count]; i++)
    {  //replacing if the value for key is null with empty string
        if([allValues objectAtIndex:i] == (NSString*)[NSNull null] || [allValues objectAtIndex:i]==(id)[NSNull null]){
            [returnDict setValue:@"" forKey:[allKeys objectAtIndex:i]];
        }
        else
            [returnDict setValue:[NSString stringWithFormat:@"%@",[allValues objectAtIndex:i]] forKey:[allKeys objectAtIndex:i]];
    }
    return returnDict;
}

#pragma mark - Regular Expression validation

+ (BOOL)validateString:(NSString*)stringToValidate regularExpression:(NSString*)regularExpression
{
    BOOL successResult = YES;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:stringToValidate options:0 range:NSMakeRange(0, [stringToValidate length])];
    if (numberOfMatches <= 0)
    {
        successResult = NO;
    }
    
    return successResult;
}

#pragma mark - Deleting Saved Image in Local Directory

-(void)deleteFilesFromLocalPathForModelName:(NSString *)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
}

#pragma mark - Save Images in local directory

- (void)saveImage:(UIImage *)image forName:(NSString*)imageName{
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/KTrackInvesco"];
        NSString* path = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];
        NSData *imageData=UIImagePNGRepresentation(image);
        if (imageData!=nil) {
            [imageData writeToFile:path atomically:YES];
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
}

-(NSString *)removeNullFromStr:(NSString *)givenStr{
    NSString *newStr;
    if ([givenStr isEqualToString:@"(null)"] || [givenStr isEqualToString:@"(null)  "] || [givenStr isEqualToString:@"(null) "] || [givenStr isEqualToString:@"<null>"] || [givenStr isKindOfClass:(id)[NSNull null]]) {
        newStr=@"";
    }
    else{
        if (givenStr.length==0) {
            newStr=@"";
        }else{
            newStr=givenStr;
        }
    }
    return newStr;
}

- (NSString *)stringFromDateWithFormatForDate:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"DD/MM/yyyy"];
    NSDate *dater = [dateFormatter dateFromString:dateStr];
    //create date from string
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:XTOnlyDateFormat];
    NSString *datestamp = [dateFormatter stringFromDate:dater];
    return datestamp;
}

#pragma mark - to get AM PM and Month Format also changes
- (NSArray *)stringFromDateWithFormatFromServerWithAMPMMonthFormat:(NSString *)formatString date:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dater = [dateFormatter dateFromString:dateStr];
    //create date from string
    
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:@"dd MMM YY"];
    NSString *datestamp = [dateFormatter stringFromDate:dater];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *timeStamp = [dateFormatter stringFromDate:dater];
    NSArray *dateTimeArr=@[datestamp,timeStamp];
    return dateTimeArr;
}


#pragma mark - Save Images Data in local directory

- (void)saveImageData:(NSData*)imageData forName:(NSString*)imageName{
    if (imageData!= nil && imageName!=nil){
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/XuperParkDriverImage"];
        NSString* path = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];
        if (imageData!=nil) {
            [imageData writeToFile:path atomically:YES];
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
}

- (BOOL)isToDateIsGreaterFromDate:(NSString *)fromDate  forToDateTime:(NSString *)toDateTime{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setTimeZone:[NSTimeZone systemTimeZone]];
    [f setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate* enddate = [f dateFromString:toDateTime];
    NSDate* currentdate =[f dateFromString:fromDate];
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    if (secondsBetweenDates>0)
        return YES;
    else
        return NO;
}

-(NSArray *)getweekDaYMonthYearFromString:(NSString *)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [formatter dateFromString:str];
    [formatter setDateFormat:@"EEE, MMM dd, yyyy"];
    NSString *dateStampWeek=[formatter stringFromDate:date];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *timeStamp =[formatter stringFromDate:date];
    NSArray *dateArray=@[dateStampWeek,timeStamp];
    return dateArray;
}

#pragma mark - User Actions

-(void)showAlertWithTitle:(NSString *)msgTitle forMessage:(NSString*)message andAction1:(NSString*)action1 andAction2:(NSString*)action2 andAction1Block:(void (^)(void))action1Block andCancelBlock:(void (^)(void))cancelBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:msgTitle
                                      message:message
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * yesButton = [UIAlertAction
                                     actionWithTitle:action1
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         if (action1Block) {
                                             action1Block();
                                         }
                                     }];
        
        [alert addAction:yesButton];
        UIAlertAction * cancelButton = [UIAlertAction
                                        actionWithTitle:action2
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                            if (cancelBlock) {
                                                cancelBlock();
                                            }
                                        }];
        
        [alert addAction:cancelButton];
        [[[XTAPP_DELEGATE window] rootViewController] presentViewController:alert animated:YES completion:nil];
    });
}

-(void)showAlertWithTitleWithSingleAction:(NSString *)msgTitle forMessage:(NSString*)message andAction1:(NSString*)action1 andAction1Block:(void (^)(void))action1Block{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:msgTitle
                                      message:message
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * yesButton = [UIAlertAction
                                     actionWithTitle:action1
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         if (action1Block) {
                                             action1Block();
                                         }
                                     }];
        [alert addAction:yesButton];
        [[[XTAPP_DELEGATE window] rootViewController] presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - Convert To Base64Str

-(NSString *)convertToBase64StrForAGivenString:(NSString *)givenStr{
    NSData *plainTextData = [givenStr dataUsingEncoding:NSUTF8StringEncoding];
    return [plainTextData base64EncodedString];
}

- (UIImage*)rotateImage:(UIImage*)sourceImage{
    if (sourceImage.imageOrientation == UIImageOrientationUp) return sourceImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, sourceImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, sourceImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, sourceImage.size.width, sourceImage.size.height,
                                             CGImageGetBitsPerComponent(sourceImage.CGImage), 0,
                                             CGImageGetColorSpace(sourceImage.CGImage),
                                             CGImageGetBitmapInfo(sourceImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,sourceImage.size.height,sourceImage.size.width), sourceImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,sourceImage.size.width,sourceImage.size.height), sourceImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (BOOL)doesString:(NSString*)string containString:(NSString*)otherString {
    if([string rangeOfString:otherString options:NSCaseInsensitiveSearch].location != NSNotFound)
        return YES;
    else
        return NO;
}

@end
