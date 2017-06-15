//
//  ViewController.m
//  StaffMap
//
//  Created by 张文强 on 2016/11/18.
//  Copyright © 2016年 张文强. All rights reserved.
//

#import "ViewController.h"
#import "ZwqTools.h"
#import "nameMap-Swift.h"
#import "NameButton.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize pCurStaffMap;

- (void)viewDidLoad {
    [super viewDidLoad];
    [databaseTool openDatabase];
    [self reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showEditInfoVC:) name:@"showEditInfo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didAddGroupBtn:) name:@"didAddGroupBtn" object:nil];
    //初始化分组按钮
    _aryGroupBtn=[@[_btnStaff,_btnFamily]mutableCopy];
    _pCurBtn=_btnStaff;
    _btnStaff.backgroundColor=[UIColor lightGrayColor];
    [self initGroupBar];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GroupChangeTo:) name:@"GroupChangeTo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAllGroup:) name:@"ShowAllGroup" object:nil];
    //从通讯录导入||导出完毕
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(importComplete:) name:@"importComplete" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exportComplete:) name:@"exportComplete" object:nil];
}
-(void)showEditInfoVC:(NSNotification*)pNoti
{
    id pObj=[pNoti object];
    EditInfoVC*pVC=[[EditInfoVC alloc]init];
    if ([pObj isKindOfClass:[NameButton class]]) {
        pVC.CurNameButton=pObj;
    }
    [self.navigationController pushViewController:pVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData
{
    NSDictionary*pDic=[ZwqTools getDefaultPlist];
    if (pDic) {
        pCurStaffMap=[[NSMutableDictionary alloc]initWithDictionary:pDic];
    }
    else
    {
        pCurStaffMap=[[NSMutableDictionary alloc]initWithCapacity:10];
    }
    [_pScrollArea initSubViews];
}

- (IBAction)open:(id)sender
{
    [self textfiledsResignFirstResponse];
}
- (IBAction)save:(id)sender {
    [self textfiledsResignFirstResponse];
    ZwqStaffArea*pSelectedView=_pScrollArea.pSelectedView;
    if (pSelectedView)
    {
        if(_txtName.text)
        {
            pSelectedView.pNameLabel.text=_txtName.text;
        }
        for (int i=0; i<[_aryText count]; i++)
        {
            UITextField*pText=_aryText[i];
            NSString*pStrText=_aryDetailKey[i];
            if (pText.text&&pStrText)
            {
                pSelectedView.pDicData[pStrText]=pText.text;
                [pText resignFirstResponder];
            }
        }
        NSString*pKeyValue=[NSString stringWithFormat:@"%d_%d",pSelectedView.xIndex,pSelectedView.yIndex];
        [pCurStaffMap setObject:pSelectedView.pDicData forKey:pKeyValue];
        [ZwqTools saveDefaultPlist:pCurStaffMap];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self textfiledsResignFirstResponse];
}
- (IBAction)saveas:(id)sender
{
    [self textfiledsResignFirstResponse];
    UIAlertController*pAlert=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"saveas",@"") message:NSLocalizedString(@"writeName", "") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction* pActionOK){
        NSString*pNewName=pAlert.textFields[0].text;
        [ZwqTools saveDefaultPlistAs:[NSString stringWithFormat:@"%@%@",pNewName,@".plist"]];
    }];
    [pAlert addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        
    }];
    [pAlert addAction:cancelAction];
    [pAlert addAction:okAction];
    [self presentViewController:pAlert animated:YES completion:nil];
}
-(void)textfiledsResignFirstResponse
{
    for (UITextField*pText in _aryText)
    {
        [pText resignFirstResponder];
    }
}
#pragma mark group相关
-(void)GroupChangeTo:(NSNotification*)notification
{
    NSNumber* pNum=notification.object;
    if(_pScrollArea.com)
    {
        [databaseTool updateNameByID:_pScrollArea.com.ID groupID:pNum.unsignedIntegerValue];
        [_pScrollArea initNames];
    }
    else
    {
        NSNumber*pNum=notification.object;
        UIButton*pBtn=_aryGroupBtn[pNum.integerValue];
        [self GroupBtnClicked:pBtn];
    }
    
    //[self initNames];
}
- (IBAction)GroupBtnClicked:(id)sender {
    if(_pCurBtn)_pCurBtn.backgroundColor=[UIColor clearColor];
    UIButton*pBtn=(UIButton*)sender;
    if (pBtn) {
        pBtn.backgroundColor=[UIColor lightGrayColor];
        _pCurBtn=pBtn;
        NSInteger nIndex=[_aryGroupBtn indexOfObject:pBtn];
        [databaseTool setCurGroupID:nIndex];
        [_pScrollArea initNames];
    }
}
- (IBAction)addGroup:(id)sender {
    newGroupVC*pVC=[[newGroupVC alloc]init];
    [self.navigationController pushViewController:pVC animated:YES];
}
- (IBAction)showAllGroup:(id)sender {
    if (_pScrollArea.com&&_pScrollArea.com.isSpreading) {
        [_pScrollArea.com shrinkWithHandle:nil];
    }
    //点击按钮进来的是转换群组,消息是移动人员位置
    if ([sender isKindOfClass:[UIButton class]]) {
        _pScrollArea.com=nil;
    }
    AllGroupVC*pVC=[[AllGroupVC alloc]init];
    [self.navigationController pushViewController:pVC animated:YES];
}
-(void)initGroupBar
{
    NSArray* aryGroups=[databaseTool getAllGroups];
    for (NSDictionary*pDic in aryGroups) {
        NSInteger nID=((NSNumber*)pDic[@"id"]).integerValue;
        if (nID!=0&&nID!=1) {
            [self newGroupBtn:pDic];
        }
    }
}
-(void)refreshGroupBar
{
    
}
-(void)didAddGroupBtn:(NSNotification*)Notification
{
    NSDictionary*pDic=[Notification userInfo];
    [self newGroupBtn:pDic];
}
-(void)newGroupBtn:(NSDictionary*)pDic
{
    UIButton*pBtn=[[UIButton alloc]initWithFrame:_btnStaff.bounds];
    if (pDic[GroupColumn2]) {
        [pBtn setImage:[UIImage imageNamed:pDic[GroupColumn2]] forState:UIControlStateNormal];
    }
    else
    {
        [pBtn setTitle:pDic[GroupColumn1] forState:UIControlStateNormal];
        [pBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [pBtn addTarget:self action:@selector(GroupBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    NSUInteger nCount=_aryGroupBtn.count;
    CGFloat fBtnW= ViewSize(pBtn).width;
    pBtn.frame=CGRectMake(nCount*fBtnW,ViewOrigin(_btnStaff).y,fBtnW,ViewSize(pBtn).height);
    [_groupScrollView addSubview:pBtn];
    _groupScrollView.contentSize=CGSizeMake((nCount+1)*fBtnW, ViewSize(_groupScrollView).height);
    [_aryGroupBtn addObject:pBtn];

}
#pragma mark 右上角按钮 相关
- (IBAction)clickRightTopBtn:(id)sender {
    UIAlertController*pAlert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray* aryTitles=[self getMenuTitles];

    for (NSString* strTitle in aryTitles)
    {
        UIAlertAction*pAction=[UIAlertAction actionWithTitle:strTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self clickAction:action];
        }];
        [pAlert addAction:pAction];
    }
    [self presentViewController:pAlert animated:YES completion:^{
        
    }];
}
-(NSArray*)getMenuTitles
{
    return  @[@"同步到通讯录",@"从通讯录导入",@"关于"];
}
-(void)clickAction:(UIAlertAction*)pAction
{
    NSArray* aryTitles=[self getMenuTitles];
    NSString* strTitle=pAction.title;
    if ([strTitle isEqualToString:aryTitles[0]] ) {
        [contactTools exportToContact];
        //self.view.maskView.backgroundColor=[UIColor grayColor];
    }
    else if([strTitle isEqualToString:aryTitles[1]])
    {
        [contactTools importFromContact];
       //  self.view.maskView.backgroundColor=[UIColor grayColor];
    }
    else if([strTitle isEqualToString:aryTitles[2]])
    {}
}
-(void)importComplete:(NSNotification*)pNoti
{
     //self.view.maskView.backgroundColor=[UIColor clearColor];
     [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:false];
}
-(void)exportComplete:(NSNotification*)pNoti
{
    // self.view.maskView.backgroundColor=[UIColor clearColor];
}
@end
