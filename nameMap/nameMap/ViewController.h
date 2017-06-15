//
//  ViewController.h
//  StaffMap
//
//  Created by 张文强 on 2016/11/18.
//  Copyright © 2016年 张文强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZwqScrollArea.h"
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet ZwqScrollArea*pScrollArea;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPosition;
@property (weak, nonatomic) IBOutlet UITextField *txtDept;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property(retain,nonatomic)NSArray*aryText;
@property(retain,nonatomic)NSArray*aryDetailKey;
@property(nonatomic,retain)NSMutableDictionary*pCurStaffMap;
#pragma mark group相关
@property(retain,nonatomic)UIButton*pCurBtn;
@property(retain,nonatomic)NSMutableArray*aryGroupBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnStaff;
@property (weak, nonatomic) IBOutlet UIButton *btnFamily;
- (IBAction)GroupBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAllGroup;
@property (weak, nonatomic) IBOutlet UIScrollView *groupScrollView;

#pragma mark 其它
- (IBAction)save:(id)sender;
- (IBAction)saveas:(id)sender;
- (IBAction)open:(id)sender;
-(void)reloadData;
-(void)textfiledsResignFirstResponse;
@end

