//
//  TCOrderCell.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/7.
//
//

#import "TCOrderCell.h"
#import "TCOrderModel.h"
#import "TCNewUnitView.h"
@implementation TCOrderCell
{
    TCNewUnitView*_orderId;
    TCNewUnitView*_orderDate;
    UILabel*_orderStatus;
    UILabel*_goodsName;
    TCNewUnitView*_weight;
    TCNewUnitView*_start;
    TCNewUnitView*_end;
    UILabel*_status;
    TCNewUnitView*_carType;
    TCNewUnitView*_carLength;
    TCNewUnitView*_carNumber;
    UIButton*_operationBtn;
    UILabel*_payStatus;
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    //    static NSString *ID = @"cell";
    static NSString * const ROCBaseTicketCellId = @"ROCBaseTicketCell";
    
    TCOrderCell*cell = [tableView dequeueReusableCellWithIdentifier:ROCBaseTicketCellId];
    
    if (cell == nil) {
        cell = [[TCOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ROCBaseTicketCellId];
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
        make.size.offset(CGSizeMake(kWindowW, 10));
        make.top.offset(0);
    }];
    
    //订单编号
    _orderId=[[TCNewUnitView alloc]init];
    _orderId.type=14;
    [self.contentView addSubview:_orderId];
    [_orderId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.height.offset(30);
        make.top.equalTo(line1.bottom);
    }];
    UIView*line0=[[UIView alloc]init];
    line0.backgroundColor=LGLighgtBGroundColour235;
    [self.contentView addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 1));
        make.top.equalTo(_orderId.bottom).offset(0);
    }];
    
    //订单创建的时间
    _orderDate=[[TCNewUnitView alloc]init];
    _orderDate.type=24;
    [self.contentView addSubview:_orderDate];
    [_orderDate  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-2);
        make.height.offset(30);
        make.top.equalTo(_orderId);
    }];
    //运输中
    _orderStatus=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, 100, 15)];
    _orderStatus.font=Font(11);
    _orderStatus.textColor=[UIColor whiteColor];
    _orderStatus.backgroundColor=KTCGreen;
    _orderStatus.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_orderStatus];
    //运输的货物
    _goodsName=[[UILabel alloc]init];
    
    _goodsName.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _goodsName.adjustsFontSizeToFitWidth=YES;
    [self.contentView addSubview:_goodsName];
    [_goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.size.offset(CGSizeMake(70, 20));
        make.top.equalTo(_orderStatus.bottom).offset(5);
    }];
    
    //终点
    _end=[[TCNewUnitView alloc]init];
    _end.type=11;
    
    [self.contentView addSubview:_end];
    [_end  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        //make.size.offset(CGSizeMake(55, 30));
        make.height.offset(30);
        make.top.equalTo(_goodsName);
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
    _start=[[TCNewUnitView alloc]init];
    _start.type=10;
    [self.contentView addSubview:_start];
    [_start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(accrowImage.left).offset(-5);
        make.height.offset(30);
        make.top.equalTo(_end);
    }];
    
    //使用车的数量
    _carNumber=[[TCNewUnitView alloc]init];
    _carNumber.type=2;
    [self.contentView addSubview:_carNumber];
    [_carNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.height.offset(30);
        make.top.equalTo(_goodsName.bottom).offset(15);
    }];
    
    //13.5米
    _carLength=[[TCNewUnitView alloc]init];
    _carLength.type=1;
    [self.contentView addSubview:_carLength];
    [_carLength mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_carNumber.left).offset(-5);
        make.height.offset(30);
        make.top.top.equalTo(_carNumber);
    }];
    //选择的车类型
    _carType=[[TCNewUnitView alloc]init];
    _carType.type=12;
    [self.contentView addSubview:_carType];
    [_carType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_carLength.left).offset(-5);
        make.height.offset(30);
        make.top.equalTo(_carLength);
    }];
    //100顿
    _weight=[[TCNewUnitView alloc]init];
