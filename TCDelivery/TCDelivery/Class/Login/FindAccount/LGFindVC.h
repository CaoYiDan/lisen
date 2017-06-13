//
//  LGFindVC.h
//  LetsGo
//
//  Created by XJS_oxpc on 16/8/15.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGLoginBaseVC.h"

@interface LGFindVC : LGLoginBaseVC
//bool
@property(nonatomic,assign)BOOL isChangePhone;

/*
 <##>绑定手机号的手机号码
 */
@property(nonatomic,copy)NSString*telPhone;
/*绑定手机传过来的手机号码*/
@property(nonatomic,copy)NSString*tel;

/*
 <##>imageUrl
 */
@property(nonatomic,copy)NSString*imageUrl;
/*
 <##>name
 */
@property(nonatomic,copy)NSString*userName;
/*
 <##>uid
 */
@property(nonatomic,copy)NSString*uid;

@end
