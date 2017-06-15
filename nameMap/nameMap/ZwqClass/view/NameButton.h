//
//  NameButton.h
//  StaffMap
//
//  Created by zhangwenqiang on 2017/3/9.
//  Copyright © 2017年 张文强. All rights reserved.
//

#import "CCZSpreadButton.h"

@interface NameButton : CCZSpreadButton
@property(nonatomic,strong)NSDictionary*dicNameInfo;
@property(nonatomic,strong)UILabel*nameLabel;
//在数据库中的id
@property(nonatomic)NSUInteger ID;
//name,ImgName,
@property(nonatomic,strong)NSString*strInfo;
@end
