//
//  FinancialTableViewCell.h
//  TianMing
//
//  Created by 李智帅 on 2017/5/22.
//  Copyright © 2017年 李智帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinancialTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView * onlyIV;
- (void)creatUI:(NSString *)image;
@end
