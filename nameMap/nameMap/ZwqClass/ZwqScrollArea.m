//
//  ZwqScrollArea.m
//  StaffMap
//
//  Created by 张文强 on 2016/11/22.
//  Copyright © 2016年 张文强. All rights reserved.
//

#import "ZwqScrollArea.h"
#import "ZwqStaffArea.h"
#import "userData.h"
#import "nameMap-Swift.h"
@interface ZwqScrollArea()

@end
@implementation ZwqScrollArea
@synthesize pSelectedView;
- (id)initWithCoder:(NSCoder *)aDecoder {
    self =[super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addName:) name:@"addName" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NameTaped:) name:@"NameTaped" object:nil];

    }
    return self;
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)initSubViews
{
    pSelectedView=nil;
    for(UIView*pView in self.subviews)
    {
        [pView removeFromSuperview];
    }
    CGSize curMapSize=CGSizeMake(10,10);
    self.contentSize=CGSizeMake(curMapSize.width*100, curMapSize.height*100);
    NSDictionary*curMapInfo=[userData getCurMapInfo];
    if (curMapInfo) {
        self.contentSize=CGSizeMake([curMapInfo[@"width"]floatValue],[curMapInfo[@"height"]floatValue]);
    }
    for (int i=0; i<curMapSize.width; i++) {
        for (int j=0; j<curMapSize.height; j++) {
            ZwqStaffArea*pArea=[[ZwqStaffArea alloc]initWithFrame:CGRectMake(i*100, j*100, 100, 100)];
            pArea.xIndex=i;
            pArea.yIndex=j;
            [pArea initData];
            [self addSubview:pArea];
        }
    }
    [self initNames];
}

-(void)initNames
{
    for (UIView *pView in [self subviews]) {
        if ([pView isKindOfClass:[NameButton class]]) {
            [pView removeFromSuperview];
        }
    }
    NSArray*pAllNames=[databaseTool getAllNamesOfCurGroup];
    for (NSDictionary*pDic in pAllNames)
    {
        [self addNameButton:pDic];
    }
}
-(void)addNameButton:(NSDictionary*)pDic
{
    NSNumber* pID=pDic[@"id"];
    NSNumber* X=pDic[Column1];
    NSNumber* Y=pDic[Column2];
    NSString* strInfo=pDic[Column3];
    CGPoint ptLoc=CGPointMake(X.floatValue, Y.floatValue);
    NameButton *com  = [[NameButton alloc] initWithFrame:CGRectMake(ptLoc.x,ptLoc.y, 100, 100)];
    com.rtPopBounds=CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    
    com.itemsNum = 3;
    com.ID=pID.integerValue;
    com.strInfo=strInfo;
    [self addSubview:com];
    self.com = com;
    //处理头像图片
    NSString*pImgName=com.dicNameInfo[@"ImgName"];//@"staffFemale";
    if(!pImgName)
    {
        pImgName=[[NSUserDefaults standardUserDefaults]objectForKey:@"ImgName"];
        if (!pImgName) {
            pImgName=@"staffFemale";
        }
    }
    com.normalImage = [UIImage imageNamed:pImgName];
    com.selImage = [UIImage imageNamed:pImgName];
    com.images = @[@"editInfo",@"delete",@"rightArray"];
    [com spreadButtonDidClickItemAtIndex:^(NSUInteger index) {
        switch (index) {
            case 1:
            {
                [databaseTool deleteName:com.ID];
                [com removeFromSuperview];
                self.com=nil;
            }
                break;
            case 0:{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"showEditInfo" object:com];
            }
                break;
            case 2:{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowAllGroup" object:com];
            }
                break;
            default:
                break;
        }
    }];
    
    
}
#pragma mark notification
-(void)addName:(NSNotification *)notification
{
    if (![notification object]||![[notification object]isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary*pInfo=[notification object];
    NSNumber* X=pInfo[Column1];
    NSNumber* Y=pInfo[Column2];
    NSString*strInfo=pInfo[Column3];
    CGPoint ptLoc=CGPointMake(X.floatValue+self.contentOffset.x, Y.floatValue+self.contentOffset.y);
    NSUInteger nID=[databaseTool getMaxID]+1;
    [self addNameButton:@{Column1:@(ptLoc.x),Column2:@(ptLoc.y),@"id":@(nID),Column3:strInfo}];
    [databaseTool insertNameX:ptLoc.x Y:ptLoc.y info:strInfo];
}
-(void)NameTaped:(NSNotification*)notification
{
    NameButton*pBtn=[notification object];
    if (_com&&_com.isSpreading) {
        [_com shrinkWithHandle:nil];
    }
    _com=pBtn;
    CGRect rtBounds=CGRectMake(self.contentOffset.x, self.contentOffset.y, self.bounds.size.width, self.bounds.size.height);
    _com.rtPopBounds=rtBounds;
    _com.ptScrollOffset=self.contentOffset;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
