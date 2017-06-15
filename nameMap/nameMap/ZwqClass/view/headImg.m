//
//  headImg.m
//  StaffMap
//
//  Created by zhangwenqiang on 2017/3/15.
//  Copyright © 2017年 张文强. All rights reserved.
//

#import "headImg.h"

@implementation headImg
+(NSArray*)defaultHeadImgAry
{
    return @[@"male.png",@"female.png",@"staffmale.png",@"staffFemale.png"];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setItems:[headImg defaultHeadImgAry]];
    self.userInteractionEnabled=true;
}
-(void) handleSubitemTap:(NSUInteger)nIndex {
    //把自己的图片换成选中的图片
    [super handleSubitemTap:nIndex];
    if (nIndex<[headImg defaultHeadImgAry].count) {
        NSString*pImgName=[headImg defaultHeadImgAry][nIndex];
        if (pImgName) {
            self.image=[UIImage imageNamed:pImgName];
//            [[NSUserDefaults standardUserDefaults]setObject:pImgName forKey:@"ImgName"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    else
    {
        NSLog(@"名字数组越界了");
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
