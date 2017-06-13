//
//  TCBaseTextView.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/6.
//
//

#import <UIKit/UIKit.h>

@interface TCBaseTextView : UIView
/**<##>textFiled*/
@property(nonatomic,strong)UITextField*textFiled;

/**根据标题的字数，控制textLabel的宽度*/
@property(nonatomic,assign)NSInteger type;
//设置标题text
-(void)setText:(NSString*)text;

@end
