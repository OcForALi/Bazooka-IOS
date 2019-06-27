//
//  BTSaveSeqListViewController.m
//  BTMate
//
//  Created by Mac on 2017/8/22.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTSaveSeqListViewController.h"
#import "BTSaveSeqListBar.h"
#import "BTSaveSeqListCell.h"
#import "BTSaveSeqLineCell.h"
#import "BTSaveSeqListEntity.h"
#import "BTSaveSeqListBottom.h"
#import "BaseNavView.h"
#import "SendPopView.h"
#import "BTSeqListViewController.h"
#import "BTSeqListCellEntity.h"
#import "PopView.h"
#import "SendResultView.h"
#import "FirmwareUpdateVCViewController.h"
@interface BTSaveSeqListViewController ()<UITableViewDelegate, UITableViewDataSource, GlobalDelegate>
{
    AppDelegate *appDelegate;
    BOOL state;
}
@property (nonatomic, strong) BaseNavView *nav;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) BTSaveSeqListBar *listBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BTSaveSeqListBottom *bottomView; //底部状态栏
@property (nonatomic, strong) UIView *safeArea;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) SendPopView *sendView;    //正在发送闪法
@property (nonatomic, strong) PopView *noPiarPop;   //未匹配蓝牙弹窗
@property (nonatomic, strong) PopView *delePop;     //删除闪法弹窗
@property (nonatomic, strong) PopView *resetPop;    //重置闪法列表弹窗
@property (nonatomic, strong) SendResultView *resultView;   //发送闪法结果

@property (nonatomic, strong) UIButton *editView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, copy) NSString *seqTitle;
@property (nonatomic, strong) NSMutableArray *sendArr;  //选择的闪法发送
@property (nonatomic, assign) NSInteger sendIndex;      //正在发送第几条闪法
@property (nonatomic, strong) CADisplayLink *autoScrollTimer;
@property (nonatomic, assign) NSInteger recordNum;      //记录重复闪法的次数
@property (nonatomic, assign) NSInteger currentIndex;   //发送闪法进度
@property (nonatomic, assign) NSInteger lineIndex;    //截止框的下标
@property (nonatomic, assign) BOOL canMove; //是否可以移动cell
@property (nonatomic, assign) BOOL autoScrollDirection; //拖动tableview方向
@property (nonatomic, assign) BOOL hideLine;  //拖动线的过程中隐藏掉cell
@property (nonatomic, assign) BOOL stopSend;  //停止闪法发送
@property (nonatomic, assign) NSInteger editCellIndex; //选择了第几个闪法编辑
@property (nonatomic, assign) NSInteger deleteRow;   //选择第几个闪法删除

@end

@implementation BTSaveSeqListViewController

- (void)cn_startai_registerAppDelegate:(AppDelegate *)delegate mode:(uint32_t)mode
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lineIndex"]) {
        self.lineIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"lineIndex"];
    }else{
        self.lineIndex = 18;
    }
    appDelegate = delegate;
    appDelegate.globalManager = [appDelegate.mMediaManager getGlobalManager:self];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (appDelegate.player.player.rate == 1) {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    }else{
//        [[AVAudioSession sharedInstance] setActive:true error:nil];
//    }

    self.editCellIndex = 1000;
    appDelegate.globalManager = [appDelegate.mMediaManager getGlobalManager:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self cn_startai_initContentView];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"firstBlod"]) {
        [self writeSeqColor];
        [self cn_startai_getDefaultSaveList];
    }else{
        [self cn_startai_getSaveList];
    }
}

#pragma mark - UI

- (void)cn_startai_initContentView
{
    [self.view addSubview:self.nav];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.line];
    [self.view addSubview:self.listBar];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.editView];
    [self.tableView addGestureRecognizer:self.tapGes];
    [self.tableView addGestureRecognizer:self.longPressGesture];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.safeArea];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.noPiarPop];
    [self.view addSubview:self.delePop];
    [self.view addSubview:self.resetPop];
    [self.view addSubview:self.sendView];
    [self.view addSubview:self.resultView];
}

- (BaseNavView *)nav
{
    @weakify(self);
    if (!_nav) {
        _nav = [[BaseNavView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WITDH, NavBarHeight)];
        _nav.hideLine = true;
        _nav.leftHandler = ^{
            [weak_self.navigationController popViewControllerAnimated:true];
        };
    }
    return _nav;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, IPHONEFringe+45, 200, 50)];
        _titleLabel.text = @"Seq.list";
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:25];
        _titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(23, self.titleLabel.bottom+15, SCREEN_WITDH-46, 1)];
        _line.backgroundColor = [UIColor colorWithHexColorString:@"999999"];
    }
    return _line;
}

- (BTSaveSeqListBar *)listBar
{
    if (!_listBar) {
        _listBar = [[BTSaveSeqListBar alloc] initWithFrame:CGRectMake(0, self.line.bottom+15, SCREEN_WITDH, 30)];
    }
    return _listBar;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.listBar.bottom, SCREEN_WITDH, SCREEN_HEIGHT-self.listBar.bottom-60-IPHONEBottom) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.layer.masksToBounds = true;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIButton *)editView
{
    if (!_editView) {
        _editView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editView setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        [_editView setTitle:@"Edit" forState:UIControlStateNormal];
        [_editView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editView addTarget:self action:@selector(cn_startai_goEdit) forControlEvents:UIControlEventTouchUpInside];
        _editView.hidden = true;
    }
    return _editView;
}

