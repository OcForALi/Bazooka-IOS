//
//  ColorCollectionCell.h
//  BluetoothBox
//
//  Created by Mac on 2017/9/21.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorCollectionCell : UICollectionViewCell

@property (nonatomic, copy) NSString *hexColor;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy) void(^updateColorHandler)(NSArray *arr);
@property (nonatomic, copy) void(^deleteColorHandler)(NSInteger row);
@property (nonatomic, copy) void(^addColorHandler)();
@property (nonatomic, assign) BOOL isAddColor;
@end
