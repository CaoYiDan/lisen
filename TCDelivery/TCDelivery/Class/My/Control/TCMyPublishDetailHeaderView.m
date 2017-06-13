//
//  TCMyPublishDetailHeaderView.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/10.
//
//

#import "TCMyPublishDetailHeaderView.h"
#import "TCUnitView.h"
#import "TCOrderModel.h"
#define  margin 0
@implementation TCMyPublishDetailHeaderView
{
    UILabel*_goodsName;
    TCUnitView*_deliveryPersen;
    TCUnitView*_deliveryPhone;
    TCUnitView*_getPerson;
    TCUnitView*_getPhone;
    TCUnitView*_weightTitle;
    TCUnitView*_weight;
    TCUnitView*_volume;
    UILabel*_descrption;
    TCUnitView*_loadAddres;
    TCUnitView*_unloadAddres;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    //货物名称
    _goodsName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 25)];
    _goodsName.textAlignment=NSTextAlignmentCenter;
    _goodsName.backgroundColor=LGLighgtBGroundColour235;
    [self addSubview:_goodsName];
    //发货人
    _deliveryPersen=[[TCUnitView alloc]init];
    _deliveryPersen.type=18;
    [self addSubview:_deliveryPersen];
    [_deliveryPersen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.height.offset(30);
        make.top.equalTo(_goodsName.bottom).offset(10);
    }];
    //发货人电话
    _deliveryPhone=[[TCUnitView alloc]init];
    _deliveryPhone.type=20;
    [self addSubview:_deliveryPhone];
    [_deliveryPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.height.offset(30);
        make.top.equalTo(_goodsName.bottom).offset(10);
    }];
    //收货人
    _getPerson=[[TCUnitView alloc]init];
    _getPerson.type=19;
    [self addSubview:_getPerson];
    [_getPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_deliveryPersen);
        make.height.offset(30);
        make.top.equalTo(_deliveryPersen.bottom).offset(margin);
    }];
    
    //收货人电话
    _getPhone=[[TCUnitView alloc]init];
    _getPhone.type=20;
    [self addSubview:_getPhone];
    [_getPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_deliveryPhone);
        make.height.offset(30);
        make.top.equalTo(_getPerson);
    }];
    //分割线
    UIView*line0=[[UIView alloc]init];
    line0.backgroundColor=LGLighgtBGroundColour235;
    [self addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 2));
        make.top.equalTo(_getPerson.bottom).offset(10);
    }];
    //重量
    _weightTitle=[[TCUnitView alloc]init];
    _weightTitle.type=27;
    [_weightTitle setLabelText:@"重量:"];
    [self addSubview:_weightTitle];
    [_weightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_deliveryPersen);
        make.height.offset(30);
        make.top.equalTo(line0.bottom).offset(10);
    }];
    //吨
    _weight=[[TCUnitView alloc]init];
    
    [self addSubview:_weight];
    [_weight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weightTitle.right).offset(4);
        make.height.offset(30);
        make.top.equalTo(_weightTitle);
    }];
    //体积
    _volume=[[TCUnitView alloc]init];
    _volume.type=26;
    [self addSubview:_volume];
    [_volume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_getPhone);
        make.height.offset(30);
        make.top.equalTo(_weightTitle);
    }];
    //描述小图标
    UIImageView*image=[[UIImageView alloc]init];
    [image setImage:[UIImage imageNamed:@"fh_fbxq_ybj_an18"]];
    [self addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_deliveryPersen);
        make.size.offset(CGSizeMake(20, 20));
        make.top.equalTo(_weightTitle.bottom).offset(5);
    }];
    //描述字体
    _descrption=[[UILabel alloc]init];
    _descrption.numberOfLines=0;
    _descrption.font=Font(12);
    _descrption.tag=333;//设置为333时，字体的大小不会根据屏幕尺寸变化。以确保计算的描述的高度准确度不会出现大偏差。
    [self addSubview:_descrption];
    [_descrption mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.right).offset(4);
        make.width.offset(kWindowW-50);
        make.top.equalTo(_weightTitle.bottom).offset(5);
    }];
    //分割线
    UIView*line1=[[UIView alloc]init];
    line1.backgroundColor=LGLighgtBGroundColour235;
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 2));
        make.top.equalTo(_descrption.bottom).offset(10);
    }];
    //装货地址
    _loadAddres=[[TCUnitView alloc]init];
    _loadAddres.type=23;
    [self addSubview:_loadAddres];
    [_loadAddres mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_getPerson);
        make.height.offset(30);
        make.top.equalTo(line1.bottom).offset(4);
    }];
    //卸货地址
    _unloadAddres=[[TCUnitView alloc]init];
    _unloadAddres.type=22;
    [self addSubview:_unloadAddres];
    [_unloadAddres mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_getPerson);
        make.height.offset(30);
        make.top.equalTo(_loadAddres.bottom).offset(margin);
    }];
}

-(void)setModel:(TCOrderModel *)model{
    _model=model;
    //运输的货物名
    _goodsName .text=[NSString stringWithFormat:@"%@--%@",model.goodsType,model.goodsName];
    //发货人
    [_deliveryPersen setLabelText:[NSString stringWithFormat:@"发货人:%@",model.outName]];
    //发货人电话
    [_deliveryPhone setLabelText:[NSString stringWithFormat:@"电话:%@",model.outTel]];
    //收货人
    [_getPerson setLabelText:[NSString stringWithFormat:@"收货人:%@",model.receiveName]];
    //收货人电话
    [_getPhone setLabelText:[NSString stringWithFormat:@"电话:%@",model.receiveTel]];
    //吨
    if ([model.weightUnit isEqualToString:@"吨"]) {
        _weight.type=0;
        [_weight setLabelText:[NSString stringWithFormat:@"%.2f",model.goodsWeight]];

    }else{
        //单位不是吨
        _weight.type=4;
        [_weight setLabelText:[NSString stringWithFormat:@"%.2f%@",model.goodsWeight,model.weightUnit]];
    }
     //体积
    if (model.goodsSize==0) {
        [_volume setLabelText:@"/"];
    }else{
   
    [_volume setLabelText:[NSString stringWithFormat:@"%.1f%@",model.goodsSize,model.sizeUnit]];
    }
    //描述
    _descrption.text=[NSString stringWithFormat:@"描述:%@",model.remarks];
    //装货地址
    [_loadAddres setLabelText:[NSString stringWithFormat:@"%@ %@ %@ %@",model.outProvince,model.outCity,model.outCounty,model.outAddress]];
    //卸货地址
    [_unloadAddres setLabelText:[NSString stringWithFormat:@"%@ %@ %@ %@",model.receiveProvince,model.receiveCity,model.receiveCounty,model.receiveAddress]];
}
@end
