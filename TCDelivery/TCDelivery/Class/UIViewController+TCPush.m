//
//  UIViewController+TCPush.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/4/12.
//
//

#import "UIViewController+TCPush.h"

@implementation UIViewController (TCPush)
-(void)pushViewCotnroller:(NSString *)viewConrollerString{
    UITabBarController* tabbar = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController*controller=[[NSClassFromString(viewConrollerString) alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self getAllPropertilesWithViewCotroller:controller];
    [(UINavigationController*)[tabbar selectedViewController]  pushViewController:controller animated:YES];
}

-(NSMutableArray*)getAllPropertilesWithViewCotroller:(UIViewController*)viewController{
    u_int count;
    objc_property_t*properties=class_copyPropertyList([viewController class], &count);
    NSMutableArray*propertiesArray=[NSMutableArray arrayWithCapacity:count];
    for (int i=0; i<count; i++) {
        const char *properName=property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String:properName]];
    }
    free(properties);
    NSLog(@"%@",propertiesArray);
    return propertiesArray;
}
@end
