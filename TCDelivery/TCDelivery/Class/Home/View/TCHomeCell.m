//
//  TCHomeCell.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/6.
//
//

#import "TCHomeCell.h"
#import "TCUnitView.h"
#import "TCOrderModel.h"
@implementation TCHomeCell
{
    UILabel*_leftTitle;
    UILabel*_goodsName;
    TCUnitView*_weight;
    TCUnitView*_start;
    TCUnitView*_end;
    UILabel*_status;
    TCUnitView*_carType;
    TCUnitView*_carLength;
    TCUnitView*_carNumber;
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"TCHomeCellID";
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell=[[TCHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
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
    UIView*topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 10)];
    topLine.backgroundColor=LGLighgtBGroundColour235;
    [self.contentView addSubview:topLine];
    
    //左上角的标题
    _leftTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 100, 15)];
    _leftTitle.font=Font(11);
    _leftTitle.textColor=[UIColor whiteColor];
    _leftTitle.backgroundColor=KTCGreen;
    _leftTitle.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_leftTitle];
    //运输的货物
    _goodsName=[[UILabel alloc]init];
    _goodsName.font=FontBold(13);
    
    [self.contentView addSubview:_goodsName];
    [_goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.size.offset(CGSizeMake(60, 20));
        make.top.equalTo(_leftTitle.bottom).offset(5);
    }];
    
    //终点
    _end=[[TCUnitView alloc]init];
    _end.type=11;
    
    [self.contentView addSubview:_end];
    [_end  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.height.offset(30);
        make.top.offset(25);
    }];
    //箭头
    UIImageView*accrowImage=[[UIImageView alloc]init];
    [accrowImage setImage:[UIImage imageNamed:@"app_home_nav25"]];
    [self.contentView addSubview:accrowImage];
    [accrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_end.left).offset(-5);
        make.centerY.equalTo(_end);
        make.size.offset(CGSizeMake(40, 15));
    }];
    //起点
    _start=[[TCUnitView alloc]init];
    _start.type=10;
    [self.contentView addSubview:_start];
    [_start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(accrowImage.left).offset(-5);
        make.height.offset(30);
        make.top.equalTo(_end);
    }];

    //使用车的数量
    _carNumber=[[TCUnitView alloc]init];
    _carNumber.type=2;
    [self.contentView addSubview:_carNumber];
    [_carNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_end);
         make.height.offset(30);
        make.top.equalTo(_goodsName.bottom).offset(5);
    }];
    
    //13.5米
    _carLength=[[TCUnitView alloc]init];
    _carLength.type=1;
    [self.contentView addSubview:_carLength];
    [_carLength mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_carNumber.left).offset(-5);
         make.height.offset(30);
        make.top.top.equalTo(_carNumber);
    }];
    //选择的车类型
    _carType=[[TCUnitView alloc]init];
    _carType.type=12;
    [self.contentView addSubview:_carType];
    [_carType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_carLength.left).offset(-2);
        make.height.offset(30);
        make.top.equalTo(_goodsName.bottom).offset(5);
    }];
    //100顿
    _weight=[[TCUnitView alloc]init];
    [self.contentView addSubview:_weight];
    [_weight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsName);
        make.height.offset(30);
        make.top.top.equalTo(_goodsName.bottom).offset(5);
    }];

    //订单状态
    _status=[[UILabel alloc]init];
    _status.font=Font(12);
    _status.textColor=KTCGreen;
    [self.contentView addSubview:_status];
    if(kiPhone6||kiPhone6Plus){
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weight.right).offset(20);
        make.size.offset(CGSizeMake(50, 30));
        make.top.equalTo(_goodsName);
    }];
    }else{
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.size.offset(CGSizeMake(50, 30));
        make.top.offset(5);
    }];
    }
}

-(void)setOrderModel:(TCOrderModel *)orderModel
{
    _orderModel=orderModel;
    //订单号
    _leftTitle.text=orderModel.orderNum;
    //运输的货物
    _goodsName.text=orderModel.goodsName;
    //装货地址
    [_start setLabelText:orderModel.outCity];
    //卸货地址
    [_end setLabelText:orderModel.receiveCity];
    //需要的车数量
    [_carNumber setLabelText:[NSString stringWithFormat:@"%d",orderModel.carNum]];
    if ([orderModel.sizeUnit isEqualToString:@"吨"]) {
        _weight.type=0;
        //重量
        [_weight setLabelText:[NSString stringWithFormat:@"%.2f",orderModel.shipingNum]];
    }else{
        _weight.type=4;
        //重量
        [_weight setLabelText:[NSString stringWithFormat:@"%.2f%@",orderModel.shipingNum,orderModel.sizeUnit]];
    }
    //长度
    [_carLength setLabelText:orderModel.carWeight];
    //车类型
    [_carType setLabelText:orderModel.carType];
    //顶单状态
    _status.text=orderModel.orderTransStatus;
}
@end
