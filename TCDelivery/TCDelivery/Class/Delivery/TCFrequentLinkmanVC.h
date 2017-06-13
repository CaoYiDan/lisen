//
//  TCFrequentLinkmanVC.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/5/3.
//
//

#import <UIKit/UIKit.h>
@class TCLinkModel;
@protocol TCFrequentLinkmanDelegate

- (void)frequentLinkmanDidSelectRowAtIndexPath:(NSIndexPath *)indexPath withObject:(TCLinkModel*)model;
@end

@interface TCFrequentLinkmanVC : UITableViewController
/**发货人选中的联系人信息*/
@property(nonatomic,copy)  NSString *deliveryId;
/**收货人选中的联系人信息*/
@property(nonatomic,copy) NSString *receiveId;
/**<##>发货人 还是 收货人*/
@property(nonatomic,assign) LinkType linkType;
//代理
@property (nonatomic, weak) id delegate;
@end
