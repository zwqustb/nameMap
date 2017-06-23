//
//  databaseTool.m
//  LSYReader
//
//  Created by zhangwenqiang on 2017/1/16.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import "databaseTool.h"


@implementation databaseTool
static sqlite3 *db;

static NSInteger CurGroupID;
+(void)openDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    NSLog(@"数据库路径:%@",database_path);
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    NSArray*aryTables=[self getAllTableName];
    if (![aryTables containsObject:TBNAME_GROUP]) {
        [self initTable];
        [self initGroupData];
    }
    [self updateSql];
    
}
+(void)updateSql
{
    //NSString*sqlUpdate=@"update names set GroupId = 0";
    //[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN  %@ INTEGER",TBNAME,Column4];
  //  [self execSql:sqlUpdate];
}

+(void)close
{
    sqlite3_close(db);
}
+(void)setCurGroupID:(NSInteger)pBookID
{
    CurGroupID=pBookID;
}
+(NSInteger)getCurGroupID
{
    return CurGroupID;
}
+(void)execSql:(NSString *)sql
{
    char *err;
    int exec_result=sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err);
    if ( exec_result!= SQLITE_OK) {
        //sqlite3_close(db);
        NSLog(@"数据库操作%@数据失败!",sql);
    }
}
#pragma mark 增
+(void)initTable
{
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS ";
    NSString*sqlNameContent=[NSString stringWithFormat:@"%@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER)",TBNAME,Column1,Column2,Column3,Column4];
    NSString*sqlGroupContent=[NSString stringWithFormat:@"%@ (ID INTEGER PRIMARY KEY, %@ TEXT,%@ TEXT)",TBNAME_GROUP,GroupColumn1,GroupColumn2];
    NSString*sqlNameAll=[sqlCreateTable stringByAppendingString:sqlNameContent];
    NSString*sqlGroupAll=[sqlCreateTable stringByAppendingString:sqlGroupContent];
    [self execSql:sqlNameAll];
    [self execSql:sqlGroupAll];
    
}
+(void)initGroupData
{
    [self insertGroup:@[@(0),@"staff",@"staff.png"]];
    [self insertGroup:@[@(1),@"family",@"kinsman.png"]];
}
+(void)insertGroup:(NSArray*)pInfo
{
    int nID=((NSNumber*)pInfo[0]).intValue;
    const char* pName=((NSString*)pInfo[1]).UTF8String;
    const char* pImgPath=((NSString*)pInfo[2]).UTF8String;
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ( 'id', '%@','%@') VALUES ( %i,'%s','%s')",
                      TBNAME_GROUP,GroupColumn1,GroupColumn2,nID,pName,pImgPath];
    [self execSql:sql1];
}
+(void)insertNameX:(NSUInteger)nX  Y:(NSUInteger)nY info:(NSString*)pInfo
{
  //  sqlite3_bind_blob(stmt, 7, [image bytes], [image length], NULL);
  //  const char* sInfo=[pInfo UTF8String];
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ( '%@', '%@','%@','%@') VALUES ( %zi, %zi,'%@',%zi)",
                      TBNAME, Column1,Column2,Column3,Column4,nX,nY,pInfo,CurGroupID];
    [self execSql:sql1];
}

#pragma mark 删
+(void)deleteAllNames
{
    NSString *sql1 = [NSString stringWithFormat:@"DELETE FROM %@",TBNAME];
    [self execSql:sql1];
}
+(void)deleteName:(NSUInteger)nID
{
    NSString *sql1 = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id=%zi",TBNAME,nID];
    [self execSql:sql1];
}
+(void)deleteTables
{
    NSString *sql1 = [NSString stringWithFormat:@"DROP TABLE %@",TBNAME_GROUP];
    NSString *sql2 = [NSString stringWithFormat:@"DROP TABLE %@",TBNAME];
    [self execSql:sql1];
    [self execSql:sql2];
}
#pragma mark 改
+(void)updateNameByID:(NSUInteger)nID info:(NSString*)pInfo
{
    NSString *sql1 = [NSString stringWithFormat:
                      @"UPDATE %@ set %@='%@' where id= %zi",
                      TBNAME, Column3,pInfo,nID];
    [self execSql:sql1];
}
+(void)updateNameByID:(NSUInteger)nID X:(NSUInteger)nX Y:(NSUInteger)nY
{
    NSString *sql1 = [NSString stringWithFormat:
                      @"UPDATE %@ set %@=%zi,%@=%zi where id= %zi",
                      TBNAME, Column1,nX,Column2,nY,nID];
    [self execSql:sql1];
}
+(void)updateNameByID:(NSUInteger)nID groupID:(NSUInteger)nGroupID
{
    NSString *sql1 = [NSString stringWithFormat:
                      @"UPDATE %@ set %@=%zi where id= %zi",
                      TBNAME, Column4,nGroupID,nID];
    [self execSql:sql1];
}
#pragma mark 查
+(NSMutableArray*)getAllTableName
{
    NSMutableArray*pAry=[NSMutableArray array];
    if (pAry) {
        sqlite3_stmt *statement;
        NSString *getTableInfo = @"select * from sqlite_master where type='table' order by name";
        sqlite3_prepare_v2(db, [getTableInfo UTF8String], -1, &statement, nil);
        while (sqlite3_step(statement) == SQLITE_ROW) {

            char *nameData = (char *)sqlite3_column_text(statement, 1);
            NSString *tableName = [[NSString alloc] initWithUTF8String:nameData];
            //  NSLog(@"name:%@",tableName);
            [pAry addObject:tableName];
        }
        sqlite3_finalize(statement);
    }
    return pAry;
}