- (BTSaveSeqListBottom *)bottomView
{
    @weakify(self);
    __weak typeof(self) weakSelf = self;
    if (!_bottomView) {
        _bottomView = [[BTSaveSeqListBottom alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60-IPHONEBottom, SCREEN_WITDH, 60)];
        _bottomView.transHandler = ^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!appDelegate.isConnected) {
                weak_self.noPiarPop.hidden = false;
                weak_self.maskView.hidden = false;
            }else{
                [weak_self cn_startai_sendSeq];
                weak_self.maskView.hidden = false;
                weak_self.sendView.hidden = false;
            }
        };
        _bottomView.restHandler = ^{
            weak_self.resetPop.hidden = false;
            weak_self.maskView.hidden = false;
        };
        _bottomView.updateHandler = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            FirmwareUpdateVCViewController *firVC = [[FirmwareUpdateVCViewController alloc] init];
            [firVC cn_startai_registerAppDelegate:appDelegate];
//            [firVC cn_startai_registerAppDelegate:strongSelf->appDelegate];
            [weak_self.navigationController pushViewController:firVC animated:true];
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

- (PopView *)noPiarPop
{
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 250 : 335;
    @weakify(self);
    if (!_noPiarPop) {
        _noPiarPop = [[PopView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT-hei)/2.0, SCREEN_WITDH-40, hei)];
        _noPiarPop.backgroundColor = [UIColor whiteColor];
        _noPiarPop.alpha = 0.7;
        _noPiarPop.text = NSLocalizedString(@"PartybarNotPair", nil);
        _noPiarPop.leftText = @"Cancel";
        _noPiarPop.rightText = @"Setting";
        _noPiarPop.hidden = true;
        _noPiarPop.leftHandler = ^{
            weak_self.noPiarPop.hidden = true;
            weak_self.maskView.hidden = true;
        };
        _noPiarPop.rightHandler = ^{
            weak_self.noPiarPop.hidden = true;
            weak_self.maskView.hidden = true;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoConnectPeripheral" object:nil];
            [weak_self.navigationController popToRootViewControllerAnimated:true];
        };
    }
    return _noPiarPop;
}

- (PopView *)delePop
{
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 250 : 335;
    @weakify(self);
    if (!_delePop) {
        _delePop = [[PopView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT-hei)/2.0, SCREEN_WITDH-40, hei)];
        _delePop.backgroundColor = [UIColor whiteColor];
        _delePop.alpha = 0.7;
        _delePop.text = NSLocalizedString(@"DeleteSeq", nil);
        _delePop.leftText = @"Cancel";
        _delePop.rightText = @"Ok";
        _delePop.hidden = true;
        _delePop.leftHandler = ^{
            weak_self.delePop.hidden = true;
            weak_self.maskView.hidden = true;
        };
        _delePop.rightHandler = ^{
            weak_self.delePop.hidden = true;
            weak_self.maskView.hidden = true;
            if (weak_self.deleteRow < weak_self.lineIndex - 1) {
                weak_self.lineIndex -- ;
            }
            [[NSUserDefaults standardUserDefaults] setInteger:weak_self.lineIndex forKey:@"lineIndex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            weak_self.editCellIndex = 10000;
            weak_self.editView.hidden = true;
            NSInteger index = weak_self.deleteRow > weak_self.lineIndex -1 ? weak_self.deleteRow - 1 : weak_self.deleteRow;
            BTSaveSeqListEntity *entity = weak_self.dataArr[index];
            [weak_self.dataArr removeObjectAtIndex:index];
            [weak_self.tableView reloadData];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDitrctory = [paths objectAtIndex:0];
            NSString *box = [documentDitrctory stringByAppendingPathComponent:@"colorBox"];
            NSString *path = [box stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",entity.title]];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        };
    }
    return _delePop;
}


- (PopView *)resetPop
{
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 250 : 335;
    @weakify(self);
    if (!_resetPop) {
        _resetPop = [[PopView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT-hei)/2.0, SCREEN_WITDH-40, hei)];
        _resetPop.backgroundColor = [UIColor whiteColor];
        _resetPop.alpha = 0.7;
        _resetPop.text = NSLocalizedString(@"ResetFlash", nil);
        _resetPop.leftText = @"Cancel";
        _resetPop.rightText = @"OK";
        _resetPop.hidden = true;
        _resetPop.leftHandler = ^{
            weak_self.resetPop.hidden = true;
            weak_self.maskView.hidden = true;
        };
        _resetPop.rightHandler = ^{
            weak_self.resetPop.hidden = true;
            weak_self.maskView.hidden = true;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDitrctory = [paths objectAtIndex:0];
            NSString *box = [documentDitrctory stringByAppendingPathComponent:@"colorBox"];
            NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: box error:nil];
            for (NSString *file in files) {
                [[NSFileManager defaultManager] removeItemAtPath:[box stringByAppendingPathComponent:file] error:nil];
            }
            [weak_self writeSeqColor];
            [weak_self cn_startai_getDefaultSaveList];
        };
    }
    return _resetPop;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor colorWithHexColorString:@"000000" withAlpha:0.7];
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (SendPopView *)sendView
{
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 270 : 250;
    @weakify(self);
    if (!_sendView) {
        _sendView = [[SendPopView alloc] initWithFrame:CGRectMake(30, (SCREEN_HEIGHT-hei)/2.0, SCREEN_WITDH-60, hei)];
        _sendView.hidden = true;
        _sendView.layer.cornerRadius = 5;
        _sendView.sendSucessdHandler = ^{
            weak_self.maskView.hidden = true;
            weak_self.sendView.hidden = true;
            weak_self.stopSend = true;
        };
    }
    return _sendView;
}

