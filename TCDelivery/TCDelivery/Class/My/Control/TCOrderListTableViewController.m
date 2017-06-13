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


#import "TCOrderListTableViewController.h"
#import "TCOrderDetailViewController.h"
#import "TCTransportDetailVC.h"
#import "TCMyPublishDetailVC.h"
#import "TCTransportListCell.h"
#import "TCOrderModel.h"
#import "TCOrderCell.h"
#import "TCOrderCellLayout.h"
#import "TCOrderTableViewCell.h"

@interface TCOrderListTableViewController ()<TCOrderTableViewCellDelegate>
@property(nonatomic,strong)UITableView*table;
//数据模型数组
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation TCOrderListTableViewController
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
    
    WeakSelf;
    NSString*url=nil;
        //我的运单
    if (self.switchType==SwitchTypeTransportList) {
        url=kTransportList;
    }else if(self.switchType==SwitchTypeMyOrderList){
        //我的订单
        url=kOrderList;
    }else{
        //我的发布
        url=kPublishList;
    }
    NSLog(@"%@",[self postDictionary]);
    [[HttpRequest sharedClient]httpRequestPOST:url parameters:[self postDictionary] progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj){
        NSLog(@"%@",responseObject);
        
        NSMutableArray*arrModel=[NSMutableArray array];
        arrModel= (NSMutableArray*)[TCOrderModel objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        
        NSMutableArray*arrModel2=[NSMutableArray array];
        
        //异步布局
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (TCOrderModel*model in arrModel) {
                TCOrderCellLayout*layout=[[TCOrderCellLayout alloc]initWithStatus:model andSwitchType:self.switchType];
                NSLog(@"%@",model.createDate);
                [arrModel2 addObject:layout];
            }
            self.dataArray=arrModel2;
            //回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView.header endRefreshing];
                
                /** 如果是不是最后一页，则底部显示加载更多*/
                NSString*isLastPage=responseObject[@"data"][@"isLastPage"];
                
                if ([isLastPage integerValue]==0){ self.table.footer.hidden=NO;}
                else{
                    self.table.footer.hidden=YES;
                }
                //没有数据的话，隐藏上拉加载更多
                if (arrModel.count==0) {
                    self.table.footer.hidden=YES;
                }
                
                [weakSelf.tableView reloadData];

            });
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        ToastError(@"网络错误");
        [weakSelf.tableView.header endRefreshing];
    }];
}

#pragma mark - 加载更多数据
- (void)loadMore
{    page++;
    WeakSelf;
    NSString*url=nil;
    //我的运单
    if (self.switchType==SwitchTypeTransportList) {
        url=kTransportList;
    }else if(self.switchType==SwitchTypeMyOrderList){
        //我的订单
        url=kOrderList;
    }else{
        //我的发布
        url=kPublishList;
    }
    
    [[HttpRequest sharedClient]httpRequestPOST:url parameters:[self postDictionary] progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        NSLog(@"%@",responseObject);
        NSMutableArray*arrModel=[NSMutableArray array];
        arrModel= (NSMutableArray*)[TCOrderModel objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        //异步布局
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (TCOrderModel*model in arrModel) {
                TCOrderCellLayout*layout=[[TCOrderCellLayout alloc]initWithStatus:model andSwitchType:self.switchType];
                [self.dataArray addObject:layout];
            }
            
            //回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView.footer endRefreshing];
                
                /** 如果是不是最后一页，则底部显示加载更多*/
                NSString*isLastPage=responseObject[@"data"][@"isLastPage"];
                
                if ([isLastPage integerValue]==0){ self.table.footer.hidden=NO;}
                else{
                    self.table.footer.hidden=YES;
                }
                
                [weakSelf.tableView reloadData];
                
            });
        });
        
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            ToastError(@"网络错误");
            [weakSelf.tableView.footer endRefreshing];
        }];
}

