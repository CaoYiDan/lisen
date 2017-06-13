//
//  TCHomeHeaderView.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/3/10.
//
//

#import "TCHomeHeaderView.h"
#import "LSUpDownButton.h"
#import "SDCycleScrollView.h"
#define  bannerHeight kWindowW/1080*400
@interface  TCHomeHeaderView()<SDCycleScrollViewDelegate>
/**
 *  频道数组
 */
@property (nonatomic, strong) NSArray *channels;
//滚动banner
@property(nonatomic,strong)SDCycleScrollView *bannerView;
//轮播图数据数组
@property(nonatomic,strong)NSMutableArray *bannerArray;
@end
@implementation TCHomeHeaderView
{
    UIButton* _publishBtn;
    UIButton*_transportBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建轮播图
        [self bannerView];
        //可点击按钮
        [self setUpBtn];
    }
    return self;
}

//轮播图数据源
- (NSMutableArray*)bannerArray{
    if (_bannerArray==nil) {
        _bannerArray=[NSMutableArray array];
    }
    return _bannerArray;
}

- (NSArray *)channels {
    if(!_channels) {
        _channels = @[@"立即发货",@"运单管理",@"运输跟踪",@"确认收货"];
    }
    return _channels;
}

/**
 *  初始顶部标签栏
 */
- (void)setUpBtn
{
    /* header头部*/
    UIView*headerView=[[UIView alloc]init];
    headerView.backgroundColor=[UIColor whiteColor];
    CGFloat   width = kWindowW / 4;
    // 内部子标签
    NSInteger count = self.channels.count;
 NSArray*imageArr=@[@"app_home_nav5",@"app_home_nav6",@"app_home_nav7",@"app_home_nav8"];
    //创建四个可点击按钮
    for (NSInteger i = 0; i < count; i++) {
        
        LSUpDownButton *button = [[LSUpDownButton alloc] init];
        button.originX = i * width;
        button.frameWidth = width;
        button.originY=0;
        button.frameHeight = kWindowW/7;
        button.tag = i;
        button.layer.borderColor=LGLighgtBGroundColour235.CGColor;
        button.layer.borderWidth=1.0;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        NSString *channel = self.channels[i];
        [button setTitle:channel forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:KMainColor forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
    }
    headerView.frame=CGRectMake(0, bannerHeight, kWindowW,kWindowW/7);
    [self addSubview:headerView];
    UIView*orderView=[self orderNmuberView];
    orderView.frame=CGRectMake(0, bannerHeight+kWindowW/7, kWindowW, 40);
    [self addSubview:orderView];
}

//我的发布个数 和 我的运输个数
- (UIView *)orderNmuberView{
    //baseView
    UIView*sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 45)];
    sectionHeaderView.backgroundColor=[UIColor whiteColor];
    //我的订单
    UIButton*myPublish=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWindowW/2, 44)];
    [myPublish setImage:[UIImage imageNamed:@"add_an1"] forState:0];
    _publishBtn=myPublish;
    myPublish.titleLabel.font=Font(12);
    [myPublish setTitleColor:[UIColor blackColor] forState:0];
    [myPublish addTarget:self action:@selector(myPublishClick) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeaderView addSubview:myPublish];
    //我的发布
    UIButton*myTransport=[[UIButton alloc]initWithFrame:CGRectMake(kWindowW/2, 0, kWindowW/2, 44)];
    [myTransport setTitleColor:[UIColor blackColor] forState:0];
    [myTransport setImage:[UIImage imageNamed:@"app_home_nav16"] forState:0];
    _transportBtn=myTransport;
    myTransport.titleLabel.font=Font(12);
    [myTransport addTarget:self action:@selector(myTransportClick) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeaderView addSubview:myTransport];
    //中间的竖线
    UIView*line=[[UIView alloc]initWithFrame:CGRectMake(kWindowW/2-1, 0, 2, 44)];
    line.backgroundColor=LGLighgtBGroundColour235;
    [sectionHeaderView addSubview:line];
    //底部线
    UIView*line2=[[UIView alloc]initWithFrame:CGRectMake(0, 44, kWindowW, 1)];
    line2.backgroundColor=LGLighgtBGroundColour235;
    [sectionHeaderView addSubview:line2];
    //底部线
    UIView*line3=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 1)];
    line3.backgroundColor=LGLighgtBGroundColour235;
    [sectionHeaderView addSubview:line3];
    return sectionHeaderView;
}

#pragma mark block  回传点击事件

- (void)myPublishClick{
     [self backClickTag:120];
}

- (void)myTransportClick{
     [self backClickTag:121];
}

#pragma  mark block回传点击事件

- (void)titleClick:(UIButton*)btn{
    [self backClickTag:btn.tag];
}

/**
 代理回传
 @return void
 */
#pragma  mark 代理回传
- (void)backClickTag:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(TCHomeHeaderViewCilck:)]) {
        [self.delegate TCHomeHeaderViewCilck:tag];
    }
}

//轮播图
- (SDCycleScrollView *)bannerView{
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,kWindowW,bannerHeight) imageURLStringsGroup:self.bannerArray];
        _bannerView.currentPageDotColor=kRGBColor(178, 27, 27);
        _bannerView.pageDotColor=kRGBColor(216, 141, 141);
        _bannerView.bannerImageViewContentMode=UIViewContentModeScaleToFill;
        _bannerView.infiniteLoop = YES;
        _bannerView.delegate = self;
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _bannerView.autoScrollTimeInterval = 3;
        [self addSubview:_bannerView];
    }
    return _bannerView;
}

#pragma mark  轮播点击事件

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
}

#pragma  mark 赋值

- (void)createByBannerArray:(NSMutableArray *)bannerArr andPublishNum:(NSInteger)publishNumber transportNum:(NSInteger)transportNumber{
  self.bannerView.imageURLStringsGroup=bannerArr;
  [_publishBtn setTitle:[NSString stringWithFormat:@"  我的发布%ld条",(long)publishNumber] forState:0];
  [_transportBtn setTitle:[NSString stringWithFormat:@"  正在运输%ld条",(long)transportNumber] forState:0];
}
@end
