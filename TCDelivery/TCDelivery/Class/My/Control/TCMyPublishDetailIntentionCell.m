//
//  TCMyPublishDetailIntentionCell.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/10.
//
//
#import "TCUnitView.h"
#import "TCShipperModel.h"
#import "TCMyPublishDetailIntentionCell.h"

@implementation TCMyPublishDetailIntentionCell
{
    TCUnitView*_industry;
    TCUnitView*_offer;
    TCUnitView*_unitPrice;
    TCUnitView*_offerDate;

    TCUnitView*_unitWeight;
    TCUnitView*_car;
    TCUnitView*_carNumber;
    UILabel*_chose;
    
    TCUnitView*_totalPrice;
    TCUnitView*_yuan;
    TCUnitView*_linkMan;
    TCUnitView*_linkPhone;
    
    UILabel*_leftTime;//剩余生成订单时间
    NSInteger leftTime;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    //意：天程物流公司
    _industry=[[TCUnitView alloc]init];
    _industry.type=30;
    
    [self addSubview:_industry];
    [_industry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.height.offset(30);
        make.top.offset(10);
    }];
    //报价时间
    _offerDate=[[TCUnitView alloc]init];
    _offerDate.type=24;
    [self addSubview:_offerDate];
    [_offerDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.height.offset(30);
        make.top.equalTo(_industry);
    }];
    //总：报价量
    _offer=[[TCUnitView alloc]init];
    _offer.type=21;
    [self addSubview:_offer];
    [_offer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_industry);
        make.height.offset(30);
        make.top.equalTo(_industry.bottom).offset(JianJu);
    }];
    //价
    _unitPrice=[[TCUnitView alloc]init];
    _unitPrice.type=29;
    [self addSubview:_unitPrice];
    [_unitPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_offerDate);
        make.height.offset(30);
        make.top.equalTo(_offer);
    }];
    
    //车辆信息
    _car=[[TCUnitView alloc]init];
    _car.type=35;
    [_car setLabelText:@"车辆数量:"];
    [self addSubview:_car];
    [_car mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_industry);
        make.height.offset(30);
        make.top.equalTo(_offer.bottom).offset(JianJu);
    }];
    //辆
    _carNumber=[[TCUnitView alloc]init];
    _carNumber.type=2;
    [self addSubview:_carNumber];
    [_carNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_car.right).offset(2);
        make.height.offset(30);
        make.top.equalTo(_car);
    }];
    
    //合计费用
    _totalPrice=[[TCUnitView alloc]init];
    _totalPrice.type=31;
    [self addSubview:_totalPrice];
    [_totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_unitPrice);
        make.height.offset(30);
        make.top.equalTo(_car);
    }];
    //4000 元
    _yuan=[[TCUnitView alloc]init];
    _yuan.type=32;
    [self addSubview:_yuan];
    [_yuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_totalPrice.right).offset(2);
        make.height.offset(30);
        make.top.equalTo(_car);
    }];
    
    //联系人
    _linkMan=[[TCUnitView alloc]init];
    _linkMan.type=33;
    [self addSubview:_linkMan];
    [_linkMan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_industry);
        make.height.offset(30);
        make.top.equalTo(_car.bottom).offset(JianJu);
    }];
    //联系人电话
    _linkPhone=[[TCUnitView alloc]init];
    _linkPhone.type=20;
    [self addSubview:_linkPhone];
    [_linkPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_unitPrice);
        make.height.offset(30);
        make.top.equalTo(_linkMan);
    }];
    //分割线
    UIView*line=[[UIView alloc]init];
    line.backgroundColor=LGLighgtBGroundColour235;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 1));
        make.top.equalTo(_linkMan.bottom).offset(10);
    }];
    //
    UIImageView*image=[[UIImageView alloc]init];
    [image setImage:[UIImage imageNamed:@"fh_fbxq_ybj_an2"]];
    [self.contentView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_linkMan);
        make.size.offset(CGSizeMake(20, 20));
        make.top.equalTo(line.bottom).offset(5);
    }];
    UILabel*leftTime1=[[UILabel alloc]init];
    leftTime1.font=Font(12);
    _leftTime=leftTime1;
    [self.contentView addSubview:leftTime1];
    [leftTime1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.right).offset(2);
        make.top.equalTo(line.bottom).offset(0);
        make.height.offset(30);
    }];
    //分割线
    UIView*line2=[[UIView alloc]init];
    line2.backgroundColor=LGLighgtBGroundColour235;
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 1));
        make.top.equalTo(image.bottom).offset(2);
    }];
    
    //取消
    UIButton*cancel=[UIButton borderButtonWithBackgroundColor:[UIColor grayColor] title:@"取消" titleLabelFont:Font(12) titleColor:[UIColor whiteColor] target:self action:@selector(cancel) clipsToBounds:YES];
    [self.contentView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.size.offset(CGSizeMake(70, 30));
        make.top.equalTo(line2.bottom).offset(2);
    }];
    //确定
    UIButton*confirm=[UIButton borderButtonWithBackgroundColor:KTCGreen title:@"确定" titleLabelFont:Font(12) titleColor:[UIColor whiteColor] target:self action:@selector(confirm) clipsToBounds:YES];
    [self.contentView addSubview:confirm];
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cancel.left).offset(-5);
        make.size.offset(CGSizeMake(70, 30));
        make.top.equalTo(cancel);
    }];
}
//取消
-(void)cancel{
    [self.delegate TCMyPublishDetailIntentionCellCtreateOrder:self.index andOption:@"取消"];
}
//确认
-(void)confirm{

  [self.delegate TCMyPublishDetailIntentionCellCtreateOrder:self.index andOption:@"确认"];
}
-(void)setShipperModel:(TCShipperModel *)shipperModel{
    _shipperModel=shipperModel;
    //意向公司
    [_industry setLabelText:shipperModel.designatedUserName];
    //报价时间
    [_offerDate setLabelText:shipperModel.bidDateStr];
    //总
    [_offer setLabelText:[NSString stringWithFormat:@"总报价量:%.1f %@",shipperModel.offerNum,shipperModel.sizeUnit]];
    //价格
    [_unitPrice setLabelText:[NSString stringWithFormat:@"单价:%.1f元/吨",shipperModel.offerPrice]];
    //车数量
    [_carNumber setLabelText:[NSString stringWithFormat:@"%d",shipperModel.carNum]];
    //价格
    [_totalPrice setLabelText:[NSString stringWithFormat:@"合计:%.2f",shipperModel.finalTotalPrice]];
    //联系人
    [_linkMan setLabelText:shipperModel.headName];
    //电话
    [_linkPhone setLabelText:shipperModel.phone];
    //生成订单的剩余时间
    leftTime=shipperModel.countdown/1000;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setLeftTime) userInfo:nil repeats:YES];
}

-(void)setLeftTime{
    if (leftTime<=0) {
        _leftTime.text=@"已生成订单";
        return;
    }
    NSInteger minute=leftTime/60;
    NSInteger second=(leftTime-minute*60);
    _leftTime.text=[NSString stringWithFormat:@"%ld分%ld秒后系统自动生成订单",minute,second];
    NSString*time=[NSString stringWithFormat:@"%ld分%ld秒",minute,second];
    //富文本，将时间变绿色
    [_leftTime setAttributeTextWithString:_leftTime.text range:NSMakeRange(0, time.length) WithColour:KTCGreen];
    leftTime--;
}
-(void)setIndex:(NSInteger)index{
    _index=index;
}
@end
