//
//  TCOrderCellLayout.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/28.
//
//

#import "TCOrderCellLayout.h"
#import "TCOrderModel.h"
#import "NSAttributedString+YYText.h"
#import "YYLabel.h"

#define font   [UIFont systemFontOfSize:16]
@implementation TCOrderCellLayout

- (instancetype)initWithStatus:(TCOrderModel *)model andSwitchType:(SwitchType)switchType{
    if (!model ) return nil;
    self = [super init];
    _model = model;
    _switchType=switchType;
    [self layout];
    return self;
}
- (void)layout {
    //我的发布 现在直接返回。目前不再布局
    if (_switchType==SwitchTypeTransportList) {
        return;
    }
    
    //订单编号
    [self _layoutOrderId];
    //运输状态
    [self _layoutTranstStatus];
    //货物名称
    [self _layoutGoodsName];
    //货物重量
    [self _layoutGoodsWeight];
    //创建时间 或者 我的发布的发布状态
    [self _layoutCreateDateOrStatus];
    //路程的起始点
    [self _layoutDistance];
    //用车信息
    [self _layoutCar];
    //订单支付状态 或者 我的发布的操作按钮
    [self _layoutPayStatusOrOption];
}

#pragma  mark 订单编号
-(void)_layoutOrderId{
    NSMutableAttributedString *OrderIdText = [NSMutableAttributedString new];
    OrderIdText.yy_minimumLineHeight=20;
    OrderIdText.yy_maximumLineHeight=30;
   
    //订单号
    {
        //我的发布与我的订单，在布局上稍有不同
        NSString*imagePath=nil;
        NSString*dataStr=nil;
        if (_switchType==SwitchTypeMyPublishList) {//我的发布
            
            dataStr=[NSString stringWithFormat:@"截止日期:%@",_model.tenderEndTime];
            //只有待报价的状态此处才是-----截止日期的图标
            imagePath=@"fh_dd_xq_an13";
            
        }else if (_switchType==SwitchTypeMyOrderList){//我的订单
            dataStr=_model.orderNum;
            //订单号的图标
            imagePath=@"fh_dd_xq_an111";
        }
        
        UIImage *image = [UIImage imageNamed:imagePath];
        image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(20, 20) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        attachText.yy_alignment=NSTextAlignmentLeft;
        [OrderIdText appendAttributedString:attachText];
        
        [OrderIdText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",dataStr] attributes:nil]];
    }
    OrderIdText.yy_font=Font(12.5);
    OrderIdText.yy_alignment=NSTextAlignmentLeft;
    self.orderIdText= OrderIdText;
}
#pragma  mark 运输状态
-(void)_layoutTranstStatus{
    //运输状态
    NSMutableAttributedString *statusAttbuiteText = [NSMutableAttributedString new];
    {
        //我的发布没有此布局
        if (_switchType==SwitchTypeMyPublishList) {//我的发布
            
        }else if (_switchType==SwitchTypeMyOrderList){//我的订单
            NSMutableAttributedString*status=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.orderTransStatus]];
            status.yy_color=[UIColor whiteColor];
            status.yy_backgroundColor=KTCGreen;
            [statusAttbuiteText appendAttributedString:status];
        }
    }
    statusAttbuiteText.yy_font=Font(12.5);
    statusAttbuiteText.yy_alignment=NSTextAlignmentCenter;
    self.statusText= statusAttbuiteText;
}
#pragma  makr货物名称
-(void)_layoutGoodsName{
    // 货物名称
    NSMutableAttributedString *goodsNameAttbuiteText = [NSMutableAttributedString new];
    {
        NSMutableAttributedString*goodsName=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",_model.goodsName]];
        goodsName.yy_font=FontBold(12);
        [goodsNameAttbuiteText appendAttributedString:goodsName];
    }
    
    goodsNameAttbuiteText.yy_alignment=NSTextAlignmentCenter;
    self.goodsNameText= goodsNameAttbuiteText;
}
#pragma  mark 货物重量
-(void)_layoutGoodsWeight{
    //100吨
    NSMutableAttributedString *goodsWeightAttbuiteText = [NSMutableAttributedString new];
    {
        if (_switchType==SwitchTypeMyPublishList) {
            //校对一下重量单位
            if ([_model.weightUnit isEqualToString:@"吨"]) {
                [goodsWeightAttbuiteText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %.2f ",_model.goodsWeight] attributes:nil]];
                
                //重量
                UIImage *image = [UIImage imageNamed:@"fh_dd_xq_an1"];
                image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
                
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(20, 20) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                attachText.yy_alignment=NSTextAlignmentLeft;
                [goodsWeightAttbuiteText appendAttributedString:attachText];
                
            }else{
                //若重量单位不是吨，则直接拼接后台返回的重量单位
                [goodsWeightAttbuiteText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %.2f %@",_model.goodsWeight,_model.weightUnit] attributes:nil]];
            }
        }else{
            
            //校对一下重量单位
            if ([_model.sizeUnit isEqualToString:@"吨"]) {
                
                [goodsWeightAttbuiteText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %.2f ",_model.shipingNum] attributes:nil]];
                //重量
                UIImage *image = [UIImage imageNamed:@"fh_dd_xq_an1"];
                image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
                
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(20, 20) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                attachText.yy_alignment=NSTextAlignmentLeft;
                [goodsWeightAttbuiteText appendAttributedString:attachText];
                
            }else{
                //若重量单位不是吨，则直接拼接后台返回的重量单位
                [goodsWeightAttbuiteText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %.2f %@",_model.shipingNum,_model.sizeUnit] attributes:nil]];
            }
        }
    }
    
    goodsWeightAttbuiteText.yy_alignment=NSTextAlignmentCenter;
    self.weightText= goodsWeightAttbuiteText;
}
#pragma  mark 创建时间 或者 我的发布的发布状态
-(void)_layoutCreateDateOrStatus{
    NSMutableAttributedString *createDateText = [NSMutableAttributedString new];
    createDateText.yy_minimumLineHeight=20;
    createDateText.yy_maximumLineHeight=30;
    {
        if (_switchType==SwitchTypeMyPublishList) {
            [createDateText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.statusFlag] attributes:nil]];
        }else{
            UIImage *image = [UIImage imageNamed:@"fh_dd_xq_an13"];
            image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
            
            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(20, 20) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
            [createDateText appendAttributedString:attachText];
            NSLog(@"%@",_model.createDate);
            [createDateText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",_model.createDateStr] attributes:nil]];
        }
    }
    createDateText.yy_font=Font(12.5);
    createDateText.yy_alignment=NSTextAlignmentRight;
    self.createDateText= createDateText;
}
#pragma  mark  路程的起始点
-(void)_layoutDistance{
    //起点---终点
    NSMutableAttributedString *distanceTextLayoutText = [NSMutableAttributedString new];
    distanceTextLayoutText.yy_minimumLineHeight=20;
    distanceTextLayoutText.yy_maximumLineHeight=30;
    //起点
    {
        UIImage *image = [UIImage imageNamed:@"fh_dd_xq_an2"];
        image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(20, 20) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        
        [distanceTextLayoutText appendAttributedString:attachText];
        
        [distanceTextLayoutText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",_model.outCity] attributes:nil]];
    }
    //    箭头
    {
        UIImage *image = [UIImage imageNamed:@"fh_dd_an9"];
        image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(20, 20) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        
        [distanceTextLayoutText appendAttributedString:attachText];
    }
    
    //终点
    {
        UIImage *image = [UIImage imageNamed:@"fh_dd_xq_an2-1"];
        image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(20, 20) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [distanceTextLayoutText appendAttributedString:attachText];
        
        NSMutableAttributedString*end=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",_model.receiveCity]];
        end.yy_lineBreakMode= NSLineBreakByTruncatingTail;
        
        [distanceTextLayoutText appendAttributedString:end];
        
    }
    distanceTextLayoutText.yy_font=Font(12.5);
    distanceTextLayoutText.yy_alignment=NSTextAlignmentRight;
    self.distanceText= distanceTextLayoutText;
}
#pragma  mark 用车信息
-(void)_layoutCar{
    NSMutableAttributedString *carTextLayoutText= [NSMutableAttributedString new];
    carTextLayoutText.yy_minimumLineHeight=20;
    carTextLayoutText.yy_maximumLineHeight=30;
    //车类型
    {
        UIImage *image = [UIImage imageNamed:@"app_home_nav16"];
        image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(20, 20) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        //        attachText.yy_alignment=NSTextAlignmentRight;
        [carTextLayoutText appendAttributedString:attachText];
        
        [carTextLayoutText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",_model.carType] attributes:nil]];
    }
    //米
    {
        NSString*carLength=nil;
        if (_switchType==SwitchTypeMyPublishList) {
            
            carLength=[NSString stringWithFormat:@"%.1f",_model.carSize];
        }else{
           carLength= _model.carWeight;
        }
        
        [carTextLayoutText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",carLength] attributes:nil]];
        UIImage *image = [UIImage imageNamed:@"app_home_nav17"];
        image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(20, 20) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        //        attachText.yy_alignment=NSTextAlignmentRight;
        [carTextLayoutText appendAttributedString:attachText];
    }
    //辆
    {
        [carTextLayoutText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d ",_model.carNum] attributes:nil]];
        
        UIImage *image = [UIImage imageNamed:@"fh_dd_xq_an12"];
        image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(20, 20) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [carTextLayoutText appendAttributedString:attachText];
    }
    carTextLayoutText.yy_font=Font(12.5);
    carTextLayoutText.yy_alignment=NSTextAlignmentRight;
    self.carText= carTextLayoutText;
}
#pragma  mark 订单支付状态 或者 我的发布的操作按钮
-(void)_layoutPayStatusOrOption{
    NSMutableAttributedString *optionTextLayoutText= [NSMutableAttributedString new];
    
    if (_switchType==SwitchTypeMyPublishList) {
        
        if ([_model.statusFlag isEqualToString:@"待报价"]) {
            NSMutableAttributedString*section=[[NSMutableAttributedString alloc]initWithString:@"立即发布报价"];
            section.yy_backgroundColor=KTCBlueColor;
            [optionTextLayoutText appendAttributedString:section];
        }
        optionTextLayoutText.yy_color=[UIColor whiteColor];
    }else{
        NSMutableAttributedString*section=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",_model.payStatus]];
        [optionTextLayoutText appendAttributedString:section];
        optionTextLayoutText.yy_color=[UIColor blackColor];
    }
    
    optionTextLayoutText.yy_font=Font(11);
    optionTextLayoutText.yy_alignment=NSTextAlignmentCenter;
    self.optionText= optionTextLayoutText;

}

@end
