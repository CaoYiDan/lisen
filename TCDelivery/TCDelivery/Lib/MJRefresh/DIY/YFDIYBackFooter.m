//
//  YFDIYBackFooter.m
//  PyfTestWeather
//
//  Created by peiyf on 15/8/3.
//  Copyright (c) 2015年 peiyf. All rights reserved.
//

#define kBackgroundColor [UIColor whiteColor]//背景色

#import "YFDIYBackFooter.h"


@interface YFDIYBackFooter()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIView *bgView;

@end

@implementation YFDIYBackFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    self.backgroundColor  = kBackgroundColor;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = kCOLOR_HEX(0x999999) ;
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    self.label = label;
    
    
    // logo图片组
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=15; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%lu", i]];
        [refreshingImages addObject:image];
    }
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_1"]];
    [logo setAnimationImages:refreshingImages];
    [logo setAnimationDuration:0.5];
    [self addSubview:logo];
    self.logo = logo;
    
    
    //
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = kBackgroundColor;
    [self addSubview:bgView];
    self.bgView = bgView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = self.bounds;
//    self.label.originX = self.mj_w*0.5 + 5;
    
    self.logo.frame = CGRectMake(0,(self.mj_h - 30)* 0.5,54 ,30);
//    self.logo.right = self.mj_w*0.5 - 5;
    
    
    self.bgView.frame = CGRectMake(0, self.mj_h , self.mj_w, 200);
    
    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"上拉加载更多...";
            [self.logo stopAnimating];
            break;
        case MJRefreshStatePulling:
            self.label.text = @"松开加载...";
            [self.logo stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在载入...";
            [self.logo startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            [self.logo stopAnimating];
            self.label.text = @"没有数据了";
        default:
            break;
    }
}

//#pragma mark 监听拖拽比例（控件被拖出来的比例）
//- (void)setPullingPercent:(CGFloat)pullingPercent
//{
//    [super setPullingPercent:pullingPercent];
//
//    // 1.0 0.5 0.0
//    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//}

@end
