//
//  TCBaseTextView.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/6.
//
//

#import "TCBaseTextView.h"
@interface TCBaseTextView()
@property(nonatomic,strong)UILabel*textLabel;
@end
@implementation TCBaseTextView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel=[[UILabel alloc]init];
        self.textLabel.font=Font(13);
        self.textLabel.adjustsFontSizeToFitWidth=YES;
        [self addSubview:_textLabel];
        self.textFiled=[[UITextField alloc]init];
        
        self.textFiled.borderStyle = UITextBorderStyleNone;
        self.textFiled.font=Font(13);
        self.textFiled.layer.borderColor=[UIColor grayColor].CGColor;
        self.textFiled.layer.borderWidth=0.6f;
        self.textFiled.layer.cornerRadius=5;
        self.textFiled.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_textFiled];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    if (self.type==1) {
        self.textLabel.frame=CGRectMake(0, 0,70, self.frameHeight);
        self.textFiled.frame=CGRectMake(80, 0, self.frameWidth-80, self.frameHeight);
    }else if(self.type==2){
        self.textLabel.frame=CGRectMake(0, 0,70, self.frameHeight);
        self.textFiled.frame=CGRectMake(80, 0, self.frameWidth-80, self.frameHeight);
        self.textLabel.textAlignment=NSTextAlignmentRight;
    }else if(self.type==3){
        self.textLabel.frame=CGRectMake(0, 0,70, self.frameHeight);
        self.textFiled.frame=CGRectMake(80, 0, self.frameWidth-80, self.frameHeight);
        self.textLabel.textAlignment=NSTextAlignmentCenter;
    }else{
    self.textLabel.frame=CGRectMake(0, 0, 40, self.frameHeight);
        self.textFiled.frame=CGRectMake(40, 0, self.frameWidth-40, self.frameHeight);
    }
}

-(void)setText:(NSString*)text{
    self.textLabel.text=text;
}
@end
