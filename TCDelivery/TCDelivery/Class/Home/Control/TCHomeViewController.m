//
//  ROCHomeVC.m
//  Ticketing
//
//  Created by 融合互联-------lisen on 16/11/1.
//  Copyright © 2016年 RHHL. All rights reserved.
//

#import "TCHomeCell.h"
#import "TCOrderModel.h"
#import "TCOrderListVC.h"
#import "TCHomeHeaderView.h"
#import "TCHomeViewController.h"
#import "LGLoginViewController.h"
#import "TCOrderDetailViewController.h"
#import "ROCBaseNavigationController.h"
//测试


@interface TCHomeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,TCHomeHeaderViewDelegate,UIAlertViewDelegate>
//header--轮播图 和6个可点击按钮
@property(nonatomic,strong)TCHomeHeaderView*header;
//item数组
@property (nonatomic, strong) NSMutableArray *items;
//tableview
@property(nonatomic,strong)UITableView*tableView;
//暂无订单提示语
@property(nonatomic,strong) UILabel*noOrderTip;
@end

@implementation TCHomeViewController
{
    int  page;
}
#pragma mark - lazy load
-(UILabel*)noOrderTip{
    if (_noOrderTip==nil) {
        _noOrderTip=[UILabel labelWithFont:Font(14) textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentCenter];
        _noOrderTip.frameWidth=200;
        _noOrderTip.frameHeight=40;
        _noOrderTip.center=self.tableView.center;
        _noOrderTip.textColor=[UIColor grayColor];
        _noOrderTip.text=@"您目前暂无订单......";
        [self.tableView addSubview:_noOrderTip];
    }
    return _noOrderTip;
}
- (NSMutableArray *)items {
    if(!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

#pragma  mark 生命周期

-(void)viewDidLoad{
    [super viewDidLoad];
    //导航栏
    [self setNavigationView];
    // 初始TableView
    [self setupTable];
    //刷新控件
    [self setupRefresh];
    /** 创建通知，一旦得到登录状态改变，则重新创建tableView*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                            name:NotificationLoginStatusChange
                                            object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果userId为空，则--登录
    if(isEmptyString([StorageUtil getRoleId])){
       [self login];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//重新登录的时候，刷新数据
-(void)refresh{
    [self.tableView.header beginRefreshing];
}

#pragma  mark 导航栏View

-(void)setNavigationView{
    self.view.backgroundColor=[UIColor whiteColor];
    //给所有的状态栏添加一个背景色
    UIView*statusView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 20)];
    statusView.backgroundColor=[UIColor whiteColor];
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:statusView];
    
    UIView*navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, kWindowW, 44)];
    navigationView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:navigationView];
    
    //导航栏图片
    UIImageView*homeTitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(kWindowW/2-49,3, 98, 38)];
    [homeTitleImage setImage:[UIImage imageNamed:@"logo"]];
    [navigationView addSubview:homeTitleImage];
    //导航栏下边的分割线
    UIView*bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, 43, kWindowW, 1)];
    bottomLine.backgroundColor=LGLighgtBGroundColour235;
    [navigationView addSubview:bottomLine];
    
}

#pragma mark - 初始化MJRefesh

- (void)setupRefresh
{
    // header
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    self.tableView.header.autoChangeAlpha = YES;
    //如果已登录，则刷新
    if (!isEmptyString([StorageUtil getRoleId])) {
        [self.tableView.header beginRefreshing];
    }
    // footer
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.footer.hidden=YES;
}

#pragma  mark 初始化TableView 和 HeaderView

- (void)setupTable {
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH-49-64) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor=LGLighgtBGroundColour235;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 90;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    //头部header
    _header=[[TCHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, kWindowW/1080*400+kWindowW/7+45)];
    _header.delegate=self;
    self.tableView.tableHeaderView=_header;
}

#pragma mark - 加载数据

- (void)loadNew
{   page=1;
    //取消网络请求
    [[HttpRequest sharedClient] cancelRequest];
    WeakSelf;
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:@"6" forKey:@"orderStatus"];
    [dict setObject:@(page) forKey:@"pageNumber"];
    [dict setObject:@"5" forKey:@"pageSize"];
    [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];
    //"SHIPPING"; //发货公司
    [dict setObject:@"SHIPPING" forKey:@"userType"];
    
    [[HttpRequest sharedClient]httpRequestPOST:kHomeUrl parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj){
        //列表数据
        self.items= (NSMutableArray*)[TCOrderModel objectArrayWithKeyValuesArray:responseObject[@"data"][@"orderDtoPageInfo"][@"list"]];
        [weakSelf.tableView. header endRefreshing];
        /** 如果是不是最后一页，则底部显示加载更多*/
        NSString*isLastPage=responseObject[@"data"][@"orderDtoPageInfo"][@"isLastPage"];
        
        if ([isLastPage integerValue]==0){ self.tableView.footer.hidden=NO;}
        else{
            self.tableView.footer.hidden=YES;
        }
        if (self.items.count==0) {//如果没有订单，则提示 您目前暂无订单
            self.noOrderTip.hidden=NO;
            self.tableView.footer.hidden=YES;
        }else{//有的话则不用隐藏
            self.noOrderTip.hidden=YES;
        }
        //轮播图数据
        NSMutableArray*banner=[NSMutableArray array];
        for (NSDictionary*dic in responseObject[@"data"][@"advertDtoList"]) {
            [banner addObject:[NSString stringWithFormat:@"%@%@",ImageBase,dic[@"imgUrl"]]];
        }
        //赋值给headerView---轮播图
        [_header createByBannerArray:banner andPublishNum:[responseObject[@"data"][@"tenderCounts"] integerValue] transportNum:[responseObject[@"data"][@"waybill"] integerValue]];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ToastError(@"网络错误");
        [weakSelf.tableView.header endRefreshing];
    }];
}

