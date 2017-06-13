//
//  TCTransportDetailVC.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/2/13.
//
//

#import "BaseViewController.h"

@interface TCTransportDetailVC : BaseViewController
/**运单编号*/
@property(nonatomic,copy)NSString* transportId;
/**运单ID*/
@property(nonatomic,copy)NSString* transportId2;
/**运单类型*/
@property(nonatomic,copy)NSString* tenderType;
@end
