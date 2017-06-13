//
//  TCBaseMenu.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/6.
//
//

#import "TCBaseMenu.h"

@implementation TCBaseMenu
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.borderColor=[UIColor grayColor].CGColor;
        self.layer.borderWidth=0.6;
        self.layer.cornerRadius=4;
        [self setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
            }
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.font=Font(13);
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.originX=0;
    self.titleLabel.frameWidth=self.frameWidth-self.imageView.frameWidth-5;
    //    self.imageView.originX=self.titleLabel.frameWidth;
    self.imageView.originX=self.frameWidth-self.imageView.frameWidth-5;
    
}
@end
