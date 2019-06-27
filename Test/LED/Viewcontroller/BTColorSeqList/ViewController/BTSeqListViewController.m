//
//  BTSeqListViewController.m
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTSeqListViewController.h"
#import "BaseNavView.h"
#import "BTSeqListViewCell.h"
#import "BTSeqListCellEntity.h"
#import "BTSeqListBottomView.h"
#import "BTPickColorViewController.h"
#import "FMDBManger.h"
#import "BTSaveSeqListViewController.h"
#import "ExternalRenameView.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"


@interface BTSeqListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) BaseNavView *nav;
@property (nonatomic, strong) UILabel *seqName;
@property (nonatomic, strong) UIButton *seqTitleBtn;
//@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ExternalRenameView *reNameView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) BTSeqListBottomView *bottomView;
@property (nonatomic, strong) UIView *safeArea;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation BTSeqListViewController


- (void)cn_startai_registerAppDelegate:(AppDelegate *)delegate mode:(uint32_t)mode
{
    appDelegate = delegate;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
//    self.navigationController.navigationBar.hidden = false;
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 20, 20);
//    [leftBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [NSMutableArray array];
    [self cn_startai_initContentView];
    BTSeqListCellEntity *tEntity = [[BTSeqListCellEntity alloc] init];
    tEntity.serial = 001;
    tEntity.onms = 1;
    tEntity.offms = 1;
    tEntity.repeat = 1;
    tEntity.brigthness = 1;
    tEntity.hexStr = @"ff0000";
    tEntity.nextHexStr = @"000000";
    tEntity.modelNum = 4;
    tEntity.isGradientModel = false;
    tEntity.tableName = self.seqName.text;
    tEntity.isModelChanged = false;
    
    [self.dataArr addObject:tEntity];
    [self cn_startai_readData];
}

#pragma mark - UI

- (void)cn_startai_initContentView
{
    [self.view addSubview:self.nav];
    [self.view addSubview:self.seqName];
//    [self.view addSubview:self.textField];
    [self.view addSubview:self.seqTitleBtn];
    [self.view addSubview:self.line];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.safeArea];
    [self.view addSubview:self.maskView];
    [self.maskView addSubview:self.reNameView];
//    [self.textField becomeFirstResponder];
}

- (BaseNavView *)nav
{
    @weakify(self);
    if (!_nav) {
        _nav = [[BaseNavView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WITDH, NavBarHeight)];
//        _nav.rightImg = [UIImage imageNamed:@"tianjia"];
        _nav.leftHandler = ^{
            [weak_self.navigationController popViewControllerAnimated:true];
        };
//        _nav.rightHandler = ^{
//            if (weak_self.textField.text.length>1) {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:NSLocalizedString(@"SaveLastOperation",nil) preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [weak_self cn_startai_writeData];
//                    weak_self.dataArr = [NSMutableArray array];
//                    BTSeqListCellEntity *tEntity = [[BTSeqListCellEntity alloc] init];
//                    tEntity.serial = 001;
//                    tEntity.onms = 1;
//                    tEntity.offms = 1;
//                    tEntity.repeat = 5;
//                    tEntity.brigthness = 1;
//                    tEntity.hexStr = @"ff0000";
//                    tEntity.modelNum = 4;
//                    tEntity.tableName = weak_self.seqName.text;
//
//                    [weak_self.dataArr addObject:tEntity];
//                    [weak_self.tableView reloadData];
//                    weak_self.textField.text = @"";
//                }];
//                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    weak_self.dataArr = [NSMutableArray array];
//                    BTSeqListCellEntity *tEntity = [[BTSeqListCellEntity alloc] init];
//                    tEntity.serial = 001;
//                    tEntity.onms = 1;
//                    tEntity.offms = 1;
//                    tEntity.repeat = 5;
//                    tEntity.brigthness = 1;
//                    tEntity.hexStr = @"ff0000";
//                    tEntity.modelNum = 4;
//                    tEntity.tableName = weak_self.seqName.text;
//
//                    [weak_self.dataArr addObject:tEntity];
//                    [weak_self.tableView reloadData];
//                    weak_self.textField.text = @"";
//                }];
//                [alert addAction:ok];
//                [alert addAction:cancle];
//                [weak_self presentViewController:alert animated:true completion:^{
//
//                }];
//            }else{
//                weak_self.dataArr = [NSMutableArray array];
//                BTSeqListCellEntity *tEntity = [[BTSeqListCellEntity alloc] init];
//                tEntity.serial = 001;
//                tEntity.onms = 1;
//                tEntity.offms = 1;
//                tEntity.repeat = 0;
//                tEntity.brigthness = 1;
//                tEntity.hexStr = @"ff0000";
//                tEntity.modelNum = 4;
//                tEntity.tableName = weak_self.seqName.text;
//
//                [weak_self.dataArr addObject:tEntity];
//                [weak_self.tableView reloadData];
//                weak_self.textField.text = @"";
//            }
//
//
//        };
    }
    return _nav;
}

