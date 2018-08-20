
//
//  NonLoginVC.m
//  KTrack
//
//  Created by Ramakrishna MV on 11/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "NonLoginVC.h"
#import "CollectionViewCell.h"
@interface NonLoginVC ()<UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *nameArr;
    NSMutableArray *imageArr;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@end

@implementation NonLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
       self.backGroundView.hidden  = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    [self.backGroundView addGestureRecognizer:tapRecognizer];
   
    nameArr = [[NSMutableArray alloc]initWithObjects:@"Locate Us ",@"Missed Call Services",@"Easy SMS",@"Consolidated Account Statement",@"Know Your Transactions", nil];
    imageArr =[[NSMutableArray alloc]initWithObjects:@"locateus",@"misscall",@"sms",@"statement",@"transactions", nil];
    [self.collectionview registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
    [UIView roundedCornerEnableForView:self.smsView forCornerRadius:10.0f forBorderWidth:0.0f forApplyShadow:YES];
      [UIView roundedCornerEnableForView:self.callView forCornerRadius:10.0f forBorderWidth:0.0f forApplyShadow:YES];
    [self.callBtn.layer setCornerRadius:20.0f];
    [self.callBtn.layer setMasksToBounds:YES];[self.smsBtn.layer setCornerRadius:20.0f];
    [self.smsBtn.layer setMasksToBounds:YES];

// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender {
    
    self.backGroundView.hidden =YES;
    }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UICollectionView Datasource and Delegates

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return nameArr.count;
    
}

-( __kindof UICollectionViewCell  *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        CollectionViewCell *cell = [self.collectionview
                                        dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
        cell.servicelabel.text = nameArr[indexPath.row];
        if (KTiPad) {
            cell.servicelabel.font=KTFontFamilySize(KTOpenSansRegular, 16.0f);
        }
        return cell;
    
} 
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5.0,5.0,5.0,5.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(((self.view.frame.size.width-30)/3),130);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item==0) {
        LocateMeVC *nonLogin =[self.storyboard instantiateViewControllerWithIdentifier:@"LocateMeVC"];
        KTPUSH(nonLogin,YES);
    }
    else if (indexPath.item==1) {
        self.backGroundView.hidden  = NO;
        self.smsView.hidden  =YES;
        self.callView.hidden  =NO;
    }
    else if (indexPath.item==2) {
        self.backGroundView.hidden  = NO;
        self.smsView.hidden  =NO;
        self.callView.hidden  =YES;
    }
    else if (indexPath.item==3) {
        CASVC *nonLogin =[self.storyboard instantiateViewControllerWithIdentifier:@"CASVC"];
        KTPUSH(nonLogin,YES);
    }
    else if (indexPath.item==4) {
        KnowYourTransactionVC *nonLogin =[self.storyboard instantiateViewControllerWithIdentifier:KTKnowYourTransactionVC];
        KTPUSH(nonLogin,YES);
    }
}

- (IBAction)easySMS:(id)sender {
    self.backGroundView.hidden =YES;
    [self sendSMS];
}


-(void)easyCall{
    NSString *phoneNumber=@"09212993399";
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
#pragma mark - MFMessageComposeDelegate Method

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:KTSMSSendFailureMsg];
            });
            break;
        }
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
      self.backGroundView.hidden =YES;
}


#pragma mark - send SMS

-(void)sendSMS{
    if(![MFMessageComposeViewController canSendText]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:KTSMSNotSupportedMsg];
        });
        return;
    }
    NSArray *recipents = @[@"09212993399"];
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    messageController.body=@"Value";
    [messageController setRecipients:recipents];
    [self presentViewController:messageController animated:YES completion:nil];
}
- (IBAction)CommomAtc:(id)sender {
    CASVC *destinyVC=[self.storyboard instantiateViewControllerWithIdentifier:KTCommonAccountStatementViewController];
    [self.navigationController pushViewController:destinyVC animated:YES];
    
}

- (IBAction)transcationSAtc:(id)sender {
    
    KnowYourTransactionVC *destinyVC=[self.storyboard instantiateViewControllerWithIdentifier:KTKnowYourTransactionVC];
    [self.navigationController pushViewController:destinyVC animated:YES];
}

- (IBAction)backAtc:(id)sender {
    KTPOP(YES);
}

- (IBAction)callAtc:(id)sender {
    self.backGroundView.hidden =YES;
    [self easyCall];
}

@end
