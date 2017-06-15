//
//  ZwqTools.h
//  StaffMap
//
//  Created by 张文强 on 2016/11/23.
//  Copyright © 2016年 张文强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZwqTools : NSObject
+(NSString*)getDocumentPath:(NSString*)pStrEnd;
+(void)saveDefaultPlist:(NSDictionary*)pDic;
+(NSDictionary*)getDefaultPlist;
+(void)saveDefaultPlistAs:(NSString *)pStrNewName;
+(void)selectPlistFile:(NSString *)pStrName;
+(NSArray*)getFileList;
+(NSDictionary*)StringToDictionary:(NSString*)pStr;
+(NSString*)DictionaryToString:(NSDictionary*)pDic;
@end