- (UILabel *)seqName
{
    if (!_seqName) {
        _seqName = [[UILabel alloc] initWithFrame:CGRectMake(50, IPHONEFringe+50, 100, 40)];
        _seqName.text = @"Seq.Name：";
        _seqName.font = [UIFont fontWithName:@"Arial" size:18];
        [_seqName sizeToFit];
    }
    return _seqName;
}

//- (UITextField *)textField
//{
//    if (!_textField) {
//        _textField = [[UITextField alloc] initWithFrame:CGRectMake(self.seqName.right+10, IPHONEFringe+40, 120, 30)];
//        _textField.textAlignment = NSTextAlignmentCenter;
////        _textField.text = @"HOME";
//        _textField.font = [UIFont fontWithName:@"Arial" size:18];
//        _textField.keyboardType = UIKeyboardTypeASCIICapable;
////        _textField.backgroundColor = [UIColor redColor];
//        [_textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
//
//    }
//    return _textField;
//}

- (UIButton *)seqTitleBtn
{
    if (!_seqTitleBtn) {
        _seqTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _seqTitleBtn.frame = CGRectMake(self.seqName.right+10, IPHONEFringe+40, 120, 30);
//        _seqTitleBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _seqTitleBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:18];
        [_seqTitleBtn setTitleColor:[UIColor colorWithHexColorString:@"333333"] forState:UIControlStateNormal];
        [_seqTitleBtn addTarget:self action:@selector(cn_startai_changeName) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seqTitleBtn;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(self.seqName.right, self.seqName.bottom, 150, 1)];
        _line.backgroundColor = [UIColor colorWithHexColorString:@"333333"];
    }
    return _line;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.line.bottom+5, SCREEN_WITDH, SCREEN_HEIGHT-NavBarHeight-IPHONEBottom-55 -30) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (ExternalRenameView *)reNameView
{
    @weakify(self);
    if (!_reNameView) {
        _reNameView = [[ExternalRenameView alloc] initWithFrame:CGRectMake(15, 150,SCREEN_WITDH-30, 220)];
        _reNameView.backgroundColor = [UIColor whiteColor];
        _reNameView.layer.cornerRadius = 10;
        _reNameView.isSeq = true;
        _reNameView.layer.masksToBounds = true;
        _reNameView.renameHandler = ^(NSInteger serail, NSString *name) {
            if (serail != -1) {
                if (name.length < 2 || name.length > 8) {
                    [weak_self cn_startai_showToastWithTitle:NSLocalizedString(@"SwitchRenameFail", nil)];
                }else{
                    name = [name uppercaseString];
                    [weak_self.seqTitleBtn setTitle:name forState:UIControlStateNormal];
                }
            }
            weak_self.maskView.hidden = true;
            [weak_self.view endEditing:true];
        };
    }
    return _reNameView;
}

