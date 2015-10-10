//
//  FileListViewController.m
//  PrivateFile
//
//  Created by Sun Jin on 14/12/10.
//  Copyright (c) 2014年 MaxLeap. All rights reserved.
//

#import "FileListViewController.h"
#import "SVProgressHUD.h"
#import "FileDetailViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.directory) {
        self.directory = [MLPrivateFile fileWithRemotePath:@"/"];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"upload" style:UIBarButtonItemStyleBordered target:self action:@selector(upload:)];
        
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refresh:)];
        UIBarButtonItem *removeAll = [[UIBarButtonItem alloc] initWithTitle:@"delAll" style:UIBarButtonItemStyleBordered target:self action:@selector(removeAll:)];
        removeAll.tintColor = [UIColor redColor];
        
        self.navigationItem.rightBarButtonItems = @[removeAll, refreshItem];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        
    }
    
    self.title = self.directory.remotePath;
    
    [self prepareFiles];
}

- (void)prepareFiles {
    NSString *docPath = [self docPath];
    NSArray *bundleJpegs = @[@"beauty", @"flower", @"scenery"];
    
    for (NSString *filename in bundleJpegs) {
        NSString *scrPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"jpg"];
        NSString *dstPath = [docPath stringByAppendingPathComponent:scrPath.lastPathComponent];
        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:dstPath]) {
            [[NSFileManager defaultManager] copyItemAtPath:scrPath toPath:dstPath error:nil];
        }
    }
}

- (NSString *)viewName {
    return [NSString stringWithFormat:@"FileList - %lu", (unsigned long)self.navigationController.viewControllers.count];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MLAnalytics beginLogPageView:[self viewName]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MLAnalytics endLogPageView:[self viewName]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([MLUser currentUser].isAuthenticated) {
        [self refresh:nil];
    }
}

- (NSString *)docPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)randomPathOfFileInDocuments {
    
    NSString *path = [self docPath], *relativePath = nil;
    BOOL _isDir = YES, _hasFile = NO;
    while (_isDir) {
        NSArray *allContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
        NSMutableArray *contentsValid = [NSMutableArray array];
        [allContents enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if (NO == [obj hasPrefix:@"."]) {
                [contentsValid addObject:obj];
            }
        }];
        if (contentsValid.count == 0) break;
        
        NSInteger index = arc4random() % contentsValid.count;
        relativePath = contentsValid[index];
        path = [path stringByAppendingPathComponent:relativePath];
        
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&_isDir];
        _hasFile = !_isDir;
    }
    
    if (!_hasFile) {
        NSLog(@"No file is found to upload.");
        return nil;
    }
    
    return path;
}

- (IBAction)upload:(id)sender {
    
    NSString *path = [self randomPathOfFileInDocuments];
    if (!path) {
        return;
    }
    
    [sender setEnabled:NO];
    
    [self uploadFileAtPath:path onCompletion:^(BOOL success) {
        if (success) {
            [self refresh:nil];
        }
        [sender setEnabled:YES];
    }];
}

- (void)uploadFileAtPath:(NSString *)path onCompletion:(void(^)(BOOL success))completion {
    
    NSString *filename = path.lastPathComponent;
    NSString *remotePath = [path stringByReplacingOccurrencesOfString:[self docPath] withString:@""];
    MLPrivateFile *file = [[MLPrivateFile alloc] initWithLocalFileAtPath:path remotePath:remotePath];
    
    NSString *status = [NSString stringWithFormat:@"start uploading %@", filename];
    [SVProgressHUD showWithStatus:status maskType:SVProgressHUDMaskTypeBlack];
    NSLog(@"Uploading %@", filename);
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"succeed" maskType:SVProgressHUDMaskTypeBlack];
            NSLog(@"========= Succeed ==========");
        } else {
            NSString *errMsg = [NSString stringWithFormat:@"failed, %@", error.localizedDescription?:error.userInfo[NSLocalizedDescriptionKey]];
            [SVProgressHUD showErrorWithStatus:errMsg maskType:SVProgressHUDMaskTypeBlack];
        }
        
        completion(succeeded);
    } progressBlock:^(int percentDone) {
        NSLog(@"upload progress: %d%%, float: %f", percentDone, percentDone/100.f);
        [SVProgressHUD showProgress:percentDone/100.f status:[NSString stringWithFormat:@"uploading %@", filename] maskType:SVProgressHUDMaskTypeBlack];
    }];
}

- (IBAction)removeAll:(id)sender {
    MLPrivateFile *root = [MLPrivateFile fileWithRemotePath:@"/"];
    [root deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refresh:nil];
    }];
}

- (IBAction)refresh:(id)sender {
    
    if ([MLUser currentUser]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        [self.directory getMetadataIncludeChildrenInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.description maskType:SVProgressHUDMaskTypeBlack];
            } else {
                NSLog(@"successfully retrieved root directory, content %lu items", (unsigned long)self.directory.contents.count);
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            }
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.directory.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MLPrivateFile *theFile = self.directory.contents[indexPath.row];
    
    UITableViewCell *cell = nil;
    if (theFile.isDirectory) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FolderCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell" forIndexPath:indexPath];
        
        double size = (double)theFile.bytes;
        NSString *unit = @"B";
        if (size > 1024.f) {
            size/=1024.f;
            unit = @"KB";
        }
        if (size > 1024.f) {
            size/=1024.f;
            unit = @"MB";
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f %@", size, unit];
    }
    
    cell.textLabel.text = theFile.remotePath.lastPathComponent;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MLPrivateFile *theFile = self.directory.contents[indexPath.row];
        [theFile deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self refresh:nil];
            }
        }];
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        
        FileDetailViewController *detailvc = segue.destinationViewController;
        detailvc.file = self.directory.contents[indexPath.row];
        
    } else if ([segue.identifier isEqualToString:@"showFolderContents"]) {
        
        FileListViewController *listvc = segue.destinationViewController;
        listvc.directory = self.directory.contents[indexPath.row];
    }
}

@end
