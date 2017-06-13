//
//  LGEditorAddresViewController.h
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/31.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//
typedef NS_ENUM(NSInteger, XCFAddressEditingContent) {
    XCFAddressEditingContentName,
    XCFAddressEditingContentPhone,
    XCFAddressEditingContentProvince,
    XCFAddressEditingContentDetailAddress
};

#import <UIKit/UIKit.h>
#import "LGAddressInfo.h"
@interface LGEditorAddresViewController : UIViewController
@property (nonatomic, assign) NSInteger infoIndex; // 收货地址数据的下标
@property (nonatomic, strong) LGAddressInfo *addressInfo;
//编辑的模型
@property (nonatomic, strong) LGAddressInfo *editaddressInfo;
@property(nonatomic,assign)BOOL isAdd;
@property (nonatomic, copy) void (^editingBlock)(XCFAddressEditingContent, NSString *);
@property (nonatomic, copy) void (^editingLocationBlock)(NSString *);
@property (nonatomic, copy) void (^deleteBlock)();
@end