- (BTSeqListBottomView *)bottomView
{
    @weakify(self);
    @weakify(appDelegate);
    if (!_bottomView) {
        _bottomView = [[BTSeqListBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-55-IPHONEBottom, SCREEN_WITDH, 55)];
        _bottomView.BTSeqListSaveHandler = ^{
            [weak_self cn_startai_writeData];
        };
        _bottomView.GotoSavedSeqListHandler = ^{
            BTSaveSeqListViewController *vc = [[BTSaveSeqListViewController alloc] init];
            [vc cn_startai_registerAppDelegate:weak_appDelegate mode:0];
            [weak_self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _bottomView;
}

- (UIView *)safeArea
{
    if (!_safeArea) {
        _safeArea = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-IPHONEBottom, SCREEN_HEIGHT, IPHONEBottom)];
        _safeArea.backgroundColor = [UIColor blackColor];
    }
    return _safeArea;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor colorWithHexColorString:@"000000" withAlpha:0.7];
        _maskView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

#pragma mark - TableView datasource delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 280;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifiy = @"BTSeqListViewCell";
    BTSeqListViewCell *cell = (BTSeqListViewCell *)[tableView dequeueReusableCellWithIdentifier:identifiy];
    if (!cell) {
        cell = [[BTSeqListViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    @weakify(self);
    //删除元素
    cell.BTSeqListSerialDeleteHandler = ^(NSInteger row) {
        
        if (weak_self.dataArr.count == 1) {
            [self cn_startai_showToastWithTitle:NSLocalizedString(@"NotDelete", nil)];
        }else{
            for (BTSeqListCellEntity *entity in weak_self.dataArr) {
                if (entity.serial == row) {
                    [weak_self.dataArr removeObject:entity];
                    break;
                }
            }
            [weak_self cn_startai_gradientHand];
            [weak_self.tableView reloadData];
        }
    };
    
    //修改元素值
    cell.BTSeqListViewCellChangeEntity = ^(BTSeqListCellEntity *entity) {
        BTSeqListCellEntity *tmp ;
        for (BTSeqListCellEntity *tEntity in weak_self.dataArr) {
            if (tEntity.serial == entity.serial) {
                if (entity.serial > 1) {
                    tmp = weak_self.dataArr[entity.serial - 2];
                }
                tEntity.onms = entity.onms;
                tEntity.offms = entity.offms;
                tEntity.repeat = entity.repeat;
                tEntity.brigthness = entity.brigthness;
                tEntity.tableName = weak_self.seqName.text;
                tEntity.modelNum = entity.modelNum;
                if (entity.modelNum == GradientModel) {
                    tEntity.modelNum = 3;
                    tEntity.isGradientModel = true;
                    if (tmp && tmp.modelNum == GradientModel && entity.isModelChanged) {
                        tEntity.hexStr = tmp.nextHexStr;
                        tEntity.nextHexStr = entity.nextHexStr;
                    }else if(!tmp || tmp.modelNum != GradientModel){
                        tEntity.hexStr = entity.hexStr;
                        tEntity.nextHexStr = @"00ff00";
                    }else{
                        tEntity.hexStr = entity.hexStr;
                        tEntity.nextHexStr = entity.nextHexStr;
                    }
                }else if (entity.modelNum == BreathModel){
                    tEntity.modelNum = 4;
                    tEntity.isGradientModel = false;
                    tEntity.nextHexStr = @"000000";
                }else{
                    tEntity.modelNum = 5;
                    tEntity.isGradientModel = false;
                    tEntity.nextHexStr = @"000000";
                }
            }
        }
        if (entity.isModelChanged) {
            [weak_self cn_startai_gradientHand];
            [weak_self.tableView reloadData];
        }
    };
    //修改元素颜色
    cell.BTPickColorHandler = ^(NSInteger row) {
        BTPickColorViewController *pickVC = [[BTPickColorViewController alloc] init];
        pickVC.row = row;
        pickVC.BTPickColorReturn = ^(NSString *color, NSInteger row) {
            for (BTSeqListCellEntity *entity in weak_self.dataArr) {
                if (entity.serial == row) {
                    entity.hexStr = color;
                    if ([entity.tableName isEqualToString:@"DOME"]) {
                        entity.nextHexStr = color;
                    }
                    break;
                }
            }
            [weak_self cn_startai_gradientHand];
            [weak_self.tableView reloadData];

        };
        
        for (BTSeqListCellEntity *entity in weak_self.dataArr) {
            if (entity.serial == row) {
                pickVC.colorHex = entity.hexStr;
                break;
            }
        }
        [weak_self.navigationController pushViewController:pickVC animated:YES];
    };
    
    cell.BTPickNextColorHandler = ^(NSInteger row) {
        BTPickColorViewController *pickVC = [[BTPickColorViewController alloc] init];
        pickVC.row = row;
        pickVC.BTPickColorReturn = ^(NSString *color, NSInteger row) {
            for (BTSeqListCellEntity *entity in weak_self.dataArr) {
                if (entity.serial == row) {
                    entity.nextHexStr = color;
                    break;
                }
            }
            [weak_self cn_startai_gradientHand];
            [weak_self.tableView reloadData];
        };
        
        for (BTSeqListCellEntity *entity in weak_self.dataArr) {
            if (entity.serial == row) {
                pickVC.colorHex = entity.nextHexStr;
                break;
            }
        }
        [weak_self.navigationController pushViewController:pickVC animated:YES];
    };
    
    //复制元素
    cell.copyHandler = ^(NSInteger row) {
        if (weak_self.dataArr.count>=8) {
            
        }else{
            [weak_self cn_startai_addColorActionAtIndex:row];
        }
    };
    
    cell.CancleEditingHandler = ^{
        [weak_self.view endEditing:true];
    };
    
    BTSeqListCellEntity *tEntity = self.dataArr[indexPath.row];
    tEntity.serial = indexPath.row+1;
    if (tEntity) {
        [cell setValueForBTSeqListViewCell:tEntity];
        if (tEntity.modelNum == GradientModel && indexPath.row>0) {
            BTSeqListCellEntity *t = self.dataArr[indexPath.row-1];
            if (t && t.modelNum == GradientModel) {
                cell.canClickFirstColor = false;
            }else{
                cell.canClickFirstColor = true;
            }
        }
    }
    cell.seqTitle = self.seqTitleBtn.titleLabel.text;
    if (indexPath.row == 0) {
        cell.hideDelte = true;
    }else{
        cell.hideDelte = false;
    }
    return cell;
}

#pragma mark -event

- (void)cn_startai_readData
{
    if (!self.seqTitle.length){
//        self.textField.text = @"HOME";
        [self.seqTitleBtn setTitle:@"HOME" forState:UIControlStateNormal];
        return;
    }
//    self.textField.text = self.seqTitle;
    [self.seqTitleBtn setTitle:_seqTitle forState:UIControlStateNormal];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDitrctory = [paths objectAtIndex:0];
    NSString *str = [NSString stringWithFormat:@"%@.plist",self.seqTitle];
    NSString *box = [documentDitrctory stringByAppendingPathComponent:@"colorBox"];
    NSString *path = [box stringByAppendingPathComponent:str];
    if (path) {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        self.dataArr = [NSMutableArray arrayWithArray:arr];
        [self.tableView reloadData];
    }
}

- (void)cn_startai_writeData
{
//    for (NSInteger i=0; i<self.dataArr.count; i++) {
//        BTSeqListCellEntity *entity = self.dataArr[i];
//        entity.serial = i+1;
//        entity.onms = entity.onms;
//        entity.offms = entity.offms;
//        entity.brigthness = entity.offms;
//        entity.repeat = entity.repeat;
//        if (self.dataArr.count == 1 && entity.modelNum == 3) {
//            [self cn_startai_addColorActionAtIndex:1];
//        }
//    }
    
    if (![self.seqTitle isEqualToString:@"DOME"] && [self.seqTitleBtn.titleLabel.text isEqualToString:@"DOME"]) {
        [self cn_startai_showToastWithTitle:NSLocalizedString(@"SwitchRenameFail", nil)];
        return;
    }
    
    if ([self.seqTitle isEqualToString:@"DOME"]) {
        self.seqTitleBtn.titleLabel.text = @"DOME";
    }
    
    if (self.dataArr.count == 0) {
        [self cn_startai_showToastWithTitle:NSLocalizedString(@"AddMode", nil)];
        return;
    }
    
    if (self.seqTitleBtn.titleLabel.text.length==1){
        [self cn_startai_showToastWithTitle:NSLocalizedString(@"SeqNameShort", nil)];
        return ;
    }else if(!self.seqTitleBtn.titleLabel.text.length){
         [self cn_startai_showToastWithTitle:NSLocalizedString(@"SeqNameNull", nil)];
        return ;
    }
    
    BOOL ok= [self isIncludeSpecialCharact:self.seqTitleBtn.titleLabel.text];
    if (ok==YES) {
        [self cn_startai_showToastWithTitle:NSLocalizedString(@"NoSpecialCharacters", nil)];
        return ;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDitrctory = [paths objectAtIndex:0];
    NSString *box = [documentDitrctory stringByAppendingPathComponent:@"colorBox"];
    NSArray *arr = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:box error:nil];
    
//    BOOL exist = false;
//    for (NSString *path in arr) {
//        if ([path rangeOfString:self.seqTitleBtn.titleLabel.text].length) {
//            exist = true;
//            break;
//        }
//    }
    
    if ([self.seqTitleBtn.titleLabel.text isEqualToString:self.seqTitle ]) {
        [self cn_startai_showToastWithTitle:NSLocalizedString(@"SeqNameRepeat", nil)];
    }else{
        [self cn_startai_showToastWithTitle:NSLocalizedString(@"SaveAsNewSeq", nil)];
    }
    
    
    BOOL have = [[NSFileManager defaultManager] fileExistsAtPath:box];
    if (!have) {
        [[NSFileManager defaultManager] createDirectoryAtPath:box withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *removePath = [box stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",self.seqTitle] ];
    if ([[NSFileManager defaultManager] fileExistsAtPath:removePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:removePath error:nil];
    }
    
//    NSString *str = [NSString stringWithFormat:@"%@.plist",self.textField.text];
    NSString *str = [NSString stringWithFormat:@"%@.plist",self.seqTitleBtn.titleLabel.text];
    NSString *path = [box stringByAppendingPathComponent:str];
    if (!self.dataArr.count) return;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    BOOL result = [NSKeyedArchiver archiveRootObject:self.dataArr toFile:path];
    NSLog(@"---------写入闪法是否成功---------_%d",result);

}

- (void)cn_startai_changeName
{
    self.maskView.hidden = false;
    self.reNameView.title = self.seqTitleBtn.titleLabel.text;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    self.maskView.hidden = true;
}

- (void)cn_startai_gradientHand
{
    BTSeqListCellEntity *tml;
    for (BTSeqListCellEntity *entity  in self.dataArr) {
        if (entity.modelNum == GradientModel && tml && tml.modelNum == GradientModel) {
            entity.nextHexStr = entity.nextHexStr;
            entity.hexStr = tml.nextHexStr;
        }else{
            tml = nil;
        }
        tml = entity;
    }
}

- (void)cn_startai_addColorActionAtIndex:(NSInteger)row
{
    @synchronized (self) {
        BTSeqListCellEntity *tEntity = [self.dataArr objectAtIndex:row-1];
        BTSeqListCellEntity *entity = [[BTSeqListCellEntity alloc] init];
        entity.hexStr = tEntity.hexStr;
        entity.serial = self.dataArr.count+1;
        entity.onms = tEntity.onms;
        entity.offms = tEntity.offms;
        entity.brigthness = tEntity.brigthness;
        entity.modelNum = tEntity.modelNum;
        entity.tableName = tEntity.tableName;
        entity.isGradientModel = tEntity.isGradientModel;
        entity.nextHexStr = tEntity.nextHexStr;
        entity.repeat = tEntity.repeat;
        
        [self.dataArr addObject:entity];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

//- (void)textChanged:(UITextField *)textField
//{
//    if (textField.text.length>8) {
//        self.textField.text = [textField.text substringToIndex:8];
//        [self cn_startai_showToastWithTitle:NSLocalizedString(@"SeqNameLong", nil)];
//    }
//    self.textField.text = [self.textField.text uppercaseString];
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

-(BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨‘「」『』￠￢￣~@#￥&*（）——+|《》$_€ -:;,。.?!""“”|、+=%"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

- (void)cn_startai_showToastWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.userInteractionEnabled = false;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.numberOfLines = 0;
    [self.view addSubview:hud];
    [hud showAnimated:true];
    [hud hideAnimated:true afterDelay:2.0];
}

#pragma mark super

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{
//    [self addColorAction];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
