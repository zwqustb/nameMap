//
//  popView.m
//  StaffMap
//
//  Created by zhangwenqiang on 2017/3/14.
//  Copyright © 2017年 张文强. All rights reserved.
//

#import "popView.h"
@interface popView()
@property (retain,nonatomic)NSMutableArray<UIImageView*>*SubItems;
@property (retain,nonatomic)UIView*BottomView;
@end
@implementation popView
-(void)setItems:(NSArray*)pAry
{
    for (NSString*pImgName in pAry) {
        UIImageView*pImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        pImgView.image=[UIImage imageNamed:pImgName];
        UITapGestureRecognizer*pTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
        [pImgView addGestureRecognizer:pTap];
        pImgView.userInteractionEnabled=YES;
        [self.SubItems addObject:pImgView];
    }
}
-(NSMutableArray*)SubItems
{
    if (!_SubItems) {
        _SubItems=[[NSMutableArray alloc]initWithCapacity:10];
    }
    return _SubItems;
}
-(void)popViews
{
    if (!_BottomView||!_BottomView.superview)
    {
        UIView*pScreenView=[UIApplication sharedApplication].keyWindow.rootViewController.view;
        _BottomView=[[UIView alloc]initWithFrame:pScreenView.bounds];
        UITapGestureRecognizer*pTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
        [_BottomView addGestureRecognizer:pTap];
        [pScreenView addSubview:_BottomView];
        CGRect rtPop=[self.superview convertRect:self.frame toView:pScreenView];
        CGPoint ptDir=[self getPopOrientation:rtPop Boundto:pScreenView.bounds];
        for (UIImageView*pImgView in _SubItems) {
            [_BottomView addSubview:pImgView];
            NSUInteger i=[_SubItems indexOfObject:pImgView]+1;
            CGAffineTransform t=CGAffineTransformMakeTranslation(ptDir.x*100*i,ptDir.y*100*i);
            pImgView.center=CGPointApplyAffineTransform(CGPointMake(CGRectGetMidX(rtPop), CGRectGetMidY(rtPop)),t) ;
        }
    }
}
-(void)shrinkViews
{
    [_BottomView removeFromSuperview];
}
-(CGPoint)getPopOrientation:(CGRect)rect Boundto:(CGRect)rtBound
{
    int x=1;
    int y=1;
    int a=rect.origin.x;
    int b=rect.origin.y;
    int c=rtBound.size.width-CGRectGetMaxX(rect);
    int d=rtBound.size.height-CGRectGetMaxY(rect);
    if( a>c) {
        x = -1;
    }
    if (b>d ){
        y = -1;
    }
    if (MAX(a, c)>MAX(b,d)) {
        // x*=2
        y=0;
    }else{
        //y*=2
        x=0;
    }
    return CGPointMake(x, y);
}
-(void) onTap:(UITapGestureRecognizer*)pTab{
    [self shrinkViews];
    UIView* pView=pTab.view;
    if ([pView isKindOfClass:[UIImageView class]]) {
        NSInteger nIndex=[_SubItems indexOfObject:(UIImageView*)pView];
        if(nIndex!=NSNotFound)
        {
            [self handleSubitemTap:nIndex];
        }
        
    }
    
}
-(void) handleSubitemTap:(NSUInteger)nIndex{
    //self
    if (_delegate) {
        [_delegate handleSubitemDidTap:nIndex];
    }
    
    
}

@end
