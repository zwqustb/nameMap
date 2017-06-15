//
//  userData.h
//  StaffMap
//
//  Created by zhangwenqiang on 2017/2/18.
//  Copyright © 2017年 张文强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userData : NSUserDefaults
+(NSDictionary*)getCurMapInfo;
+(NSString*)getCurMapName;
@end