//请求网络传的参数
-(NSMutableDictionary*)postDictionary{
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:@(page) forKey:@"pageNumber"];
    [dict setObject:@"7" forKey:@"pageSize"];
    [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];
    
    //我的运单
    if (self.switchType==SwitchTypeTransportList) {
        /**  运单状态，用于查询 （0全部，1运输中 2运输完成 3已删除(以取消) 4未运输 5历史运单（已取消，已完成）,6非历史运单(运输中，未运输),7离当前最近的一单运单（如果有运输中的那么就取运输中的，反之则取未运输的，再则返回null））
         */
        [dict setObject:@"SHIPPING" forKey:@"userType"];
        if (self.selectedIndex==2) {
            [dict setObject:@"4" forKey:@"orderDetailStatus"];
        }else if(self.selectedIndex==3){
            [dict setObject:@"2" forKey:@"orderDetailStatus"];
        }
        else{
            [dict setObject:@(self.selectedIndex) forKey:@"orderDetailStatus"];
        }
    }else if(self.switchType==SwitchTypeMyOrderList){
        //我的订单
        /** 订单状态，0全部订单(或者不填写)，1运输中订单 2运输完成订单 3已删除订单(已取消) 4待运输 5历史订单（包括已取消和已完成） 6非历史订单（运输中和待运输）
         */
        [dict setObject:@"SHIPPING" forKey:@"userType"];
        if (self.selectedIndex==2) {
            [dict setObject:@"4" forKey:@"orderStatus"];
        }else if (self.selectedIndex==3) {
            [dict setObject:@"2" forKey:@"orderStatus"];
        }else{
            [dict setObject:@(self.selectedIndex) forKey:@"orderStatus"];
        }

            }else{
        //我的发布
        //statusFlag (string, optional): 发布状态（报价中，已结束，待报价，如果不传递值就是查询全部） ,(注：该字段的值为字符串（报价中，已结束，待报价）)
        if (self.selectedIndex==0) {
            //全部 不传值
        }else if(self.selectedIndex==1){
            [dict setObject:@"待报价" forKey:@"statusFlag"];
        }else if (self.selectedIndex==2){
            [dict setObject:@"报价中" forKey:@"statusFlag"];
        }else if (self.selectedIndex==3){
            [dict setObject:@"已结束" forKey:@"statusFlag"];
        }
    }
    NSLog(@"%@",dict);
    return dict;
}
- (void)setupTableView
{
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH-49-75-64) style:UITableViewStylePlain];

    //替换tableview
    self.tableView=_table;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.table.separatorColor=[UIColor clearColor];
     self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.contentInset    = UIEdgeInsetsMake(0, 0, 58, 0);
    if (self.switchType==SwitchTypeTransportList) {
        self.table.rowHeight=125;
    }else{
        self.table.rowHeight =166;
    }
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}


#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu",(unsigned long)_dataArray.count);
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.switchType==SwitchTypeMyOrderList||self.switchType==SwitchTypeMyPublishList) {
       
        TCOrderTableViewCell*cell=[TCOrderTableViewCell cellWithTableView:tableView];
        TCOrderCellLayout*layout=self.dataArray[indexPath.row];
        [cell setLayout:layout andIndexpathRow:indexPath.row];
        
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
    
     TCTransportListCell*cell=[TCTransportListCell cellWithTableView:tableView];
        TCOrderCellLayout*layout=self.dataArray[indexPath.row];
        cell.orderModel=layout.model;
        return cell;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //详情
    TCOrderCellLayout*layout=self.dataArray[indexPath.row];
    TCOrderModel*model=layout.model;
    if (self.switchType==SwitchTypeMyPublishList) {//我的发布详情
        TCMyPublishDetailVC*vc=[[TCMyPublishDetailVC alloc]init];
        vc.tenderId=model.tenderId;
        if ([model.statusFlag isEqualToString:@"待报价"]) {
            vc.canEdit=YES;//待报价-----可编辑
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else if(self.switchType==SwitchTypeMyOrderList){//我的订单详情
    TCOrderDetailViewController*vc=[[TCOrderDetailViewController alloc]init];
    vc.orderNum=model.orderNum;
    vc.orderId=model.orderId;
    [self.navigationController pushViewController:vc animated:YES];
    }else{//运单详情
        TCTransportDetailVC*vc=[[TCTransportDetailVC alloc]init];
        vc.transportId=model.orderDetailsNum;
        vc.transportId2=model.orderId;
        vc.tenderType=model.tenderType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma  mark cell底部的操作按钮点击事件
-(void)TCOrderTableViewCellOptionType:(NSString *)optionType atIndexPathRow:(NSInteger)row{
    TCOrderCellLayout*layout=self.dataArray[row];
    if ([optionType isEqualToString:@"立即发布报价"]) {
        NSMutableDictionary*dict=[NSMutableDictionary dictionary];
        [dict setObject:layout.model.tenderId forKey:@"tenderId"];
        
        [[HttpRequest sharedClient]httpRequestPOST:kPublicDemanNow parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj){
            
            NSString*success=responseObject[@"success"];
            if ([success integerValue]==0) {//失败
                ToastError(responseObject[@"info"]);
            }else{//成功之后重新刷新
                ToastSuccess(@"已开始报价");
                [self.table.header beginRefreshing];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            ToastError(@"网络错误");
        }];
    }
}
@end
