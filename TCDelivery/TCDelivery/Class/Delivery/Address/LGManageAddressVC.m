//
//  LGManageAddressVC.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/8/16.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//



#import "LGEditorAddresViewController.h"

#import "LGManageAddressVC.h"
#import "LGAddresModel.h"
#import "LGManageCell.h"
#import "LGAddresModel.h"

@interface UITableViewController()

@property(nonatomic,strong)NSMutableArray*addressArr;

@end
@implementation LGManageAddressVC
{
    BOOL ifchoseCellBack;
    BOOL ifcontuse;
}
//-(NSMutableArray*)addressArr{
//    if (_addressArr==nil) {
//        _addressArr=[[NSMutableArray alloc]init];
//    }
//    return _addressArr;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatnavigation];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ifcontuse=NO;
    ifchoseCellBack=NO;
    self.tableView.rowHeight=120;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self loadNewTopics];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([self.MYControl isEqualToString:@"我的中心"]||ifcontuse) {
        return;
    }
    
    if (ifchoseCellBack) {
        NSLog(@"gfd");
    }else{
        
        if (self.addressArr.count==0) {
            if ([self.delegate respondsToSelector:@selector(selectAddress:)]) {
                LGAddressInfo*addressInfo=[[LGAddressInfo alloc]init];
                [self.delegate selectAddress:addressInfo];
            }
            return;
        }
        LGAddressInfo*addressInfo=self.addressArr[0];
        if ([self.delegate respondsToSelector:@selector(selectAddress:)]) {
            [self.delegate selectAddress:addressInfo];
        }
    }
}

-(void)creatnavigation{
    self.title=@"收货信息管理";
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    button.bounds = CGRectMake(0, 0, 40, 30);
    [button addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//添加按钮点击事件
-(void)add{
    LGEditorAddresViewController*vc=[[LGEditorAddresViewController alloc]init];
    ifcontuse=YES;
    vc.isAdd=YES;
    vc.view.backgroundColor=[UIColor blackColor];
    [self.navigationController pushViewController:vc animated:YES];
}

//刷新触发的事件，直接请求网络数据
-(void)loadNewTopics{
    WeakSelf;
    
//    [LGAddresModel getAddresses:^(BOOL result, NSNumber *resultCode, NSString *message, NSArray *addresses) {
//        [weakSelf.tableView.header endRefreshing];
//        
//        //直接将封装一层请求得到的数据数组传给本类的数组。刷新tableView
//        weakSelf.addressArr=(NSMutableArray*)addresses;
//        NSLog(@"数组个数%lu",(unsigned long)self.addressArr.count);
//        
//        [weakSelf.tableView reloadData];
//        
//    } failure:^(NSError *error) {
//        ToastError(@"貌似网络异常");
//        [weakSelf.tableView.header endRefreshing];
//    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGManageCell*cell=[LGManageCell tableViewCellWithTableView:tableView with:indexPath];
    //cell 不显示被选中
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //模型赋值
    WeakSelf;
    //cell点击回调编辑
    cell.clickblock=^(NSInteger index){
        NSLog(@"%ld",(long)index);
        /** 大于等于200  即为设置为默认按钮点击事件*/
        if (index >=200) {
            LGAddressInfo*info=weakSelf.addressArr[index-200];

//            [LGAddresModel setDefaultWithId:[NSString stringWithFormat:@"%ld",(long)info.addressId] success:^(BOOL result) {
//                [weakSelf.tableView.header beginRefreshing];
//            } failure:^(NSError *error) {
//                ToastError(@"亲,好像出了点小错误");
//            }];

        }else{
            /** 小于200 ,即为编辑事件*/
        LGEditorAddresViewController*vc=[[LGEditorAddresViewController alloc]init];
        vc.isAdd=NO;
        ifcontuse=YES;
          
        LGAddressInfo*info=weakSelf.addressArr[index];
        vc.editaddressInfo=info;
        
        [weakSelf.navigationController pushViewController:vc
                                                 animated:YES];
        }
        
    };
    [cell setAddressInfo:self.addressArr[indexPath.row] with:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.MYControl isEqualToString:@"我的中心"]) {
        return;
    }
    ifchoseCellBack=YES;
    LGAddressInfo*addressInfo=self.addressArr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(selectAddress:)]) {
        [self.delegate selectAddress:addressInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
    //异步进行网络请求，将选中的地址设置为默认地址。与此同时，返回订单界面
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
//    
//    dispatch_async(concurrentQueue, ^(){
//        NSString*adddresId=[NSString stringWithFormat:@"%ld",addressInfo.addressId];
//        
//        [LGAddresModel setDefaultWithId:adddresId success:^(BOOL result) {
//        // Toast(@"已将此地址设置为默认地址");
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        } failure:^(NSError *error) {
//            Toast(@"亲,好像出了点小错误");
//        }];
//        
//    });

}


@end
