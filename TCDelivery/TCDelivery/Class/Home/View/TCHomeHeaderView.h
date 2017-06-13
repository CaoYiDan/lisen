//
//  TCHomeHeaderView.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/3/10.
//
//

#import <UIKit/UIKit.h>
@protocol TCHomeHeaderViewDelegate
-(void)TCHomeHeaderViewCilck:(NSInteger)tag;
@end

@interface TCHomeHeaderView : UIView
/**<##>代理回传点击事件*/
@property(nonatomic,weak)id delegate;
//给轮播图和订单数量赋值
-(void)createByBannerArray:(NSMutableArray*)bannerArr andPublishNum:(NSInteger)publishNumber transportNum:(NSInteger)transportNumber;

@end
