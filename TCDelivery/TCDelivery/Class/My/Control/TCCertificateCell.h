//
//  TCCertificateCell.h
//  TCDelivery
//
//  Created by 融合互联-------lisen on 17/4/19.
//
//

#import <UIKit/UIKit.h>

@interface TCCertificateCell : UITableViewCell
/**图片*/
@property (nonatomic, strong) UIImageView *image;
/**传入的图片Url*/
@property (nonatomic, copy) NSString *imageUrl;
@end
