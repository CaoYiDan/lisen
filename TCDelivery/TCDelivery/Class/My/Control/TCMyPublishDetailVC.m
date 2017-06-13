//
//  TCMyPublishDetailVC.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/10.

#import "TCOrderModel.h"
#import "TCShipperModel.h"
#import "TCDeliveryViewController.h"
#import "TCMyPublishDetailVC.h"
#import "TCMyPublishDetailIntentionCell.h"
#import "TCMyPublishDetailShipperCell.h"
#import "TCMyPublishDetailHeaderView.h"
@interface TCMyPublishDetailVC ()<UITableViewDelegate,UITableViewDataSource,TCMyPublishDetailIntentionCellDelegate>
@property(nonatomic,strong)UITableView*tab;
//每一个cell 对应一个是否被选定的标记
@property(nonatomic,strong)NSMutableArray*selectedItems;
//承运放模型数组
@property(nonatomic,strong)NSMutableArray*shipperArray;
//意向承运方模型数组
@property(nonatomic,strong)NSMutableArray*intentionArray;

@end

@implementation TCMyPublishDetailVC
{
    TCMyPublishDetailHeaderView*_header;
    NSInteger _selectedIndexRow;
    TCOrderModel*_model;
    NSString*_tenderType;//发布类型，公开竞争有报价信息，总包模式没有报价信息。
}
//承运方数组
-(NSMutableArray*)shipperArray{
    
    if (!_shipperArray) {
        _shipperArray=[[NSMutableArray alloc]init];
    }
    return _shipperArray;
}
//意向承运方数组
-(NSMutableArray*)intentionArray{
    if ((!_intentionArray)) {
        _intentionArray=[NSMutableArray array];
    }
    return _intentionArray;
}
//每一个cell 对应一个是否被选定的标记
-(NSMutableArray*)selectedItems{
    
    if (!_selectedItems) {
        _selectedItems=[[NSMutableArray alloc]init];
    }
    return _selectedItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"发布需求详情";
    //初始化tableview
    [self creatTableView];
    //请求需求数据---即头部数据
    [self loadData];
    //请求承运方报价信息---cell数据
    [self laodShipperData];
    //设置编辑按钮
    [self editButton];
}
#pragma  makr  设置编辑按钮
-(void)editButton{
    if (_canEdit) {
        UIBarButtonItem*btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(edit)];
        self.navigationItem.rightBarButtonItem=btn;
    }
}
-(void)edit{
    TCDeliveryViewController*vc=[[TCDeliveryViewController alloc]init];
    vc.model=_model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma  mark 请求需求数据
-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString*url=[NSString stringWithFormat:@"%@/%@",kPublishDetail,self.tenderId];
    
    [[HttpRequest sharedClient]httpRequestGET:url parameters:nil progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        NSLog(@"%@",responseObject);
        
        NSArray*arr=[NSArray array];
        arr=[TCOrderModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self setHeader:arr[0]];
        [self.tab reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ToastError(@"网络错误");
    }];
}
#pragma  mark  请求承运方报价数据
-(void)laodShipperData{
    //先随意设定一个数值
    _selectedIndexRow=1200;
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:self.tenderId forKey:@"tenderId"];
    [dict setObject:@"1" forKey:@"pageNumber"];
    [dict setObject:@(100) forKey:@"pageSize"];
    
    [[HttpRequest sharedClient]httpRequestPOST:kPublishShipper parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        NSMutableArray*arr=[NSMutableArray array];
        arr =(NSMutableArray*)[TCShipperModel objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        int i=0;
        
        NSMutableArray*intention=[NSMutableArray array];
        NSMutableArray*shipper=[NSMutableArray array];
        for (TCShipperModel*model in arr) {
            if([model.bidStatus isEqualToString:@"WILL_SELECT"]){
                //意向订单
                [intention addObject:model];
            }else if ([model.bidStatus isEqualToString:@"WAIT_SELECT"]){
                //承运方报价数组
                [shipper addObject:model];
            }
            i++;
        }
        self.shipperArray=shipper;
        self.intentionArray=intention;
        [self.tab reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma  mark  给头部赋值
-(void)setHeader:(TCOrderModel*)model{
    _header.model=model;
    _tenderType=model.tenderType;
    _model=model;
   CGFloat addHeight=[model.remarks getSizeWithTextSize:CGSizeMake(kWindowW-50, 1000) fontSize:12.8].height;
    _header.frameHeight+=addHeight-10;
}
#pragma  mark  初始化tableView
-(void)creatTableView{
    //初始化tableview
    _tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH-64) style:UITableViewStylePlain];
    _tab.delegate                     = self;
    _tab.dataSource                   = self;
    self.tab.backgroundColor=LGLighgtBGroundColour235;
    _tab.showsVerticalScrollIndicator = NO;
    _tab.separatorStyle               = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tab];
    //header
    _header=[[TCMyPublishDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 260)];
    _header.backgroundColor=[UIColor whiteColor];
    _tab.tableHeaderView=_header;
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![_tenderType isEqualToString:@"OPEN"]) {//总包模式没有报价信息
        return 0;
    }
    if (self.intentionArray.count==0) {
        return 1;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.shipperArray.count==0?1:self.shipperArray.count;
    }
    return self.intentionArray.count==0?1:self.intentionArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCBaseTableViewCell*cell1=nil;
    if (indexPath.section==0) {
        if (self.shipperArray.count==0) {
            UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noneCell"];
            
            cell.textLabel.text=@"您目前没有其他承运方报价";
            
            cell.textLabel.font=Font(13);
            return cell;
        }
        //承运方报价cell
        TCMyPublishDetailShipperCell*cell=[TCMyPublishDetailShipperCell cellWithTableView:tableView];
        
        TCShipperModel*model=self.shipperArray[indexPath.row];
        
        [cell setModel:model andIndex:indexPath.row];
        if (self.intentionArray.count==0) {
            //可以选择
            cell.chose.backgroundColor=KTCGreen;
        }else{
            //不可以选择
            cell.chose.backgroundColor=LGLighgtBGroundColour235;
        }
        return cell;
    }else{
        if (self.intentionArray.count==0) {
            UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noneCell"];
            cell.textLabel.text=@"您目前还没有选定意向承运方";
            return cell;
        }
        //意向承运方
       TCMyPublishDetailIntentionCell* cell=[TCMyPublishDetailIntentionCell cellWithTableView:tableView];
        TCShipperModel*model=self.intentionArray[0];
        cell.delegate=self;
        cell.index=indexPath.row;
        cell.shipperModel=model;
        return cell;
    }

    return cell1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
