//
//  FinancialTableViewCell.m
//  TianMing
//
//  Created by 李智帅 on 2017/5/22.
//  Copyright © 2017年 李智帅. All rights reserved.
//

#import "FinancialTableViewCell.h"

@implementation FinancialTableViewCell

- (UIImageView *)onlyIV{

    if (!_onlyIV) {
        _onlyIV = [[UIImageView alloc]init];
        _onlyIV.frame = CGRectMake(0, 0, SCREEN_W, 160);
        [self addSubview:_onlyIV];
    }
    return _onlyIV;
}

- (void)creatUI:(NSString *)image{

    self.onlyIV.image = [UIImage imageNamed:image];
}
#define SINGLE_LINE_HEIGHT  (1/[UIScreen mainScreen].scale)  // 线的高度
#define  COLOR_LINE_GRAY [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1]  //分割线颜色 #e0e0e0
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //下分割线
    CGContextSetStrokeColorWithColor(context, COLOR_LINE_GRAY.CGColor); //  COLOR_LINE_GRAY 为线的颜色
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, SINGLE_LINE_HEIGHT)); //SINGLE_LINE_HEIGHT 为线的高度
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
