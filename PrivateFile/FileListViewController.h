//
//  FileListViewController.h
//  PrivateFile
//
//  Created by Sun Jin on 14/12/10.
//  Copyright (c) 2014年 ilegendsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <LAS/LAS.h>
#import <LAS/LASPrivateFileManager.h> // 最终发布版本中，这个头文件将会被包括在 LAS.h 中

@interface FileListViewController : UITableViewController

@property (nonatomic, strong) LASPrivateFile *directory;

@end
