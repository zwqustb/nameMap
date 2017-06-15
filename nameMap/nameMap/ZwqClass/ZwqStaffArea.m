//
//  ZwqStaffArea.m
//  StaffMap
//
//  Created by 张文强 on 2016/11/22.
//  Copyright © 2016年 张文强. All rights reserved.
//

#import "ZwqStaffArea.h"
#import "ZwqScrollArea.h"
#import "ViewController.h"
#import "AppDelegate.h"
@implementation ZwqStaffArea
@synthesize pDicData;
@synthesize pNameLabel;
@synthesize xIndex;
@synthesize yIndex;
- (id)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth=1;
        self.layer.borderColor=[UIColor grayColor].CGColor;
//        pDicData=[[NSMutableDictionary alloc]initWithCapacity:4];
//        pNameLabel=[[UILabel alloc]initWithFrame:self.bounds];
//        pNameLabel.textAlignment=NSTextAlignmentCenter;
//        [self addSubview:pNameLabel];
    }
    return self;
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//  UITouch*pTouch=[touches anyObject];
//    ZwqScrollArea*pScrollView=(ZwqScrollArea*)[self superview];
//    if(!pScrollView.pSelectedView)
//    {
//        pScrollView.pSelectedView=self;
//        [self setSelected:YES];
//    }
//    else if(pScrollView.pSelectedView==self)
//    {
//        return;
//    }
//    else
//    {
//        [pScrollView.pSelectedView setSelected:false];
//        pScrollView.pSelectedView=self;
//        [self setSelected:YES];
//    }
//    AppDelegate*pDele=(AppDelegate*)[UIApplication sharedApplication].delegate;
//    UINavigationController*pNVC=(UINavigationController*)pDele.window.rootViewController;
//    ViewController*pVC=(ViewController*)pNVC.viewControllers[0];
//    if (pVC&&pDicData)
//    {
//        for (int i=0; i<[pVC.aryText count]; i++)
//        {
//            UITextField*pText=pVC.aryText[i];
//            NSString*pKey=pVC.aryDetailKey[i];
//            pText.text=pDicData[pKey];
//        }
//    }
}
-(void)setSelected:(BOOL)bSelect
{
    if(bSelect)
    {
        self.backgroundColor=[UIColor greenColor];
    }
    else
    {
        self.backgroundColor=[UIColor whiteColor];
    }
}
//
-(void)initData
{
//    AppDelegate*pDele=(AppDelegate*)[UIApplication sharedApplication].delegate;
//    UINavigationController*pNVC=(UINavigationController*)pDele.window.rootViewController;
//    ViewController* pVC=pNVC.viewControllers[0];
//    if (pVC&&pVC.pCurStaffMap)
//    {
//        NSString*pKey=[NSString stringWithFormat:@"%d_%d",xIndex,yIndex];
//        id pDicValue=[pVC.pCurStaffMap objectForKey:pKey];
//        if (pDicValue&&[pDicValue isKindOfClass:[NSDictionary class]])
//        {
//            pDicData =pDicValue;
//            NSString*pName=[pDicData objectForKey:@"name"];
//            if (pName) {
//                pNameLabel.text=pName;
//            }
//        }
//    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
