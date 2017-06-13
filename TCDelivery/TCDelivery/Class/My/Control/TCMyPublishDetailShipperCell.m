//
//  TCMyPublishDetailShipperCell.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/10.
//
//

#import "TCMyPublishDetailShipperCell.h"
#import "TCShipperModel.h"
#import "TCUnitView.h"
@implementation TCMyPublishDetailShipperCell
{
    UILabel*_industryIndex;
    UILabel*_industry;
    TCUnitView*_offer;
    TCUnitView*_unitPrice;
    TCUnitView*_offerDate;
    TCUnitView*_offerWeight;
    TCUnitView*_car;
    TCUnitView*_carNumber;
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
   
    //序列号
    _industryIndex=[[UILabel alloc]init];
    _industryIndex.backgroundColor=KTCBlueColor;
    _industryIndex .textAlignment=NSTextAlignmentCenter;
    _industryIndex.textColor=[UIColor whiteColor];
    [self addSubview:_industryIndex];
    [_industryIndex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.size.offset(CGSizeMake(20, 20));
        make.top.offset(10);
    }];
    //天程物流公司
    UILabel*industry=[[UILabel alloc]init];
    _industry=industry;
    industry.font=Font(12);
    [self addSubview:industry];
    [industry makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_industryIndex.right).offset(4);
        make.height.offset(20);
        make.top.offset(10);
    }];
    //报价
    _offer=[[TCUnitView alloc]init];
    _offer.type=28;
    [_offer setLabelText:@"报价量:"];
    [self addSubview:_offer];
    [_offer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_industryIndex);
        make.height.offset(30);
        make.top.equalTo(_industryIndex.bottom).offset(JianJu);
    }];
    //报价 吨
    _offerWeight=[[TCUnitView alloc]init];
    _offerWeight.type=0;
    [self addSubview:_offerWeight];
    [_offerWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_offer.right).offset(2);
        make.height.offset(30);
        make.top.equalTo(_offer);
    }];
    
    //单价
    _unitPrice=[[TCUnitView alloc]init];
    _unitPrice.type=29;
    [self addSubview:_unitPrice];
    [_unitPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.height.offset(30);
        make.top.equalTo(_offer);
    }];
    //选定
    _chose=[[UILabel alloc]init];
    _chose.text=@"选定";
    _chose.textAlignment=NSTextAlignmentCenter;
    _chose.layer.cornerRadius=5;
    _chose.clipsToBounds=YES;
    _chose .font=Font(12);
    _chose.textColor=[UIColor whiteColor];
    [self addSubview:_chose];
    [_chose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_unitPrice);
        make.size.offset(CGSizeMake(70, 20));
        make.top.equalTo(_industryIndex);
    }];
    
    
    //车辆信息
    _car=[[TCUnitView alloc]init];
    _car.type=35;
    [_car setLabelText:@"车辆数量:"];
    [self addSubview:_car];
    [_car mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_offer);
        make.height.offset(30);
        make.top.equalTo(_offerWeight.bottom).offset(JianJu);
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
    //报价时间
    _offerDate=[[TCUnitView alloc]init];
    _offerDate.type=37;
    [self addSubview:_offerDate];
    [_offerDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_industryIndex);
        make.height.offset(30);
        make.top.equalTo(_carNumber.bottom).offset(JianJu);
    }];
}

-(void)setModel:(TCShipperModel *)shiperModel andIndex:(NSInteger)index{
    //序列号
    _industryIndex.text=[NSString stringWithFormat:@"%ld",(long)index+1];
    //承运方公司名称
    _industry .text=shiperModel.designatedUserName;
    //吨
    [_offerWeight setLabelText:[NSString stringWithFormat:@"%.1f",shiperModel.offerNum]];
    //报价时间
    [_offerDate setLabelText:[NSString stringWithFormat:@"报价时间:%@",shiperModel.bidDateStr]];
    //报价车辆数量
    [_carNumber setLabelText:[NSString stringWithFormat:@"%d",shiperModel.carNum]];
    //单价
    [_unitPrice setLabelText:[NSString stringWithFormat:@"%.2f 元/吨",shiperModel.offerPrice]];

}
@end
