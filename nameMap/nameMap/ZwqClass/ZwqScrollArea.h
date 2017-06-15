//
//  ZwqScrollArea.h
//  StaffMap
//
//  Created by 张文强 on 2016/11/22.
//  Copyright © 2016年 张文强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZwqStaffArea.h"
#import "NameButton.h"
@interface ZwqScrollArea : UIScrollView
@property(assign,nonatomic)ZwqStaffArea*pSelectedView;
@property (nonatomic,retain)NameButton*com;
-(void)initSubViews;
-(void)initNames;
@end
