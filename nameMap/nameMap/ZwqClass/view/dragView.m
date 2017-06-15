//
//  dragView.m
//  StaffMap
//
//  Created by zhangwenqiang on 2017/2/22.
//  Copyright © 2017年 张文强. All rights reserved.
//

#import "dragView.h"
#import "nameMap-swift.h"

@implementation dragView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius=self.frame.size.width*.5;
    self.userInteractionEnabled=true;

    UILongPressGestureRecognizer*pLongPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:pLongPress];
    UIPanGestureRecognizer*pPan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(HandlePan:)];
    [self addGestureRecognizer:pPan];
    
    UITapGestureRecognizer*pTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapDrag:)];
    [self addGestureRecognizer:pTap];
    CGFloat dragX=[[NSUserDefaults standardUserDefaults]floatForKey:@"dragX"];
    CGFloat dragY=[[NSUserDefaults standardUserDefaults]floatForKey:@"dragY"];
    self.frame=CGRectMake(dragX, dragY, 100, 100);

    // Initialization code
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)longPress:(UILongPressGestureRecognizer *)longPress
{
    [self popViews];
}
-(void) handleSubitemTap:(NSUInteger)nIndex
{
    if (nIndex<[headImg defaultHeadImgAry].count)
    {
        NSString*pImgName=[headImg defaultHeadImgAry][nIndex];
        if (pImgName)
        {
            [[NSUserDefaults standardUserDefaults]setObject:pImgName forKey:@"ImgName"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    else
    {
        NSLog(@"名字数组越界了");
    }
}
-(void)HandlePan:(UIPanGestureRecognizer *)pPan
{
    CGPoint point = [pPan locationInView:self];

    switch (pPan.state) {
        case UIGestureRecognizerStateBegan:
            self.backgroundColor=[UIColor redColor];
            _lastPoint=point;
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGAffineTransform t=CGAffineTransformMakeTranslation(point.x-_lastPoint.x,point.y-_lastPoint.y);
            CGPoint ptNewCenter=CGPointApplyAffineTransform(self.center, t);
            if ([self.superview.subviews[0] isKindOfClass:[UIScrollView class]]) {
                UIScrollView*pScroll=(UIScrollView*)self.superview.subviews[0];
                CGPoint ptOffset=pScroll.contentOffset;
                CGRect rtBounds=self.superview.bounds;
                rtBounds=CGRectInset(rtBounds, 50, 50);
                if (ptNewCenter.x<rtBounds.origin.x) {
                    ptNewCenter.x=rtBounds.origin.x;
                    if (pScroll.contentOffset.x>0) {
                        pScroll.contentOffset=CGPointMake(ptOffset.x-1, ptOffset.y);
                    }
                }
                if (ptNewCenter.y<rtBounds.origin.y) {
                    ptNewCenter.y=rtBounds.origin.y;
                    if (pScroll.contentOffset.y>0) {
                        pScroll.contentOffset=CGPointMake(ptOffset.x, ptOffset.y-1);
                    }
                }
                if (ptNewCenter.x>CGRectGetMaxX(rtBounds)) {
                    ptNewCenter.x=CGRectGetMaxX(rtBounds);
                    if (pScroll.contentOffset.x<pScroll.contentSize.width-ViewSize(pScroll).width) {
                        pScroll.contentOffset=CGPointMake(ptOffset.x+1, ptOffset.y);
                    }
                }
                if (ptNewCenter.y>CGRectGetMaxY(rtBounds)) {
                    ptNewCenter.y=CGRectGetMaxY(rtBounds);
                    if (pScroll.contentOffset.y<pScroll.contentSize.height-ViewSize(pScroll).height) {
                        pScroll.contentOffset=CGPointMake(ptOffset.x, ptOffset.y+1);
                    }
                }
            }
            self.center=ptNewCenter;
    
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [[NSUserDefaults standardUserDefaults]setFloat:self.frame.origin.x forKey:@"dragX"];
            [[NSUserDefaults standardUserDefaults]setFloat:self.frame.origin.y forKey:@"dragY"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            self.backgroundColor=[UIColor clearColor];
        }
            break;
        default:
            break;
    }
}
-(void)TapDrag:(UITapGestureRecognizer*)pTap
{
    CGPoint ptCenter = self.frame.origin;
  //  [NameLogic addName];
    NSString*ImgName=[[NSUserDefaults standardUserDefaults]objectForKey:@"ImgName"];
    if (!ImgName) {
        ImgName=@"staffFemale";
    }
    NSString*strInfo=[NSString stringWithFormat:@"{&ImgName&:&%@&}",ImgName];
    NSDictionary*pDic=@{Column1:@(ptCenter.x),Column2:@(ptCenter.y),Column3:strInfo};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addName" object:pDic];
}
@end
