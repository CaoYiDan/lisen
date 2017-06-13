//
//  TCFrequentLinkmanVC.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/5/3.
//
//

#import "TCFrequentLinkmanVC.h"
#import "TCAddLinkmanVC.h"
#import "TCFrequentCell.h"
#import "TCLinkModel.h"
@interface TCFrequentLinkmanVC ()
@property (nonatomic ,strong) UIButton *addLinkmanBtn;
@property(nonatomic,strong) NSMutableArray *items;
@end

@implementation TCFrequentLinkmanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    self.tableView.rowHeight = 75;
    self.tableView.separatorColor=[UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLinkMan)];
    self.tableView.header.autoChangeAlpha = YES;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:self.addLinkmanBtn aboveSubview:self.tableView];
    if (self.linkType == LinkTypeDelivery) {
        [_addLinkmanBtn setTitle:@"+ 新建发货联系人" forState:0];
    }else{
        [_addLinkmanBtn setTitle:@"+ 新建收货联系人" forState:0];
    }
    [self.tableView.header beginRefreshing];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;    //让rootView禁止滑动
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.addLinkmanBtn removeFromSuperview];
}

- (void)loadLinkMan{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];
    [dict setObject:@(self.linkType) forKey:@"categoryFlag"];
    
    [[HttpRequest sharedClient]httpRequestPOST:kReceiverList parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        self.items =(NSMutableArray *)[TCLinkModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.tableView.header endRefreshing];
    }];
}

- (void)setNavigation{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(kWindowW/2-50, 0, 100, 44)];
    title.text= @"常用联系人";
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=[UIColor blackColor];
    self.navigationItem.titleView=title;
}
- (UIButton *)addLinkmanBtn{
    if (!_addLinkmanBtn) {
        _addLinkmanBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, kWindowH-50, kWindowW-40, 40)];
        _addLinkmanBtn.backgroundColor = [UIColor redColor];
        [_addLinkmanBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchDown];
    }
    return _addLinkmanBtn;
}
- (void)add{
    TCAddLinkmanVC *vc = [[TCAddLinkmanVC alloc]init];
    vc.linkType = self.linkType;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCFrequentCell *cell = [TCFrequentCell tableViewCellWithTableView:tableView with:indexPath];
    TCLinkModel *info = self.items[indexPath.row];
    [cell setLinkInfo:info with:indexPath];//模型赋值
    //先判断这是选择发货人 还是 收货人 ，其次显示选中的红色对勾
    if (self.linkType == LinkTypeDelivery) {
        [cell haveSelectedReceiverId:self.deliveryId];
    }else{
        [cell haveSelectedReceiverId:self.receiveId];
    }
    WeakSelf;
    cell.TCFrequentBlock = ^(NSInteger index){
        TCAddLinkmanVC *vc=[[TCAddLinkmanVC alloc]init];
        vc.model=info;
        vc.linkType=weakSelf.linkType;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCLinkModel *model =  self.items[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(frequentLinkmanDidSelectRowAtIndexPath: withObject:)]) {
        [self.delegate frequentLinkmanDidSelectRowAtIndexPath:indexPath withObject:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSMutableArray *)items{
    if (!_items) {
        _items=[[NSMutableArray alloc]init];
    }
    return _items;
}
@end
