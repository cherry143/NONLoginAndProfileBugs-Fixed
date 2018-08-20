//
//  DBManager.h
//  KTrack
//
//  Created by Narasimha Murthy on 10/04/18.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject{
    NSString *str_databasePath;
    NSString *str_dbPath;
}

+(DBManager *)sharedDataManagerInstance;
-(void)createDatabase;

#pragma mark - common method like close open update delete query from table methods

- (void)executeUpdateQuery:(NSString*)queryString;
- (void)executeDeleteQuery:(NSString*)queryString;
-(void)openDataBase;
-(void)closeDataBase;

#pragma mark - Insering records from table methods

-(void)insertIntoTable14:(NSArray *)table14Rec;
-(void)insertIntoTable13:(NSArray *)table13Rec;
-(void)insertIntoTable12:(NSArray *)table12Rec;
-(void)insertIntoTable11:(NSArray *)table11Rec;
-(void)insertIntoTable10:(NSArray *)table10Rec;
-(void)insertIntoTable9:(NSArray *)table9Rec;
-(void)insertIntoTable8:(NSArray *)table8Rec;
-(void)insertIntoTable7:(NSArray *)table7Rec;
-(void)insertIntoTable6:(NSArray *)table6Rec;
-(void)insertIntoTable5:(NSArray *)table5Rec;
-(void)insertIntoTable4:(NSArray *)table4Rec;
-(void)insertIntoTable3:(NSArray *)table3Rec;
-(void)insertIntoTable2:(NSArray *)table2Rec;

#pragma mark - Fetching records from table methods
-(NSArray *)fetchRecordFromTable2:(NSString *)fetchQuery;
-(NSArray *)fetchRecordFromTable4:(NSString *)fetchQuery;
-(NSArray *)fetchRecordFromTable6:(NSString *)fetchQuery;
-(NSArray *)fetchRecordFromTable12:(NSString *)fetchQuery;
-(NSArray *)uniqueFetchRecordFromTable2:(NSString *)fetchQuery;
-(NSArray *)uniqueFolioFetchRecordFromTable2:(NSString *)fetchQuery;
-(NSArray *)FetchAllRecordFromTable8:(NSString *)fetchQuery;

-(NSArray *)fetchAllRecordsFromTable14:(NSString *)fetchQuery;
-(NSArray *)fetchAllRecordsFromTable13:(NSString *)fetchQuery;
-(NSArray *)fetchSpinnerUniqueFundBasedFromTable13:(NSString *)fetchQuery;
-(NSArray *)fetchSpinnerUniqueFundBasedOnPanFromTable13:(NSString *)fetchQuery;
-(NSArray *)fetchAllRecordsFromTable5:(NSString *)fetchQuery;


-(NSArray *)fetchAllRecordsFromTable3:(NSString *)fetchQuery;
-(NSArray *)fetchAllRecordsFromTable9:(NSString *)fetchQuery;
-(NSArray *)fetchAllRecordsFromTable10:(NSString *)fetchQuery;

-(BOOL)fetchTotalUnitBalance:(NSString *)fetchQuery;

@end

