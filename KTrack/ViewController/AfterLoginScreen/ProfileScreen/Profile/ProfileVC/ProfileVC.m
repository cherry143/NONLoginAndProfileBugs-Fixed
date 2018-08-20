//
//  ProfileVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 17/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "ProfileVC.h"
#import <AVFoundation/AVFoundation.h>

@interface ProfileVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    __weak IBOutlet UITableView *tbl_profileList;
    __weak IBOutlet UIButton *btn_missingInfo;
    __weak IBOutlet UILabel *lbl_profilePercentage;
    __weak IBOutlet UIView *view_progressView;
    __weak IBOutlet UILabel *lbl_userName;
    __weak IBOutlet UIImageView *img_profile;
    NSArray *arr_profileRec,*arr_fundsRec;
    TYMProgressBarView *view_profileProgress;
    NSString *str_userPrimaryPan,*str_boolEKYC;
    BOOL ImageUploadTrue;
    int navigateScreen;
    __weak IBOutlet UIView *view_missingInfo;
}
@end

@implementation ProfileVC
@synthesize navScreenStage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
    [self initialiseViewOnLoad];
    [self loadProfilePicIfImageExists];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"MYProfile"];
    ImageUploadTrue=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - viewWIll Appear

-(void)viewDidAppear:(BOOL)animated{
    if (ImageUploadTrue==NO){
        if ([_str_fromScreen isEqualToString:@"NavScreen"] || [_str_fromScreen isEqual:@"NavScreen"]) {
            _str_fromScreen=@"";
            navigateScreen=navScreenStage;
            [self switchToScreen:navigateScreen];
        }
        else{
            [self getProfilePercentageAPI];
        }
    }
}

#pragma mark - InitialiseView

-(void)initialiseViewOnLoad{
    [UIImageView roundedCornerImageHalf:img_profile];
    [UIView roundedCornerEnableForView:view_progressView forCornerRadius:view_progressView.frame.size.height/2 forBorderWidth:0.0f forApplyShadow:NO];
    NSString *str_userName=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]];
    lbl_userName.text=[NSString stringWithFormat:@"Hello %@",str_userName.uppercaseString];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"Fill the missing information to achieve 100% completion"];
    [attriString addAttribute:NSUnderlineStyleAttributeName
                        value:@(NSUnderlineStyleSingle)
                        range:(NSRange){9,19}];
    NSMutableAttributedString *highlightedAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attriString];
    [highlightedAttributedString addAttribute:NSForegroundColorAttributeName value:KTWhiteColor range:NSMakeRange(0,[attriString length])];
    [btn_missingInfo setAttributedTitle:highlightedAttributedString forState:UIControlStateNormal];
    view_profileProgress=[[TYMProgressBarView alloc]initWithFrame:CGRectMake(0,0, view_progressView.frame.size.width, view_progressView.frame.size.height)];
    view_profileProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view_profileProgress.barFillColor=KTProgressUnFill;
    [view_progressView addSubview:view_profileProgress];
    NSArray *arr_primaryPan = [[DBManager sharedDataManagerInstance]fetchRecordFromTable12:[NSString stringWithFormat:@"SELECT * FROM TABLE12_PANDETAILS WHERE flag='%@'",@"P"]];
    if (arr_primaryPan.count>0) {
        KT_TABLE12 *rec_primaryPan=arr_primaryPan[0];
        str_userPrimaryPan=rec_primaryPan.PAN;
        str_boolEKYC=rec_primaryPan.KYC;
    }
    else{
        str_userPrimaryPan=@"";
        str_boolEKYC=@"";
    }
    if (str_userPrimaryPan.length>0) {
        arr_fundsRec = [[DBManager sharedDataManagerInstance]uniqueFetchRecordFromTable2:[NSString stringWithFormat:@"SELECT DISTINCT(fundDesc),fund FROM TABLE2_DETAILS WHERE PAN='%@' ORDER BY fundDesc",str_userPrimaryPan]];
        if (arr_fundsRec.count>0) {
            arr_profileRec=@[
                             @{@"RightImage":@"Demographic_P", @"Title":@"Demographic Details", @"LeftArrowImage":@"Demographic_Arrow"},
                             @{@"RightImage":@"Fatca_P", @"Title":@"FATCA Details", @"LeftArrowImage":@"Fatca_Arrow"},
                             @{@"RightImage":@"Communication_P", @"Title":@"Communication Details", @"LeftArrowImage":@"Comm__Arrow"},
                             @{@"RightImage":@"Nominee_P", @"Title":@"Nominee Details", @"LeftArrowImage":@"Nomiee_Arrow"},
                             @{@"RightImage":@"Bank_P", @"Title":@"Bank Details", @"LeftArrowImage":@"Bank_Arrow"},
                             @{@"RightImage":@"Folio_P", @"Title":@"Folio Details", @"LeftArrowImage":@"Folio_Arrow"}
                             ];
        }
        else{
            arr_profileRec=@[
                             @{@"RightImage":@"Demographic_P", @"Title":@"Demographic Details", @"LeftArrowImage":@"Demographic_Arrow"},
                             @{@"RightImage":@"Fatca_P", @"Title":@"FATCA Details", @"LeftArrowImage":@"Fatca_Arrow"},
                             @{@"RightImage":@"Communication_P", @"Title":@"Communication Details", @"LeftArrowImage":@"Comm__Arrow"},
                             @{@"RightImage":@"Nominee_P", @"Title":@"Nominee Details", @"LeftArrowImage":@"Nomiee_Arrow"},
                             @{@"RightImage":@"Bank_P", @"Title":@"Bank Details", @"LeftArrowImage":@"Bank_Arrow"}
                             ];
        }
        [tbl_profileList setScrollEnabled:YES];
    }
    else{
        arr_profileRec=@[
                         @{@"RightImage":@"Demographic_P", @"Title":@"Demographic Details", @"LeftArrowImage":@"Demographic_Arrow"}
                        ];
        [tbl_profileList setScrollEnabled:NO];
    }
    [tbl_profileList reloadData];
}

