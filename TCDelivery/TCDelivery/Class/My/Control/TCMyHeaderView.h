//
//  TCMyHeaderView.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/6.
//
//

#import <UIKit/UIKit.h>
typedef  void(^myHeaderBlock)(NSString*type,NSInteger tag);

@interface TCMyHeaderView : UIView
@property(nonatomic,copy)myHeaderBlock MyHeaderblock;
//刷新用户的认证状态
-(void)refreshStatus;
//设置头像
-(void)setPhotoWithImagePath:(NSString *)photoImagePath;
-(void)setImage:(UIImage*)image;
@end
