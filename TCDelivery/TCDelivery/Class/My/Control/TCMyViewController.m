//
//  TCMyViewController.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/6.
//
//
#import "BDImagePicker.h"
#import "TCMyViewController.h"
#import "TCOrderListVC.h"
#import "LGLoginViewController.h"
#import "ROCBaseNavigationController.h"
#import "TCAuthenticationVCViewController.h"
#import "TCMyHeaderView.h"
#import "TCSetTController.h"
#import "OtherViewController.h"
#import "FinancialViewController.h"
//测试
#import "TCMyPublishDetailVC.h"
@interface TCMyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tab;
@property(nonatomic,strong)TCMyHeaderView*headerView;
@end

@implementation TCMyViewController
{
    NSArray*_textArr;
    BOOL _ifNeedCreateTableView;
    UIImage *_photoImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title=@"我";
    self.view.backgroundColor=LGLighgtBGroundColour235;
    _textArr=@[@"fh_an9",@"fh_an7",@"jrfw",@"fh_an8",@"d1",@"d1"];
    //创建TableView
    [self creatTableView];
     _ifNeedCreateTableView=NO;
    /** 创建通知，一旦得到登录状态改变，则重新创建tableView*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeTableView)
                                                 name:NotificationLoginStatusChange
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (_ifNeedCreateTableView) {
        //创建TableView
        [self creatTableView];
        //判断一下是否登录
        if(isEmptyString([StorageUtil getRoleId])) {
            [self login];
        }
        _ifNeedCreateTableView=NO;
    }
    //获取用户信息
    [self getUserMessage];
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 获取用户信息
-(void)getUserMessage{
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    [dict setObject:[StorageUtil getRoleId] forKey:@"id"];
    //"SHIPPING"; //发货公司
    [dict setObject:@"SHIPPING" forKey:@"userType"];
    [dict setObject:@[@"userSubType",@"status",@"headImage",@"imgHeadPath"] forKey:@"properties"];//属性列表（不填写就查询全部属性，填写哪个查询
    [[HttpRequest sharedClient]httpRequestPOST:kUserMessage parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj){
        NSLog(@"%@",responseObject);
        NSString*success=responseObject[@"success"];
        if ([success integerValue]==1) {
            [StorageUtil saveUserStatus:responseObject[@"data"][@"status"]];
            
            [StorageUtil saveUserSubType:responseObject[@"data"][@"userSubType"]];
            [_headerView setPhotoWithImagePath:[NSString stringWithFormat:@"%@%@",responseObject[@"data"][@"imgHeadPath"],responseObject[@"data"][@"headImage"]]];
            [_headerView refreshStatus];
        }else{
            ToastError(@"账号异常,请重新登录");
            [self login];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ToastError(@"网络错误");
    }];
}
-(void)removeTableView{
    [self.tab removeFromSuperview];
    _ifNeedCreateTableView=YES;
}
#pragma  mark  初始化tableView
-(void)creatTableView{
    //初始化tableview
    _tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH-49-64) style:UITableViewStylePlain];
    _tab.delegate                     = self;
    _tab.dataSource                   = self;
    _tab.showsVerticalScrollIndicator = NO;
    _tab.separatorStyle               = UITableViewCellSeparatorStyleNone;
    _tab.rowHeight=42;
    [self.view addSubview:_tab];
    
    //header
    TCMyHeaderView*headerView=[[TCMyHeaderView alloc]init];
    _headerView=headerView;
    if (isEmptyString([StorageUtil getRoleId])) {
        headerView.frame=CGRectMake(0, 0, kWindowW, 110+kWindowW/6+10);
    }else{
        headerView.frame=CGRectMake(0, 0, kWindowW, 110+kWindowW/6+10);
    }
    _tab.tableHeaderView=headerView;
    
    WeakSelf;
    headerView.MyHeaderblock=^(NSString*str ,NSInteger tag){
        //判断一下是否登录
        if(isEmptyString([StorageUtil getRoleId])) {
            [weakSelf login];
            return ;
        }
        if (tag==110) {  //去认证
            TCAuthenticationVCViewController*vc=[[TCAuthenticationVCViewController alloc]init];
            vc.userApplyStatus=str;
            weakSelf.navigationController.navigationBarHidden = NO;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (tag==120){//登录按钮点击
            [weakSelf login];
        }else if (tag==130){//修改头像
            [weakSelf photo];
        }else {//小订单点击
    TCOrderListVC*vc=[[TCOrderListVC alloc]init];
            
    if (tag==200) {
        vc.switchType=SwitchTypeMyPublishList;
    }else if(tag==201){
        vc.switchType=SwitchTypeMyOrderList;
    }else{
         vc.switchType=SwitchTypeTransportList;
    }
        [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
}

-(void)login{
    LGLoginViewController*vc=[[LGLoginViewController alloc]init];
    ROCBaseNavigationController*navc=[[ROCBaseNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:^{
        
    }];
}

#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*identifier=@"cell2";
    
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType=UITableViewCellStyleValue1;
    [cell.imageView setImage:[UIImage imageNamed:@"icon"]];
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"我的消息";
    }else  if (indexPath.row==1){
        cell.textLabel.text=@"关于我们";
    }else if (indexPath.row==2){
        cell.textLabel.text=@"金融服务";
    }else if (indexPath.row==3){
         cell.textLabel.text=@"设置";
    }else{
    cell.textLabel.text=kUrlBase;
    }
    
    [cell.imageView setImage:[UIImage imageNamed:_textArr[indexPath.row]]];
    UIView*line=[[UIView alloc]initWithFrame:CGRectMake(0, 41, kWindowW, 1)];
    line.backgroundColor=LGLighgtBGroundColour235;
    [cell.contentView addSubview:line];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        TCSetTController*vc=[[TCSetTController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==1) {
        OtherViewController*vc=[[OtherViewController alloc]init];
        vc.titleStr=@"关于我们";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==2) {
        FinancialViewController *vc=[[FinancialViewController alloc]init];
//        vc.titleStr=@"关于我们";
        [self.navigationController pushViewController:vc animated:YES];
    }

}
#pragma  mark 调取相册
-(void)photo{
    WeakSelf;
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        //上传图片---获取图片网络地址
        [weakSelf upDateHeadIcon:image];
        _photoImage=image;
    }];
}
#pragma  mark 上传图片
- (void)upDateHeadIcon:(UIImage *)photo{
    if (isNull(photo)) {
        return;
    }
  
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         
                                                         @"text/html",
                                                         
                                                         @"image/jpeg",
                                                         
                                                         @"image/png",
                                                         
                                                         @"application/octet-stream",
                                                         
                                                         @"text/json",
                                                         
                                                         nil];
    
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    
    NSData * imageData = UIImageJPEGRepresentation(photo,0.5);
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"text"];
    [imageData writeToFile:fullPath atomically:NO];
    
    NSMutableDictionary * dictT = [[NSMutableDictionary alloc]init];
    [dictT setObject:imageData forKey:@"image"];
    
    [manager POST:kPostPhoto parameters:dictT constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"text.jpg" mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //将二进制转为字符串
        NSString *result2 = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        //字符串转字典
        NSDictionary*dict=[self dictionaryWithJsonString:result2];
        NSLog(@"%@",dict);
        //上传用户头像路径
        [self postPhotoWithImagePath:dict[@"image"]];
        //给用户头像赋值
        [_headerView setImage:_photoImage];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ToastError(@"上传失败");
    }];
}
- (void)postPhotoWithImagePath:(NSString *)imagePath{
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];
    [dict setObject:imagePath forKey:@"headImage"];
    [[HttpRequest sharedClient]httpRequestPOST:kUpdateHeadImage parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
        if ([responseObject[@"code"]integerValue]==200) {
            ToastSuccess(@"修改成功");
        }else{
            if (!responseObject[@"info"]) {
                ToastError(@"未知错误");
            }else{
                ToastError(responseObject[@"info"]);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma  mark  将字符串转成字典
-(id )dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        
        return nil;
    }
    
    return dic;
}
@end
