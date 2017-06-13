//
//  TCMyPublishDetailVC.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/10.
//
//

#import "BaseViewController.h"

@interface TCMyPublishDetailVC : BaseViewController
/**我的发布Id*/
@property(nonatomic,copy)NSString*tenderId;
/**是否可编辑*/
@property(nonatomic,assign)BOOL canEdit;
@end
