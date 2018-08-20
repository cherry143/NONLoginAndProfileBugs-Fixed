//
//  SlideMenuVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 02/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "SlideMenuVC.h"

@interface SlideMenuVC ()<UICollectionViewDelegateFlowLayout>{
    __weak IBOutlet UICollectionView *coll_menu;
    __weak IBOutlet UILabel *txt_userNameEmail;
    NSArray *arr_menuArr;
}

@end

@implementation SlideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self InitialiseViewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View DidLoad Initialise

-(void)InitialiseViewDidLoad{
    NSString *str_userName=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]];
    NSString *str_emailID=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserEmailID]]];
    txt_userNameEmail.text=[NSString stringWithFormat:@"Hello %@\n%@",str_userName,str_emailID];
    if (KTiPad) {
       txt_userNameEmail.font=KTFontFamilySize(KTOpenSansRegular, 16.0f);
    }
    [coll_menu registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
    coll_menu.backgroundColor=[UIColor clearColor];
    [self loadArrayComponents];
}

#pragma mark - Array Assigning Cancellation

-(void)loadArrayComponents{
    NSString *loginType=[[SharedUtility sharedInstance]readStringUserPreference:KTLoginTypeKey];
    NSArray *arr_primaryPan = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='%@'",@"P"]];
    if (arr_primaryPan.count>0) {
        NSArray *arr_familyPan = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE NOT flag='%@'",@"P"]];
        if (arr_familyPan.count>0) {
            if ([loginType isEqualToString:@"facebook"] || [loginType isEqual:@"facebook"] || [loginType isEqualToString:@"google"] || [loginType isEqual:@"google"]) {
                arr_menuArr=@[
                              @[@{@"Title":@"Transact",@"Image":@"MenuTransact"}, @{@"Title":@"Transact In Family Folios", @"Image":@"FamilyTrans"}, @{@"Title":@"Transaction History",@"Image":@"TransactionHistory"}, @{@"Title":@"NAV",@"Image":@"LatestNav"}, @{@"Title":@"Link Family Folios",@"Image":@"Associate_FamyMenu"}, @{@"Title":@"De-Link Family Folios",@"Image":@"DeAssociate"}, @{@"Title":@"Consolidated Account Statement",@"Image":@"AccStatement"}, @{@"Title":@"Cancel Systematic Transactions",@"Image":@"Cancellation"},@{@"Title":@"Link Your Aadhaar",@"Image":@"LinkAadhaar"}, @{@"Title":@"Link Aadhaar For Your Family Folios", @"Image":@"FamilyFolio"},  @{@"Title":@"KOTM",@"Image":@"Kotm"}, @{@"Title":@"Notifications",@"Image":@"Notifications"}, @{@"Title":@"Rate Us",@"Image":@"Ratings"}],
                              @[@{@"Title":@"My Profile",@"Image":@"ProfileDetails"}, @{@"Title":@"Logout",@"Image":@"Logout"}],
                              @[@{@"Title":@"Call Us",@"Image":@"MenuContact"}, @{@"Title":@"Raise A Query",@"Image":@"MenuQuery"}]];
            }
            else{
                arr_menuArr=@[
                              @[@{@"Title":@"Transact",@"Image":@"MenuTransact"}, @{@"Title":@"Transact In Family Folios", @"Image":@"FamilyTrans"}, @{@"Title":@"Transaction History",@"Image":@"TransactionHistory"}, @{@"Title":@"NAV",@"Image":@"LatestNav"}, @{@"Title":@"Link Family Folios",@"Image":@"Associate_FamyMenu"}, @{@"Title":@"De-Link Family Folios",@"Image":@"DeAssociate"}, @{@"Title":@"Consolidated Account Statement",@"Image":@"AccStatement"}, @{@"Title":@"Cancel Systematic Transactions",@"Image":@"Cancellation"},@{@"Title":@"Link Your Aadhaar",@"Image":@"LinkAadhaar"}, @{@"Title":@"Link Aadhaar For Your Family Folios", @"Image":@"FamilyFolio"},  @{@"Title":@"KOTM",@"Image":@"Kotm"}, @{@"Title":@"Notifications",@"Image":@"Notifications"}, @{@"Title":@"Rate Us",@"Image":@"Ratings"}],
                              @[@{@"Title":@"My Profile",@"Image":@"ProfileDetails"}, @{@"Title":@"Change Password",@"Image":@"ChangePassword"}, @{@"Title":@"PIN/Pattern Setup",@"Image":@"PinPattern"},@{@"Title":@"Logout",@"Image":@"Logout"}],
                              @[@{@"Title":@"Call Us",@"Image":@"MenuContact"}, @{@"Title":@"Raise A Query",@"Image":@"MenuQuery"}]];
            }
            
        }
        else{
            if ([loginType isEqualToString:@"facebook"] || [loginType isEqual:@"facebook"] || [loginType isEqualToString:@"google"] || [loginType isEqual:@"google"]) {
                arr_menuArr=@[
                              @[@{@"Title":@"Transact",@"Image":@"MenuTransact"}, @{@"Title":@"Transaction History",@"Image":@"TransactionHistory"}, @{@"Title":@"NAV",@"Image":@"LatestNav"}, @{@"Title":@"Link Family Folios",@"Image":@"Associate_FamyMenu"}, @{@"Title":@"Consolidated Account Statement",@"Image":@"AccStatement"}, @{@"Title":@"Cancel Systematic Transactions",@"Image":@"Cancellation"},@{@"Title":@"Link Your Aadhaar",@"Image":@"LinkAadhaar"}, @{@"Title":@"Link Aadhaar For Your Family Folios", @"Image":@"FamilyFolio"},  @{@"Title":@"KOTM",@"Image":@"Kotm"}, @{@"Title":@"Notifications",@"Image":@"Notifications"}, @{@"Title":@"Rate Us",@"Image":@"Ratings"}],
                              @[@{@"Title":@"My Profile",@"Image":@"ProfileDetails"}, @{@"Title":@"Logout",@"Image":@"Logout"}],
                              @[@{@"Title":@"Call Us",@"Image":@"MenuContact"}, @{@"Title":@"Raise A Query",@"Image":@"MenuQuery"}]];
            }
            else{
                
                arr_menuArr=@[
                              @[@{@"Title":@"Transact",@"Image":@"MenuTransact"}, @{@"Title":@"Transaction History",@"Image":@"TransactionHistory"}, @{@"Title":@"NAV",@"Image":@"LatestNav"}, @{@"Title":@"Link Family Folios",@"Image":@"Associate_FamyMenu"}, @{@"Title":@"Consolidated Account Statement",@"Image":@"AccStatement"}, @{@"Title":@"Cancel Systematic Transactions",@"Image":@"Cancellation"},@{@"Title":@"Link Your Aadhaar",@"Image":@"LinkAadhaar"}, @{@"Title":@"Link Aadhaar For Your Family Folios", @"Image":@"FamilyFolio"},  @{@"Title":@"KOTM",@"Image":@"Kotm"}, @{@"Title":@"Notifications",@"Image":@"Notifications"}, @{@"Title":@"Rate Us",@"Image":@"Ratings"}],
                              @[@{@"Title":@"My Profile",@"Image":@"ProfileDetails"}, @{@"Title":@"Change Password",@"Image":@"ChangePassword"}, @{@"Title":@"PIN/Pattern Setup",@"Image":@"PinPattern"},@{@"Title":@"Logout",@"Image":@"Logout"}],
                              @[@{@"Title":@"Call Us",@"Image":@"MenuContact"}, @{@"Title":@"Raise A Query",@"Image":@"MenuQuery"}]];
            }
            
        }
    }
    else{
        if ([loginType isEqualToString:@"facebook"] || [loginType isEqual:@"facebook"] || [loginType isEqualToString:@"google"] || [loginType isEqual:@"google"]) {
            arr_menuArr=@[
                          @[@{@"Title":@"Transact",@"Image":@"MenuTransact"}, @{@"Title":@"Transaction History",@"Image":@"TransactionHistory"}, @{@"Title":@"NAV",@"Image":@"LatestNav"}, @{@"Title":@"Consolidated Account Statement",@"Image":@"AccStatement"}, @{@"Title":@"Link Your Aadhaar",@"Image":@"LinkAadhaar"}, @{@"Title":@"Link Aadhaar For Your Family Folios", @"Image":@"LinkAadhaar"}, @{@"Title":@"Notifications",@"Image":@"Notifications"}, @{@"Title":@"Rate Us",@"Image":@"Ratings"}],
                          @[@{@"Title":@"My Profile",@"Image":@"ProfileDetails"}, @{@"Title":@"Logout",@"Image":@"Logout"}],
                          @[@{@"Title":@"Call Us",@"Image":@"MenuContact"}, @{@"Title":@"Raise A Query",@"Image":@"MenuQuery"}]];
        }
        else{
            arr_menuArr=@[
                          @[@{@"Title":@"Transact",@"Image":@"MenuTransact"}, @{@"Title":@"Transaction History",@"Image":@"TransactionHistory"}, @{@"Title":@"NAV",@"Image":@"LatestNav"}, @{@"Title":@"Consolidated Account Statement",@"Image":@"AccStatement"}, @{@"Title":@"Link Your Aadhaar",@"Image":@"LinkAadhaar"}, @{@"Title":@"Link Aadhaar For Your Family Folios", @"Image":@"LinkAadhaar"}, @{@"Title":@"Notifications",@"Image":@"Notifications"}, @{@"Title":@"Rate Us",@"Image":@"Ratings"}],
                          @[@{@"Title":@"My Profile",@"Image":@"ProfileDetails"}, @{@"Title":@"Change Password",@"Image":@"ChangePassword"}, @{@"Title":@"PIN/Pattern Setup",@"Image":@"PinPattern"},@{@"Title":@"Logout",@"Image":@"Logout"}],
                          @[@{@"Title":@"Call Us",@"Image":@"MenuContact"}, @{@"Title":@"Raise A Query",@"Image":@"MenuQuery"}]];
        }
    }
}

