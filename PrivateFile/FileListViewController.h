//
//  FileListViewController.h
//  PrivateFile
//
//  Created by Sun Jin on 14/12/10.
//  Copyright (c) 2014年 MaxLeap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <MaxLeap/MaxLeap.h>

@interface FileListViewController : UITableViewController

@property (nonatomic, strong) MLPrivateFile *directory;

@end
