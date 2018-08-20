//
//  LocateMeVC.m
//  KTrack
//
//  Created by mnarasimha murthy on 10/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import "LocateMeVC.h"


@interface LocateMeVC ()<CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MKMapViewDelegate>{
    CLLocationManager *locationManager;
    __weak IBOutlet UIButton *btn_showList;
    CLGeocoder *geocoder;
    __weak IBOutlet MKMapView *mapView_map;
    __weak IBOutlet UITextField *txt_cityNameField;
    double currentLat,currentLong;
    UIPickerView *picker_dropDown;
    NSArray *arr_locationNames,*arr_pinLocationArray;
}

@end

@implementation LocateMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialiseViewLoad];
    [self allocLocationManager];
    [self viewLoadMapInMapView];
    [self getBranchListAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitialiseViewLoad

-(void)initialiseViewLoad{
    [UITextField withoutRoundedCornerTextField:txt_cityNameField forCornerRadius:5.0f forBorderWidth:1.5f];
    [txt_cityNameField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    picker_dropDown=[[UIPickerView alloc]init];
    picker_dropDown.delegate=self;
    picker_dropDown.dataSource=self;
    picker_dropDown.backgroundColor=[UIColor whiteColor];
    [btn_showList setHidden:YES];
    [txt_cityNameField addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];

}

-(void)doneAction:(UIBarButtonItem *)done{
    [self fetchBranchesBasedOnCityName:[NSString stringWithFormat:@"%@",txt_cityNameField.text]];
    [txt_cityNameField resignFirstResponder];
}

#pragma mark - Alloc location

-(void)allocLocationManager{
    locationManager = [CLLocationManager new];
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    switch ([error code]) {
        case kCLErrorDenied:
                [self locationAccessDeined];
            break;
        case kCLErrorLocationUnknown:

            break;
        default:
            break;
    }
}

#pragma mark - Access Denied location

-(void)locationAccessDeined{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SharedUtility sharedInstance]showAlertWithTitle:@"Message" forMessage:@"" andAction1:@"" andAction2:@"" andAction1Block:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } andCancelBlock:^{
            
        }];
    });
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocation *currentLocation = newLocation;
    [locationManager stopUpdatingLocation];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CLPlacemark *placemark= [placemarks lastObject];
                currentLat=placemark.location.coordinate.latitude;
                currentLong=placemark.location.coordinate.longitude;
                [self setCenterCordinatesforLatitude:currentLat forLongitude:currentLong];
            });
        }
        else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}

- (IBAction)backAtc:(id)sender {
    KTPOP(YES);
}

#pragma mark - UIPickerView Delegates and DataSource methods Starts

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return arr_locationNames.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%@",arr_locationNames[row][@"city"]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    txt_cityNameField.text=[NSString stringWithFormat:@"%@",arr_locationNames[row][@"city"]];
}

#pragma mark - UIPickerView Delegates and DataSource methods Ends

#pragma mark - GET BRANCH LIST API

-(void)getBranchListAPI{
    [[APIManager sharedManager]showHUDInView:self.view hudMessage:@"Loading...!"];
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_url = [NSString stringWithFormat:@"%@GetBranchList?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[APIManager sharedManager]hideHUD];
            if (error_statuscode==0) {
                arr_locationNames=responce[@"Dtinformation"];
                txt_cityNameField.inputView=picker_dropDown;
                [picker_dropDown reloadAllComponents];
            }
            else{
                NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
                     [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            }
        });
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - LoadMapView

-(void)viewLoadMapInMapView{
    mapView_map.showsUserLocation=YES;
    mapView_map.delegate=self;
    [mapView_map setZoomEnabled:YES];
    [mapView_map setScrollEnabled:YES];
}

-(void)setCenterCordinatesforLatitude:(double)lati forLongitude:(double)longi{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lati, longi);
    [mapView_map setCenterCoordinate:coordinate animated:YES];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate,90000,90000);
    MKCoordinateRegion adjustedRegion = [mapView_map regionThatFits:viewRegion];
    [mapView_map setRegion:adjustedRegion animated:YES];
}