#pragma mark - Load Image In Image View if Profile Exists

-(void)loadProfilePicIfImageExists{
    NSString *str_userName=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/KTrackInvesco"];
    NSString *profileImagePath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png",str_userName,@"ImageProfile"]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:profileImagePath];
    if (fileExists){
        dispatch_async(dispatch_get_main_queue(), ^{
            img_profile.image=[UIImage imageWithContentsOfFile:profileImagePath];
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            img_profile.image=[UIImage imageNamed:@"User"];
        });
    }
}

#pragma mark - Button Back Tapped

- (IBAction)btn_backTapped:(id)sender {
    NSString *str_userName=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/KTrackInvesco"];
    NSString *profileImagePath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png",str_userName,@"ImageProfile"]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:profileImagePath];
    if (fileExists){
        
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]saveImage:img_profile.image forName:[NSString stringWithFormat:@"%@%@",str_userName, @"ImageProfile"]];
        });
    }
    KTPOP(YES);
}

- (IBAction)btn_uploadProfilePicToServer:(id)sender {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        [self showCameraActionSheet];
    }
    else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
             if(granted){
                 [self showCameraActionSheet];
             }
             else{
                 [self accessDenied];
             }
        }];
    }
}

#pragma mark - Move To Camera Access Denied By User

-(void)accessDenied{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
        [[SharedUtility sharedInstance]showAlertWithTitle:accessDescription forMessage:@"To give permissions tap on 'Change Settings' button" andAction1:@"Change Settings" andAction2:@"Cancel" andAction1Block:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } andCancelBlock:^{

        }];
    });
}

#pragma mark - show camera action sheet

-(void)showCameraActionSheet{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
            controller.allowsEditing = NO;
            controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            controller.delegate = self;
            [self.navigationController presentViewController:controller animated:YES completion: nil];
            
        }
        else{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:@"Message" withMessage:@"No Camera Available"];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self.navigationController presentViewController:controller animated:YES completion: nil];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:NO completion:nil];    }]];
    [alertController setModalPresentationStyle:UIModalPresentationFormSheet];
    alertController.popoverPresentationController.sourceView=img_profile;
    alertController.popoverPresentationController.permittedArrowDirections=UIPopoverArrowDirectionAny;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    ImageUploadTrue=YES;
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    image=[[SharedUtility sharedInstance]rotateImage:image];
    NSString *str_userName=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
         [[SharedUtility sharedInstance]saveImage:image forName:[NSString stringWithFormat:@"%@%@",str_userName, @"ImageProfile"]];
     });
    img_profile.image=image;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    ImageUploadTrue=YES;
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - TableView Delegate and Data Source delegate starts

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_profileRec.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileTblCell *cell=(ProfileTblCell*)[tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    if (cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileTblCell" owner:self options:nil];
        cell = (ProfileTblCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    NSDictionary  *dic= arr_profileRec[indexPath.row];
    cell.img_representation.image=[UIImage imageNamed:dic[@"RightImage"]];
    cell.lbl_representation.text=[NSString stringWithFormat:@"%@",dic[@"Title"]];
    if(KTiPad){
        cell.lbl_representation.font=KTFontFamilySize(KTOpenSansSemiBold, 16.0f);
    }
    cell.img_arrowRepresentation.image=[UIImage imageNamed:dic[@"LeftArrowImage"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KTiPad?90:70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width,1)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *str_userName=[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUserNameKey]]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/KTrackInvesco"];
    NSString *profileImagePath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png",str_userName,@"ImageProfile"]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:profileImagePath];
    if (fileExists){
        
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
           [[SharedUtility sharedInstance]saveImage:img_profile.image forName:[NSString stringWithFormat:@"%@%@",str_userName, @"ImageProfile"]];
        });
    }
    NSDictionary  *dic= arr_profileRec[indexPath.row];
    NSString *str_title=[NSString stringWithFormat:@"%@",dic[@"Title"]];
    if ([str_title isEqualToString:@"Demographic Details"] || [str_title isEqual:@"Demographic Details"]){
        [self moveToDemoScreen];
    }
    else if ([str_title isEqualToString:@"FATCA Details"] || [str_title isEqual:@"FATCA Details"]){
        [self FactaDetailsScreen];
    }
    else if ([str_title isEqualToString:@"Communication Details"] || [str_title isEqual:@"Communication Details"]){
        [self communicationDetailScreen];
    }
    else if ([str_title isEqualToString:@"Nominee Details"] || [str_title isEqual:@"Nominee Details"]){
        [self nomineeDetailsScreen];
    }
    else if ([str_title isEqualToString:@"Bank Details"] || [str_title isEqual:@"Bank Details"]){
        [self bankDetailsScreen];
    }
    else if ([str_title isEqualToString:@"Folio Details"] || [str_title isEqual:@"Folio Details"]){
        [self folioDetailsScreen];
    }
}

