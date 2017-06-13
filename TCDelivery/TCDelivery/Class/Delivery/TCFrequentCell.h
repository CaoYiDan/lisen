//
//  TCFrequentCell.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/5/3.
//
//

#import <UIKit/UIKit.h>
typedef  void(^TCFrequentBlock)(NSInteger indexPath);
@class TCLinkModel;
@interface TCFrequentCell : UITableViewCell
@property(nonatomic,copy)TCFrequentBlock TCFrequentBlock;
+ (instancetype)tableViewCellWithTableView:(UITableView *)tableView with:(NSIndexPath*)index;
- (void)setLinkInfo:(TCLinkModel *)info with:(NSIndexPath*)index;
//选中在发布界面显示的联系人cell
- (void)haveSelectedReceiverId:(NSString *)receiverId;
@end
