//
//  LGLoginViewController.h
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/16.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGLoginViewController : UIViewController<UITextFieldDelegate>
{
    BOOL ischangelogin;
}

//- (instancetype) initWithRootControllerClass:(NSString *)clazz;
// 购物车中的商品信息
@property (nonatomic, strong) NSMutableArray *DataArray;

@property(nonatomic,copy)NSString*formWhere;//判断是否从首页进。

@property (nonatomic,strong)NSString *rootClass;

@property(nonatomic,assign)BOOL isPushView;

@end