- (SendResultView *)resultView
{
    @weakify(self);
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 200 : 250;
    if (!_resultView) {
        _resultView = [[SendResultView alloc] initWithFrame:CGRectMake((SCREEN_WITDH-250)/2.0, (SCREEN_HEIGHT-250)/2.0, 250, 250)];
        _resultView.layer.cornerRadius = 5;
        _resultView.hidden = true;
        _resultView.backgroundColor = [UIColor whiteColor];
        _resultView.sendSucessdHandler = ^{
            weak_self.maskView.hidden = true;
            weak_self.resultView.hidden = true;
        };
    }
    return _resultView;
}

- (UITapGestureRecognizer *)tapGes
{
    if (!_tapGes) {
        _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
        _tapGes.numberOfTapsRequired = 1;
    }
    return _tapGes;
}

-(UILongPressGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        _longPressGesture.minimumPressDuration = 0.5;
    }
    return _longPressGesture;
}

#pragma mark - tableView Delegate DataSourece

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    static NSString *identifiy = @"BTSaveSeqListCell";
    static NSString *identifiy1 = @"";
    if (indexPath.row == self.lineIndex - 1) {
        BTSaveSeqLineCell *cell = (BTSaveSeqLineCell *)[tableView dequeueReusableCellWithIdentifier:identifiy1];
        if (!cell) {
            cell = [[BTSaveSeqLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiy1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        if (self.hideLine) {
            cell.hidden = true;
        }else{
            cell.hidden = false;
        }
        return cell;
    }else{
    BTSaveSeqListCell *cell = (BTSaveSeqListCell *)[tableView dequeueReusableCellWithIdentifier:identifiy];
    if (!cell) {
        cell = [[BTSaveSeqListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifiy];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //删除seq
    cell.BTSaveSeqListCellDeleteHandler = ^(NSInteger row) {
        weak_self.deleteRow = row;
        weak_self.delePop.hidden = false;
        weak_self.maskView.hidden = false;
    };
    
    //seq上移
    cell.BTSaveSeqListCellUpHandler = ^(NSInteger row) {
        if (row>1) {
            NSIndexPath *path1 = [NSIndexPath indexPathForRow:row inSection:0];
            NSIndexPath *path2 = [NSIndexPath indexPathForRow:row-1 inSection:0];
            if ([[tableView cellForRowAtIndexPath:path2] isKindOfClass:[BTSaveSeqLineCell class]]) {
                path2 = [NSIndexPath indexPathForRow:row-2 inSection:0];
                [weak_self.dataArr exchangeObjectAtIndex:row-1 withObjectAtIndex:row-2];

            }else if (row - 1 > self.lineIndex -1) {
                [weak_self.dataArr exchangeObjectAtIndex:row-1 withObjectAtIndex:row-2];

            }else{
                [weak_self.dataArr exchangeObjectAtIndex:row withObjectAtIndex:row-1];

            }
            self.editCellIndex = 10000;
            self.editView.hidden = true;
            [self.tableView reloadRowsAtIndexPaths:@[path1] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:@[path2] withRowAnimation:UITableViewRowAnimationTop];
        }
    };
    
//    seq下移
    cell.BTSaveSeqListCellDownHandler = ^(NSInteger row) {
        if ( row+1<self.dataArr.count) {
            NSIndexPath *path1 = [NSIndexPath indexPathForRow:row inSection:0];
            NSIndexPath *path2 = [NSIndexPath indexPathForRow:row+1 inSection:0];
            if ([[tableView cellForRowAtIndexPath:path2] isKindOfClass:[BTSaveSeqLineCell class]]) {
                path2 = [NSIndexPath indexPathForRow:row+2 inSection:0];
                [weak_self.dataArr exchangeObjectAtIndex:row withObjectAtIndex:row+1];
            }else if(row+1<self.lineIndex-1){
                [weak_self.dataArr exchangeObjectAtIndex:row withObjectAtIndex:row+1];
            }else{
                [weak_self.dataArr exchangeObjectAtIndex:row-1 withObjectAtIndex:row];
                
            }

            self.editCellIndex = 10000;
            self.editView.hidden = true;
            [self.tableView reloadRowsAtIndexPaths:@[path1] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:@[path2] withRowAnimation:UITableViewRowAnimationBottom];
        }
    };
    
    //seq修改
    cell.BTSaveSeqListCellChangeHandler = ^(NSString *title, NSInteger row) {
        if (row == 0) {
            self.tableView.layer.masksToBounds = false;
        }
        weak_self.editCellIndex = row;
        weak_self.seqTitle = title;
        CGSize textSize = [title boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
        weak_self.editView.hidden = false;
        CGFloat top = row>=self.lineIndex-1? 40*row-20 : 40*row-20;
        
        weak_self.editView.frame = CGRectMake(SCREEN_WITDH/5.0+textSize.width, top, 49, 32);
        [weak_self.tableView reloadData];
    };

    NSInteger index = indexPath.row > self.lineIndex - 1 ? indexPath.row -1 : indexPath.row;
    if (index<self.dataArr.count) {
        BTSaveSeqListEntity *entity = self.dataArr[index];
        entity.serial = index;
        cell.tEntity = entity;
        cell.lineIndex = self.lineIndex-1;
        if (indexPath.row == self.editCellIndex) {
            cell.titleColor = @"ff6a6e";
        }
    }
    return cell;

    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.editCellIndex = 10000;
    self.tableView.layer.masksToBounds = true;
    self.editView.hidden = true;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.editCellIndex = 10000;
    self.tableView.layer.masksToBounds = true;
    self.editView.hidden = true;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.lineIndex-1) {
        return 40;
    }
    return 40;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


- (void)tapGes:(UITapGestureRecognizer *)tap
{
    self.editView.hidden = true;
    self.editCellIndex = 10000;
}

static UIView *snapshot = nil;
- (void)longPressGesture:(UILongPressGestureRecognizer *)longGesture
{
    CGPoint location = [longGesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];

    static NSIndexPath *sourceIndexPath = nil;
    
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath) {
                sourceIndexPath = indexPath;
            
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                if (![cell isKindOfClass: [BTSaveSeqLineCell class]]) {
                    return;
                }
                self.editCellIndex = 10000;
                self.editView.hidden = true;
                self.hideLine = true;
                ((BTSaveSeqLineCell *)cell).lineColor = @"EE842D";
                self.canMove = true;
                snapshot = [self customSnapsshotFromView:cell];
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                cell.hidden = true;
                [UIView animateWithDuration:0.2 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.alpha = 1.0;
                    
                } completion:nil];
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.canMove) {
                
                if ([self cn_startai_checkIfSnapshotMeetsEdge]) {
                    [self cn_startai_startAutoScrollTimer];
                }else{
                    [self cn_startai_stopAutoScrollTimer];
                }
                CGPoint center = snapshot.center;
                center.y = location.y;
                snapshot.center = center;
                if (indexPath && ![indexPath isEqual:sourceIndexPath] && indexPath.row > 0) {
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
                    if (![cell isKindOfClass: [BTSaveSeqLineCell class]]) {
                        return;
                    }
                    // 移动cell
                    [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    sourceIndexPath = indexPath;

                }else{
                
                }
            }
        }
            break;
            
        default:
        {
            self.hideLine = false;
            if (self.canMove) {
                [self cn_startai_stopAutoScrollTimer];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
                cell.hidden = false;
                if ([cell isKindOfClass: [BTSaveSeqLineCell class]]) {
                    ((BTSaveSeqLineCell *)cell).lineColor = @"333333";
                }
                [UIView animateWithDuration:0.2 animations:^{
                    snapshot.center = cell.center;
                    snapshot.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                }];
                sourceIndexPath = nil;
                if (_autoScrollDirection == false && indexPath == nil){
                    self.lineIndex = self.dataArr.count+1;
                }else if (indexPath.row == 0) {
                    self.lineIndex = 2;
                }else{
                    self.lineIndex = indexPath.row+1;
                }
                if (self.lineIndex > 31) {
                    self.lineIndex = 31;
                }
                [[NSUserDefaults standardUserDefaults] setInteger:self.lineIndex forKey:@"lineIndex"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.canMove = false;
                [self.tableView reloadData];
            }
        }
            break;
    }
}

- (UIView *)customSnapsshotFromView:(UIView *)inputView
{
    UIView *snapShot;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<7.0f) {
        
        snapShot = [[UIView alloc]initWithFrame:inputView.frame];
        // 1.开始上下文
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, YES, 1);
        // 2.将view的图层渲染到上下文
        [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
        // 3.取出图片
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        // 4.结束上下文
        UIGraphicsEndImageContext();
        UIImageView *shot = [[UIImageView alloc]initWithImage:viewImage];
        [snapShot addSubview:shot];
    }
    else {
        //  snapshotViewAfterScreenUpdates 此方法只在7.0以上才能使用
        snapShot = [inputView snapshotViewAfterScreenUpdates:YES];
    }
    return snapShot;
}

/**
 *  检查截图是否到达边缘，并作出响应
 */
- (BOOL)cn_startai_checkIfSnapshotMeetsEdge
{
    CGFloat minY = CGRectGetMinY(snapshot.frame);
    CGFloat maxY = CGRectGetMaxY(snapshot.frame);
    if (minY < self.tableView.contentOffset.y) {
        _autoScrollDirection = true;
        return YES;
    }
    if (maxY > self.tableView.bounds.size.height + self.tableView.contentOffset.y) {
        _autoScrollDirection = false;
        return YES;
    }
    return NO;
}

/**
 *  创建定时器并运行
 */
- (void)cn_startai_startAutoScrollTimer
{
    if (!_autoScrollTimer) {
        _autoScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(cn_startai_startAutoScroll)];
        [_autoScrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}
/**
 *  停止定时器并销毁
 */
- (void)cn_startai_stopAutoScrollTimer
{
    if (_autoScrollTimer) {
        [_autoScrollTimer invalidate];
        _autoScrollTimer = nil;
    }
}

/**
 *  开始自动滚动
 */
- (void)cn_startai_startAutoScroll
{
    CGFloat pixelSpeed = 4;
    if (_autoScrollDirection == true) {//向下滚动
        if (self.tableView.contentOffset.y > 0) {//向下滚动最大范围限制
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - pixelSpeed)];
            snapshot.center = CGPointMake(snapshot.center.x, snapshot.center.y - pixelSpeed);
        }
    }else{                                               //向上滚动
        if (self.tableView.contentOffset.y + self.tableView.bounds.size.height < self.tableView.contentSize.height) {//向下滚动最大范围限制
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + pixelSpeed)];
            snapshot.center = CGPointMake(snapshot.center.x, snapshot.center.y + pixelSpeed);
        }
    }
    
}

