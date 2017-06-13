//
//  PriceCollectionViewCell.m
//  TianMing
//
//  Created by 李智帅 on 17/2/8.
//  Copyright © 2017年 李智帅. All rights reserved.
//

#import "PriceCollectionViewCell.h"

@implementation PriceCollectionViewCell
//
//{
//    NSIndexPath*_indexPath;
//}
//- (void)refreshModel:(PriceModel *)model{
//
//    self.carLab.text = @"津D-23123";
//    
//    [self.selectBtn setTitle:@"津D-23123" forState:UIControlStateNormal];
//    self.selectBtn.titleLabel.font = Font(13);
//    [self.selectBtn setImage:[UIImage imageNamed:@"cyf_bjxq_an2-1"] forState:UIControlStateNormal];
//    [self.selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [self.selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
//}
//
- (void)selectBtnClick{

    self.selectBtn.selected = !self.selectBtn.selected;
    if ([_delegate respondsToSelector:@selector(collectionCellClick)]) {
        [_delegate collectionCellClick];
    }

}


- (void)refreshInsuranceStr:(NSString *)str{

    [self.selectBtn setTitle:str forState:UIControlStateNormal];
    NSLog(@"%@",self.selectBtn.titleLabel.text);
    self.selectBtn.titleLabel.font = Font(13);
    [self.selectBtn setImage:[UIImage imageNamed:@"cyf_bjxq_an2-1"] forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}


//- (UILabel *)carLab{
//
//    if (!_carLab) {
//        _carLab = [FactoryUI createLabelWithFrame:CGRectMake(0, 0, self.frame.size.width,20) text:@"" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13]];
//        _carLab.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:_carLab];
//    }
//    return _carLab;
//}

- (UIButton *)selectBtn{

    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(0,2,self.frame.size.width, 20);
        [_selectBtn setImage:[UIImage imageNamed:@"cyf_bjxq_an2"] forState:UIControlStateSelected];
        [_selectBtn setImage:[UIImage imageNamed:@"cyf_bjxq_an2-1"] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setTitleColor:[UIColor blackColor] forState:0];
        [self addSubview:_selectBtn];
    }
    return _selectBtn;
}
//-(void)refreshWithText:(NSString *)text andIndexPath:(NSIndexPath *)indexPath{
//    [self.selectBtn setTitle:text forState:UIControlStateNormal];
////    _indexPath=indexPath;
//}

@end