-(void)addPinWithTitle:(NSString *)title forLatitude:(double)latitude forLongitude:(double)longitude{
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = latitude;
    newRegion.center.longitude = longitude;
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate =newRegion.center;
    myAnnotation.title = title;
    [mapView_map addAnnotation:myAnnotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>) annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView_map dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image=[UIImage imageNamed:@"flag"];
            pinView.canShowCallout = YES;
        }
        else {
            pinView.annotation = annotation;
            pinView.image=[UIImage imageNamed:@"flag"];
            pinView.canShowCallout = YES;
        }
        return pinView;
    }
    return nil;
}

#pragma mark - fetch result based on cityName

-(void)fetchBranchesBasedOnCityName:(NSString *)cityName{
    NSString *unique_UDID = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTUniqueUDID];
    NSString *str_operatingSystem = [[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTOperationSystem];
    NSString *str_appVersion =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:KTAppVersion];
    NSString *str_cityName =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:cityName];
    NSString *str_latitude =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%f",currentLat]];
    NSString *str_longitude =[[SharedUtility sharedInstance]convertToBase64StrForAGivenString:[NSString stringWithFormat:@"%f",currentLong]];
    NSString *str_url = [NSString stringWithFormat:@"%@GetBranchAddress?Adminusername=c21hcnRzZXJ2aWNl&Adminpassword=a2FydnkxMjM0JTI0&IMEI=%@&OS=%@&APKVer=%@&City=%@&latde=%@&longtde=%@",KTBaseurl,unique_UDID,str_operatingSystem,str_appVersion,str_cityName,str_latitude,str_longitude];
    [[APIManager sharedManager]requestGetUrl:str_url parameters:nil success:^(NSDictionary *responce) {
        int error_statuscode=[responce[@"Dtinformation"][0][@"Error_Code"]intValue];
        if (error_statuscode==0) {
            [mapView_map removeAnnotations:[mapView_map annotations]];
            [btn_showList setHidden:NO];
            arr_pinLocationArray=responce[@"Dtinformation"];
            for (NSDictionary *dic in arr_pinLocationArray) {
                [self addPinWithTitle:dic[@"add1"] forLatitude:[dic[@"Latitude"]floatValue] forLongitude:[dic[@"Longitude"]floatValue]];
            }
            [self setCenterCordinatesforLatitude:[arr_pinLocationArray[0][@"Latitude"]floatValue] forLongitude:[arr_pinLocationArray[0][@"Longitude"]floatValue]];
        }
        else{
            NSString *error_message=[NSString stringWithFormat:@"%@",responce[@"Dtinformation"][0][@"Error_Message"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn_showList setHidden:YES];
                [[SharedUtility sharedInstance]showAlertViewWithTitle:KTError withMessage:error_message];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Show List Button Tapped

- (IBAction)btnShowListClicked:(UIButton *)sender {
    ShowBranchDetailsListVC *destinationController=[self.storyboard instantiateViewControllerWithIdentifier:KTShowBranchDetailsListViewController];
    destinationController.arr_branchDetailsRec=arr_pinLocationArray;
    destinationController.currentLocLatitude=currentLat;
    destinationController.currentLocLongitude=currentLong;
    [self addChildViewController:destinationController];
    [self.view addSubview:destinationController.view];
}

#pragma mark - TextFields Delegate Methods Starts

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([[APIManager sharedManager]hasInternetConnection]==NO) {
        [txt_cityNameField resignFirstResponder];
    }
    else{
        [textField becomeFirstResponder];
        txt_cityNameField.text=[NSString stringWithFormat:@"%@",arr_locationNames[0][@"city"]];
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

// if implemented, called in place of textFieldDidEndEditing:

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

// return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

// called when clear button pressed. return NO to ignore (no notifications)

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TextFields Delegate Methods Ends

@end