#pragma mark - 加载更多数据

- (void)loadMore
{    page++;
    WeakSelf;
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"orderStatus"];
    [dict setObject:@(page) forKey:@"pageNumber"];
    [dict setObject:@"5" forKey:@"pageSize"];
    [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];
    [dict setObject:[StorageUtil getUserSubType] forKey:@"userType"];
    [[HttpRequest sharedClient]httpRequestPOST:kOrderList parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        NSMutableArray*arr=[NSMutableArray array];
        arr= (NSMutableArray*)[TCOrderModel objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        
        [self.items addObjectsFromArray:arr];
        [weakSelf.tableView.footer endRefreshing];
        
        /** 如果是不是最后一页，则底部显示加载更多*/
        NSString*isLastPage=responseObject[@"data"][@"isLastPage"];
        
        if ([isLastPage integerValue]==0){ self.tableView.footer.hidden=NO;
        }
        else{
            self.tableView.footer.hidden=YES;
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ToastError(@"网络错误");
        [weakSelf.tableView.footer endRefreshing];
    }];
}

#pragma mark - Tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}

// 返回对应的单元格视图
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCHomeCell*cell=[TCHomeCell cellWithTableView:tableView];
    TCOrderModel*model=self.items[indexPath.row];
    cell.orderModel=model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TCOrderModel*model=self.items[indexPath.row];
    TCOrderDetailViewController*vc=[[TCOrderDetailViewController alloc]init];
    vc.orderId=model.orderId;
    vc.orderNum=model.orderNum;
    [self.navigationController pushViewController:vc animated:YES];
}
//登录
-(void)login{
    LGLoginViewController*vc=[[LGLoginViewController alloc]init];
    ROCBaseNavigationController*loginNav=[[ROCBaseNavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:loginNav animated:YES
                     completion:^{}];
}

#pragma  mark header的点击事件处理

-(void)TCHomeHeaderViewCilck:(NSInteger)tag{
    if (tag==120) {
        [self myPublishClick];
    }else if ( tag==121){
        [self myTransportClick];
    }else{
        [self titleClick:tag];
    }
}

#pragma  mark 点击了立即发货，订单管理等按钮
-(void)titleClick:(NSInteger)tag{
    if (tag==0){
        self.tabBarController.selectedIndex=1;//发货
    }else if (tag==1){
        TCOrderListVC*vc=[[TCOrderListVC alloc]init];
        vc.switchType=SwitchTypeTransportList;//运单管理----全部
        vc.firstSelectedBtn=0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tag==2){
        self.tabBarController.selectedIndex=2;//跟踪
    }else if (tag==3){
        TCOrderListVC*vc=[[TCOrderListVC alloc]init];
        vc.switchType=SwitchTypeTransportList;//运单管理-----运输中
        vc.firstSelectedBtn=1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma  mark 我的发布

-(void)myPublishClick{
    TCOrderListVC*vc=[[TCOrderListVC alloc]init];
    vc.switchType=SwitchTypeMyPublishList;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  mark 我的运单

-(void)myTransportClick{
    TCOrderListVC*vc=[[TCOrderListVC alloc]init];
    vc.switchType=SwitchTypeTransportList;
    vc.firstSelectedBtn=1;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
