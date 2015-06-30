//
//  FileDetailViewController.h
//  PrivateFile
//
//  Created by Sun Jin on 14/12/10.
//  Copyright (c) 2014年 ilegendsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <LAS/LAS.h>
#import <LAS/LASPrivateFileManager.h> // 最终发布版本中，这个头文件将会被包括在 LAS.h 中

typedef NS_OPTIONS(NSInteger, ScrollDirection) {
    ScrollDirectionNone = 1 << 0,
    ScrollDirectionRight = 1 << 1,
    ScrollDirectionLeft = 1 << 2,
    ScrollDirectionUp = 1 << 3,
    ScrollDirectionDown = 1 << 4,
    ScrollDirectionCrazy = 1 << 5
};

@interface FileDetailViewController : UIViewController <UITextViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) LASPrivateFile *file;

@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic) ScrollDirection scrolDirection;

@end
