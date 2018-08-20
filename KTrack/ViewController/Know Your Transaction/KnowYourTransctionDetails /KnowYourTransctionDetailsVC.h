//
//  KnowYourTransctionDetailsVC.h
//  KTrack
//
//  Created by Ramakrishna MV on 23/04/18.
//  Copyright © 2018 narasimha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KnowYourTransctionDetailsVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *dateTableView;
@property (weak, nonatomic) IBOutlet UITableView *TransctionTableView;
@property (nonatomic,retain) NSArray *arr_transactRecords;

@end
