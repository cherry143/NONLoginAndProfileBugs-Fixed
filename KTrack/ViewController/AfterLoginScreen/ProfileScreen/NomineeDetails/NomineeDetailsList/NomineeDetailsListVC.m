//
//  NomineeDetailsListVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 24/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "NomineeDetailsListVC.h"

@interface NomineeDetailsListVC (){
    __weak IBOutlet UIButton *btn_profileDashboard;
    __weak IBOutlet UIButton *btn_addNewAccount;
    __weak IBOutlet UITableView *tbl_nomineeList;
    NSArray *arr_nomineeList;
}

@end

@implementation NomineeDetailsListVC
@synthesize str_selectedPrimaryPan;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
    [self initialiseOnViewLoad];
    [XTAPP_DELEGATE callPagelogOnEachScreen:@"NomineeDetailsList"];
}

#pragma mark - View Did appear

-(void)viewDidAppear:(BOOL)animated{
    [self getNomineeDetailsFromAPI:str_selectedPrimaryPan];
}

#pragma mark - ViewLoad

-(void)initialiseOnViewLoad{
    [UIButton roundedCornerButtonWithoutBackground:btn_profileDashboard forCornerRadius:KTiPad?25.0f:btn_profileDashboard.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [UIButton roundedCornerButtonWithoutBackground:btn_addNewAccount forCornerRadius:KTiPad?25.0f:btn_addNewAccount.frame.size.height/2 forBorderWidth:0.0f forBorderColor:KTClearColor forBackGroundColor:KTButtonBackGroundBlue];
    [btn_profileDashboard setHidden:YES];
    [btn_addNewAccount setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate and Data Source delegate starts

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arr_nomineeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankFolioTblCell *cell=(BankFolioTblCell*)[tableView dequeueReusableCellWithIdentifier:@"FolioContactCell"];
    if (cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BankFolioTblCell" owner:self options:nil];
        cell = (BankFolioTblCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.layer.cornerRadius=5.0f;
    }
    NSDictionary *dic=arr_nomineeList[indexPath.section];
    cell.img_common.image=[UIImage imageNamed:@"Default_Bank_Nominee_Background"];
    cell.lbl_common.text=[NSString stringWithFormat:@"Name : %@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dic[@"kn_NomName"]]]]];
    cell.lbl_commonDetail.text=[NSString stringWithFormat:@"Relation : %@",[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dic[@"kn_NomRelation"]]]]];
    [cell.lbl_common setAttributedText:[cell.lbl_common differentBoldSubstringForLabel:cell.lbl_common forFirstString:@"Name :" forSecondString:[XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dic[@"kn_NomName"]]]]]];
    [cell.lbl_commonDetail setAttributedText:[cell.lbl_commonDetail differentBoldSubstringForLabel:cell.lbl_commonDetail forFirstString:@"Relation :" forSecondString: [XTAPP_DELEGATE removeNullFromStr:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dic[@"kn_NomRelation"]]]]]];
    [cell.btn_delete addTarget:self action:@selector(deleteNomineeRec:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic=arr_nomineeList[indexPath.section];
    NomineeDetailsVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"NomineeDetailsVC"];
    destination.str_selectedPrimaryPan=str_selectedPrimaryPan;
    destination.str_fromScreen=@"ShowDetails";
    destination.dic_selectedNomineeRec=dic;
    [self.navigationController pushViewController:destination animated:YES];
}

#pragma mark - Button Action

- (IBAction)btn_myProfileDashboardTapped:(id)sender {
    KTPOP(YES);
}

- (IBAction)btn_newAccountTapped:(id)sender {
    NomineeDetailsVC *destination=[KTHomeStoryboard(@"Profile") instantiateViewControllerWithIdentifier:@"NomineeDetailsVC"];
    destination.str_selectedPrimaryPan=str_selectedPrimaryPan;
    [self.navigationController pushViewController:destination animated:YES];
}

- (IBAction)btn_backTapped:(id)sender {
    KTPOP(YES);
}

#pragma mark - Get Nominee Details

-(void)getNomineeDetailsFromAPI:(NSString *)userPAN{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_PAN =[XTAPP_DELEGATE convertToBase64StrForAGivenString:userPAN];
    NSString *str_fund =[XTAPP_DELEGATE convertToBase64StrForAGivenString:@""];
    NSString *str_url = [NSString stringWithFormat:@"%@GetNomineeDetailsbyPAN?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&Fund=%@&PAN=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_fund,str_PAN];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        arr_nomineeList=responce[@"Table"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            [btn_profileDashboard setHidden:NO];
            [btn_addNewAccount setHidden:NO];
            if ([arr_nomineeList count]>0) {
                [tbl_nomineeList setHidden:NO];
                [tbl_nomineeList reloadData];
            }
            else{
                [tbl_nomineeList setHidden:YES];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:@"No Nominee record found."];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Action for Delete Button

-(void)deleteNomineeRec:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_nomineeList];
    NSIndexPath *indexPath = [tbl_nomineeList indexPathForRowAtPoint:buttonPosition];
    if (indexPath!=nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic=arr_nomineeList[indexPath.section];
            [[SharedUtility sharedInstance]showAlertWithTitle:@"Information" forMessage:[NSString stringWithFormat:@"Are you sure that want to delete %@ from nominees list?",[NSString stringWithFormat:@"%@",dic[@"kn_NomName"]]] andAction1:@"YES" andAction2:@"NO" andAction1Block:^{
                [self getDeleteNomineeDetailsFromAPI:str_selectedPrimaryPan forNomineeID:[NSString stringWithFormat:@"%@",dic[@"kn_slno"]]];
            } andCancelBlock:^{
               
            }];
        });
    }
}

#pragma mark - Delete Nominee API

-(void)getDeleteNomineeDetailsFromAPI:(NSString *)userPAN forNomineeID:(NSString *)serialNomineeID{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [XTAPP_DELEGATE convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[XTAPP_DELEGATE convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_PAN =[XTAPP_DELEGATE convertToBase64StrForAGivenString:userPAN];
    NSString *str_nomineeID =[XTAPP_DELEGATE convertToBase64StrForAGivenString:serialNomineeID];
    NSString *str_url = [NSString stringWithFormat:@"%@DeleteNominee?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&PAN=%@&Slno=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_PAN,str_nomineeID];
    NSLog(@"%@",str_url);
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
            if (error_statuscode==0) {
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    [[SharedUtility sharedInstance]showAlertWithTitleWithSingleAction:KTSuccessMsg forMessage:error_message andAction1:@"OK" andAction1Block:^{
                        [self getNomineeDetailsFromAPI:str_selectedPrimaryPan];
                    }];
                });
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APIManager sharedManager]hideHUD];
                    [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
                });
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

@end
