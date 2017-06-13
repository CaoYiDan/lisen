//
//  LGBaseTableVC.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/8/15.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGBaseTableVC.h"

@implementation LGBaseTableVC
-(NSMutableArray*)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)heightArray{
    if (_heightArray==nil) {
        _heightArray=[[NSMutableArray alloc]init];
    }
    return _heightArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationItem.title=@"";
    [self.navigationController setNavigationBarHidden:NO];
    
    if ([self.tableViewStyle isEqualToString:@"分组样式"]) {
        self.TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWindowW,kWindowH-70) style:UITableViewStyleGrouped];
    }else{
        self.TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWindowW,kWindowH-64) style:UITableViewStylePlain];
    }
    
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.TableView.backgroundColor =LGLighgtBGroundColour235;
    self.TableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.TableView];
    NSLog(@"%@",self.ifNeedRefresh);
    if ([self.ifNeedRefresh isEqualToString:@"no"]) {
        
    }else{
        
        [self setupRefresh];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self loadNewTopics];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.TableView.header endRefreshing];
}

#pragma mark - 初始化
- (void)setupRefresh
{
    // header
    self.TableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
    self.TableView.header.autoChangeAlpha = YES;
//    [self.TableView.header beginRefreshing];
    
    // footer
//    self.TableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
//    self.TableView.footer.hidden = YES;
}

//在子类中实现
-(void)loadNewTopics{}
-(void)loadMoreTopics{}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"none"];
    return cell;
}
-(void)TableView:(UITableView *)TableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.TableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
