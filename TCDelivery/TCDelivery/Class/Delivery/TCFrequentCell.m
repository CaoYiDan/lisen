//
//  TCFrequentCell.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/5/3.
//
//
#import "TCLinkModel.h"
#import "TCFrequentCell.h"

@interface TCFrequentCell()

@property (weak, nonatomic) UIButton *yesMark;
@property (weak, nonatomic)  UILabel *Phone;
@property (weak, nonatomic)  UILabel *address;
@property (weak, nonatomic)  UILabel *name;
@property (nonatomic, strong) TCLinkModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIButton *defaultBtn;
@property (nonatomic, strong) UIImageView *tickImageView;
@end
@implementation TCFrequentCell

+ (instancetype)tableViewCellWithTableView:(UITableView *)tableView with:(NSIndexPath*)index
{
    static NSString *identifier = @"FrequentCell";
    TCFrequentCell *cell = [tableView cellForRowAtIndexPath:index];
    if (cell == nil) {
        cell = [[TCFrequentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.multipleSelectionBackgroundView = [[UIView alloc] init];
        cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UIImageView *tickImageView=[[UIImageView alloc]init];
    [tickImageView setImage:[UIImage imageNamed:@"agree"]];
    self.tickImageView=tickImageView;
    [self.contentView addSubview:tickImageView];
    [tickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.width.offset(20);
        make.height.offset(20);
        make.centerY.offset(0);
    }];
    
    //姓名
    UILabel*nameLabel=[[UILabel alloc]init];
    nameLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:nameLabel];
    self.name=nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.equalTo(tickImageView.right).offset(5);
        make.width.offset(120);
        make.height.offset(20);
    }];
    //手机号码
    UILabel*telLab=[[UILabel alloc]init];
    [self.contentView addSubview:telLab];
    
    self.Phone=telLab;
    telLab.font=[UIFont systemFontOfSize:14];
    [telLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.top).offset(0);
        make.right.equalTo(self.right).offset(-15);
        make.size.offset(CGSizeMake(150,20));
    }];
    
    //编辑按钮
    UIButton*editor=[[UIButton alloc]init];
    editor.backgroundColor=[UIColor whiteColor];
    [editor setTitle:@"编辑" forState:UIControlStateNormal];
    editor.layer.borderColor=[UIColor redColor].CGColor;
    editor.titleLabel.font=Font(11);
    editor.layer.borderWidth=1.0;
    [editor setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [editor addTarget:self action:@selector(editor) forControlEvents:UIControlEventTouchUpInside];
    editor.layer.cornerRadius=5;
    [self.contentView addSubview:editor];
    [editor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-2);
        make.size.offset(CGSizeMake(60, 32));
        make.centerY.offset(0);
    }];
    
    //地址
    UILabel*Addreslab=[[UILabel alloc]init];
    [self.contentView addSubview:Addreslab];
    Addreslab.font=Font(13);
    Addreslab.numberOfLines=2;
    self.address=Addreslab;
    [Addreslab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.bottom).offset(5);
        make.left.equalTo(nameLabel);
        make.right.equalTo(self).equalTo(-63);
    }];

    self.Phone.textColor = [UIColor blackColor];
    self.address.textColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.yesMark setImage:[UIImage
                                imageNamed:@"flight_butn_check_select"] forState:0];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = LGLighgtBGroundColour235;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.size.offset(CGSizeMake(kWindowW, 1));
        make.bottom.offset(0);
    }];
}
//
- (void)setLinkInfo:(TCLinkModel *)info with:(NSIndexPath*)index{
    
    _model = info;
    //行数
    _indexPath=index;
    
    self.name.text=info.receiveName;
    self.Phone.text=info.receiveTel;
    
    if (info.defaultFlag == 1) {
        
        self.address.text=[NSString stringWithFormat:@"默认 %@%@%@%@",info.receiveProvince,info.receiveCity,info.receiveCounty,info.receiveAddress];
        [self.address setAttributeTextWithString:self.address.text range:NSMakeRange(0, 2) WithColour:[UIColor redColor]];
    }else{
        self.address.text=[NSString stringWithFormat:@"%@%@%@%@",info.receiveProvince,info.receiveCity,info.receiveCounty,info.receiveAddress];
    }
}
- (void)haveSelectedReceiverId:(NSString *)receiverId{
    if ([receiverId isEqualToString:_model.receiverId]) {
        _tickImageView.hidden = NO;
    }else{
        _tickImageView.hidden = YES;
    }
}

#pragma  mark 设置为默认地址
-(void)setDefaukt:(UIButton*)btn{
    NSLog(@"%ld",(long)btn.tag);
    self.TCFrequentBlock(btn.tag);
}

-(void)editor{
    !self.TCFrequentBlock?:self.TCFrequentBlock(self.indexPath.row);
}
@end
