//
//  NotificationsVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 29/06/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "NotificationsVC.h"

@interface NotificationsVC (){
    NSArray *arr_notificationList;
    __weak IBOutlet UILabel *lbl_errorMsg;
    __weak IBOutlet UITableView *tbl_notifications;
}
@end

@implementation NotificationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [lbl_errorMsg setHidden:YES];
    [tbl_notifications setHidden:YES];
    [self getUserNotificationsAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NotificationList API

-(void)getUserNotificationsAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_url = [NSString stringWithFormat:@"%@getNotifications?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&uid=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Table"][0][@"Error_code"]intValue];
        if (error_statuscode==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                arr_notificationList=responce[@"Dtdata"];
                [lbl_errorMsg setHidden:YES];
                [tbl_notifications setHidden:NO];
                [tbl_notifications reloadData];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIManager sharedManager]hideHUD];
                [lbl_errorMsg setHidden:NO];
                [tbl_notifications setHidden:YES];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_notificationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationTblCell *cell = [[NotificationTblCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationCell"];
    if (cell!=nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTblCell" owner:self options:nil];
        cell = (NotificationTblCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    NSDictionary *dic=arr_notificationList[indexPath.row];
    NSString *str_transactionType=[NSString stringWithFormat:@"%@",dic[@"kn_trtype"]];
    cell.lbl_notifinationName.text=[NSString stringWithFormat:@"%@",dic[@"kn_fund"]];
    if ([str_transactionType rangeOfString:@"NEW" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        if ([str_transactionType rangeOfString:@"RED" options:NSCaseInsensitiveSearch].location == NSNotFound || [str_transactionType rangeOfString:@"FUL" options:NSCaseInsensitiveSearch].location == NSNotFound) {
            if ([str_transactionType rangeOfString:@"SWOP" options:NSCaseInsensitiveSearch].location == NSNotFound || [str_transactionType rangeOfString:@"SWOF" options:NSCaseInsensitiveSearch].location == NSNotFound || [str_transactionType rangeOfString:@"LTOP" options:NSCaseInsensitiveSearch].location == NSNotFound || [str_transactionType rangeOfString:@"LTOF" options:NSCaseInsensitiveSearch].location == NSNotFound) {
                if ([str_transactionType rangeOfString:@"ISIP" options:NSCaseInsensitiveSearch].location == NSNotFound) {
                    if ([str_transactionType rangeOfString:@"STP" options:NSCaseInsensitiveSearch].location == NSNotFound) {
                        if ([str_transactionType rangeOfString:@"SWP" options:NSCaseInsensitiveSearch].location == NSNotFound) {
                            if ([str_transactionType rangeOfString:@"Add" options:NSCaseInsensitiveSearch].location == NSNotFound) {
                                cell.img_typeNotification.image=[UIImage imageNamed:@"Notification"];
                                cell.lbl_notifinationName.textColor=[UIColor colorWithHexString:@"#adadad"];
                            }
                            else {
                                cell.img_typeNotification.image=[UIImage imageNamed:@"AdditionalPurchase"];
                                cell.lbl_notifinationName.textColor=[UIColor colorWithHexString:@"#47736d"];
                            }
                        }
                        else {
                            cell.img_typeNotification.image=[UIImage imageNamed:@"SWPTransact"];
                            cell.lbl_notifinationName.textColor=[UIColor colorWithHexString:@"#c72d43"];
                        }
                    }
                    else {
                        cell.img_typeNotification.image=[UIImage imageNamed:@"STPTransact"];
                        cell.lbl_notifinationName.textColor=[UIColor colorWithHexString:@"#156497"];
                    }
                }
                else {
                    cell.img_typeNotification.image=[UIImage imageNamed:@"SIP"];
                    cell.lbl_notifinationName.textColor=[UIColor colorWithHexString:@"#c72d43"];
                }
            }
            else {
                cell.img_typeNotification.image=[UIImage imageNamed:@"Switch"];
                cell.lbl_notifinationName.textColor=[UIColor colorWithHexString:@"#a95f0f"];
            }
        }
        else {
            cell.img_typeNotification.image=[UIImage imageNamed:@"Redemption"];
            cell.lbl_notifinationName.textColor=[UIColor colorWithHexString:@"#4f34b0"];
        }
    }
    else {
        cell.img_typeNotification.image=[UIImage imageNamed:@"NewPurchase"];
        cell.lbl_notifinationName.textColor=[UIColor colorWithHexString:@"#328b4f"];
    }
    cell.lbl_notificationDate.text=[NSString stringWithFormat:@"%@",dic[@"kn_date"]];
    cell.lbl_notificationDescription.text=[NSString stringWithFormat:@"%@",dic[@"kn_msg"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width,5)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width,5)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}

#pragma mark - back Button Tapped

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

@end