#pragma mark - TableView Delegate and Data Source delegate ends

#pragma mark - Navigation Code

-(void)moveToDemoScreen{
    DemographicDetailsVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"DemographicDetailsVC"];
    destination.str_selectedPrimaryPan=str_userPrimaryPan;
    destination.str_ekyc=str_boolEKYC;
    [self.navigationController pushViewController:destination animated:YES];
}

-(void)FactaDetailsScreen{
    FATCADetailsVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"FATCADetailsVC"];
    destination.str_selectedPrimaryPan=str_userPrimaryPan;
    [self.navigationController pushViewController:destination animated:YES];
}

-(void)communicationDetailScreen{
    CommunicationDetailsVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"CommunicationDetailsVC"];
    destination.str_selectedPrimaryPan=str_userPrimaryPan;
    [self.navigationController pushViewController:destination animated:YES];
}

-(void)nomineeDetailsScreen{
    NomineeDetailsListVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"NomineeDetailsListVC"];
    destination.str_selectedPrimaryPan=str_userPrimaryPan;
    [self.navigationController pushViewController:destination animated:YES];
}

-(void)bankDetailsScreen{
    BankDetailsListVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"BankDetailsListVC"];
    destination.str_selectedPrimaryPan=str_userPrimaryPan;
    [self.navigationController pushViewController:destination animated:YES];
}

-(void)folioDetailsScreen{
    FolioDetailsVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"FolioDetailsVC"];
    destination.str_selectedPrimaryPan=str_userPrimaryPan;
    [self.navigationController pushViewController:destination animated:YES];
}

#pragma mark - get Profile Percentage

-(void)getProfilePercentageAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_userId =[XTAPP_DELEGATE convertToBase64StrForAGivenString:[[SharedUtility sharedInstance]readStringUserPreference:KTLoginUsername]];
    NSString *str_url = [NSString stringWithFormat:@"%@Profilepercentage?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&userid=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_userId];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
                NSString *str_per=[NSString stringWithFormat:@"%@",responce[@"Dtdata"][0][@"Percentage"]];
                CGFloat cent=[str_per floatValue]/100;
                view_profileProgress.progress=cent;
                if (cent>0.0000000) {
                    view_profileProgress.barFillColor=KTPieChartLiquidColor;
                }
                else{
                    view_profileProgress.barFillColor=KTProgressUnFill;
                }
                lbl_profilePercentage.text=[NSString stringWithFormat:@"%@%%",str_per];
                navigateScreen=[responce[@"Table1"][0][@"Screen"] intValue];
                if ([str_per intValue]<100) {
                    [[SharedUtility sharedInstance]showAlertWithTitle:KTSuccessMsg forMessage:[NSString stringWithFormat:@"Your profile is not 100%% complete. Do you want to complete your profile to transact smoothly?"] andAction1:@"YES" andAction2:@"NO" andAction1Block:^{
                        [self switchToScreen:navigateScreen];
                    } andCancelBlock:^{
                        
                    }];
                   
                }
                else{
                    [view_missingInfo setHidden:YES];
                }
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

-(void)switchToScreen:(int)screenValue{
    switch (screenValue) {
        case 1:
            [self moveToDemoScreen];
            break;
        case 2:
             [self FactaDetailsScreen];
            break;
        case 3:
            [self communicationDetailScreen];
            break;
        case 4:
            [self nomineeDetailsScreen];
            break;
        case 5:
            [self bankDetailsScreen];
            break;
        case 6:
            [self folioDetailsScreen];
            break;
        default:
            break;
    }
}

#pragma mark - View DIDDisappear

-(void)viewDidDisappear:(BOOL)animated{
    ImageUploadTrue=NO;
}

#pragma mark - Missing Info Tapped

- (IBAction)btn_missingInfoTapped:(id)sender {
    [self switchToScreen:navigateScreen];
}

@end
