//
//  TCAddLinkmanVC.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/5/3.
//
//

typedef NS_ENUM(NSInteger, XCFAddressEditingContent) {
    XCFAddressEditingContentName,
    XCFAddressEditingContentPhone,
    XCFAddressEditingContentProvince,
    XCFAddressEditingContentDetailAddress
};

#import <UIKit/UIKit.h>
@class TCLinkModel;
@interface TCAddLinkmanVC : UIViewController
@property (nonatomic, assign) NSInteger infoIndex; // 收货地址数据的下标
@property (nonatomic, strong) TCLinkModel *model;
/**0:发货人 1:收货人*/
@property(nonatomic,assign)LinkType  linkType;

//编辑的模型

@property(nonatomic,assign)BOOL isAdd;
@property (nonatomic, copy) void (^editingBlock)(XCFAddressEditingContent, NSString *);
@property (nonatomic, copy) void (^editingLocationBlock)(NSString *);
@property (nonatomic, copy) void (^deleteBlock)();
@end
