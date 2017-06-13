//
//  TCOrderCell.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/7.
//
//

#import "TCTransportListCell.h"
#import "TCOrderModel.h"
#import "TCUnitView.h"
@implementation TCTransportListCell
{
    TCUnitView*_orderId;
    TCUnitView*_orderStatus;
    UILabel*_industry;
    TCUnitView*_weight;
    TCUnitView*_deliveryData;
    TCUnitView*_weightTitle;
    TCUnitView*_driver;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    //    static NSString *ID = @"cell";
    static NSString * const TCTransportListCellId = @"TCTransportListCell";
    
    TCTransportListCell*cell = [tableView dequeueReusableCellWithIdentifier:TCTransportListCellId];
    
    if (cell == nil) {
        cell = [[TCTransportListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TCTransportListCellId];
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
    UIView*line1=[[UIView alloc]init];
    line1.backgroundColor=LGLighgtBGroundColour235;
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 15));
        make.top.offset(0);
    }];
    
    //订单编号
    _orderId=[[TCUnitView alloc]initWithFrame:CGRectMake(10, 15, 200, 30)];
    _orderId.type=14;
    [self.contentView addSubview:_orderId];
    //订单状态
    _orderStatus=[[TCUnitView alloc]init];
    _orderStatus.type=12;
    [self.contentView addSubview:_orderStatus];
    [_orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.height.offset(30);
        make.top.equalTo(_orderId);
    }];
    
    UIView*line0=[[UIView alloc]init];
    line0.backgroundColor=LGLighgtBGroundColour235;
    [self.contentView addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 3));
        make.top.equalTo(_orderId.bottom).offset(0);
    }];
    
    //公司
    _industry=[[UILabel alloc]init];
    _industry.font=FontBold(13);
    _industry.numberOfLines=3;
    _industry.adjustsFontSizeToFitWidth=YES;
    [self.contentView addSubview:_industry];
    [_industry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.size.offset(CGSizeMake(80, 40));
        make.top.equalTo(line0.bottom).offset(10);
    }];
    
    //司机
    _driver=[[TCUnitView alloc]init];
    _driver.type=16;
    [self.contentView addSubview:_driver];
    [_driver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.height.offset(30);
        make.top.equalTo(line0.bottom).offset(10);
    }];
    
    //100吨
    _weight=[[TCUnitView alloc]init];
//    _weight.type=0;
    [self.contentView addSubview:_weight];
    [_weight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_driver.left).offset(-8);
        make.height.offset(30);
        make.top.equalTo(_driver);
    }];
    //载重
    _weightTitle=[[TCUnitView alloc]init];
    _weightTitle.type=15;
    [_weightTitle setLabelText:@"运输量:"];
    [self.contentView addSubview:_weightTitle];
    [_weightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_weight.left).offset(-5);
        make.height.offset(30);
        make.top.equalTo(_weight);
    }];
    
    //发货时间
    _deliveryData=[[TCUnitView alloc]init];
    _deliveryData.type=39;
    [self.contentView addSubview:_deliveryData];
    [_deliveryData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_driver);
        make.height.offset(30);
        make.top.equalTo(_weightTitle.bottom).offset(5);
    }];
}
-(void)setOrderModel:(TCOrderModel *)orderModel
{
    _orderModel=orderModel;
    //承运方公司
    _industry.text=orderModel.cyfName;
    //运单号
    [_orderId setLabelText:[NSString stringWithFormat:@"运单号 %@",orderModel.orderDetailsNum]];
    //运单状态
    [_orderStatus setLabelText:orderModel.transStatus];
    //校对一下重量单位
    if ([orderModel.sizeUnit isEqualToString:@"吨"]) {
        _weight.type=0;
        //重量
        [_weight setLabelText:[NSString stringWithFormat:@"%.2f",orderModel.actualNum]];
    }else{
        _weight.type=4;
        //重量
        [_weight setLabelText:[NSString stringWithFormat:@"%.2f%@",orderModel.actualNum,orderModel.sizeUnit]];
    }
    //司机
    [_driver setLabelText:[NSString stringWithFormat:@"%@",orderModel.driverName]];
    //发货的时间
    [_deliveryData setLabelText:[NSString stringWithFormat:@"发货时间:%@",orderModel.deliverTimeStr]];
    
}
@end
