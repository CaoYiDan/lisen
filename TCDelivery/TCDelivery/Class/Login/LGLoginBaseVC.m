//
//  LGLoginBaseVC.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/8/15.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGLoginBaseVC.h"

@implementation LGLoginBaseVC
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden=YES;
      self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    //基于一个滑动的scrollview
    [self creatscroview];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=NO;
}

-(void)setupNavigationWithTilteName:(NSString*)titleName{
    self.navigationController.navigationBarHidden=YES;
    UILabel*titlelab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, kWindowW, 44)];
    titlelab.backgroundColor=KMainColor;
    titlelab.textAlignment=NSTextAlignmentCenter;
    titlelab.text=titleName;
    titlelab.textColor=[UIColor blackColor];
    [self.view addSubview:titlelab];
    UIButton*button=[UIButton buttonWithBackgroundColor:nil title:nil
                                         titleLabelFont:nil titleColor:nil target:self action:@selector(back) clipsToBounds:NO];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
//    button.backgroundColor=[UIColor blackColor];
    button.frame=CGRectMake(0, 20, 50, 44);
    [self.view addSubview:button];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)creatscroview{
    
    UIScrollView*scroview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH-64)];
    scroview.backgroundColor=LGLighgtBGroundColour235;
    scroview.showsVerticalScrollIndicator=NO;
    scroview.contentSize=CGSizeMake(kWindowW, kWindowH);
    [self.view addSubview:scroview];
    self.scroview=scroview;
}

@end
