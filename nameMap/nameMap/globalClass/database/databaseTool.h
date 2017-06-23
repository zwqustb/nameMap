//
//  databaseTool.h
//  LSYReader
//
//  Created by zhangwenqiang on 2017/1/16.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBNAME          @"Names.sqlite"
#define TBNAME          @"names"
#define TBNAME_GROUP    @"groups"
#define Column1         @"X"
#define Column2         @"Y"
#define Column3         @"info"
#define Column4         @"GroupId"
#define GroupColumn1    @"name"
#define GroupColumn2    @"ImgPath"


@interface databaseTool : NSObject
+(void)openDatabase;
+(void)close;

+(void)setCurGroupID:(NSInteger)pBookID;
+(NSInteger)getCurGroupID;
//增
+(void)insertNameX:(NSUInteger)nX  Y:(NSUInteger)nY info:(NSString*)pInfo;
+(void)insertGroup:(NSArray*)pInfo;
//删
+(void)deleteName:(NSUInteger)nID;
+(void)deleteAllNames;
//改
+(void)updateNameByID:(NSUInteger)nID info:(NSString*)pInfo;
+(void)updateNameByID:(NSUInteger)nID X:(NSUInteger)nX Y:(NSUInteger)nY;
+(void)updateNameByID:(NSUInteger)nID groupID:(NSUInteger)nGroupID;
//查
+(NSUInteger)getMaxID;//获取最大id
+(NSInteger)getNewGroupID;
+(NSMutableArray*)getAllTableName;
+(NSMutableArray*)getAllNamesOfCurGroup;
+(NSArray*)getAllNames;
+(NSArray*)getAllGroups;
+(void)exportToContact;
@end