#pragma mark 编辑闪法
- (void)cn_startai_goEdit
{
    self.tableView.layer.masksToBounds = true;
    self.editView.hidden = true;
    BTSeqListViewController *vc = [[BTSeqListViewController alloc] init];
    vc.seqTitle = self.seqTitle;
    [vc cn_startai_registerAppDelegate:appDelegate mode:0];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark 获取已存储闪法列表
- (void)cn_startai_getSaveList
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDitrctory = [paths objectAtIndex:0];
    NSString *box = [documentDitrctory stringByAppendingPathComponent:@"colorBox"];
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: box error:nil];
    NSFileManager *manger = [NSFileManager defaultManager];
    self.dataArr = [NSMutableArray array];
//    NSMutableArray *muArr = [NSMutableArray array];
    for (NSString *file in files) {
        BTSaveSeqListEntity *entity = [[BTSaveSeqListEntity alloc] init];
        NSString *path = [box stringByAppendingPathComponent:file];
        NSError *error ;
        //通过文件管理器来获得属性
        NSDictionary * attrs = [manger attributesOfItemAtPath:path error:&error];
        //获取字典中文件创建时间
        NSString * fileCreatTime = [NSString stringWithFormat:@"%@",attrs[NSFileModificationDate] ];
        entity.title = [file substringToIndex:file.length-6];
        entity.date = [fileCreatTime substringWithRange:NSMakeRange(0, 10)];
        entity.createData = [fileCreatTime substringWithRange:NSMakeRange(0,19)];
        NSString *str1 = [entity.createData stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@":" withString:@""];
        entity.createData = str3;

        [self.dataArr addObject:entity];
    }
    for (NSInteger i =0; i<self.dataArr.count-1; i++) {
        for (NSInteger j=0; j<self.dataArr.count-i-1; j++) {
            BTSaveSeqListEntity *t1 = self.dataArr[j];
            
            if (j>=self.dataArr.count) break;
            BTSaveSeqListEntity *t2 = self.dataArr[j+1];
            if ([t1.createData integerValue] < [t2.createData integerValue ]) {
                [self.dataArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }

    for (BTSaveSeqListEntity *entity in self.dataArr) {
        if ([entity.title isEqualToString:@"DOME"]) {
            BTSaveSeqListEntity *t = [[BTSaveSeqListEntity alloc] init];
            t.title = entity.title;
            t.serial = entity.serial;
            t.date = entity.date;
            t.createData = entity.createData;
            [self.dataArr removeObject:entity];
            [self.dataArr insertObject:t atIndex:0];
            break;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark 生成默认闪法列表
- (void)cn_startai_getDefaultSaveList
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDitrctory = [paths objectAtIndex:0];
    NSString *box = [documentDitrctory stringByAppendingPathComponent:@"colorBox"];
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: box error:nil];
    NSFileManager *manger = [NSFileManager defaultManager];
    self.dataArr = [NSMutableArray array];
    self.lineIndex = 18;
    [[NSUserDefaults standardUserDefaults] setInteger:18 forKey:@"lineIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSString *file in files) {
        BTSaveSeqListEntity *entity = [[BTSaveSeqListEntity alloc] init];
        NSString *path = [box stringByAppendingPathComponent:file];
        NSError *error ;
        //通过文件管理器来获得属性
        NSDictionary * attrs = [manger attributesOfItemAtPath:path error:&error];
        //获取字典中文件创建时间
        NSString * fileCreatTime = [NSString stringWithFormat:@"%@",attrs[NSFileModificationDate] ];
        entity.title = [file substringToIndex:file.length-6];
        entity.date = [fileCreatTime substringWithRange:NSMakeRange(0, 10)];
        entity.createData = [fileCreatTime substringWithRange:NSMakeRange(0,19)];
        if ([entity.title isEqualToString:@"DOME"]) {
            [muArr insertObject:entity atIndex:0];
            //            [self.dataArr insertObject:entity atIndex:0];
        }else{
            [muArr addObject:entity];
            //            [self.dataArr addObject:entity];
        }
    }
    
    NSArray *titleArr = @[@"DOME",@"GRADIENT",@"FADE1",@"FADE2",@"FADE3",@"FADE4",@"FADE5",@"FADE6",@"CHANGE1",@"CHANGE2",@"FLASH1",
                          @"FLASH2",@"FLASH3",@"FLASH4",@"FLASH5",@"FLASH6",@"FLASH7"];
    
    for (NSInteger i=0; i<titleArr.count; i++) {
        for (BTSaveSeqListEntity *entity in muArr) {
            if ([entity.title isEqualToString:titleArr[i]]) {
                [self.dataArr addObject:entity];
            }
        }
    }
    
    for (BTSaveSeqListEntity *enti in self.dataArr) {
        NSLog(@"--------%@=========",enti.title);
    }
    
    [self.tableView reloadData];
}

#pragma mark 开始同步闪法
- (void)cn_startai_sendSeq
{
    if (self.dataArr.count<self.lineIndex-1) {
        self.sendArr = [NSMutableArray arrayWithArray:self.dataArr];
    }else{
        self.sendArr = [NSMutableArray array];
        for (NSInteger i = 0; i<self.lineIndex-1; i++) {
            BTSaveSeqListEntity *entity = self.dataArr[i];
            [self.sendArr addObject:entity];
        }
    }
    if (!self.sendArr.count) {
        return;
    }
    
    self.sendIndex = 0;
    self.recordNum = 0;
    self.currentIndex = 0;
    self.stopSend = false;
    [self cn_startai_nextSeq];
}

#pragma mark 闪法发送及数据组成
- (void)cn_startai_sendSeqWithBTSaveSeqListEntity:(BTSaveSeqListEntity *)tEntity seq:(NSInteger)seq
{
    NSInteger len = tEntity.title.length;
    NSMutableString *name = [[NSMutableString alloc]initWithString:tEntity.title];

    //闪法名称
    NSMutableData *nameData = [NSMutableData dataWithData:[name dataUsingEncoding:NSUTF8StringEncoding] ];
    for (NSInteger i=0; i <8 - len; i++) {
        NSData *nul = [@" " dataUsingEncoding:NSUTF8StringEncoding];
        [nameData appendData:nul];
    }
    //闪法序号
    UInt8 serial = (UInt8)seq;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDitrctory = [paths objectAtIndex:0];
    NSString *box = [documentDitrctory stringByAppendingPathComponent:@"colorBox"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:[box stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",tEntity.title]]];
    
    //高4位为闪法重复次数。
    // 低4位为单元模式数量，最多暂定8个
    UInt8 repeatNum = (UInt8)(arr.count);
    
    
    NSMutableData *naData = [NSMutableData data];
    [naData appendData:nameData];
    [naData appendBytes:&serial length:sizeof(serial)];
    [naData appendBytes:&repeatNum length:sizeof(repeatNum)];
    for (NSInteger i = 0; i< arr.count; i++) {
        
        BTSeqListCellEntity *entity = arr[i];
        
        //单元模式高4位为单元模式序号
        // 低4位为单元模式
        UInt8 model = (UInt8)(((entity.serial-1) * 16) + entity.modelNum);
        NSArray *color = [UIColor toRGBcolorByHexColorString:entity.hexStr];
        NSArray *nextColor = [UIColor toRGBcolorByHexColorString:entity.nextHexStr];
        UInt8 red1 = (UInt8)([color[0] integerValue]);
        UInt8 green1 = (UInt8)([color[1] integerValue]);
        UInt8 blue1 = (UInt8)([color[2] integerValue]);
        
        UInt8 red2 =  (UInt8)([nextColor[0] integerValue]);
        UInt8 green2 =  (UInt8)([nextColor[1] integerValue]);
        UInt8 blue2 = (UInt8)([nextColor[2] integerValue]);
        
       
        UInt8 repeat = entity.repeat;
        UInt8 zero = 0x00;
        UInt8 speed = (UInt8)(entity.onms *90+10);
        UInt8 bright = (UInt8)(entity.brigthness * 90+10);
        UInt8 offtime = (UInt8)(entity.offms *90+10);
        
        [naData appendBytes:&model length:sizeof(model)];
        [naData appendBytes:&red1 length:sizeof(red1)];
        [naData appendBytes:&green1 length:sizeof(green1)];
        [naData appendBytes:&blue1 length:sizeof(blue1)];
        [naData appendBytes:&red2 length:sizeof(red2)];
        [naData appendBytes:&green2 length:sizeof(green2)];
        [naData appendBytes:&blue2 length:sizeof(blue2)];
        [naData appendBytes:&repeat length:sizeof(repeat)];
        [naData appendBytes:&speed length:sizeof(speed)];
        [naData appendBytes:&zero length:sizeof(zero)];
        [naData appendBytes:&bright length:sizeof(bright)];
        [naData appendBytes:&offtime length:sizeof(offtime)];
        [naData appendBytes:&zero length:sizeof(zero)];


    }
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    if (key != -1 && key != 0) {
        [appDelegate.globalManager sendCustomCommand:key param1:0x12 param2:(UInt32)naData.length others:naData];
    }
    
    [self performSelector:@selector(cn_startai_queFlash) withObject:nil afterDelay:0.5];
    
}

- (void)cn_startai_queFlash
{
    int key1 = [appDelegate.globalManager buildKey:QUE cmdID:0x97];
    if (key1 != -1 && key1 !=0) {
        [appDelegate.globalManager sendCustomCommand:key1 param1:0 param2:0 others:nil];
    }
}

- (void)cn_startai_nextSeq
{
    self.currentIndex = self.sendIndex;
    if (self.sendIndex<self.sendArr.count) {
        BTSaveSeqListEntity *tEntity = self.sendArr[self.sendIndex];
        [self cn_startai_sendSeqWithBTSaveSeqListEntity:tEntity seq:self.sendIndex];
    }
    [self.sendView sendSucessNum:self.sendIndex Total:self.sendArr.count];
    if (self.sendIndex == self.sendArr.count) {
        self.maskView.hidden = false;
        self.resultView.hidden = false;
        self.resultView.title = @"SYNC   SUCCEED!";
        [self cn_startai_writeSendSeqListWithIndex:self.sendIndex];
    }
}

- (void)cn_startai_writeSendSeqListWithIndex:(NSInteger)index
{
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSInteger i=0; i<index; i++) {
        [muArr addObject:self.sendArr[i]];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDitrctory = [paths objectAtIndex:0];
    NSString *box = [documentDitrctory stringByAppendingPathComponent:@"sendBox"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:box]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:box withIntermediateDirectories:true attributes:nil error:nil];
    }
    NSString *path = [box stringByAppendingPathComponent:@"sendSeq.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    BOOL sucess = [NSKeyedArchiver archiveRootObject:muArr toFile:path];
    NSLog(@"-----------发送闪法结果写入文件是否成功--------%d-----------",sucess);
}

#pragma mark 收到自定义命令回调，处理返回信息
- (void)customCommandArrived:(UInt32)cmdKey param1:(UInt32)arg1 param2:(UInt32)arg2 others:(NSData *)data
{
    //arg1 是否可以发送闪法 arg2 mcu已存储到闪法序号
    self.sendIndex = arg2+1;
    if (self.sendIndex == self.currentIndex) {
        self.recordNum ++;
        sleep(0.5);
    }else{
        self.recordNum = 0;
    }
    if (self.stopSend) {
        self.stopSend = false;
        [self cn_startai_writeSendSeqListWithIndex:arg2+1];
    }else{
        if (self.recordNum<5){
            [self cn_startai_nextSeq];
        }else{
            [self.sendView sendSucessNum:arg2+1 Total:arg2+1];
            [self cn_startai_writeSendSeqListWithIndex:arg2+1];
            self.maskView.hidden = false;
            self.resultView.hidden = false;
            self.resultView.title = @"Sync  failed！Please retry!";
        }
    }
    NSLog(@"-----是否可以重复发送闪法-------%d---+++++++++++++++++++++%d",arg1,arg2);
}

#pragma mark 准备就绪
- (void)managerReady
{
    
}

#pragma mark 音箱功能模式变化
-(void)modeChanged:(UInt32)mode
{
    appDelegate.model = mode;
}

#pragma mark 音箱音效模式变化
-(void)soundEffectChanged:(UInt32)mode
{
    
}

#pragma mark  EQ模式变化
-(void)eqModeChanged:(UInt32)mode
{
    
}

#pragma mark 音箱电池电量或充放电状态变化
-(void)batteryChanged:(UInt32)battery charging:(BOOL)charging
{
    
}

#pragma mark 音箱静音及音量状态变化
-(void)volumeChanged:(UInt32)current max:(UInt32)max min:(UInt32)min isMute:(BOOL)mute
{
    appDelegate.currentVoice = current;
    appDelegate.maxVoice = max;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"speakerVolumeChange" object:nil];
}

#pragma mark 音箱外置卡插拔状态变化
-(void)hotplugCardChanged:(BOOL)visibility
{
    
}


#pragma mark 音箱外置U盘插拔状态变化
-(void)hotplugUhostChanged:(BOOL)visibility
{
    appDelegate.canUseUSB = visibility;
}

#pragma mark USB线插拔状态变化
-(void)hotplugUSBChanged:(BOOL)visibility
{
    
}

#pragma mark 音箱Linein连接线插拔状态变化
-(void)lineinChanged:(BOOL)visibility
{
    
}

#pragma mark 显示音箱对话框
-(void)dialogMessageArrived:(UInt32)type messageID:(UInt32)messageId
{
    
}

#pragma mark 显示音箱提示信息
-(void)toastMessageArrived:(UInt32)messageId
{
    
}

#pragma mark 取消音箱提示信息
-(void)dialogCancel
{
    
}

#pragma mark DAE音效模式变化
-(void)daeModeChangedWithVBASS:(BOOL)vbassEnable andTreble:(BOOL)trebleEnable
{
    
}

#pragma mark DAE音效模式变化
-(void)daeModeChangedWithVBASS:(BOOL)vbassEnable treble:(BOOL)trebleEnable surround:(BOOL)surroundEnable
{
    
}

#pragma mark DAE音效模式变化
-(void)daeModeChanged:(int)daeOpts
{
    
}

#pragma mark super

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 写入系统默认闪法
- (void)writeSeqColor
{
    
    NSArray *titleArr = @[@"DOME",@"GRADIENT",@"FADE1",@"FADE2",@"FADE3",@"FADE4",@"FADE5",@"FADE6",@"CHANGE1",@"CHANGE2",@"FLASH1",
                          @"FLASH2",@"FLASH3",@"FLASH4",@"FLASH5",@"FLASH6",@"FLASH7"];
    //快闪on时间
    CGFloat quickOn = 0.08;
    CGFloat quickOff = 0.40;
    
    for (NSInteger i=0; i<titleArr.count; i++) {
        NSMutableArray *muArr = [NSMutableArray array];
        if (i==0) {
            //白灯常量
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"ffffff" name:titleArr[i] model:5 on:1.0 off:1.0];
            tEntity.nextHexStr = @"ffffff";
            [muArr addObject:tEntity];
        }else if (i==1){
            //红绿蓝三色渐变
            NSArray *colorArr = @[@"ff0000",@"0000ff",@"00ff00"];
            for (NSInteger j=0; j<colorArr.count; j++) {
                BTSeqListCellEntity *tEntity = [self getTentity:j+1 hexColor:colorArr[j] name:titleArr[i] model:3 on:1.0 off:1.0];
                tEntity.isGradientModel = true;
                tEntity.nextHexStr = colorArr[(j+colorArr.count+1)%colorArr.count];
                [muArr addObject:tEntity];
            }
        }else if (i==2){
            //蓝渐变
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"0000ff" name:titleArr[i] model:4 on:1.0 off:1.0];
            [muArr addObject:tEntity];
        }else if (i==3){
            //紫渐变
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"ff00ff" name:titleArr[i] model:4 on:1.0 off:1.0];
            [muArr addObject:tEntity];
        }else if (i==4){
            //红渐变
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"ff0000" name:titleArr[i] model:4 on:1.0 off:1.0];
            [muArr addObject:tEntity];
        }else if (i==5){
            //黄渐变
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"ffff00" name:titleArr[i] model:4 on:1.0 off:1.0];
            [muArr addObject:tEntity];
        }else if (i==6){
            //绿渐变
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"00ff00" name:titleArr[i] model:4 on:1.0 off:1.0];
            [muArr addObject:tEntity];
        }else if (i==7){
            //白渐变
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"ffffff" name:titleArr[i] model:4 on:1.0 off:1.0];
            [muArr addObject:tEntity];
        }else if (i==8){
            //红绿蓝顺序亮
            NSArray *colorArr = @[@"ff0000",@"00ff00",@"0000ff"];
            for (NSInteger j=0; j<colorArr.count; j++) {
                BTSeqListCellEntity *tEntity = [self getTentity:j+1 hexColor:colorArr[j] name:titleArr[i] model:5 on:1.0 off:0];
                [muArr addObject:tEntity];
            }
        }else if (i==9){
            //黄红紫蓝青白绿顺序亮
            NSArray *colorArr = @[@"ffff00",@"ff0000",@"ff00ff",@"0000ff",@"00ffff",@"ffffff",@"00ff00"];
            for (NSInteger j=0; j<colorArr.count; j++) {
                BTSeqListCellEntity *tEntity = [self getTentity:j+1 hexColor:colorArr[j] name:titleArr[i] model:5 on:1.0 off:0];
                [muArr addObject:tEntity];
            }
        }else if (i==10){
            //红绿蓝快闪
            NSArray *colorArr = @[@"ff0000",@"00ff00",@"0000ff"];
            for (NSInteger j=0; j<colorArr.count; j++) {
                BTSeqListCellEntity *tEntity = [self getTentity:j+1 hexColor:colorArr[j] name:titleArr[i] model:5 on:quickOn off:quickOff];
                [muArr addObject:tEntity];
            }
        }else if (i==11){
            //蓝快闪
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"0000ff" name:titleArr[i] model:5 on:quickOn off:quickOff];
            [muArr addObject:tEntity];
        }else if (i==12){
            //紫快闪
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"ff00ff" name:titleArr[i] model:5 on:quickOn off:quickOff];
            [muArr addObject:tEntity];
        }else if (i==13){
            //红快闪
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"ff0000" name:titleArr[i] model:5 on:quickOn off:quickOff];
            [muArr addObject:tEntity];
        }else if (i==14){
            //绿快闪
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"00ff00" name:titleArr[i] model:5 on:quickOn off:quickOff];
            [muArr addObject:tEntity];
        }else if (i==15){
            //白快闪
            BTSeqListCellEntity *tEntity = [self getTentity:1 hexColor:@"ffffff" name:titleArr[i] model:5 on:quickOn off:quickOff];
            [muArr addObject:tEntity];
          
        }else if (i==16){
            //红绿蓝快闪
            NSArray *colorArr = @[@"ff0000",@"00ff00",@"0000ff"];
            for (NSInteger j=0; j<colorArr.count; j++) {
                BTSeqListCellEntity *tEntity = [self getTentity:j+1 hexColor:colorArr[j] name:titleArr[i] model:5 on:quickOn off:quickOff];
                [muArr addObject:tEntity];
            }
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDitrctory = [paths objectAtIndex:0];
        NSString *box = [documentDitrctory stringByAppendingPathComponent:@"colorBox"];
        BOOL have = [[NSFileManager defaultManager] fileExistsAtPath:box];
        if (!have) {
            [[NSFileManager defaultManager] createDirectoryAtPath:box withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@.plist",titleArr[i]];
        NSString *path = [box stringByAppendingPathComponent:str];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
        BOOL result = [NSKeyedArchiver archiveRootObject:muArr toFile:path];
        NSLog(@"----------写入默认闪法--------_%d--------------%@",result,titleArr[i]);
    }

    [[NSUserDefaults standardUserDefaults] setObject:@"firstBlod" forKey:@"firstBlod"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BTSeqListCellEntity *)getTentity:(NSInteger)serial hexColor:(NSString *)hexColor name:(NSString *)name model:(NSInteger)model on:(CGFloat)on off:(CGFloat)off

{
    BTSeqListCellEntity *tEntity = [[BTSeqListCellEntity alloc] init];
    tEntity.serial = serial;
    tEntity.onms = on;
    tEntity.offms = off;
    tEntity.repeat = 1;
    tEntity.brigthness = 1.0;
    tEntity.hexStr = hexColor;
    tEntity.modelNum = model;
    tEntity.tableName = name;
    tEntity.isGradientModel = false;
    tEntity.nextHexStr = @"000000";
    tEntity.isModelChanged = false;
    
    return tEntity;
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

@end
