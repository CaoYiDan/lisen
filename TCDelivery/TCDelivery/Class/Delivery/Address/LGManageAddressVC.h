//
//  LGManageAddressVC.h
//  LetsGo
//
//  Created by XJS_oxpc on 16/8/16.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGBaseTableVC.h"

#import <UIKit/UIKit.h>
#import "LGAddressInfo.h"

@protocol SelectAddressDelegate <NSObject>
@optional
- (void)selectAddress:(LGAddressInfo *)addressInfo;
@end

@interface LGManageAddressVC :UITableViewController

@property (nonatomic, weak) id<SelectAddressDelegate> delegate;
// 记录被选中的收货地址
@property (nonatomic, assign) NSInteger selectedRow;
/*
 <##>是否在个人中心界面进入的，如果是，则cell被点击时，不会pop
 */
@property(nonatomic,copy)NSString*MYControl;
@end
