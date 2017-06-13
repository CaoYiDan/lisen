//
//  FinancialViewController.m
//  TianMing
//
//  Created by 李智帅 on 2017/5/22.
//  Copyright © 2017年 李智帅. All rights reserved.
//

#import "FinancialViewController.h"
#import "FinancialTableViewCell.h"
#import "SDCycleScrollView.h"
#import "FinancialDetailViewController.h"
@interface FinancialViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{

    SDCycleScrollView * _adScrol;
    UITableView * _tableView;
}
@property(nonatomic,strong)NSMutableArray * bannerArray;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation FinancialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNav];
    [self createBanner];
    // Do any additional setup after loading the view.
}
#pragma mark - 轮播图
- (void)createBanner{
    
    NSString * one = @"1559103217846906832";
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",HomeBanner,one]);
    [[HttpRequest sharedClient]httpRequestGET:[NSString stringWithFormat:@"%@%@",HomeBanner,one] parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        
        NSLog(@"首页轮播图%@",responseObject);
        NSMutableArray * dataArr = responseObject[@"data"];
        for (NSDictionary * tempDic in dataArr) {
            
            NSString * bannerStr = [NSString stringWithFormat:@"%@%@",tempDic[@"imgHeadPath"],tempDic[@"imgUrl"]];
            NSLog(@"bannerStr%@",bannerStr);
            
            [self.bannerArray addObject:bannerStr];
            NSLog(@"self.bannerArray%@",self.bannerArray);
        }
        if (self.bannerArray.count !=0) {
            [self createUI];
            //[self createRefresh];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    //return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160.0;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 180;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"FinancialCell";
    FinancialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[FinancialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    if (self.dataArr.count!=0) {
        
        NSString * str = self.dataArr[indexPath.row];
        [cell creatUI:str];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * arr = @[@"ETC卡",@"车险服务",@"驾乘座位险"];
    FinancialDetailViewController * sendVC = [[FinancialDetailViewController alloc]init];
    
    sendVC.titleStr =arr[indexPath.row];
    sendVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sendVC animated:YES];
    
}



#pragma mark - createUI
- (void)createUI{
    
    NSLog(@"createUI%@",self.bannerArray);
    [self.dataArr addObject:@"financial1.jpg"];
    [self.dataArr addObject:@"financial2.jpg"];
    [self.dataArr addObject:@"financial3.jpg"];
    _adScrol = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,SCREEN_W,SCREEN_W/2.7) imageURLStringsGroup:self.bannerArray];
    
    _adScrol.bannerImageViewContentMode=UIViewContentModeScaleToFill;
    _adScrol.infiniteLoop = YES;
    _adScrol.delegate = self;
    _adScrol.placeholderImage = [UIImage imageNamed:@"1.jpg"];
    //adScrol.dotColor = [UIColor whiteColor];
    _adScrol.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, SCREEN_H) style:UITableViewStylePlain];
    _tableView.backgroundColor =[UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = view;
    _tableView.tableHeaderView = _adScrol;
    [self.view addSubview: _tableView];
    
}
#pragma mark - createNav
- (void)createNav{
    self.title =@"金融服务";
//    self.titleLabel.text = @"金融服务";
//    self.titleLabel.textColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
//    [self.leftButton setImage:[UIImage imageNamed:@"btn_left"] forState:UIControlStateNormal];
//    [self.leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - backClick
- (void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazyLoad
//轮播图数据源
-(NSMutableArray*)bannerArray{
    if (_bannerArray==nil) {
        _bannerArray=[NSMutableArray array];
    }
    return _bannerArray;
}
-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
