//
//  BTPickColorViewController.m
//  BTMate
//
//  Created by Mac on 2017/8/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTPickColorViewController.h"
#import "BTPreview.h"
#import "UIImage+ColorSelect.h"
#import "ColorCollectionCell.h"
#import "BaseNavView.h"
#import "BTPickColorView.h"

@interface BTPickColorViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) BaseNavView *nav;
@property (nonatomic, strong) UILabel *pickLabel;
@property (nonatomic, copy) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *prelabel;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) BTPreview *preView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, strong) BTPickColorView *pickView;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation BTPickColorViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSKeyedArchiver archiveRootObject:self.dataArr toFile:self.filePath];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self cn_startai_initContentView];
    self.dataArr = [NSMutableArray array];
//    self.dataArr = [NSMutableArray arrayWithArray:@[@"ff0000",@"00ff00",@"0000ff",@"fff000",@"ff00ff",@"00ffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff",@"ffffff"]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDitrctory = [paths objectAtIndex:0];
    NSString *box = [documentDitrctory stringByAppendingPathComponent:@"pickColor"];
    BOOL have = [[NSFileManager defaultManager] fileExistsAtPath:box];
    if (!have) {
        [[NSFileManager defaultManager] createDirectoryAtPath:box withIntermediateDirectories:YES attributes:nil error:nil];
    }
    self.filePath= [box stringByAppendingPathComponent:@"pickColor.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:self.filePath contents:nil attributes:nil];
            self.dataArr = [NSMutableArray arrayWithArray:@[@"ffffff",@"00ff00",@"0000ff",@"ff0000",@"00ffff",@"ff00ff",@"ffff00",@"00ff80",@"0080ff",@"ff8000"]];
    }else{
        self.dataArr = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cn_startai_hideMask:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];

}

- (void)cn_startai_hideMask:(UITapGestureRecognizer *)tap
{
    self.pickView.hidden = true;
}

#pragma mark - UI

- (void)cn_startai_initContentView
{
    [self.view addSubview:self.nav];
    [self.view addSubview:self.pickLabel];
    [self.view addSubview:self.collectionView];
//    [self.collectionView addSubview:self.deleteBtn];
//    [self.view addSubview:self.confirmBtn];
    [self.view addSubview:self.preView];
    [self.view addSubview:self.prelabel];
    [self.view addSubview:self.pickView];
//    [self.collectionView addGestureRecognizer:self.longPress];
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
//        [_deleteBtn setBackgroundColor:[UIColor redColor]];
        [_deleteBtn addTarget:self action:@selector(cn_startai_deleteColor) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.hidden = true;
    }
    return _deleteBtn;
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

- (UILabel *)pickLabel
{
    if (!_pickLabel) {
        _pickLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, IPHONEFringe + 50, 150, 20)];
        _pickLabel.text =@"Pick the color";
        _pickLabel.font = [UIFont fontWithName:@"Arial" size:18];
        _pickLabel.textColor = [UIColor blackColor];
    }
    return _pickLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(58, NavBarHeight+60, SCREEN_WITDH-58*2, (SCREEN_WITDH-58*2)*1.25) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[ColorCollectionCell class] forCellWithReuseIdentifier:@"identifier"];
        
    }
    return _collectionView;
}

