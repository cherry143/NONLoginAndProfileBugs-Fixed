
//
//  KnowYourTransctionDetailsVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 23/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "KnowYourTransctionDetailsVC.h"

@interface KnowYourTransctionDetailsVC ()

@end

@implementation KnowYourTransctionDetailsVC
@synthesize arr_transactRecords;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_transactRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.dateTableView) {
        KYTDateCell *cell = [[KYTDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KYTDateCell"];
        if (cell!=nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KYTDateCell" owner:self options:nil];
            cell = (KYTDateCell *)[nib objectAtIndex:0];
            [tableView setSeparatorColor:[UIColor blackColor]];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        NSDictionary *dic=arr_transactRecords[indexPath.row];
        cell.lbl_date.textColor  =[UIColor  blackColor];
        
        cell.lbl_date.text=[NSString stringWithFormat:@"%@",dic[@"Transaction Date"]];
        return cell;
    }
    else if (tableView == self.TransctionTableView){
         KYTDetailsCell *cell = [[KYTDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KYTDetailsCell"];
        if (cell!=nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KYTDetailsCell" owner:self options:nil];
            cell = (KYTDetailsCell *)[nib objectAtIndex:0];
            [tableView setSeparatorColor:[UIColor blackColor]];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dic=arr_transactRecords[indexPath.row];
        cell.lbl_trasactType.text=[NSString stringWithFormat:@"%@",dic[@"Trtype"]];
        cell.lbl_trasactType.textColor  =[UIColor  blackColor];
        cell.lbl_scheme.textColor  =[UIColor  blackColor];

        cell.lbl_scheme.text=[NSString stringWithFormat:@"%@",dic[@"Scheme Desc"]];
        NSString *str_Transstatus=[NSString stringWithFormat:@"%@",dic[@"Transaction Status"]];
        if ([str_Transstatus caseInsensitiveCompare:@"Rejected"]==NSOrderedSame || [str_Transstatus caseInsensitiveCompare:@"Pre Rejected"]==NSOrderedSame ) {
            [cell.btn_transact setAttributedTitle:[UIButton underlineForButton:str_Transstatus forAttributedColor:[UIColor redColor]] forState:UIControlStateNormal];
        }
        else{
            [cell.btn_transact setTitle:str_Transstatus forState:UIControlStateNormal];
            [cell.btn_transact setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        return cell;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.dateTableView) {
        KYTDateCell *headerView=(KYTDateCell*)[tableView dequeueReusableCellWithIdentifier:@"KYTDateCell"];
        if (headerView==nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KYTDateCell" owner:self options:nil];
            headerView = (KYTDateCell *)[nib objectAtIndex:0];
            headerView.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        headerView.lbl_date.text=@"Date";
        headerView.lbl_date.font=KTFontFamilySize(KTOpenSansSemiBold,12);
        [headerView.lbl_date setTextColor:KTButtonBackGroundBlue];
        return headerView;
    }
    if (tableView == self.TransctionTableView) {
        DetailsHeaderCell *headerView=(DetailsHeaderCell*)[tableView dequeueReusableCellWithIdentifier:@"DetailsHeaderCell"];
        if (headerView==nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailsHeaderCell" owner:self options:nil];
            headerView = (DetailsHeaderCell *)[nib objectAtIndex:0];
            headerView.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        return headerView;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}


#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.dateTableView) {
        CGFloat offsetY= self.dateTableView.contentOffset.y;
        CGPoint itemOffsetY=self.TransctionTableView.contentOffset;
        itemOffsetY.y=offsetY;
        self.TransctionTableView.contentOffset=itemOffsetY;
        if(offsetY==0){
            self.TransctionTableView.contentOffset=CGPointZero;
        }
    }
    else{
        CGFloat offsetY= self.TransctionTableView.contentOffset.y;
        CGPoint itemOffsetY=self.dateTableView.contentOffset;
        itemOffsetY.y=offsetY;
        self.dateTableView.contentOffset=itemOffsetY;
        if(offsetY==0){
            self.dateTableView.contentOffset=CGPointZero;
        }
    }
    
}


- (IBAction)backAct:(UIButton *)sender {
    KTPOP(YES);
}

@end
