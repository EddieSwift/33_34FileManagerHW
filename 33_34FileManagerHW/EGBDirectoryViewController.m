//
//  EGBDirectoryViewController.m
//  33_34FileManagerHW
//
//  Created by Eduard Galchenko on 2/8/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "EGBDirectoryViewController.h"
#import "EGBFolderCell.h"
#import "EGBFileCell.h"
#import "UIView+UITableViewCell.h"

@interface EGBDirectoryViewController ()

@property (strong, nonatomic) NSArray *contents;
@property (strong, nonatomic) NSMutableArray *foldersArray;
@property (strong, nonatomic) NSMutableArray *filesArray;
@property (strong, nonatomic) NSString *selectedPath;
@property (assign, nonatomic) NSInteger folderCount;

@end

@implementation EGBDirectoryViewController

- (void) setPath:(NSString *)path {
 
    _path = path;
    
    NSError *error = nil;
    
    // Calling methods of sorting folders and files
    [self sortFoldersAndFiles];
    
    if (error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self.tableView reloadData];
    
    self.navigationItem.title = [self.path lastPathComponent];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.folderCount = 0;
    
    if (!self.path) {
        
        self.path = @"/Users/eddie/Documents/IOSDevCourse";
    }
}

- (void)viewWillAppear:(BOOL)animated {
 
    [super viewWillAppear:animated];
    
    if ([self.navigationController.viewControllers count] > 1) {
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back To Root" style:UIBarButtonItemStylePlain target:self action:@selector(actionBackToRoot:)];

        self.navigationItem.rightBarButtonItem = backButton;
    }
}

#pragma mark - Button Actions

- (void) actionBackToRoot:(UIBarButtonItem*) sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionCreateFolderAndFile:(UIBarButtonItem *)sender {
    
    NSString *folderName = [NSString stringWithFormat:@"New Folder %ld", self.folderCount];
    NSString *path = [self.path stringByAppendingPathComponent:folderName];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSMutableArray *fileManager = [NSMutableArray arrayWithArray:self.contents];
    [fileManager addObject:folderName];
    self.contents = fileManager;
    
     self.folderCount++;
    
    NSInteger row = [self.contents indexOfObject:folderName];
    
    [self.tableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];

    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (IBAction)infoFolderButton:(UIButton *)sender {
    
    UITableViewCell *cell = [sender superCell];
    
    if (cell) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"File"
                                   message:[NSString stringWithFormat:@"action %ld %ld", indexPath.section, indexPath.row]
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"action %ld %ld", indexPath.section, indexPath.row);
    }
    
    NSLog(@"actionInfoCell");
}

#pragma mark - Private Methods

- (void) sortFoldersAndFiles {
    
    NSError *error = nil;
    
    // Checking for hidden files and making them invisible
    NSArray *tempArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:&error];
    
    NSMutableArray *mutArray = [NSMutableArray array];
    
    NSMutableArray *newMutArray = [NSMutableArray array];
    
    self.foldersArray = [NSMutableArray array];
    self.filesArray = [NSMutableArray array];
    
    NSArray *foldArray = [[NSArray alloc] init];
    NSArray *fileArray = [[NSArray alloc] init];
    
    self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:&error];
    
    for (int i = 0; i < [tempArray count]; i++) {
        
        if (![tempArray[i] hasPrefix:@"."]) {
            
            [mutArray addObject:tempArray[i]];
        }
    }
    
    // Sorting folders and files
    for (int i = 0; i < [mutArray count]; i++) {
        
        NSString *newPath = [self.path stringByAppendingPathComponent:mutArray[i]];
        
        BOOL isDirectory = NO;
        
        [[NSFileManager defaultManager] fileExistsAtPath:newPath isDirectory:&isDirectory];
        
        if (isDirectory) {
            
            [self.foldersArray addObject:mutArray[i]];
            
        } else {
            
            [self.filesArray addObject:mutArray[i]];
        }
    }
    
    foldArray = [NSArray arrayWithArray:self.foldersArray];
    foldArray = [foldArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    fileArray = [NSArray arrayWithArray:self.filesArray];
    fileArray = [fileArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (int i = 0; i < [foldArray  count]; i++) {
        
        [newMutArray addObject:foldArray[i]];
    }
    
    for (int i = 0; i < [fileArray  count]; i++) {
        
        [newMutArray addObject:fileArray[i]];
    }
    
    self.contents = [NSArray arrayWithArray:newMutArray];
}

- (BOOL) isDirectoryAtIndexPath:(NSIndexPath*) indexPath {
 
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    NSString *pathName = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:pathName isDirectory:&isDirectory];
    
    return isDirectory;
}

// Counting files sizes
- (NSString*) fileSizeFromValue:(unsigned long long) size {
    
    static NSString *units[] = {@"B", @"KB", @"MB", @"GB", @"TB"};
    //    NSArray *units = [[NSArray alloc] initWithObjects:@"B", @"KB", @"MB", @"GB", @"TB", nil];
    static int unitsCount = 5;
    
    int index = 0;
    
    double fileSize = (double) size;
    
    while (fileSize > 1024 && index < unitsCount) {
        
        fileSize /= 1024;
        index++;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", fileSize, units[index]];
}

// Counting of folders sizes
- (unsigned long long) folderSize:(NSString *) folderPath {

    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

#pragma mark - UITableDataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *fileIdentifier = @"FileCell";
    static NSString *folderIdentifier = @"FolderCell";
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    NSString *path = [self.path stringByAppendingPathComponent:fileName];
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    static NSDateFormatter *dateFormatter = nil;
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        EGBFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:folderIdentifier];
        
        cell.nameFolderLabel.text = fileName;

        
        cell.sizeFolderLabel.text = [self fileSizeFromValue:[self folderSize:path]];
        
        if (!dateFormatter) {
            
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        }
        
        cell.dateFolderLabel.text = [dateFormatter stringFromDate:[attributes fileModificationDate]];
        
        return cell;
        
    } else {
        
        EGBFileCell *cell = [tableView dequeueReusableCellWithIdentifier:fileIdentifier];
        
        cell.nameFileLabel.text = fileName;
        cell.sizeLabel.text = [self fileSizeFromValue:[attributes fileSize]];
        
        if (!dateFormatter) {
            
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        }
        
        cell.dateLabel.text = [dateFormatter stringFromDate:[attributes fileModificationDate]];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
    NSMutableArray *fileManager = [NSMutableArray arrayWithArray:self.contents];
    NSString *content = [fileManager objectAtIndex:indexPath.row];
    NSString *path = [self.path stringByAppendingPathComponent:content];
    
    [fileManager removeObject:content];
    self.contents = fileManager;
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return UITableViewCellEditingStyleDelete;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
        
        /*
        EGBDirectoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EGBDirectoryViewController"];
        
        viewController.path = filePath;
        [self.navigationController pushViewController:viewController animated:YES];
        */
        
        self.selectedPath = filePath;
        
        [self performSegueWithIdentifier:@"navigateDeep" sender:nil];
    }
}

#pragma mark - Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
 
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    EGBDirectoryViewController *viewController = segue.destinationViewController;
    viewController.path = self.selectedPath;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
