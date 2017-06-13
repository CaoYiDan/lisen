//
//  LGManageCell.h
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/30.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//
typedef  void(^block)(NSInteger indexPath);
#import <UIKit/UIKit.h>
#import "LGAddressInfo.h"
@interface LGManageCell : UITableViewCell
@property (weak, nonatomic) UIButton *yesMark;
@property (weak, nonatomic)  UILabel *Phone;
@property (weak, nonatomic)  UILabel *address;
@property (weak, nonatomic)  UILabel *Name;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic,strong)LGAddressInfo*addressInfo;
@property(nonatomic,copy)block clickblock;
@property(nonatomic,strong)UIButton*defaultBtn;
+ (instancetype)tableViewCellWithTableView:(UITableView *)tableView with:(NSIndexPath*)index;
- (void)setAddressInfo:(LGAddressInfo *)addressInfo with:(NSIndexPath*)index;
@end
