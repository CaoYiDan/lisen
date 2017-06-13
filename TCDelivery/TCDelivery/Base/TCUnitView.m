//
//  TCUnitView.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/7.
//
//

#import "TCUnitView.h"
#import "TCImageArr.h"

@implementation TCUnitView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.unitImageView=[[UIImageView alloc]init];
        self.unitImageView .contentMode=UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.unitImageView];
        
        self.unitTextLabel=[[UILabel alloc]init];
        self.unitTextLabel.font=Font(13);

        self.unitTextLabel.adjustsFontSizeToFitWidth=YES;
        
        [self addSubview:self.unitTextLabel];
        

    }
    return self;
}

-(void)setType:(NSInteger)type{
    _type=type;
   
    if (type<10) {//右边的图片

        [self.unitTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(UIEdgeInsetsMake(0, 0, 0, 22));
        }];
        [self.unitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.size.offset(CGSizeMake(20, 20));
            make.top.offset(4);
        }];
        [self.unitImageView setImage:[UIImage imageNamed:[TCImageArr shareWithRightImageArr][type]]];
        self.unitTextLabel.textAlignment=NSTextAlignmentRight;
    }else{
        
        [self.unitTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(UIEdgeInsetsMake(0, 25, 0, 0));
        }];
        [self.unitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.size.offset(CGSizeMake(20, 20));
            make.top.offset(4);
        }];
        self.unitTextLabel.textAlignment=NSTextAlignmentLeft;
        [self.unitImageView setImage:[UIImage imageNamed:[TCImageArr shareWithLeftImageArr][type-10]]];
    }
}
-(void)setLabelText:(NSString*)text{
    if (isEmptyString(text)) {
        self.unitTextLabel.text=@"--";
    }else{
    self.unitTextLabel.text=text;
    }
}
@end
