//
//  TCCertificateCell.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/4/19.
//
//

#import "TCCertificateCell.h"

@implementation TCCertificateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, kWindowW-20, 200)];
    self.image=image;
    
    image.contentMode=UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:image];
    
    UIButton*saveBtn=[[UIButton alloc]init];
    [saveBtn setTitle:@"保存凭证" forState:0];
    saveBtn.titleLabel.font=Font(13);
    saveBtn.backgroundColor=KTCBlueColor;
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.size.offset(CGSizeMake(100, 35));
        make.top.equalTo(image.bottom).offset(10);
    }];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor =LGLighgtBGroundColour235;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.size.offset(CGSizeMake(kWindowW, 1));
        make.top.equalTo(saveBtn.bottom).offset(10);
    }];
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl=imageUrl;
    [self.image sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
//保存图片
- (void)save{
    UIImage *image = self.image.image;
     UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    ToastSuccess(@"保存成功");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
