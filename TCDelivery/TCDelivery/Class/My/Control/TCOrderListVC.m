//
//  LGSwitchController.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/14.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "TCOrderListVC.h"

#import "TCOrderListTableViewController.h"

@interface TCOrderListVC ()<UIScrollViewDelegate>
//contentView
@property (weak, nonatomic) UIScrollView *contentView;
//顶部点击标题
@property (weak, nonatomic) UIView *titlesView;
//点击按钮
@property (weak, nonatomic) UIButton *selectedButton;
//整个界面的滑动View
//@property (weak, nonatomic) UIView *sliderView;
//约束坐标
@property(strong,nonatomic) MASConstraint*sliderViewCenterX;
//订单类型数组
@property(strong,nonatomic)NSArray*styleArray;
//style
@property(nonatomic,copy)NSString*style;
//当前选择的index页，用来返回界面时，重新选取此index.
@property(nonatomic,assign)NSInteger selectedIndex;

@end

@implementation TCOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor=KMainColor;
    
    if (self.switchType==0) {
    self.navigationItem.title=@"我的发布";
    }else if(self.switchType==1){
     self.navigationItem.title=@"运单列表";
    }else if (self.switchType==2){
     self.navigationItem.title=@"订单管理";
    }
    
    [self setupChildViewControllers];
    [self setupContentView];
    
    [self setupTitlesView];
    //显示第几个状态的订单
    UIButton*button=[self.titlesView.subviews objectAtIndex:self.firstSelectedBtn];
    [self titleClick:button];
    //加载对应状态的View
    [self switchController:self.firstSelectedBtn];
    
}

-(void)switchBackClick{
    /**
     无论是从哪个界面跳转到的此界面，一律回跳到根控制器
     */
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setupChildViewControllers
{
    if (self.switchType==SwitchTypeMyOrderList) {//我的订单
        [self setupOneChildViewController:OrderTypeAll];
        [self setupOneChildViewController:OrderTypeTransport];
        [self setupOneChildViewController:OrderTypeWill];
        [self setupOneChildViewController:OrderTypeFinished];
//        [self setupOneChildViewController:OrderTypeCancel];
    }else if (self.switchType==SwitchTypeMyPublishList)//我的发布
    {
        [self setupOneChildViewController:MyPublishTypeAll];
        [self setupOneChildViewController:MyPublishTypeWill];
        [self setupOneChildViewController:MyPublishTypeIng];
        [self setupOneChildViewController:MyPublishTypeHaveFinished];
       
    }else if (self.switchType==SwitchTypeTransportList){//运单订单
        [self setupOneChildViewController:TransportTypeAll];
        [self setupOneChildViewController:TransportTypeIng];
        [self setupOneChildViewController:TransportTypeWill];
        [self setupOneChildViewController:TransportTypeHaveFinished];
    
    }
}

- (void)setupOneChildViewController:(NSInteger)type
{
    TCOrderListTableViewController*vc=[[TCOrderListTableViewController alloc]init];
    vc.selectedIndex= type;
    vc.switchType=self.switchType;
    [self addChildViewController:vc];
}

- (void)setupContentView
{
    UIScrollView *contentView                  = [[UIScrollView alloc] init];
    contentView.backgroundColor                = LGLighgtBGroundColour235;
    contentView.frame                          = CGRectMake(0, 20, kWindowW, kWindowH-20);
    contentView.autoresizingMask               = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.delegate                       = self;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator   = NO;
    contentView.pagingEnabled                  = YES;
    contentView.contentSize                    = CGSizeMake(contentView.frameWidth * self.childViewControllers.count, 0);
    
    [self.view addSubview:contentView];
    self.contentView                           = contentView;
}

- (void)setupTitlesView
{
    UIView *titlesView          = [[UIView alloc] init];
    
    titlesView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titlesView.frame            = CGRectMake(0, 74, self.view.frame.size.width, 30);
    [self.view addSubview:titlesView];
    self.titlesView             = titlesView;
     ;
    if (self.switchType==SwitchTypeMyOrderList) {//我的订单
        [self setupTitleButton:@"全部"];
        [self setupTitleButton:@"运输中"];
         [self setupTitleButton:@"待运输"];
        [self setupTitleButton:@"已完成"];
    }else if (self.switchType==SwitchTypeMyPublishList)//我的发布
    {
        [self setupTitleButton:@"全部"];
        [self setupTitleButton:@"待报价"];
        [self setupTitleButton:@"报价中"];
        [self setupTitleButton:@"已结束"];
    }else if (self.switchType==SwitchTypeTransportList){//运单
         [self setupTitleButton:@"全部"];
        [self setupTitleButton:@"运输中"];
        [self setupTitleButton:@"待运输"];
        [self setupTitleButton:@"已完成"];
        
    }
}

- (void)titleClick:(UIButton*)button
{
    self.selectedButton.backgroundColor=[UIColor whiteColor];
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    self.selectedButton.backgroundColor=KTCGreen;

    int index = (int)[self.titlesView.subviews indexOfObject:button];
    
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.frame.size.width, self.contentView.contentOffset.y) animated:YES];
}

- (UIButton *)setupTitleButton:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titlesView addSubview:button];
    
    [button setTitleColor:[UIColor grayColor] forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    button.backgroundColor=[UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13];

    [button makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(self.titlesView).multipliedBy(0.25);
        
        make.bottom.equalTo(self.titlesView);
        NSUInteger index = self.titlesView.subviews.count - 1;
        if (index == 0) {
            make.left.equalTo(self.titlesView);
        } else {
            make.left.equalTo(self.titlesView.subviews[index-1].right);
        }
    }];

    return button;
}

- (void)switchController:(NSInteger)index
{
    TCOrderListTableViewController*vc = self.childViewControllers[index];
    vc.view.originY = 80;
    vc.view.frameWidth = self.contentView.frameWidth;
    vc.view.frameHeight = self.contentView.frameHeight-30;
    vc.view.originX = vc.view.frameWidth * index;
    [self.contentView addSubview:vc.view];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self titleClick:self.titlesView.subviews[index]];
    [self switchController:index];
}

- (void)scrollViewDidEndScrollingAnimation:(nonnull UIScrollView *)scrollView
{
    [self switchController:(int)(scrollView.contentOffset.x / scrollView.frame.size.width)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x<-50) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
