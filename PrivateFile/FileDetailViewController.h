//
//  FileDetailViewController.h
//  PrivateFile
//
//  Created by Sun Jin on 14/12/10.
//  Copyright (c) 2014年 MaxLeap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MaxLeap/MaxLeap.h>

typedef NS_OPTIONS(NSInteger, ScrollDirection) {
    ScrollDirectionNone = 1 << 0,
    ScrollDirectionRight = 1 << 1,
    ScrollDirectionLeft = 1 << 2,
    ScrollDirectionUp = 1 << 3,
    ScrollDirectionDown = 1 << 4,
    ScrollDirectionCrazy = 1 << 5
};

@interface FileDetailViewController : UIViewController <UITextViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) MLPrivateFile *file;

@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic) ScrollDirection scrolDirection;

@end
