//
//  userData.m
//  StaffMap
//
//  Created by zhangwenqiang on 2017/2/18.
//  Copyright © 2017年 张文强. All rights reserved.
//

#import "userData.h"

@implementation userData
+(NSDictionary*)getCurMapInfo
{
    NSString*curMapName=[self getCurMapName];
    if (!curMapName) {
        return nil;
    }
    return   [[NSUserDefaults standardUserDefaults]dictionaryForKey:curMapName];
}
+(NSString*)getCurMapName
{
    return   [[NSUserDefaults standardUserDefaults]stringForKey:@"curMapName"];
}
@end