#pragma mark - CollectionView Delegate Methods Implementation

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return arr_menuArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    long int count=0;
    if (section==0){
        count=[arr_menuArr[0] count];
    }
    else if (section==1){
        count=[arr_menuArr[1] count];
    }
    else if (section==2){
        count=[arr_menuArr[2] count];
    }
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [coll_menu
                                dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.section==0) {
        NSDictionary *dic=arr_menuArr[0][indexPath.item];
        cell.servicelabel.text=[NSString stringWithFormat:@"%@",dic[@"Title"]];
        if (KTiPad) {
            cell.servicelabel.font=KTFontFamilySize(KTOpenSansRegular, 16.0f);
        }
        cell.imageView.image=[UIImage imageNamed:dic[@"Image"]];
    }
    else if (indexPath.section==1){
        NSDictionary *dic=arr_menuArr[1][indexPath.item];
        cell.servicelabel.text=[NSString stringWithFormat:@"%@",dic[@"Title"]];
        if (KTiPad) {
            cell.servicelabel.font=KTFontFamilySize(KTOpenSansRegular, 16.0f);
        }
        cell.imageView.image=[UIImage imageNamed:dic[@"Image"]];
    }
    else if (indexPath.section==2){
        NSDictionary *dic=arr_menuArr[2][indexPath.item];
        cell.servicelabel.text=[NSString stringWithFormat:@"%@",dic[@"Title"]];
        if (KTiPad) {
            cell.servicelabel.font=KTFontFamilySize(KTOpenSansRegular, 16.0f);
        }
        cell.imageView.image=[UIImage imageNamed:dic[@"Image"]];
    }
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5.0,5.0,5.0,5.0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    KTHIDEREMOVEVIEW;
    if (indexPath.section==0) {
        NSDictionary *dic=arr_menuArr[0][indexPath.item];
        NSString *str_title=[NSString stringWithFormat:@"%@",dic[@"Title"]];
        if ([str_title isEqual:@"Transact"]) {
            TransactNowVC *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"TransactNowVC"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"Transact In Family Folios"]) {
            TranscationWithfaimy *destination=[KTHomeStoryboard(@"Home") instantiateViewControllerWithIdentifier:@"TranscationWithfaimy"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"Transaction History"]) {
            TransactionHistorVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"TransactionHistorVC"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"KOTM"]) {
            MenuKOTMVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"MenuKOTMVC"];
            KTPUSH(destination,YES);

        }
        else if ([str_title isEqual:@"NAV"]) {
            NetAssetValueGraphVC *destination = [KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"NetAssetValueGraphVC"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"Link Family Folios"]) {
            LinkFamilyFolioVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"LinkFamilyFolioVC"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"De-Link Family Folios"]) {
            DELinkFolioVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"DELinkFolioVC"];
             KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"Link Your Aadhaar"]) {
             LinkAadhaarVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"LinkAadhaarVC"];
             KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"Link Aadhaar For Your Family Folios"]) {
            LinkAadhaarVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"LinkAadhaarVC"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"Consolidated Account Statement"]) {
            CommonAccountStatementVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"CommonAccountStatementVC"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"Cancel Systematic Transactions"]) {
            CancelSystematicTransactVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"CancelSystematicTransactVC"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"Notifications"]) {
            NotificationsVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"NotificationsVC"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"Rate Us"]) {
            NSString *iTunesLink = @"itms://itunes.apple.com/in/app/karvyforex/id1390446081?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }
    }
    else if(indexPath.section==1){
        NSDictionary *dic=arr_menuArr[1][indexPath.item];
        NSString *str_title=[NSString stringWithFormat:@"%@",dic[@"Title"]];
        if ([str_title isEqual:@"My Profile"]) {
            ProfileVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"ProfileVC"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"Change Password"]) {
            ChangePasswordVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"ChangePasswordVC"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"PIN/Pattern Setup"]) {
            PinPatternSetupVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"PinPatternSetupVC"];
            KTPUSH(destination,YES);
        }
        else if ([str_title isEqual:@"Logout"]) {
            NSString *userName = [[SharedUtility sharedInstance]readStringUserPreference:KTLoginShowPatternPin];
            if (userName.length!=0) {
                PinPatternVC *destination=[KTHomeStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"PinPatternVC"];
                KTPUSH(destination,YES);
            }
            else{
                LoginVC *destination=[KTHomeStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"LoginVC"];
                KTPUSH(destination,YES);
            }
        }
    }
    else if(indexPath.section==2){
        NSDictionary *dic=arr_menuArr[2][indexPath.item];
        NSString *str_title=[NSString stringWithFormat:@"%@",dic[@"Title"]];
        if ([str_title isEqual:@"Call Us"]) {
            NSString *phoneNumber=@"18004197744";
            NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:phoneNumber]];
            NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]];
            if ([UIApplication.sharedApplication canOpenURL:phoneUrl]) {
                [UIApplication.sharedApplication openURL:phoneUrl];
            }
            else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl]) {
                [UIApplication.sharedApplication openURL:phoneFallbackUrl];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:KTDeviceDoesnotSupportCalls];
                });
            }
        }
        else if ([str_title isEqual:@"Raise A Query"]) {
            LoginRaiseaQueryVC *destination=[KTHomeStoryboard(@"Menu") instantiateViewControllerWithIdentifier:@"LoginRaiseaQueryVC"];
            KTPUSH(destination,YES);
        }
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGSizeMake(((self.view.frame.size.width-30)/3),130);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        MenuHeaderView *headerView = [coll_menu dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MenuHeader" forIndexPath:indexPath];
        if (indexPath.section==0) {
            headerView.lbl_headerTitle.text=@"ACCOUNT DETAILS";
        }
        else if (indexPath.section==1){
            headerView.lbl_headerTitle.text = @"PERSONAL DETAILS";
        }
        else if (indexPath.section==2) {
            headerView.lbl_headerTitle.text = @"CUSTOMER SUPPORT";
        }
        if (KTiPad) {
            headerView.lbl_headerTitle.font=KTFontFamilySize(KTOpenSansSemiBold, 20.0f);
        }
        headerView.lbl_headerTitle.textColor=[UIColor lightGrayColor];
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark - close button tapped

- (IBAction)btn_closeTapped:(id)sender {
    KTHIDEREMOVEVIEW;
}

@end
