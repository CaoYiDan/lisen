//
//  TCUnitView.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/7.
//
//

#import <UIKit/UIKit.h>

@interface TCUnitView : UIView
/**<##>图片*/
@property(nonatomic,strong)UIImageView*unitImageView;
/**<##>z字体*/
@property(nonatomic,strong)UILabel*unitTextLabel;
@property(nonatomic,assign)NSInteger type;
-(void)setLabelText:(NSString*)text;
@end
