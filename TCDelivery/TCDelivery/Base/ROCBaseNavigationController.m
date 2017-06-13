//
//  ROCBaseNavigationController.m
//  Ticketing
//
//  Created by 融合互联-------lisen on 16/11/1.
//  Copyright © 2016年 RHHL. All rights reserved.
//

#import "ROCBaseNavigationController.h"

@implementation ROCBaseNavigationController
-(void)viewDidLoad{
    [super viewDidLoad];
    /* 设置title的字体颜色*/
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationBar setBarTintColor:KNavigationColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        //第二级则隐藏底部Tab
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 40, 30);
        
        button.titleLabel.font = [UIFont systemFontOfSize:1];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }

    
    [super pushViewController:viewController animated:animated];
}
-(void)back:(UIButton*)btn{
    [self popViewControllerAnimated:YES];
}

@end
