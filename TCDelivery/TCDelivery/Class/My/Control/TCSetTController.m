//
//  TCSetTController.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/3/8.
//
//

#import "TCSetTController.h"

@interface TCSetTController ()
@property(nonatomic,strong)UILabel*lbl;
@end

@implementation TCSetTController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"设置";
    //注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ok"];
    self.tableView.rowHeight=42;
    self.tableView.separatorColor=[UIColor clearColor];
 
    UIButton*quitBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWindowW/2-70, kWindowH-60-64, 140, 32)];
    quitBtn.layer.cornerRadius=10;
    quitBtn.clipsToBounds=YES;
    quitBtn.backgroundColor=KTCBlueColor;
    [quitBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [quitBtn setTitle:@"退出登录" forState:0];
    [self.view addSubview:quitBtn];
}
-(void)quit{
//    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
//    [dict setObject:[StorageUtil getRoleId] forKey:@"userId"];
//    [[HttpRequest sharedClient]httpRequestPOST:kUrlEquit parameters:dict progress:nil sucess:^(NSURLSessionDataTask *task, id responseObject, ResponseObject *obj) {
//        NSLog(@"%@",responseObject);
        [StorageUtil saveRoleId:@""];
        [StorageUtil saveRealName:@""];
        [StorageUtil saveUserMobile:@""];
        [StorageUtil saveUserType:@""];
        [StorageUtil saveUserSubType:@""];
        [StorageUtil saveHeaderName:@""];
        [StorageUtil saveUserStatus:@""];
        self.tabBarController.selectedIndex=0;
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"shibai");
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ok" forIndexPath:indexPath];
    
    if (indexPath.row==0) {
        self.lbl=[[UILabel alloc]init];
        self.lbl.text=[NSString stringWithFormat:@"约%.2fMB(包括图片，数据等)",[[SDImageCache sharedImageCache] checkTmpSize]];
        self.lbl.font=Font(11);
        self.lbl.textColor=[UIColor blackColor];
        
        self. lbl.textAlignment=NSTextAlignmentRight;
        self.lbl.frame=CGRectMake(kWindowW-210, 0, 200, 42);
        [cell addSubview:self.lbl];
        cell.textLabel.text=@"清除缓存";
        UIView*line=[[UIView alloc]initWithFrame:CGRectMake(0, cell.frameHeight-1, kWindowW, 1)];
        line.backgroundColor=LGLighgtBGroundColour235;
        [cell addSubview:line];
        [cell.imageView setImage:[UIImage imageNamed:@"fh_an9"]];
    }else if(indexPath.row==5){
        
       
        
    }
    cell.selectionStyle=UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        
        [[SDImageCache sharedImageCache] clearDisk];
        ToastSuccess(@"清理成功");
        self.lbl.text=@"约0.00MB(包括图片，数据等)";
    }else if(indexPath.row==5){
        
    }
}
@end
