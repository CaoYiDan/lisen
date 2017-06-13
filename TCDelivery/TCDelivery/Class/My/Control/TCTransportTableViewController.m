//
//  TCOrderListTableViewController.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/7.
//
//
//    orderStatus (string): 订单状态，0全部订单(或者不填写)，1运输中订单 2运输完成订单 3已      删除订单(已取消) 4待运输 5历史订单（包括已取消和已完成） 6非历史订单（运输中和待运输） ,
//    pageNumber (integer): 分页参数（将要查询的页数） ,
//    pageSize (integer): 分页参数（查询的个数） ,
//    tenderId (string, optional): 需求id(如果有，通过需求id查询该需求已经生成了多少订单；如果没有，那么就查询全部) ,
//    userId (string): 当前登录人id（如果不提供当前登录人员的id，那么就查询全部） ,
//    userType (string): 当前登录人二级角色(如果当前登录人id填写了，该字段必须提供),


#import "TCTransportTableViewController.h"

#import "TCTransportDetailVC.h"

#import "TCTransportListCell.h"
#import "TCOrderModel.h"

@interface TCTransportTableViewController ()
@property(nonatomic,strong)UITableView*table;
//数据模型数组
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation TCTransportTableViewController
{
    int  page;
}

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=[NSString stringWithFormat:@"订单 %@",self.orderNum];
    [self setupTableView];
    [self setupRefresh];
}

#pragma mark - 初始化MJRefesh
- (void)setupRefresh
{
    // header
    self.table.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    self.table.header.autoChangeAlpha = YES;
    [self.table.header beginRefreshing];
    // footer
    self.table.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.table.footer.hidden=YES;
}
#pragma mark - 加载数据
- (void)loadNew
{   page=1;
    //取消网络请求
    [[HttpRequest sharedClient] cancelRequest];
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    
    [dict setObject:@"1" forKey:@"pageNumber"];
    [dict setObject:@"6" forKey:@"pageSize"];
    [dict setObject:self.orderId forKey:@"orderId"];
    
//    [dict setObject:@(self.selectedIndex) forKey:@"orderDetailStatus"];
    
    [[HttpRequest sharedClient]httpRequestPOST:kTransportList parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj){
        NSLog(@"%@",responseObject);
        
        self.dataArray= (NSMutableArray*)[TCOrderModel objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        [self.tableView.header endRefreshing];
        
        /** 如果是不是最后一页，则底部显示加载更多*/
        NSString*isLastPage=responseObject[@"data"][@"isLastPage"];
        
        if ([isLastPage integerValue]==0){ self.table.footer.hidden=NO;}
        else{
            self.table.footer.hidden=YES;
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        ToastError(@"网络错误");
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark - 加载更多数据
- (void)loadMore
{    page++;
    WeakSelf;
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:@(page) forKey:@"pageNumber"];
    [dict setObject:@"6" forKey:@"pageSize"];
    [dict setObject:self.orderId forKey:@"orderId"];

    [[HttpRequest sharedClient]httpRequestPOST:kTransportList parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        
        NSMutableArray*arr=[NSMutableArray array];
        arr= (NSMutableArray*)[TCOrderModel objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        
        [self.dataArray addObjectsFromArray:arr];
        [weakSelf.tableView.footer endRefreshing];
        
        /** 如果是不是最后一页，则底部显示加载更多*/
        NSString*isLastPage=responseObject[@"data"][@"isLastPage"];
        
        if ([isLastPage integerValue]==0){ self.table.footer.hidden=NO;}
        else{
            self.table.footer.hidden=YES;
        }
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        ToastError(@"网络错误");
        [weakSelf.tableView.footer endRefreshing];
    }];
}

- (void)setupTableView
{
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH-49-75-64) style:UITableViewStylePlain];
    
    //替换tableview
    self.tableView=_table;
    self.table.separatorColor=[UIColor clearColor];
    self.tableView.backgroundColor = LGLighgtBGroundColour235;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.contentInset    = UIEdgeInsetsMake(0, 0, 58, 0);
    self.table.rowHeight    =125;
    
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        TCOrderModel*model=self.dataArray[indexPath.row];
        TCTransportListCell*cell=[TCTransportListCell cellWithTableView:tableView];
        cell.orderModel=model;
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCOrderModel*model=self.dataArray[indexPath.row];
    
    TCTransportDetailVC*vc=[[TCTransportDetailVC alloc]init];
    vc.transportId=model.orderDetailsNum;
    vc.transportId2=model.orderId;
    vc.tenderType = model.tenderType;
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
