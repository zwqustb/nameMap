//
//  NameButton.m
//  StaffMap
//
//  Created by zhangwenqiang on 2017/3/9.
//  Copyright © 2017年 张文强. All rights reserved.
//

#import "NameButton.h"

@implementation NameButton
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        _dicNameInfo=[[NSMutableDictionary alloc]initWithCapacity:10];
        [self addSubview:self.nameLabel];
    }
    return self;
}
-(UILabel*)nameLabel
{
    if (!_nameLabel) {
        CGRect rtFrame=self.bounds;
        _nameLabel=[[UILabel alloc]initWithFrame:rtFrame];
        _nameLabel.backgroundColor=RGBA(255, 255, 255,0.5);
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        _nameLabel.numberOfLines=3;
        
    }
    return _nameLabel;
}
-(void)setStrInfo:(NSString *)strInfo
{
    if (strInfo)
    {
       _strInfo= [strInfo stringByReplacingOccurrencesOfString:@"&" withString:@"\""];
        _dicNameInfo=[ZwqTools StringToDictionary:_strInfo];
        if (_dicNameInfo[@"name"]) {
            _nameLabel.text=_dicNameInfo[@"name"];
        }
    }
   
}
- (void)panEnd:(CGPoint)ptCur
{
    [databaseTool updateNameByID:_ID X:ptCur.x Y:ptCur.y];
}
- (void)spreadWithHandle:(void(^)())handle
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NameTaped" object:self];
    [self.superview bringSubviewToFront:self];
    [super spreadWithHandle:handle];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
