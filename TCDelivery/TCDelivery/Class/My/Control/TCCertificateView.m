//
//  TCCertificateView.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/4/13.
//
//
#import "TCCertificateCell.h"
#import "TCCertificateView.h"
@interface TCCertificateView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, copy)NSString *imageHeaderUrl;
@property(nonatomic, strong)NSArray *imageArr;
@end
@implementation TCCertificateView
{
    UITableView *_tab;
}

-(NSArray *)imageArr{
    if (_imageArr==nil) {
        _imageArr=@[].mutableCopy;
    }
    return _imageArr;
}

- (id)initWithFrame:(CGRect)frame CertificateImagePath:(NSString *)imagePath imageHeaderUrl:(NSString *)headerUrl{
    self=[super initWithFrame:frame];
    if (self) {
        [self createTableView];
        [self createUIWithImagePath:nil];
        self.imageHeaderUrl=headerUrl;
        self.imageArr=[imagePath componentsSeparatedByString:@"|"];
    }
    return self;
}

- (void)createTableView{
    //初始化tableview
    _tab=[[UITableView alloc]initWithFrame:CGRectMake(10, 84, kWindowW-20, self.frameHeight-80) style:UITableViewStylePlain];
    _tab.delegate                     = self;
    _tab.dataSource                   = self;
    _tab.showsVerticalScrollIndicator = NO;
    _tab.separatorStyle               = UITableViewCellSeparatorStyleNone;
    _tab.backgroundColor=LGLighgtBGroundColour235;
    [self addSubview:_tab];
}

#pragma  mark 《UITableViewDelegate》

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const ROCBaseTicketCellId = @"ROCBaseTicketCell";
    TCCertificateCell*cell = [tableView dequeueReusableCellWithIdentifier:ROCBaseTicketCellId];
    if (cell == nil) {
        cell = [[TCCertificateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ROCBaseTicketCellId];
    }
    NSString *imagePath1 = self.imageArr[indexPath.row];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",self.imageHeaderUrl,imagePath1];
    cell.imageUrl=imageUrl;
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 256.0f;
}

- (void)createUIWithImagePath:(NSString *)imagePath{
    self.backgroundColor=kRGBAColor(0, 0, 0, 0.4);
    UIButton*shatBtn=[[UIButton alloc]init];
    [shatBtn setBackgroundImage:[UIImage imageNamed:@"shat"] forState:0];
    [shatBtn addTarget:self action:@selector(shat) forControlEvents:UIControlEventTouchUpInside];
    shatBtn.layer.borderColor = [UIColor redColor].CGColor;
    shatBtn.layer.borderWidth = 0.50f;
    shatBtn.layer.cornerRadius=15;
    shatBtn.layer.masksToBounds=YES;
    [self addSubview:shatBtn];
    [shatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_tab.right).offset(5);
        make.size.offset(CGSizeMake(30, 30));
        make.bottom.equalTo(_tab.top).offset(25);
    }];
}

-(void)shat{
    [self removeFromSuperview];
}

@end
