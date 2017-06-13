//
//  MyHeaderView.m
//  LetsGo
//
//  Created by 融合互联-------lisen on 16/12/16.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "TCMyHeaderView.h"
#import "LSUpDownButton.h"

@interface TCMyHeaderView()<UIScrollViewDelegate>
@property(nonatomic,strong)UIView*noLoginView;
@property(nonatomic,strong)UIView*userView;
@end
@implementation TCMyHeaderView
{
    UIImageView*_imageView;
    UILabel*_name;
    UILabel*_commpentName;
    UILabel*_phone;
    UIButton*_confirmBtn;
    
    UILabel*_nonLoginTip;
    UIButton*_loginBtn;
    
    UIView*_lineView;
    UIView*_btnView;
    
    UIScrollView*_scrollowView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //获取用户信息
//        [self getUserMessage];
        [self setContentView];
    }
    return self;
}

//未登录的界面
-(UIView*)noLoginView{
    if (!_noLoginView) {
        
        UIView*vi=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 125)];
        vi.backgroundColor=LGLighgtBGroundColour235;
        UILabel*noLoginLab=[UILabel labelWithFont:Font(13) textColor:[UIColor blackColor] numberOfLines:1 textAlignment:NSTextAlignmentCenter];
        noLoginLab.text=@"您还没有登录";
        _nonLoginTip=noLoginLab;
        noLoginLab.frame=CGRectMake(kWindowW/2-50, 20, 100, 25);
        [vi addSubview:noLoginLab];
        
        UIButton*loginBtn=[UIButton borderButtonWithBackgroundColor:KMainColor title:@"点击此处登录" titleLabelFont:Font(14) titleColor:[UIColor whiteColor] target:self action:@selector(tap:) clipsToBounds:YES];
        _loginBtn=loginBtn;
        loginBtn.tag=120;
        loginBtn.frame=CGRectMake(kWindowW/2-80, 55, 160, 35);
        [vi addSubview:loginBtn];
        _noLoginView=vi;
        [self addSubview:vi];
    }
    return _noLoginView;
}
//登录过的用户信息界面
-(UIView*)userView{
    
    if (!_userView) {
        _userView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 100)];
        _userView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_userView];
        /** 左边的---”图片“*/
        _imageView=[[UIImageView alloc]init];
        _imageView.backgroundColor=KMainColor;
        _imageView.layer.cornerRadius=5;
        _imageView.layer.masksToBounds=YES;
        _imageView.userInteractionEnabled=YES;
        [_imageView setImage:[UIImage imageNamed:@"fh_an12"]];
        _imageView.frame=CGRectMake(10, 125/2-45, 70, 70);
        [_userView addSubview:_imageView];

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap)];
        tap.numberOfTapsRequired =1;
        //轻拍手指个数
        tap.numberOfTouchesRequired =1;
        [_imageView addGestureRecognizer:tap];
        
        /**公司名称*/
        _commpentName=[UILabel labelWithFont:Font(12) textColor:[UIColor whiteColor] numberOfLines:0 textAlignment:NSTextAlignmentLeft];
        _commpentName.textColor=[UIColor blackColor];
        _commpentName.frame=CGRectMake(95, 30, kWindowW-100, 20);
        //如果有名字，就写名字，没有名字就写手机号
        _commpentName.text=[StorageUtil getRealName];
        [_userView addSubview:_commpentName];
        /**手机号码*/
        _phone=[UILabel labelWithFont:Font(12) textColor:[UIColor whiteColor] numberOfLines:0 textAlignment:NSTextAlignmentLeft];
        _phone.textColor=[UIColor blackColor];
        _phone.frame=CGRectMake(95, 55, 130, 20);
        _phone.text=[StorageUtil getUserMobile];
        [_userView addSubview:_phone];
        //认证按钮
        _confirmBtn=[UIButton borderButtonWithBackgroundColor:[UIColor whiteColor] title:@"" titleLabelFont:Font(12) titleColor:[UIColor whiteColor] target:self action:@selector(btn:) clipsToBounds:YES];
        _confirmBtn.frame=CGRectMake(kWindowW-90, 60, 80, 26);
        [_userView addSubview:_confirmBtn];
    }
    return _userView;
}
- (void)imageTap{
    !self.MyHeaderblock? : self.MyHeaderblock(@"photo",130);
}
//刷新认证状态
-(void)refreshStatus{
    //用户认证状态
    NSString*btnText=nil;
    NSLog(@"%@",[StorageUtil getUserStatus]);
    if ([[StorageUtil getUserStatus]isEqualToString:APPLY_STATUS_CONFIRMED]) {
        btnText=@"已认证";
        _confirmBtn.backgroundColor=[UIColor orangeColor];
    }else if ([[StorageUtil getUserStatus]isEqualToString:APPLY_STATUS_APPLYING]){
        btnText=@"审核中";
        _confirmBtn.backgroundColor=KTCGreen;
    }else if ([[StorageUtil getUserStatus]isEqualToString:APPLY_STATUS_UNCONFIRMED]){
        btnText=@"未通过";
        _confirmBtn.backgroundColor=KTCGreen;
    }else{
        btnText=@"去认证";
        _confirmBtn.backgroundColor=KTCGreen;
    }
    [_confirmBtn setTitle:btnText forState:0];
}
//按钮---去认证
-(void)btn:(UIButton*)btn{
    if(![btn.titleLabel.text isEqualToString:@"审核中"]){
    !self.MyHeaderblock? : self.MyHeaderblock(btn.titleLabel.text,110);
  }
}
//点击登录按钮
-(void)myViewClick:(UIButton*)btn{
    !self.MyHeaderblock? : self.MyHeaderblock(@"order",120);
}
//布局UI
-(void)setContentView{
    UIView*header=nil;
    
    if (isEmptyString([StorageUtil getRoleId])){
        /** 未登录*/
        self.noLoginView.frame=CGRectMake(0, 0, kWindowW, 100);
        header=self.noLoginView;
    }else{
        //已登录
        self.userView.frame=CGRectMake(0, 0, kWindowW, 100);
        header=self.userView;
    }
    
    _lineView=[[UIView alloc]init];
    _lineView.backgroundColor=LGLighgtBGroundColour235;
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(header.bottom).offset(0);
        make.size.offset(CGSizeMake(kWindowW, 10));
    }];
   
    //三个可选择按钮
    [self creatOrderScrollView];
}

