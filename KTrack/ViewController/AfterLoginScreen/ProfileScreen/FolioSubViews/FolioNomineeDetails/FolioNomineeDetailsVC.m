//
//  FolioNomineeDetailsVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 22/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "FolioNomineeDetailsVC.h"

@interface FolioNomineeDetailsVC (){
    NSArray *arr_folioNomineeList;
    __weak IBOutlet UITableView *tbl_nomineeInfo;
}

@end

@implementation FolioNomineeDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tbl_nomineeInfo.estimatedRowHeight=80.0f;
}

#pragma mark - Nominee Details View Will appear

-(void)viewWillAppear:(BOOL)animated{
    [self loadNomineeDetailsInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate and Data Source delegate starts

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_folioNomineeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FolioNomineeDetailsTblCell *cell=(FolioNomineeDetailsTblCell*)[tableView dequeueReusableCellWithIdentifier:@"FolioNominee"];
    if (cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FolioNomineeDetailsTblCell" owner:self options:nil];
        cell = (FolioNomineeDetailsTblCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    KT_TABLE9 *nominee_Rec= arr_folioNomineeList[indexPath.row];
    cell.lbl_schemeName.text=[NSString stringWithFormat:@"%@",nominee_Rec.schPln];
    if (KTiPad) {
        cell.lbl_schemeName.font=KTFontFamilySize(KTOpenSansRegular, 16.0f);
    }
    cell.lbl_detailsName.text=[NSString stringWithFormat:@"%@",nominee_Rec.nomDetails];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KTiPad?60.0f:40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width,0)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FolioNomineeDetailsTblCell *headerView=(FolioNomineeDetailsTblCell*)[tableView dequeueReusableCellWithIdentifier:@"FolioNominee"];
    if (headerView==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FolioNomineeDetailsTblCell" owner:self options:nil];
        headerView = (FolioNomineeDetailsTblCell *)[nib objectAtIndex:0];
        headerView.selectionStyle=UITableViewCellSelectionStyleNone;
        headerView.backgroundColor=[UIColor whiteColor];
    }
    headerView.lbl_schemeName.text=@"Scheme";
    if (KTiPad) {
        headerView.lbl_schemeName.font=KTFontFamilySize(KTOpenSansSemiBold, 16.0f);
        headerView.lbl_detailsName.font=KTFontFamilySize(KTOpenSansSemiBold,16.0f);
    }
    else{
        headerView.lbl_schemeName.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        headerView.lbl_detailsName.font=KTFontFamilySize(KTOpenSansSemiBold,12);
    }
    headerView.lbl_schemeName.textAlignment=NSTextAlignmentCenter;
    headerView.lbl_detailsName.textAlignment=NSTextAlignmentCenter;
    headerView.lbl_detailsName.text=@"Nominee Details";
    [headerView.lbl_schemeName setTextColor:KTButtonBackGroundBlue];
    [headerView.lbl_detailsName setTextColor:KTButtonBackGroundBlue];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Load Nominee Details Info

-(void)loadNomineeDetailsInfo{
    arr_folioNomineeList=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable9:[NSString stringWithFormat:@"SELECT * FROM TABLE9_NOMINEEDETAILS WHERE fund='%@' AND Acno='%@' ",XTAPP_DELEGATE.str_folioDetailFund,XTAPP_DELEGATE.str_folioDetailsAcno]];
    if (arr_folioNomineeList==0) {

    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [tbl_nomineeInfo reloadData];
        });
    }
}

@end
