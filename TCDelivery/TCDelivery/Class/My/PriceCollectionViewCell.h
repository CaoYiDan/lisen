//
//  PriceCollectionViewCell.h
//  TianMing
//
//  Created by 李智帅 on 17/2/8.
//  Copyright © 2017年 李智帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceCollectionViewCell;
//代理---其实就是根据cell的整体选择状态改变全选按钮的选择状态
@protocol PriceViewCollectionViewDelegate <NSObject>
@optional
- (void)collectionCellClick;
@end

@interface PriceCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIButton * selectBtn;
@property(nonatomic,strong)UILabel * carLab;
//代理
@property (nonatomic, weak) id <PriceViewCollectionViewDelegate> delegate;


- (void)refreshInsuranceStr:(NSString *)str;
//-(void)refreshWithText:(NSString*)text andIndexPath:(NSIndexPath*)indexPath;
//
@property(nonatomic,copy)NSString * carId;
@end