#pragma
-(void)creatOrderScrollView
{
    NSArray*textArr=@[@"我的发布",@"我的订单",@"我的运单"];

    for (int i=0; i<3; i++) {
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(i*kWindowW/3, 110, kWindowW/3, kWindowW/7)];
        [btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderWidth=0.5;
        btn.layer.borderColor=LGLighgtBGroundColour235.CGColor;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        btn.titleLabel.font=Font(14);
        [btn setTitle:textArr[i] forState:UIControlStateNormal];
        btn.tag=200+i;
        [self addSubview:btn];
    }
    UIView*bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, 110+kWindowW/7, kWindowW, 10)];
    bottomLine.backgroundColor=LGLighgtBGroundColour235;
    [self addSubview:bottomLine];
}

#pragma  mark  各类订单点击事件
-(void)tap:(UIButton*)btn{
    !self.MyHeaderblock? : self.MyHeaderblock(@"order",btn.tag);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        _scrollowView.scrollEnabled = NO;
    }
}

-(void)updateOrderNumberWith:(NSMutableArray *)numberArr{

}
- (void)setPhotoWithImagePath:(NSString *)photoImagePath{
    if (!isEmptyString(photoImagePath)) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:photoImagePath]];
        NSLog(@"%@",photoImagePath);
    }
}
-(void)setImage:(UIImage *)image{
    [_imageView setImage:image];
}
@end