- (UILabel *)prelabel
{
    if (!_prelabel) {
        _prelabel = [[UILabel alloc] initWithFrame:CGRectMake(58, self.preView.top-30, 200, 20)];
        _prelabel.text = @"Preview";
        _prelabel.textColor = [UIColor blackColor];
        _prelabel.font = [UIFont fontWithName:@"Arial" size:18];
    }
    return _prelabel;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(58, SCREEN_HEIGHT - IPHONEBottom - 41/184.5*(SCREEN_WITDH-58-62)-20, SCREEN_WITDH-58-62 , 41/184.5*(SCREEN_WITDH-58-62));
        _confirmBtn.layer.cornerRadius = 10;
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"confirm"] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(cn_startai_confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (BTPreview *)preView
{
    if (!_preView) {
        _preView = [[BTPreview alloc] initWithFrame:CGRectMake(58, SCREEN_HEIGHT - IPHONEBottom -40 -65, SCREEN_WITDH-116, 65)];
    }
    return _preView;
}

- (BTPickColorView *)pickView
{
    @weakify(self);
    CGFloat height = (SCREEN_WITDH-100)*(93/494.0) + SCREEN_WITDH-100 + 57 +150;
//    CGFloat height = IS_IPHONE_5_OR_LESS ? 450 : SCREEN_WITDH;
    if (!_pickView) {
        _pickView = [[BTPickColorView alloc] initWithFrame:CGRectMake(10, IPHONEFringe+20, SCREEN_WITDH - 20, height)];
        _pickView.layer.cornerRadius = 10;
        _pickView.layer.masksToBounds = true;
        _pickView.hidden = true;
        _pickView.getColorValueHandler = ^(BTWheelRGBEntity *rgb) {
            [weak_self.preView setColorWithRed:rgb.red green:rgb.green blue:rgb.blue];
        };
        _pickView.addColorHandler = ^(BTWheelRGBEntity *rgb) {
            weak_self.pickView.hidden = true;
            NSString *hex = [UIColor toHexColorByColorArr:@[@(rgb.red),@(rgb.green),@(rgb.blue)]];
            [weak_self.dataArr addObject:hex];
            [weak_self.collectionView reloadData];
            [NSKeyedArchiver archiveRootObject:weak_self.dataArr toFile:weak_self.filePath];
            weak_self.color = hex;
            [weak_self cn_startai_confirm];
        };
    }
    return _pickView;
}


#pragma mark CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count+1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    @weakify(self);
    ColorCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    cell.row = indexPath.row;
    cell.updateColorHandler = ^(NSArray *arr) {
        [weak_self.preView setColorWithRed:[arr[0] integerValue] green:[arr[1] integerValue] blue:[arr[2] integerValue]];
        if (indexPath.row < self.dataArr.count) {
            weak_self.color = self.dataArr[indexPath.row];
            [weak_self cn_startai_confirm];
        }
    };
    @weakify(cell);

    cell.deleteColorHandler = ^(NSInteger row) {
        [weak_cell addSubview:self.deleteBtn];
        weak_self.deleteBtn.tag = 100+row;
        weak_self.deleteBtn.hidden = false;
        weak_self.deleteBtn.frame = CGRectMake((SCREEN_WITDH-58*2)/4.0-30, 0, 30, 30);
//        [weak_self.dataArr removeObjectAtIndex:row];
//        [weak_self.collectionView reloadData];
//        [NSKeyedArchiver archiveRootObject:weak_self.dataArr toFile:weak_self.filePath];
    };
    
    cell.addColorHandler = ^{
        if (self.dataArr.count<19) {
            weak_self.pickView.hidden = false;
        }
    };
    
    if (indexPath.row < self.dataArr.count) {
        cell.hexColor = self.dataArr[indexPath.row];
        cell.isAddColor = false;
    }else{
        cell.isAddColor = true;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((NSInteger)(SCREEN_WITDH-58*2)/4.0, (NSInteger)(SCREEN_WITDH-58*2)/4.0);
}


#pragma mark - event

- (void)cn_startai_deleteColor
{
    if (self.deleteBtn.tag-100<self.dataArr.count) {
        [self.dataArr removeObjectAtIndex:self.deleteBtn.tag-100];
        [self.collectionView reloadData];
        [NSKeyedArchiver archiveRootObject:self.dataArr toFile:self.filePath];
        [self.deleteBtn removeFromSuperview];
        self.deleteBtn.tag = 1000;
        self.deleteBtn.hidden = true;
    }
}

- (void)cn_startai_confirm
{
    if (self.BTPickColorReturn) {
        self.BTPickColorReturn(self.color, self.row);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - super

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.deleteBtn removeFromSuperview];
    self.deleteBtn.hidden = true;
    self.deleteBtn.tag = 1000;
}

- (void)setColorHex:(NSString *)colorHex
{
    self.color = colorHex;
    NSArray *arr = [UIColor toRGBcolorByHexColorString:colorHex];
    [self.preView setColorWithRed:[arr[0] integerValue] green:[arr[1] integerValue] blue:[arr[2] integerValue]];
}

@end
