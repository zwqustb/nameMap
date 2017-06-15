//
//  ZwqTools.m
//  StaffMap
//
//  Created by 张文强 on 2016/11/23.
//  Copyright © 2016年 张文强. All rights reserved.
//

#import "ZwqTools.h"

@implementation ZwqTools
+(NSString*)getDocumentPath:(NSString*)pStrEnd
{
    //找到Documents文件所在的路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:pStrEnd];
    return plistPath;
}
+(void)saveDefaultPlist:(NSDictionary*)pDic
{
    if (!pDic) {
        return;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString*plistPath=[self getDocumentPath:@"Default.plist"];
    NSLog(@"documentPath:%@",plistPath);
    //开始创建文件
    if (![fm fileExistsAtPath:plistPath])
    {
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
    }
    //删除文件
    //[fm removeItemAtPath:plistPath error:nil];
    //把数据写入plist文件
    [pDic writeToFile:plistPath atomically:YES];
    //读取plist文件，首先需要把plist文件读取到字典中
//    NSDictionary *dic2 = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//    //打印数据
//    NSLog(@"key1 is %@",[dic2 valueForKey:@"1"]);
//    NSLog(@"dic is %@",dic2);
//    //把TestPlist文件加入
//    NSString *plistPaths = [filePath stringByAppendingPathComponent:@"tests.plist"];
//    //开始创建文件
//    [fm createFileAtPath:plistPaths contents:nil attributes:nil];
//    //创建一个数组
//    NSArray *arr = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];
//    //写入
//    [arr writeToFile:plistPaths atomically:YES];
//    //读取
//    NSArray *arr1 = [NSArray arrayWithContentsOfFile:plistPaths];
}

+(NSDictionary*)getDefaultPlist
{
    NSDictionary*pDicRet=nil;
    NSString*plistPath=[self getDocumentPath:@"Default.plist"];
    //开始创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        pDicRet=[NSDictionary dictionaryWithContentsOfFile:plistPath];
    }
    return pDicRet;
}
+(void)saveDefaultPlistAs:(NSString *)pStrNewName
{
    if (!pStrNewName) {
        return;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString*oldPlistPath=[self getDocumentPath:@"Default.plist"];
    NSString*newPlistPath=[self getDocumentPath:pStrNewName];
    NSError*pError=nil;
    if([fm fileExistsAtPath:newPlistPath])
    {
        [fm removeItemAtPath:newPlistPath error:nil];
    }
    [fm copyItemAtPath:oldPlistPath toPath:newPlistPath error:&pError];
    if (pError) {
        NSLog(@"%@",pError.description);
    }
}
+(void)selectPlistFile:(NSString *)pStrName
{
    if (!pStrName)
    {
        return;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString*oldPlistPath=[self getDocumentPath:@"Default.plist"];
    NSString*newPlistPath=[self getDocumentPath:pStrName];
    NSError*pError=nil;
    [fm removeItemAtPath:oldPlistPath error:nil];
    [fm copyItemAtPath:newPlistPath toPath:oldPlistPath error:&pError];
    if (pError) {
        NSLog(@"%@",pError.description);
    }
}
+(NSArray*)getFileList
{
    NSString*pPath=[self getDocumentPath:nil];
    NSArray*pAryList=[[NSFileManager defaultManager]subpathsAtPath:pPath];
    return pAryList;
}
+(NSDictionary*)StringToDictionary:(NSString*)pStr
{
    NSData*pData=[pStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary*pDic=[NSJSONSerialization JSONObjectWithData:pData options:NSJSONReadingMutableContainers error:nil];
    return pDic;
}
+(NSString*)DictionaryToString:(NSDictionary*)pDic
{
   NSData*pData=[NSJSONSerialization dataWithJSONObject:pDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString*pStr=[[NSString alloc]initWithData:pData encoding:NSUTF8StringEncoding];
    return pStr;
}
@end
