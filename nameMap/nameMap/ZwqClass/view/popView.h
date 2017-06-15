//
//  popView.h
//  StaffMap
//
//  Created by zhangwenqiang on 2017/3/14.
//  Copyright © 2017年 张文强. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol popViewDelegate
//@optional
-(void)handleSubitemDidTap:(NSInteger)nIndex;
@end
@interface popView : UIImageView
@property(nonatomic,assign)id<popViewDelegate>delegate;
-(void)setItems:(NSArray*)pAry;
-(void) handleSubitemTap:(NSUInteger)nIndex;
-(void)popViews;
@end
