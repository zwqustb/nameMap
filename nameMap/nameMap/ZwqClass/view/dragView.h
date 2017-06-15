//
//  dragView.h
//  StaffMap
//
//  Created by zhangwenqiang on 2017/2/22.
//  Copyright © 2017年 张文强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "popView.h"
#import "headImg.h"
@interface dragView : headImg
@property(nonatomic)CGPoint lastPoint;
@property(nonatomic,retain)NSMutableArray* aryImgNames;
@end
