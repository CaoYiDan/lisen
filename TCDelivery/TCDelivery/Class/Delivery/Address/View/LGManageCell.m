//
//  LGManageCell.m
//  LetsGo
//
//  Created by XJS_oxpc on 16/5/30.
//  Copyright © 2016年 XJS_oxpc. All rights reserved.
//

#import "LGManageCell.h"
@interface LGManageCell()

@end

@implementation LGManageCell

+ (instancetype)tableViewCellWithTableView:(UITableView *)tableView with:(NSIndexPath*)index
{
    static NSString *identifier = @"managerCell";
    LGManageCell *cell = [tableView cellForRowAtIndexPath:index];
    if (cell == nil) {
        cell = [[LGManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.multipleSelectionBackgroundView = [[UIView alloc] init];
        cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
        
    }
    
    return cell;
}

- (void)setAddressInfo:(LGAddressInfo *)addressInfo with:(NSIndexPath*)index{
    
    _addressInfo = addressInfo;
    //背景白色
    _indexPath=index;
    UIView*view=[[UIView alloc]init];
    [self addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self) .offset(UIEdgeInsetsMake(00, 0, 0, 0));
    }];
    //姓名
    UILabel*Namelab=[[UILabel alloc]init];
    Namelab.text=addressInfo.receiver;
    Namelab.font=[UIFont systemFontOfSize:14];
    [view addSubview:Namelab];
    self.Name=Namelab;
    [Namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(10);
        make.width.offset(120);
        make.height.offset(20);
    }];
    //手机号码
    UILabel*Tellab=[[UILabel alloc]init];
    Tellab.text=addressInfo.phoneNumber;
    [view addSubview:Tellab];
    
    self.Phone=Tellab;
    Tellab.font=[UIFont systemFontOfSize:14];
    [Tellab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Namelab.top).offset(0);
        make.right.equalTo(self.right).offset(-15);
        make.size.offset(CGSizeMake(Width(150), Height(20)));
    }];
 
   
    
    //默认按钮
    UIButton*button=[[UIButton alloc]init];
       [view addSubview:button];
    
    self.yesMark=button;
    self.yesMark.tag=index.row+200;
    NSLog(@"%ld",(long)self.yesMark.tag);
    [self.yesMark addTarget:self action:@selector(setDefaukt:) forControlEvents:UIControlEventTouchUpInside];
  
    
    
    //编辑按钮
    UIButton*editor=[[UIButton alloc]init];
    editor.backgroundColor=[UIColor whiteColor];
    [editor setTitle:@"编辑" forState:UIControlStateNormal];
    editor.layer.borderColor=[UIColor redColor].CGColor;
    editor.titleLabel.font=Font(12);
    editor.layer.borderWidth=1.0;
    [editor setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [editor addTarget:self action:@selector(editor) forControlEvents:UIControlEventTouchUpInside];
    editor.layer.cornerRadius=5;

    [view addSubview:editor];
    
    
    
    
    [editor mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-2);
        make.size.offset(CGSizeMake(90, 32));
        make.bottom.offset(-2);
        
    }];
  
    
    //默认地址
    UILabel*Addreslab=[[UILabel alloc]init];
    [view addSubview:Addreslab];
    Addreslab.font=Font(13);
    Addreslab.numberOfLines=1;
    self.address=Addreslab;
    [Addreslab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(Namelab.bottom).offset(5);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).equalTo(0);
        
    }];
    if ([addressInfo.defaultAddress isEqualToString:@"DEFAULT"]) {
//        self.yesMark.selected = YES;
        
        self.Phone.textColor = [UIColor blackColor];
        self.address.textColor = [UIColor blackColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
         NSString*str = [NSString stringWithFormat:@"[默认] %@ %@", addressInfo.location, addressInfo.detailAddress];
        self.address.text=str;
        [self.address setAttributeTextWithString:str range:NSMakeRange(0, 4) WithColour:[UIColor redColor]];
        [self.yesMark setImage:[UIImage
                          imageNamed:@"flight_butn_check_select"] forState:UIControlStateNormal];
        
    } else  {
//        self.yesMark.selected = NO;
        self.Phone.textColor = [UIColor darkGrayColor];
        self.address.textColor = [UIColor darkGrayColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
         self.address.text = [NSString stringWithFormat:@"%@ %@", addressInfo.location, addressInfo.detailAddress];
        [self.yesMark setImage:[UIImage
                          imageNamed:@"flight_butn_check_unselect"] forState:UIControlStateNormal];
    }
    
    UIView*line=[[UIView alloc]init];
    line.backgroundColor=LGLighgtBGroundColour235;
    [view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 1));
        make.top.equalTo(Addreslab.bottom).offset(5);
    }];
    
   //默认地址
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(-2);
        make.left.equalTo(self).offset(10);
        make.size.offset(CGSizeMake(120, 30));
    }];
    [button setTitle:@"设置为默认地址" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth=YES;
    self.Phone.text = addressInfo.phoneNumber;
    self.Name.text=addressInfo.receiver;
   
}
#pragma  mark 设置为默认地址
-(void)setDefaukt:(UIButton*)btn{
    NSLog(@"%ld",(long)btn.tag);
   self.clickblock(btn.tag);
}

-(void)setFrame:(CGRect)frame{
    frame.size.height-=10;
    [super setFrame:frame];
}

-(void)editor{
    self.clickblock(self.indexPath.row);
}
@end
