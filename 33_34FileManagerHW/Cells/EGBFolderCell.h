//
//  EGBFolderCell.h
//  33_34FileManagerHW
//
//  Created by Eduard Galchenko on 2/8/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGBFolderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameFolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeFolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateFolderLabel;


@end

NS_ASSUME_NONNULL_END
