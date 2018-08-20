//
//  ShowBranchDetailsListVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 11/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "ShowBranchDetailsListVC.h"

@interface ShowBranchDetailsListVC (){
    __weak IBOutlet UITableView *tbl_branchDetails;
    __weak IBOutlet NSLayoutConstraint *contraints_height;
}
@end

@implementation ShowBranchDetailsListVC
@synthesize arr_branchDetailsRec,currentLocLatitude,currentLocLongitude;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tbl_branchDetails.estimatedRowHeight=20.0f;
}

#pragma mark - View Did Appear

-(void)viewDidAppear:(BOOL)animated{
    if (arr_branchDetailsRec.count==1) {
        [self increaseHeightOfTheTableView:KTiPad?155.0f:135.0f];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TouchEvents

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    KTHIDEREMOVEVIEW;
    END_EDITING;
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - TableView Delegate and Data Source delegate starts

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_branchDetailsRec.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowBranchDetailsCell *cell=(ShowBranchDetailsCell*)[tableView dequeueReusableCellWithIdentifier:KTBranchDetailsCell];
    if (cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShowBranchDetailsCell" owner:self options:nil];
        cell = (ShowBranchDetailsCell *)[nib objectAtIndex:0];
        [tableView setSeparatorColor:[UIColor blackColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [self configureDataIntoBranchDetails:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, 0, tableView.frame.size.width,0)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width,0)];
    headerView.backgroundColor=[UIColor whiteColor];
    return headerView;
}

#pragma mark - TableView Delegate and Data Source delegate ends

#pragma mark - Configure Data In Cell

-(void)configureDataIntoBranchDetails:(ShowBranchDetailsCell*)cell atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic_branchRec=arr_branchDetailsRec[indexPath.row];
    cell.lbl_contactPerson.text=[NSString stringWithFormat:@"%@",dic_branchRec[@"Contactperson1"]];
    cell.lbl_emailID.text=[NSString stringWithFormat:@"%@",dic_branchRec[@"EmailID1"]];
    cell.lbl_branchName.text=[NSString stringWithFormat:@"%@",dic_branchRec[@"branchname"]];
    cell.lbl_address1.text=[NSString stringWithFormat:@"%@",dic_branchRec[@"add1"]];
    cell.lbl_address2.text=[NSString stringWithFormat:@"%@",dic_branchRec[@"add2"]];
    cell.lbl_address3.text=[NSString stringWithFormat:@"%@",dic_branchRec[@"add3"]];
    cell.lbl_zipCode.text=[NSString stringWithFormat:@"%@",dic_branchRec[@"pincode"]];
    [cell.btn_call addTarget:self action:@selector(btn_callTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_route addTarget:self action:@selector(btn_routeTapped:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - cell button Action

-(void)btn_callTapped:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_branchDetails];
    NSIndexPath *indexPath = [tbl_branchDetails indexPathForRowAtPoint:buttonPosition];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    }
    else{
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_branchDetails];
        NSIndexPath *indexPath = [tbl_branchDetails indexPathForRowAtPoint:buttonPosition];
        if (indexPath == nil){
            NSLog(@"couldn't find index path");
        }
        else{
            @try{
                NSDictionary *dic_branchRec=arr_branchDetailsRec[indexPath.row];
                NSString *phoneNumber=[NSString stringWithFormat:@"%@",dic_branchRec[@"telno1"]];
                NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:phoneNumber]];
                NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]];
                if ([UIApplication.sharedApplication canOpenURL:phoneUrl]) {
                    [UIApplication.sharedApplication openURL:phoneUrl];
                }
                else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl]) {
                    [UIApplication.sharedApplication openURL:phoneFallbackUrl];
                }
             }
             @catch (NSException *exception){
                
            }
        }
    }
}

-(void)btn_routeTapped:(UIButton *)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbl_branchDetails];
    NSIndexPath *indexPath = [tbl_branchDetails indexPathForRowAtPoint:buttonPosition];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    }
    else{
        NSDictionary *dic_branchRec=arr_branchDetailsRec[indexPath.row];
        double branchLat = [dic_branchRec[@"Latitude"] doubleValue];
        double branchLong = [dic_branchRec[@"Longitude"] doubleValue];
        
        NSString *string = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&directionsmode=driving",currentLocLatitude,currentLocLongitude,branchLat,branchLong];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
     //  NSString *string = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",currentLocLatitude,currentLocLongitude,branchLat,branchLong];
     //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
}

#pragma mark - Increase Table height

-(void)increaseHeightOfTheTableView:(CGFloat)height {
    contraints_height.active = YES;
    contraints_height.constant =height;
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
}

@end

