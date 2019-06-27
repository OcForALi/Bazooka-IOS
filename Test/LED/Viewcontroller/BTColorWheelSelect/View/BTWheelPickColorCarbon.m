//
//  BTWheelPickColorCarbon.m
//  Test
//
//  Created by Mac on 2019/3/18.
//  Copyright © 2019 QiXing. All rights reserved.
//

#import "BTWheelPickColorCarbon.h"
#import "UIView+ColorSelect.h"

@interface BTWheelPickColorCarbon ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BTWheelPickColorCarbon

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@(0));
//        make.width.height.equalTo(@(300));
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initContentView];
    }
    return self;
}

- (void)initContentView
{
    [self addSubview:self.collectionView];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 30;
        layout.minimumInteritemSpacing = 30;
        layout.itemSize = CGSizeMake(SCREEN_WITDH * 0.187, SCREEN_WITDH * 0.187);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BTWheelPickColorCarbon"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTWheelPickColorCarbon" forIndexPath:indexPath];
    
    UIImageView *imgView = [cell viewWithTag:100+indexPath.row];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        imgView.tag = 100+indexPath.row;
        imgView.userInteractionEnabled = true;
        [cell addSubview:imgView];
    }
    
    NSString *name = [NSString stringWithFormat:@"color%ld",indexPath.row+1];
    imgView.image = [UIImage imageNamed:name];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapClick:)];
    [imgView addGestureRecognizer:tap];
    
    UIImageView *frameImageView = [cell viewWithTag:1000 + indexPath.row];
    if (!frameImageView) {
        
        frameImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        frameImageView.tag = 1000+indexPath.row;
        frameImageView.image = [UIImage imageNamed:@"FrameColor"];
        frameImageView.hidden = YES;
        [cell addSubview:frameImageView];
        
    }
    
    return cell;
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    
    for (int i = 0 ; i < 9; i++) {

        UIImageView *imageView = [self viewWithTag:i + 1000];
        
        if (tap.view.tag - 100 == i) {
            imageView.hidden = NO;
        }else{
            imageView.hidden = YES;
        }
        
    }
    
    NSArray *colorArray = @[@[@"255",@"255",@"0",@"255"],
                            @[@"255",@"0",@"255",@"255"],
                            @[@"0",@"255",@"255",@"255"],
                            @[@"255",@"40",@"40",@"255"],
                            @[@"255",@"100",@"50",@"255"],
                            @[@"65",@"150",@"255",@"255"],
                            @[@"65",@"255",@"70",@"255"],
                            @[@"255",@"235",@"53",@"255"],
                            @[@"0",@"255",@"100",@"255"]];
    
//    CGPoint point = [tap locationInView:tap.view];
//    NSArray *colorArr = [tap.view colorAtPixel:point];
    NSArray *colorArr = colorArray[tap.view.tag - 100];
    if (self.getColorHanlder) {
        self.getColorHanlder(colorArr);
    }
}

- (void)setReset{
    
    for (int i = 0 ; i < 9; i++) {
        
        UIImageView *imageView = [self viewWithTag:i + 1000];

            imageView.hidden = YES;
        }
    
}

@end
