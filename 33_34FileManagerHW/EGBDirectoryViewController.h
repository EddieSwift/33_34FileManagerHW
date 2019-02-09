//
//  EGBDirectoryViewController.h
//  33_34FileManagerHW
//
//  Created by Eduard Galchenko on 2/8/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGBDirectoryViewController : UITableViewController

@property (strong, nonatomic) NSString *path;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backToRootButton;

- (IBAction)infoFolderButton:(UIButton *)sender;
- (IBAction)actionBackToRoot:(UIBarButtonItem *)sender;
- (IBAction)actionCreateFolderAndFile:(UIBarButtonItem *)sender;

@end

NS_ASSUME_NONNULL_END
