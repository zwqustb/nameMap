//
//  ZwqStaffArea.h
//  StaffMap
//
//  Created by 张文强 on 2016/11/22.
//  Copyright © 2016年 张文强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZwqStaffArea : UIView
@property(nonatomic,retain)NSMutableDictionary*pDicData;
@property(nonatomic,retain)UILabel*pNameLabel;
@property int xIndex;
@property int yIndex;
-(void)initData;
@end
