//
//  DBManager.m
//  XuperParkDriver
//
//  Created by Narasimha Murthy on 06/10/17.
//  Copyright © 2017 Narasimha Murthy. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
static DBManager *sharedDataManagerInstance = nil;
static sqlite3 *database = nil;

+(DBManager *)sharedDataManagerInstance{
    if (!sharedDataManagerInstance) {
        sharedDataManagerInstance=[DBManager new];
    }
    return sharedDataManagerInstance;
}

#pragma mark - Creating DataBasePath

-(NSString *)getDBPath{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc=[paths objectAtIndex:0];
    return [doc stringByAppendingPathComponent:@"KTrackiOSDB.sqlite"];
}

#pragma mark - Create Database

-(void)createDatabase{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    str_dbPath=[self getDBPath];
    BOOL success=[fileManager fileExistsAtPath:str_dbPath];
    if(!success) {
        if(sqlite3_open([[self getDBPath]UTF8String], &database)==SQLITE_OK){
            
            NSString *create_TABLE2=@"CREATE TABLE TABLE2_DETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, fund TEXT, fundDesc VARCHAR, sch TEXT, schDesc VARCHAR, pln TEXT, plnDesc VARCHAR, opt TEXT, optDesc VARCHAR, Acno TEXT,balUnits TEXT, lastNAV TEXT, curValue TEXT , lastNavDate TEXT, pFlag TEXT, rFlag TEXT, sFlag TEXT, minAmt TEXT, schType TEXT, Kyc1 TEXT, pModeValue TEXT, pModeDesc VARCHAR, mobile TEXT, pSchFlg TEXT, rSchFlg TEXT, sSchFlg TEXT, schDesc1 VARCHAR, taxSaverFlag TEXT, aadharFlag TEXT, brokercd TEXT, subbrokercd TEXT, sipFlag TEXT, subCategory TEXT, investment_Flag TEXT, PAN TEXT, costValue TEXT, gainValue TEXT, redMinAmt TEXT, sipSchFlg TEXT, notallowed_flag TEXT, fund_CostValue TEXT, fund_CurValue TEXT, fund_GainValue TEXT)";
            
            NSString *create_TABLE3=@"CREATE TABLE TABLE3_DETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, fund TEXT, fundDesc VARCHAR, Acno TEXT, invName TEXT, add1 TEXT, add2 TEXT, add3 TEXT, city TEXT, state TEXT, telPhone TEXT, mobile TEXT, email TEXT, PAN TEXT)";
            
            NSString *create_TABLE4=@"CREATE TABLE TABLE4_DETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, name TEXT, y TEXT, color TEXT, currentValue TEXT, gainVal TEXT, gain TEXT, costValue TEXT, percentage TEXT, PAN TEXT, todayGain TEXT, totpercent TEXT, gainPercent TEXT)";
            
            NSString *create_TABLE5=@"CREATE TABLE TABLE5_DETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, fund TEXT, fundDesc VARCHAR, percentage TEXT, PAN TEXT, totpercent TEXT)";
            
            NSString *create_TABLE6=@"CREATE TABLE TABLE6_DETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, fund TEXT, fundDesc VARCHAR, currentValue TEXT, gainVal TEXT, gain TEXT, costValue TEXT, percentage TEXT, PAN TEXT, todayGain TEXT, totpercent TEXT, gainPercent TEXT)";
            
            NSString *create_TABLE7=@"CREATE TABLE TABLE7_DETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, fund TEXT, scheme TEXT, plan TEXT, fundName VARCHAR, schemeName VARCHAR, Acno TEXT, invName TEXT, unitBalance TEXT, navDate TEXT, Nav TEXT, currentValue TEXT, curValue TEXT, costValue TEXT, avgAgeDays TEXT, annualizYield TEXT, dividendValue TEXT, schemeClass TEXT, appreciationValue TEXT, pSchFlg TEXT, rSchFlg TEXT, sSchFlg TEXT, PAN TEXT, sipSchFlg TEXT)";
            
            NSString *create_TABLE8=@"CREATE TABLE TABLE8_BANKACCOUNT (ID Integer PRIMARY KEY AUTOINCREMENT, fund TEXT, foliono TEXT, bnkcode TEXT, bnkname TEXT, bnkactype TEXT, bnkacno TEXT)";
            
            NSString *create_TABLE9=@"CREATE TABLE TABLE9_NOMINEEDETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, fund TEXT, Acno TEXT, sch TEXT, pln TEXT, schPln VARCHAR, nomDetails VARCHAR)";
            
            NSString *create_TABLE10=@"CREATE TABLE TABLE10_BANKDETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, fund TEXT, Acno TEXT, sch TEXT, pln TEXT, schPln VARCHAR, bankDetails VARCHAR)";
            
            NSString *create_TABLE11=@"CREATE TABLE TABLE11_TRANSACTIONDETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, fund TEXT, scheme TEXT, pln TEXT, Acno TEXT, trdt TEXT, Nav TEXT, trtype TEXT, navdt TEXT, amount TEXT, units TEXT, fundDesc VARCHAR, schemeDesc VARCHAR, planDesc VARCHAR, trtypeDesc VARCHAR, Pop TEXT, trdt1 TEXT, invName TEXT)";
            
            NSString *create_TABLE12=@"CREATE TABLE TABLE12_PANDETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, PAN TEXT, flag TEXT, invName TEXT, KYC TEXT, minor TEXT)";
            
            NSString *create_TABLE13=@"CREATE TABLE TABLE13_DETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, fund TEXT, fundDesc VARCHAR, schemeClass TEXT, currentValue TEXT, costValue TEXT, gainValue TEXT, gainPercent TEXT, PAN TEXT, imagePath TEXT)";
            
            NSString *create_TABLE14=@"CREATE TABLE TABLE14_DETAILS (ID Integer PRIMARY KEY AUTOINCREMENT, fund TEXT, fundDesc VARCHAR, schemeClass TEXT, currentValue TEXT, costValue TEXT, gainValue TEXT, gainPercent TEXT, PAN TEXT, schDesc VARCHAR, plnDesc VARCHAR, units TEXT, sch TEXT, pln TEXT, lastnav TEXT)";
            
            char *error;
            
            if(sqlite3_exec(database, [create_TABLE8 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE8_BANKACCOUNT table");
            }
            else{
                KTLog(@"Failed to create TABLE8_BANKACCOUNT table");
            }
            
            if(sqlite3_exec(database, [create_TABLE9 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE9_NOMINEEDETAILS table");
            }
            else{
                KTLog(@"Failed to create TABLE9_NOMINEEDETAILS table");
            }
            
            if(sqlite3_exec(database, [create_TABLE10 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE10_BANKDETAILS table");
            }
            
            else{
                KTLog(@"Failed to create TABLE10_BANKDETAILS table");
            }
            
            if(sqlite3_exec(database, [create_TABLE11 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE11_TRANSACTIONDETAILS table");
            }
            else{
                KTLog(@"Failed to create TABLE11_TRANSACTIONDETAILS table");
            }
            
            if(sqlite3_exec(database, [create_TABLE12 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE12_PANDETAILS table");
            }
            else{
                KTLog(@"Failed to create TABLE12_PANDETAILS table");
            }
            
            if(sqlite3_exec(database, [create_TABLE13 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE13_DETAILS table");
            }
            else{
                KTLog(@"Failed to create TABLE13_DETAILS table");
            }
            
            if(sqlite3_exec(database, [create_TABLE14 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE14_DETAILS table");
            }
            else{
                KTLog(@"Failed to create TABLE14_DETAILS table");
            }
            
            if(sqlite3_exec(database, [create_TABLE2 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE2_DETAILS table");
            }
            else{
                KTLog(@"Failed to create TABLE2_DETAILS table");
            }
            
            if(sqlite3_exec(database, [create_TABLE3 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE3_DETAILS table");
            }
            else{
                KTLog(@"Failed to create TABLE3_DETAILS table");
            }
            
            if(sqlite3_exec(database, [create_TABLE4 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE4_DETAILS table");
            }
            else{
                KTLog(@"Failed to create TABLE4_DETAILS table");
            }
            
            if(sqlite3_exec(database, [create_TABLE5 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE5_DETAILS table");
            }
            else{
                KTLog(@"Failed to create TABLE5_DETAILS table");
            }
            
            if(sqlite3_exec(database, [create_TABLE6 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE6_DETAILS table");
            }
            else{
                KTLog(@"Failed to create TABLE6_DETAILS table");
            }
            
            if(sqlite3_exec(database, [create_TABLE7 UTF8String], NULL, NULL, &error)==SQLITE_OK){
                KTLog(@"success TABLE7_DETAILS table");
            }
            else{
                KTLog(@"Failed to create TABLE7_DETAILS table");
            }
        }
        else{
            KTLog(@"Database not opened...!");
        }
    }
    else{
        KTLog(@"File with same name all ready exists...!");
    }
    sqlite3_release_memory(120);
    sqlite3_close(database);
}

#pragma mark - excuteDeleteQuery

- (void)executeDeleteQuery:(NSString*)queryString{
    @synchronized (self){
        @try {
            sqlite3_stmt *statement = nil ;
            NSString *path = [self getDBPath];
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ) {
                if((sqlite3_prepare_v2(database,[queryString UTF8String],-1, &statement, NULL)) == SQLITE_OK){
                    sqlite3_step(statement);
                }
                sqlite3_finalize(statement);
            }
            statement=nil;
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
        @catch (NSException *exception) {
            NSLog(@"Exception :%@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - excuteUpdateQuery

- (void)executeUpdateQuery:(NSString*)queryString{
    @synchronized (self){
        @try {
            sqlite3_stmt *statement = nil ;
            NSString *path = [self getDBPath];
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ) {
                if((sqlite3_prepare_v2(database,[queryString UTF8String],-1, &statement, NULL)) == SQLITE_OK){
                    sqlite3_step(statement);
                }
                sqlite3_finalize(statement);
            }
            statement=nil;
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
        @catch (NSException *exception) {
            NSLog(@"Exception :%@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - open DB

-(void)openDataBase{
    NSString *path = [self getDBPath];
    sqlite3_open([path UTF8String],&database);
}

#pragma mark - Close DB

-(void)closeDataBase{
    NSString *path = [self getDBPath];
    if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
        sqlite3_release_memory(120);
        sqlite3_close(database);
    }
}

#pragma mark - InsertQuery Into Table 2 Record

-(void)insertIntoTable2:(NSArray *)table2Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE2_DETAILS (fund, fundDesc, sch, schDesc, pln, plnDesc, opt, optDesc, Acno, balUnits, lastNAV, curValue, lastNavDate, pFlag, rFlag, sFlag, minAmt, schType, Kyc1, pModeValue, pModeDesc, mobile, pSchFlg, rSchFlg, sSchFlg, schDesc1, taxSaverFlag, aadharFlag, brokercd, subbrokercd, sipFlag, subCategory, investment_Flag, PAN, costValue, gainValue, redMinAmt, sipSchFlg, notallowed_flag, fund_CostValue, fund_CurValue, fund_GainValue) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table2Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",TRIMWHITESPACE(dic[@"Fund"])]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"FundDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"Sch"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"SchDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"Pln"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [[NSString stringWithFormat:@"%@",dic[@"PlnDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 7, [[NSString stringWithFormat:@"%@",dic[@"Opt"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 8, [[NSString stringWithFormat:@"%@",dic[@"OptDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 9, [[NSString stringWithFormat:@"%@",dic[@"Acno"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 10, [[NSString stringWithFormat:@"%@",dic[@"BalUnits"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 11, [[NSString stringWithFormat:@"%@",dic[@"LastNAV"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 12, [[NSString stringWithFormat:@"%@",dic[@"CurValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 13, [[NSString stringWithFormat:@"%@",dic[@"LastNavDate"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 14, [[NSString stringWithFormat:@"%@",dic[@"pFlag"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 15, [[NSString stringWithFormat:@"%@",dic[@"rFlag"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 16, [[NSString stringWithFormat:@"%@",dic[@"sFlag"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 17, [[NSString stringWithFormat:@"%@",dic[@"MinAmt"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 18, [[NSString stringWithFormat:@"%@",dic[@"SchType"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 19, [[NSString stringWithFormat:@"%@",dic[@"Kyc1"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 20, [[NSString stringWithFormat:@"%@",dic[@"PmodeValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 21, [[NSString stringWithFormat:@"%@",dic[@"PmodeDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 22, [[NSString stringWithFormat:@"%@",dic[@"Mobile"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 23, [[NSString stringWithFormat:@"%@",dic[@"pSchFlg"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 24, [[NSString stringWithFormat:@"%@",dic[@"rSchFlg"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 25, [[NSString stringWithFormat:@"%@",dic[@"sSchFlg"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 26, [[NSString stringWithFormat:@"%@",dic[@"SchDesc1"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 27, [[NSString stringWithFormat:@"%@",dic[@"TaxSaverFlag"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 28, [[NSString stringWithFormat:@"%@",dic[@"AadharFlag"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 29, [[NSString stringWithFormat:@"%@",dic[@"brokercd"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 30, [[NSString stringWithFormat:@"%@",dic[@"subbrokercd"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 31, [[NSString stringWithFormat:@"%@",dic[@"sipFlag"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 32, [[NSString stringWithFormat:@"%@",dic[@"SubCategory"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 33, [[NSString stringWithFormat:@"%@",dic[@"Investment_Flag"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 34, [[NSString stringWithFormat:@"%@",dic[@"PAN"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 35, [[NSString stringWithFormat:@"%@",dic[@"CostValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 36, [[NSString stringWithFormat:@"%@",dic[@"GainValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 37, [[NSString stringWithFormat:@"%@",dic[@"RedMinAmt"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 38, [[NSString stringWithFormat:@"%@",dic[@"sipSchFlg"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 39, [[NSString stringWithFormat:@"%@",dic[@"notallowed_flag"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 40, [[NSString stringWithFormat:@"%@",dic[@"Fund_CostValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 41, [[NSString stringWithFormat:@"%@",dic[@"Fund_CurValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 42, [[NSString stringWithFormat:@"%@",dic[@"Fund_GainValue"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE2_DETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE2_DETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE2_DETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 3 Record



-(void)insertIntoTable3:(NSArray *)table3Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE3_DETAILS (fund, fundDesc, Acno, invName, add1, add2, add3, city, state, telPhone, mobile, email, PAN) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table3Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",TRIMWHITESPACE(dic[@"Fund"])]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"FundDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"Acno"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"InvName"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"Add1"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [[NSString stringWithFormat:@"%@",dic[@"Add2"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 7, [[NSString stringWithFormat:@"%@",dic[@"Add3"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 8, [[NSString stringWithFormat:@"%@",dic[@"City"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 9, [[NSString stringWithFormat:@"%@",dic[@"State"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 10, [[NSString stringWithFormat:@"%@",dic[@"TelPhone"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 11, [[NSString stringWithFormat:@"%@",dic[@"Mobile"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 12, [[NSString stringWithFormat:@"%@",dic[@"Email"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 13, [[NSString stringWithFormat:@"%@",dic[@"PAN"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE3_DETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE3_DETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE3_DETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 4 Record

-(void)insertIntoTable4:(NSArray *)table4Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE4_DETAILS (name, y, color, currentValue, gainVal, gain, costValue, percentage, PAN, todayGain, totpercent, gainPercent) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table4Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",dic[@"name"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"y"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"color"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"Current Value"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"GainVal"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [[NSString stringWithFormat:@"%@",dic[@"Gain"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 7, [[NSString stringWithFormat:@"%@",dic[@"CostValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 8, [[NSString stringWithFormat:@"%@",dic[@"Percentage"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 9, [[NSString stringWithFormat:@"%@",dic[@"PAN"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 10, [[NSString stringWithFormat:@"%@",dic[@"todaygain"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 11, [[NSString stringWithFormat:@"%@",dic[@"totpercent"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 12, [[NSString stringWithFormat:@"%@",dic[@"GainPercent"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE4_DETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE4_DETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE4_DETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 5 Record

-(void)insertIntoTable5:(NSArray *)table5Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE5_DETAILS (fund, fundDesc, percentage, PAN, totpercent) VALUES (?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table5Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",TRIMWHITESPACE(dic[@"Fund"])]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"FundDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"Percentage"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"PAN"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"totpercent"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE5_DETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE5_DETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE5_DETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 6 Record

-(void)insertIntoTable6:(NSArray *)table6Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE6_DETAILS (fund, fundDesc, currentValue, gainVal, gain, costValue, percentage, PAN, todayGain, totpercent, gainPercent) VALUES (?,?,?,?,?,?,?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table6Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",TRIMWHITESPACE(dic[@"Fund"])]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"FundDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"CurrentValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"GainVal"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"Gain"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [[NSString stringWithFormat:@"%@",dic[@"CostValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 7, [[NSString stringWithFormat:@"%@",dic[@"Percentage"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 8, [[NSString stringWithFormat:@"%@",dic[@"PAN"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 9, [[NSString stringWithFormat:@"%@",dic[@"todaygain"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 10, [[NSString stringWithFormat:@"%@",dic[@"totpercent"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 11, [[NSString stringWithFormat:@"%@",dic[@"GainPercent"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE6_DETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE6_DETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE6_DETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 7 Record

-(void)insertIntoTable7:(NSArray *)table7Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE7_DETAILS (fund, scheme, plan, fundName, schemeName, Acno, invName, unitBalance, navDate, Nav, currentValue, curValue, costValue, avgAgeDays, annualizYield, dividendValue, schemeClass, appreciationValue, pSchFlg, rSchFlg, sSchFlg, PAN, sipSchFlg) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table7Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",TRIMWHITESPACE(dic[@"Fund"])]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"Scheme"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"Plan"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"FundName"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"SchemeName"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [[NSString stringWithFormat:@"%@",dic[@"Acno"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 7, [[NSString stringWithFormat:@"%@",dic[@"InvName"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 8, [[NSString stringWithFormat:@"%@",dic[@"UnitBalance"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 9, [[NSString stringWithFormat:@"%@",dic[@"NavDate"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 10, [[NSString stringWithFormat:@"%@",dic[@"NAV"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 11, [[NSString stringWithFormat:@"%@",dic[@"CurrentValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 12, [[NSString stringWithFormat:@"%@",dic[@"CurValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 13, [[NSString stringWithFormat:@"%@",dic[@"CostValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 14, [[NSString stringWithFormat:@"%@",dic[@"AvgAgeDays"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 15, [[NSString stringWithFormat:@"%@",dic[@"AnnualizYield"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 16, [[NSString stringWithFormat:@"%@",dic[@"DividendValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 17, [[NSString stringWithFormat:@"%@",dic[@"SchemeClass"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 18, [[NSString stringWithFormat:@"%@",dic[@"AppreciationValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 19, [[NSString stringWithFormat:@"%@",dic[@"pSchFlg"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 20, [[NSString stringWithFormat:@"%@",dic[@"rSchFlg"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 21, [[NSString stringWithFormat:@"%@",dic[@"sSchFlg"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 22, [[NSString stringWithFormat:@"%@",dic[@"PAN"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 23, [[NSString stringWithFormat:@"%@",dic[@"sipSchFlg"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE7_DETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE7_DETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE7_DETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 8 Record

-(void)insertIntoTable8:(NSArray *)table8Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE8_BANKACCOUNT (fund, foliono, bnkcode, bnkname, bnkactype, bnkacno) VALUES (?,?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table8Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",TRIMWHITESPACE(dic[@"Fund"])]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"foliono"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"bnkcode"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"bnkname"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"bnkactype"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [[NSString stringWithFormat:@"%@",dic[@"bnkacno"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE8_BANKACCOUNT all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE8_BANKACCOUNT all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE8_BANKACCOUNT for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 9 Record

-(void)insertIntoTable9:(NSArray *)table9Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE9_NOMINEEDETAILS (fund, Acno, sch, pln, schPln, nomDetails) VALUES (?,?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table9Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",TRIMWHITESPACE(dic[@"Fund"])]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"Acno"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"Sch"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"Pln"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"SchPln"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [[NSString stringWithFormat:@"%@",dic[@"NomDetails"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE9_NOMINEEDETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE9_NOMINEEDETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE9_NOMINEEDETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 10 Record

-(void)insertIntoTable10:(NSArray *)table10Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE10_BANKDETAILS (fund, Acno, sch, pln, schPln, bankDetails) VALUES (?,?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table10Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",TRIMWHITESPACE(dic[@"Fund"])]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"Acno"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"Sch"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"Pln"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"SchPln"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [[NSString stringWithFormat:@"%@",dic[@"BankDetails"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE10_BANKDETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE10_BANKDETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE10_BANKDETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 11 Record

-(void)insertIntoTable11:(NSArray *)table11Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE11_TRANSACTIONDETAILS (fund, scheme, pln, Acno, trdt, Nav, trtype, navdt, amount, units, fundDesc, schemeDesc, planDesc, trtypeDesc, Pop, trdt1, invName) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table11Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",TRIMWHITESPACE(dic[@"Fund"])]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"Scheme"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"Pln"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"Acno"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"Trdt"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [[NSString stringWithFormat:@"%@",dic[@"Nav"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 7, [[NSString stringWithFormat:@"%@",dic[@"Trtype"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 8, [[NSString stringWithFormat:@"%@",dic[@"Navdt"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 9, [[NSString stringWithFormat:@"%@",dic[@"Amount"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 10, [[NSString stringWithFormat:@"%@",dic[@"Units"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 11, [[NSString stringWithFormat:@"%@",dic[@"FundDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 12, [[NSString stringWithFormat:@"%@",dic[@"SchemeDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 13, [[NSString stringWithFormat:@"%@",dic[@"PlanDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 14, [[NSString stringWithFormat:@"%@",dic[@"TrtypeDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 15, [[NSString stringWithFormat:@"%@",dic[@"Pop"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 16, [[NSString stringWithFormat:@"%@",dic[@"Trdt1"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 17, [[NSString stringWithFormat:@"%@",dic[@"InvName"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE11_TRANSACTIONDETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE11_TRANSACTIONDETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE11_TRANSACTIONDETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 12 Record

-(void)insertIntoTable12:(NSArray *)table12Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE12_PANDETAILS (PAN, flag, invName, KYC, minor) VALUES (?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table12Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",dic[@"PAN"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"flag"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"invname"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"KYC"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"minor"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE12_PANDETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE12_PANDETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE12_PANDETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 13 Record

-(void)insertIntoTable13:(NSArray *)table13Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE13_DETAILS (fund, fundDesc, schemeClass, currentValue, costValue, gainValue, gainPercent, PAN, imagePath) VALUES (?,?,?,?,?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table13Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",TRIMWHITESPACE(dic[@"Fund"])]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"FundDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"SchemeClass"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"CurrentValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"CostValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [[NSString stringWithFormat:@"%@",dic[@"GainValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 7, [[NSString stringWithFormat:@"%@",dic[@"GainPercent"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 8, [[NSString stringWithFormat:@"%@",dic[@"pan"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 9, [[NSString stringWithFormat:@"%@",dic[@"image_path"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE13_DETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE13_DETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE13_DETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - InsertQuery Into Table 14 Record

-(void)insertIntoTable14:(NSArray *)table14Rec{
    @synchronized (self) {
        @try {
            NSString *path = [self getDBPath];
            char* errorMessage;
            sqlite3_stmt* stmt=nil;
            if(sqlite3_open([path UTF8String],&database) == SQLITE_OK ){
                sqlite3_exec(database, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
                NSString *insertQuery=[NSString stringWithFormat:@"INSERT INTO TABLE14_DETAILS (fund, fundDesc, schemeClass, currentValue, costValue, gainValue, gainPercent, PAN, schDesc, plnDesc, units, sch, pln, lastnav) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
                const char *sqlStmt=[insertQuery UTF8String];
                sqlite3_prepare_v2(database, sqlStmt, (int)strlen(sqlStmt), &stmt, NULL);
                for (NSDictionary *dic in table14Rec) {
                    sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%@",TRIMWHITESPACE(dic[@"Fund"])]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 2, [[NSString stringWithFormat:@"%@",dic[@"FundDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 3, [[NSString stringWithFormat:@"%@",dic[@"SchemeClass"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",dic[@"CurrentValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 5, [[NSString stringWithFormat:@"%@",dic[@"CostValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 6, [[NSString stringWithFormat:@"%@",dic[@"GainValue"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 7, [[NSString stringWithFormat:@"%@",dic[@"GainPercent"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 8, [[NSString stringWithFormat:@"%@",dic[@"pan"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 9, [[NSString stringWithFormat:@"%@",dic[@"SchDesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 10, [[NSString stringWithFormat:@"%@",dic[@"plndesc"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 11, [[NSString stringWithFormat:@"%@",dic[@"units"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 12, [[NSString stringWithFormat:@"%@",dic[@"sch"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 13, [[NSString stringWithFormat:@"%@",dic[@"pln"]]UTF8String], -1, SQLITE_STATIC);
                    sqlite3_bind_text(stmt, 14, [[NSString stringWithFormat:@"%@",dic[@"lastnav"]]UTF8String], -1, SQLITE_STATIC);
                    if (sqlite3_step(stmt) != SQLITE_DONE)
                    {
                        printf("Commit Failed!\n");
                    }
                    
                    sqlite3_reset(stmt);
                }
                if(sqlite3_exec(database, "COMMIT TRANSACTION", NULL, NULL, &errorMessage)==SQLITE_OK)
                {
                    KTLog(@"commited products TABLE14_DETAILS all");
                }
                else
                {
                    KTLog(@"commited  fail products TABLE14_DETAILS all");
                }
                stmt=nil;
                sqlite3_finalize(stmt);
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            KTLog(@"Error failed to Update into TABLE14_DETAILS for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
}

#pragma mark - Portfolio Screen Query

-(NSArray *)fetchRecordFromTable4:(NSString *)fetchQuery{
    NSMutableArray *arr_portfolio=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE4 *table_rec=[[KT_TABLE4 alloc]init];
                        table_rec.row_id=(int)sqlite3_column_int(stmt,0);
                        table_rec.name=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        table_rec.y=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                        table_rec.color=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                        table_rec.currentValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                        table_rec.gainVal=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                        table_rec.gain=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                        table_rec.costValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,7)];
                        table_rec.percentage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,8)];
                        table_rec.PAN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,9)];
                        table_rec.todayGain=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,10)];
                        table_rec.totpercent=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,11)];
                        table_rec.gainPercent=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,12)];
                        [arr_portfolio addObject:table_rec];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_portfolio;
}

-(NSArray *)fetchRecordFromTable12:(NSString *)fetchQuery{
    NSMutableArray *arr_table12=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE12 *table_rec=[[KT_TABLE12 alloc]init];
                        table_rec.row_id=(int)sqlite3_column_int(stmt,0);
                        table_rec.PAN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        table_rec.flag=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                        table_rec.invName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                        table_rec.KYC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                        table_rec.minor=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                        [arr_table12 addObject:table_rec];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table12;
}

-(NSArray *)fetchRecordFromTable6:(NSString *)fetchQuery{
    NSMutableArray *arr_table6=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE6 *table_rec=[[KT_TABLE6 alloc]init];
                        table_rec.row_id=(int)sqlite3_column_int(stmt,0);
                        table_rec.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        table_rec.fundDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                        table_rec.currentValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                        table_rec.gainVal=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                        table_rec.gain=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                        table_rec.costValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                        table_rec.percentage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,7)];
                        table_rec.PAN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,8)];
                        table_rec.todayGain=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,9)];
                        table_rec.totpercent=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,10)];
                        table_rec.gainPercent=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,11)];
                        [arr_table6 addObject:table_rec];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table6;
}

-(NSArray *)fetchRecordFromTable2:(NSString *)fetchQuery{
    NSMutableArray *arr_table2=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE2 *table_rec=[[KT_TABLE2 alloc]init];
                        table_rec.row_id=(int)sqlite3_column_int(stmt,0);
                        table_rec.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        table_rec.fundDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                        table_rec.sch=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                        table_rec.schDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                        table_rec.pln=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                        table_rec.plnDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                        table_rec.opt=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,7)];
                        table_rec.optDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,8)];
                        table_rec.Acno=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,9)];
                        table_rec.balUnits=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,10)];
                        table_rec.lastNAV=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,11)];
                        table_rec.curValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,12)];
                        table_rec.lastNavDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,13)];
                        table_rec.pFlag=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,14)];
                        table_rec.rFlag=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,15)];
                        table_rec.sFlag=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,16)];
                        table_rec.minAmt=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,17)];
                        table_rec.schType=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,18)];
                        table_rec.Kyc1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,19)];
                        table_rec.pModeValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,20)];
                        table_rec.pModeDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,21)];
                        table_rec.mobile=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,22)];
                        table_rec.pSchFlg=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,23)];
                        table_rec.rSchFlg=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,24)];
                        table_rec.sSchFlg=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,25)];
                        table_rec.schDesc1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,26)];
                        table_rec.taxSaverFlag=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,27)];
                        table_rec.aadharFlag=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,28)];
                        table_rec.brokercd=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,29)];
                        table_rec.subbrokercd=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,30)];
                        table_rec.sipFlag=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,31)];
                        table_rec.subCategory=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,32)];
                        table_rec.investment_Flag=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,33)];
                        table_rec.PAN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,34)];
                        table_rec.costValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,35)];
                        table_rec.gainValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,36)];
                        table_rec.redMinAmt=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,37)];
                        table_rec.sipSchFlg=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,38)];
                        table_rec.notallowed_flag=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,39)];
                        table_rec.fund_CostValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,40)];
                        table_rec.fund_CurValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,41)];
                        table_rec.fund_GainValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,42)];
                        [arr_table2 addObject:table_rec];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table2;
}


-(NSArray *)uniqueFetchRecordFromTable2:(NSString *)fetchQuery{
    NSMutableArray *arr_table2=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_Table2RawQuery *table_rec=[[KT_Table2RawQuery alloc]init];
                        table_rec.fundDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,0)];
                        table_rec.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        [arr_table2 addObject:table_rec];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table2;
}

-(NSArray *)uniqueFolioFetchRecordFromTable2:(NSString *)fetchQuery{
    NSMutableArray *arr_table2=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE2 *table_rec=[[KT_TABLE2 alloc]init];
                        table_rec.Acno=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,0)];
                        table_rec.notallowed_flag=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        [arr_table2 addObject:table_rec];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table2;
}

-(NSArray *)FetchAllRecordFromTable8:(NSString *)fetchQuery{
    NSMutableArray *arr_table2=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE8 *table_rec=[[KT_TABLE8 alloc]init];
                        table_rec.row_id=(int)sqlite3_column_int(stmt,0);
                        table_rec.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        table_rec.foliono=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                        table_rec.bnkcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                        table_rec.bnkname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                        table_rec.bnkactype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                        table_rec.bnkacno=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                        [arr_table2 addObject:table_rec];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table2;
}

/* 05/05/2018 Murthy Queries */

-(NSArray *)fetchSpinnerUniqueFundBasedFromTable13:(NSString *)fetchQuery{
    NSMutableArray *arr_table13=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE13 *rec_dic=[[KT_TABLE13 alloc]init];
                        rec_dic.fundDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,0)];
                        rec_dic.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        [arr_table13 addObject:rec_dic];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table13;
}

-(NSArray *)fetchSpinnerUniqueFundBasedOnPanFromTable13:(NSString *)fetchQuery{
    NSMutableArray *arr_table13=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE13 *rec_dic=[[KT_TABLE13 alloc]init];
                        rec_dic.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,0)];
                        [arr_table13 addObject:rec_dic];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table13;
}

-(NSArray *)fetchAllRecordsFromTable13:(NSString *)fetchQuery{
    NSMutableArray *arr_table13=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE13 *rec_dic=[[KT_TABLE13 alloc]init];
                        rec_dic.row_id=(int)sqlite3_column_int(stmt,0);
                        rec_dic.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        rec_dic.fundDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                        rec_dic.schemeClass=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                        rec_dic.currentValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                        rec_dic.costValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                        rec_dic.gainValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                        rec_dic.gainPercent=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,7)];
                        rec_dic.PAN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,8)];
                        rec_dic.imagePath=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,9)];
                        [arr_table13 addObject:rec_dic];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table13;
}

-(NSArray *)fetchAllRecordsFromTable14:(NSString *)fetchQuery{
    NSMutableArray *arr_table14=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE14 *rec_dic=[[KT_TABLE14 alloc]init];
                        rec_dic.row_id=(int)sqlite3_column_int(stmt,0);
                        rec_dic.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        rec_dic.fundDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                        rec_dic.schemeClass=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                        rec_dic.currentValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                        rec_dic.costValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                        rec_dic.gainValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                        rec_dic.gainPercent=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,7)];
                        rec_dic.PAN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,8)];
                        rec_dic.schDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,9)];
                        rec_dic.plnDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,10)];
                        rec_dic.units=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,11)];
                        rec_dic.sch=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,12)];
                        rec_dic.pln=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,13)];
                        rec_dic.lastNAV=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,14)];
                        [arr_table14 addObject:rec_dic];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table14;
}

-(NSArray *)fetchAllRecordsFromTable5:(NSString *)fetchQuery{
    NSMutableArray *arr_table5=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE5 *rec_dic=[[KT_TABLE5 alloc]init];
                        rec_dic.row_id=(int)sqlite3_column_int(stmt,0);
                        rec_dic.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        rec_dic.fundDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                        rec_dic.percentage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                        rec_dic.PAN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                        rec_dic.totpercent=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                        [arr_table5 addObject:rec_dic];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table5;
}

-(NSArray *)fetchAllRecordsFromTable3:(NSString *)fetchQuery{
    NSMutableArray *arr_table3=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE3 *rec_dic=[[KT_TABLE3 alloc]init];
                        rec_dic.row_id=(int)sqlite3_column_int(stmt,0);
                        rec_dic.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        rec_dic.fundDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                        rec_dic.Acno=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                        rec_dic.invName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                        rec_dic.add1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                        rec_dic.add2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                        rec_dic.add3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,7)];
                        rec_dic.city=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,8)];
                        rec_dic.state=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,9)];
                        rec_dic.telPhone=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,10)];
                        rec_dic.mobile=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,11)];
                        rec_dic.email=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,12)];
                        rec_dic.PAN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,13)];
                        [arr_table3 addObject:rec_dic];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table3;
}

-(NSArray *)fetchAllRecordsFromTable9:(NSString *)fetchQuery{
    NSMutableArray *arr_table9=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE9 *rec_dic=[[KT_TABLE9 alloc]init];
                        rec_dic.row_id=(int)sqlite3_column_int(stmt,0);
                        rec_dic.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        rec_dic.Acno=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                        rec_dic.sch=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                        rec_dic.pln=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                        rec_dic.schPln=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                        rec_dic.nomDetails=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                        [arr_table9 addObject:rec_dic];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table9;
}

-(NSArray *)fetchAllRecordsFromTable10:(NSString *)fetchQuery{
    NSMutableArray *arr_table10=[[NSMutableArray alloc]init];
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        KT_TABLE10 *rec_dic=[[KT_TABLE10 alloc]init];
                        rec_dic.row_id=(int)sqlite3_column_int(stmt,0);
                        rec_dic.fund=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,1)];
                        rec_dic.Acno=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,2)];
                        rec_dic.sch=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,3)];
                        rec_dic.pln=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,4)];
                        rec_dic.schPln=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,5)];
                        rec_dic.bankDetails=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,6)];
                        [arr_table10 addObject:rec_dic];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    return arr_table10;
}

-(BOOL)fetchTotalUnitBalance:(NSString *)fetchQuery{
    BOOL checkedUnitBalance;
    NSString *str_balUnits;
    @synchronized (self)
    {
        @try {
            if (sqlite3_open([[self getDBPath]UTF8String],&database)==SQLITE_OK){
                sqlite3_stmt *stmt=nil;
                const char *sqlfetch=[fetchQuery UTF8String];
                if (sqlite3_prepare_v2(database, sqlfetch, -1,&stmt, NULL)==SQLITE_OK) {
                    while (sqlite3_step(stmt)==SQLITE_ROW){
                        str_balUnits=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt,0)];
                    }
                }
                sqlite3_finalize(stmt);
                stmt=nil;
                sqlite3_release_memory(120);
                sqlite3_close(database);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error failed to fetch record from ERROR_MESSAGES for reason %@",exception.reason);
            sqlite3_release_memory(120);
            sqlite3_close(database);
        }
    }
    if ([str_balUnits isEqualToString:@"0.0"] || [str_balUnits isEqual:@"0.0"] || [str_balUnits isEqualToString:@"0"] || [str_balUnits isEqual:@"0"]) {
        checkedUnitBalance = YES;
    }
    else{
        checkedUnitBalance = NO;
    }
    return checkedUnitBalance;
}

@end