//    _weight.type=0;
    [self.contentView addSubview:_weight];
    [_weight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsName);
        make.height.offset(30);
        make.top.equalTo(_carLength);
    }];
    UIView*line=[[UIView alloc]init];
        line.backgroundColor=LGLighgtBGroundColour235;
        [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 1));
        make.top.equalTo(_carNumber.bottom).offset(10);
    }];
    //右下角的状态
    UILabel*payStatus=[[UILabel alloc]init];
    _payStatus=payStatus;
    _payStatus.textColor=[UIColor blackColor];
    _payStatus.textAlignment=NSTextAlignmentCenter;
    payStatus.font=Font(12);
    [self.contentView addSubview:payStatus];
    [_payStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(5);
        make.height.offset(20);
        make.right.offset(-10);
    }];
}

//模型赋值
-(void)setOrderModel:(TCOrderModel *)orderModel{
    _orderModel=orderModel;
//我的发布模型赋值-----我的发布和我的订单模型有些出入，故不同的地方分开来写
    if (self.switchType==SwitchTypeMyPublishList) {
        //订单状态的字体色
        _payStatus.textColor=[UIColor whiteColor];
        //待报价的左上角的图标显示的是截止日期
        if([orderModel.statusFlag isEqualToString:@"待报价"]){
        _orderId.type=37;//待报价的左上角的图标显示的是截止日期
            
        [_orderId setLabelText:[NSString stringWithFormat:@"截止日期:%@",orderModel.tenderEndTime]];
             //订单状态的背景色--蓝色
            _payStatus.backgroundColor=KTCBlueColor;
        }else {
        _orderId.type=14;//其他的左上角的图标显示的是---号
            
        [_orderId setLabelText:[NSString stringWithFormat:@"订单号:%@",orderModel.tenderId]];
            if ([orderModel.statusFlag isEqualToString:@"报价中"]) {
                _payStatus.backgroundColor=KTCGreen;
            }else{
                _payStatus.backgroundColor=[UIColor grayColor];
            }
        }//隐藏
        _orderDate.hidden=YES;
        _orderStatus.hidden=YES;
        //运输的货物
        _goodsName.text=orderModel.goodsType;
        [_start setLabelText:orderModel.outProvince];
        [_end setLabelText:orderModel.receiveProvince];
        [_carNumber setLabelText:[NSString stringWithFormat:@"%d",orderModel.carNum]];
        if ([orderModel.weightUnit isEqualToString:@"吨"]) {
            _weight.type=0;
            //重量
            [_weight setLabelText:[NSString stringWithFormat:@"%.1f",orderModel.goodsWeight]];
        }else{
            _weight.type=4;
            //重量
            [_weight setLabelText:[NSString stringWithFormat:@"%.1f%@",orderModel.goodsWeight,orderModel.weightUnit]];
        }
        //右下角的状态
        _payStatus.text=orderModel.statusFlag;
        [_carType setLabelText:orderModel.carType];
//        [_carLength setLabelText:orderModel.carSize];
    }else{//我的订单模型赋值
    [_orderId setLabelText:[NSString stringWithFormat:@"订单号:%@",orderModel.orderNum]];
    [_orderDate setLabelText:orderModel.createDateStr];
        
    _orderStatus.text=orderModel.payStatus;
    
    _goodsName.text=orderModel.goodsType;
    [_start setLabelText:orderModel.outProvince];
    [_end setLabelText:orderModel.receiveProvince];
    [_carNumber setLabelText:[NSString stringWithFormat:@"%d",orderModel.carNum]];
        //校对一下重量单位
        if ([orderModel.sizeUnit isEqualToString:@"吨"]) {
            //重量
            _weight.type=0;
            [_weight setLabelText:[NSString stringWithFormat:@"%.2f",orderModel.tenderWeight]];
        }else{
            _weight.type=4;
            //重量
            [_weight setLabelText:[NSString stringWithFormat:@"%.2f%@",orderModel.tenderWeight,orderModel.sizeUnit]];
        }
        _payStatus.text=orderModel.payStatus;
        [_carType setLabelText:orderModel.carType];
//        [_carLength setLabelText:orderModel.carSize];
    }
}
@end