+(NSMutableArray*)getAllNamesOfCurGroup
{
    return  [self getAllNamesOfGroup:CurGroupID];
    
}
+(NSMutableArray*)getAllNamesOfGroup:(NSInteger)nGroupID
{
    NSMutableArray*pAry=[NSMutableArray array];
    if (pAry) {
        sqlite3_stmt *statement;
        NSString *getChapterInfo =[NSString stringWithFormat:
                                   @"select * from %@ where %@=%zi order by id ",TBNAME,Column4,nGroupID];
        sqlite3_prepare_v2(db, [getChapterInfo UTF8String], -1, &statement, nil);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary*pDic=[NSMutableDictionary dictionary];
            int nID = sqlite3_column_int(statement, 0);
            pDic[@"id"]=@(nID);
            int nX = sqlite3_column_int(statement, 1);
            pDic[Column1]=@(nX);
            int nY = sqlite3_column_int(statement, 2);
            pDic[Column2]=@(nY);
            
            char *pInfo = (char *)sqlite3_column_text(statement,3);
            if (pInfo) {
                NSString *strInfo = [NSString stringWithCString:pInfo encoding:NSUTF8StringEncoding];//[[NSString alloc] initWithUTF8String:pInfo];
                pDic[Column3]= strInfo;
            }
            pDic[Column4]=@(nGroupID);
            [pAry addObject:pDic];
        }
        sqlite3_finalize(statement);
    }
    return pAry;
}
+(NSArray*)getAllGroups
{
    NSMutableArray*pAry=[NSMutableArray array];
    if (pAry) {
        sqlite3_stmt *statement;
        NSString *getChapterInfo =[NSString stringWithFormat:
                                   @"select * from %@  order by id ",TBNAME_GROUP];
        sqlite3_prepare_v2(db, [getChapterInfo UTF8String], -1, &statement, nil);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary*pDic=[NSMutableDictionary dictionary];
            int nID = sqlite3_column_int(statement, 0);
            pDic[@"id"]=@(nID);
            char* pName =(char*) sqlite3_column_text(statement, 1);
            pDic[GroupColumn1]=[NSString stringWithUTF8String:pName];
            char* pImg = (char*)sqlite3_column_text(statement, 2);
            pDic[GroupColumn2]=[NSString stringWithUTF8String:pImg];
            
            char *pInfo = (char *)sqlite3_column_text(statement,3);
            if (pInfo) {
                NSString *strInfo = [[NSString alloc] initWithUTF8String:pInfo];
                pDic[Column3]=strInfo;
            }
            [pAry addObject:pDic];
        }
        sqlite3_finalize(statement);
    }
    return pAry;
}
+(NSArray*)getAllNames
{
    NSMutableArray*aryNames=[NSMutableArray array];
    NSArray*pAryGroup=[self getAllGroups];
    for (NSDictionary* dicGroup in pAryGroup) {
        NSNumber*pGroupID=(NSNumber*)dicGroup[@"id"];
        NSArray* aryThoseNames=[self getAllNamesOfGroup:pGroupID.integerValue ];
        [aryNames addObjectsFromArray:aryThoseNames];
    }
    return aryNames;
}
+(NSUInteger)getMaxID
{
    NSUInteger nRet=0;
    sqlite3_stmt *statement;
    NSString *getChapterInfo =[NSString stringWithFormat:
                               @"select max(id) from %@  order by id desc",TBNAME];
    sqlite3_prepare_v2(db, [getChapterInfo UTF8String], -1, &statement, nil);
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        nRet = sqlite3_column_int(statement, 0);
    }
    sqlite3_finalize(statement);
    return nRet;
}
+(NSInteger)getNewGroupID
{
    NSInteger nRet=0;
    NSMutableArray* aryId=[NSMutableArray array];
    sqlite3_stmt *statement;
    if (aryId) {
        NSString *getChapterInfo =[NSString stringWithFormat:
                                   @"select id from %@  order by id desc",TBNAME_GROUP];
        sqlite3_prepare_v2(db, [getChapterInfo UTF8String], -1, &statement, nil);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            int nRet = sqlite3_column_int(statement, 0);
            [aryId addObject:@(nRet)];
        }
        sqlite3_finalize(statement);
    }
    for (int i=0; i<=aryId.count; i++) {
        if (![aryId containsObject:@(i)]) {
            nRet=i;
            break;
        }
    }
    return nRet;
}
//导出到通讯录
+(void)exportToContact
{

//    NSArray*pAryGroup=[self getAllGroups];
//    for (NSDictionary* dicGroup in pAryGroup) {
//        NSNumber*pGroupID=(NSNumber*)dicGroup[@"id"];
//        NSArray* aryNames=[self getAllNamesOfGroup:pGroupID.integerValue ];
//        for (NSDictionary*dicName in aryNames) {
//            [contactTools createOne:dicName];
//        }
//    }
}
@end