#pragma  mark  sectionHeader
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //baseView
    UILabel*sectionHeaderView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 25)];
    sectionHeaderView.font=Font(16);
    sectionHeaderView.textAlignment=NSTextAlignmentCenter;
    sectionHeaderView.backgroundColor=LGLighgtBGroundColour235;
    if(section==0){
        sectionHeaderView.text=@"承运方报价列表";
    }else if (section==1){
        sectionHeaderView.text=@"意向承运方";
    }
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (self.shipperArray.count==0) {
            return 40;
        }
        return 140;
    }else{
        return 218;
    }
}
#pragma  mark 生成意向订单
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中意向订单，没有回应
    if (indexPath.section==1) {
        return;
    }
    if (self.intentionArray.count!=0 && indexPath.section==0) {
        ToastError(@"处理了意向订单之后，才能继续选择");
        return;
    }
    if (self.shipperArray.count==0) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    TCShipperModel*model=self.shipperArray[indexPath.row];
    //点中其中一个承运方报价，则将
    //1.此订单设置为意向订单，上传服务器
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
//    bidId (integer, optional): 报价id ,
//    updateBy (string, optional):
    [dict setObject:model.bidId forKey:@"bidId"];
    [dict setObject:[StorageUtil getRoleId] forKey:@"updateBy"];
    
    [[HttpRequest sharedClient]httpRequestPOST:KBidSelect parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        NSString*ifSuccess=responseObject[@"success"];
        NSLog(@"%@",responseObject);
        if ([ifSuccess integerValue]==0){//失败
            ToastError(responseObject[@"info"]);
        }else{//成功

            //2.改变选中的意向订单
            _selectedIndexRow=indexPath.row;
            //3.重新加载承运方数据
            [self laodShipperData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ToastError(@"网络错误");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
#pragma  mark 意向订单的delegate----确认生成订单或取消意向订单
-(void)TCMyPublishDetailIntentionCellCtreateOrder:(NSInteger)row andOption:(NSString *)option{
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([option isEqualToString:@"确认"]) {//生成订单
        NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
        TCShipperModel*model=self.intentionArray[row];
        
//        addType (string, optional): 创建渠道 1手机 2pc					端 3定时任务 ,
//        bidId (string, optional): 报价主键 ,
//        createBy (string, optional): 创建人
        [dict setObject:@"1" forKey:@"addType"];
        [dict setObject:model.bidId forKey:@"bidId"];
        [dict setObject:[StorageUtil getRoleId] forKey:@"createBy"];
//        iszjxl  是否使用中交兴路(0不使用，1使用，缺省为0)
        [dict setObject:@"0" forKey:@"iszjxl"];
        [[HttpRequest sharedClient]httpRequestPOST:KCreateOrder parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
            NSLog(@"生成订单---%@",responseObject);
            NSString*ifSuccess=responseObject[@"success"];
            
            if ([ifSuccess integerValue]==0){//失败
                ToastError(responseObject[@"info"]);
            }else{//成功
                ToastSuccess(@"订单已生成！");
                //将意向订单清空，
                [self.intentionArray removeAllObjects];
                //重新刷新---是报价承运方可以继续选择。
                [self .tab reloadData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"失败了");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];

    }else if([option isEqualToString:@"取消"]){//取消订单
       
        NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
        TCShipperModel*model=self.intentionArray[row];
    
        [dict setObject:model.bidId forKey:@"bidId"];
        [dict setObject:[StorageUtil getRealName] forKey:@"updateBy"];
     
        [[HttpRequest sharedClient]httpRequestPOST:KCancelIntention parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
            NSLog(@"取消订单---%@",responseObject);
            NSString*ifSuccess=responseObject[@"success"];
            
            if ([ifSuccess integerValue]==0){//失败
                
            }else{//成功
                
                [self.intentionArray removeAllObjects];
                [self.tab reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"失败了");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}
@end
