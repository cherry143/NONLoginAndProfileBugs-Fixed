//
//  FolioContactDetailsVC.m
//  KTrack
//
//  Created by Ramakrishna.M.V on 22/05/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "FolioContactDetailsVC.h"

@interface FolioContactDetailsVC (){
    NSArray *arr_folioContactList;
    __weak IBOutlet UITableView *tbl_contactInfo;
}
@end

@implementation FolioContactDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tbl_contactInfo.estimatedRowHeight=80.0f;
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadContactInfo];
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
    long int count=0;
    if (arr_folioContactList.count>0){
        count=3;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FolioContactDetailCell *cell=(FolioContactDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"FolioContactCell"];
    if (cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FolioContactDetailCell" owner:self options:nil];
        cell = (FolioContactDetailCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    KT_TABLE3 *contact_Rec= arr_folioContactList[0];
    if (indexPath.row==0){
        cell.img_representation.image=[UIImage imageNamed:@"FolioCall"];
        cell.lbl_representation.text=[NSString stringWithFormat:@"%@",contact_Rec.mobile];
    }
    else if (indexPath.row==1){
        cell.img_representation.image=[UIImage imageNamed:@"FolioMail"];
        cell.lbl_representation.text=[NSString stringWithFormat:@"%@",contact_Rec.email];
    }
    else if (indexPath.row==2){
        cell.img_representation.image=[UIImage imageNamed:@"FolioAddress"];
        cell.lbl_representation.text=[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@",contact_Rec.invName,contact_Rec.add1,contact_Rec.add2,contact_Rec.add3,contact_Rec.city,contact_Rec.state];
    }
    if (KTiPad) {
        cell.lbl_representation.font=KTFontFamilySize(KTOpenSansRegular, 16.0f);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=0.0f;
    if (indexPath.row==2) {
        height=UITableViewAutomaticDimension;
    }
    else{
        height=80.0f;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width,1)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadContactInfo{
    arr_folioContactList=[[DBManager sharedDataManagerInstance]fetchAllRecordsFromTable3:[NSString stringWithFormat:@"SELECT * FROM TABLE3_DETAILS WHERE fund='%@' AND Acno='%@' AND PAN = '%@'",XTAPP_DELEGATE.str_folioDetailFund,XTAPP_DELEGATE.str_folioDetailsAcno,XTAPP_DELEGATE.str_folioDetailsPan]];
    if (arr_folioContactList==0) {

    }
    else{
         dispatch_async(dispatch_get_main_queue(), ^{
             [tbl_contactInfo reloadData];
         });
    }
}

@end
