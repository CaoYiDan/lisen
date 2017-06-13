//
//  TCOrderTableViewCell.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/28.
//
//

#import "TCOrderTableViewCell.h"
#import "TCOrderModel.h"

#import "YYLabel.h"
@interface TCOrderTableViewCell ()
@property(nonatomic,strong) YYLabel*optionButton;
@property(nonatomic,assign) NSInteger indexPathRow;
@end

@implementation TCOrderTableViewCell
{
    YYLabel*_orderId;
    YYLabel*_status;
    YYLabel*_goodsName;
    YYLabel*_goodsWeight;
    
    YYLabel*_createDate;
    YYLabel*_distance;
    YYLabel*_car;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    //    static NSString *ID = @"cell";
    static NSString * const ROCBaseTicketCellId = @"ROCBaseTicketCell";
    
    TCOrderTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ROCBaseTicketCellId];
    
    if (cell == nil) {
        cell = [[TCOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ROCBaseTicketCellId];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpView];
    }
    return self;
}
-(void)setUpView{
    UIView*topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 10)];
    topLine.backgroundColor=LGLighgtBGroundColour235;
    [self.contentView addSubview:topLine];
    
    //订单编号
    _orderId=[YYLabel new];
    _orderId.frame=CGRectMake(10, 12, kWindowW/2+100,30);
    [self.contentView addSubview:_orderId];
    //中上的分割线
    UIView*line0=[[UIView alloc]initWithFrame:CGRectMake(0, 42, kWindowW, 2)];
    line0.backgroundColor=LGLighgtBGroundColour235;
    [self.contentView addSubview:line0];
    //订单状态
    _status=[YYLabel new];
    _status.textColor=[UIColor whiteColor];
    _status.backgroundColor=KTCGreen;
    _status.frame=CGRectMake(10, 42,120,20);
    [self.contentView addSubview:_status];
    //运输的货物名称
    _goodsName=[YYLabel new];
    _goodsName.frame=CGRectMake(10, 60,100,30);
    [self.contentView addSubview:_goodsName];
    //运输的货物重量
    _goodsWeight=[YYLabel new];
    _goodsWeight.frame=CGRectMake(20, 100,100,30);
    [self.contentView addSubview:_goodsWeight];
    //右边的创建时间
    _createDate=[YYLabel new];
    _createDate.frame=CGRectMake(kWindowW/2-5, 12,kWindowW/2, 30);
    [self.contentView addSubview:_createDate];
    
    //起点--终点
    _distance=[YYLabel new];
    _distance.frame=CGRectMake(60, 60, kWindowW-70, 30);
    [self.contentView addSubview:_distance];
    //用车信息
    _car=[YYLabel new];
    _car.frame=CGRectMake(70, 100 , kWindowW-80, 30);
    [self.contentView addSubview:_car];
    
    //中下的分割线
    UIView*line1=[[UIView alloc]initWithFrame:CGRectMake(0, 135, kWindowW, 2)];
    line1.backgroundColor=LGLighgtBGroundColour235;
    [self.contentView addSubview:line1];
    
    //操作按钮
    _optionButton=[YYLabel new];
    _optionButton.frame=CGRectMake(kWindowW-100, 138,90,26);
    WeakSelf;
    _optionButton .textTapAction=^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {//立即发布
        if ([weakSelf.delegate respondsToSelector:@selector(TCOrderTableViewCellOptionType:atIndexPathRow:)]) {//通过代理回传
            [weakSelf.delegate TCOrderTableViewCellOptionType:weakSelf.optionButton.text atIndexPathRow:weakSelf.indexPathRow];
        }
    };

    [self.contentView addSubview:_optionButton];
}

-(void)setLayout:(TCOrderCellLayout *)layout andIndexpathRow:(NSInteger)row{
    self.indexPathRow=row;
    self.layout=layout;
    //编号
    _orderId.attributedText=layout.orderIdText;
    //货物名称
    _goodsName.attributedText=layout.goodsNameText;
    //货物载重
    _goodsWeight.attributedText=layout.weightText;
    //订单状态
    _createDate.attributedText=layout.createDateText;
    //起点--终点
    _distance.attributedText=layout.distanceText;
    //用车信息
    _car.attributedText=layout.carText;
    if ([layout.model.statusFlag isEqualToString:@"待报价"]) {
        _optionButton.backgroundColor=KTCBlueColor;
    }else{
        _optionButton.backgroundColor=[UIColor whiteColor];
    }
    if (layout.switchType ==SwitchTypeMyPublishList) {
        _status.hidden=YES;//我的发布 没有此控件
    }else{
        //状态
        _status.attributedText=layout.statusText;
        _status.hidden=NO;
    }
    //操作按钮
    _optionButton.attributedText=layout.optionText;
}


@end
