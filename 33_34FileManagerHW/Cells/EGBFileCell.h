//
//  EGBFileCell.h
//  33_34FileManagerHW
//
//  Created by Eduard Galchenko on 2/8/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGBFileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameFileLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

NS_ASSUME_NONNULL_END
