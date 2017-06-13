//
//  TCUnitView.m
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/7.
//
//

#import "TCNewUnitView.h"
#import "TCImageArr.h"
#import "NSString+Additions.h"

@implementation TCNewUnitView
{
    NSString*_imagePath;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        //
        //        self.unitTextLabel.adjustsFontSizeToFitWidth=YES;
        //
        //        [self addSubview:self.unitTextLabel];
        
    }
    return self;
}
-(void)setType:(NSInteger)type{
    _type=type;
    
    if (type<10) {//右边的图片
        _imagePath=[TCImageArr shareWithRightImageArr][type];
        
    }else{
        _imagePath=[TCImageArr shareWithLeftImageArr][type-10];
    }
}
-(void)setLabelText:(NSString *)text{
    
  
    CGFloat width =[text getSizeWithTextSize:CGSizeMake(MAXFLOAT,30) fontSize:13].width;
    
    self.mj_size=CGSizeMake(width+28, 30);
    CGRect rect = self.bounds;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frameWidth-1, 30), YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor whiteColor] set];
        CGContextFillRect(context, rect);
        {
            [text drawInRect:CGRectMake(25,7, self.frameWidth-25 , 30) withAttributes:@{NSFontAttributeName:Font(12),NSForegroundColorAttributeName:[UIColor blackColor]}];
        }
        
        {
            [[UIImage imageNamed:_imagePath] drawInRect:CGRectMake(0,5, 20, 20) blendMode:kCGBlendModeNormal alpha:1];
            
        }
        UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
//
//            self.frame = rect;
//            self.image = nil;
//            self.image = temp;
//
            [self setImage:temp];
        });
    });


}
//将主要内容绘制到图片上
- (void)drawTex:(NSString *)text{
    
}


@end
