//
//  FileDetailViewController.m
//  PrivateFile
//
//  Created by Sun Jin on 14/12/10.
//  Copyright (c) 2014年 LAS. All rights reserved.
//

#import "FileDetailViewController.h"
#import <MobileCoreServices/UTType.h>
#import "SVProgressHUD.h"

@interface FileDetailViewController ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation FileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.file.localPath.lastPathComponent;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    webView.scrollView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    self.webView = webView;
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    dispatch_block_t displayFile = ^{
        NSURL *url = [NSURL fileURLWithPath:self.file.localPath];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
    };
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.file.localPath]) {
        displayFile();
    } else {
        // 说明：directory 是本地文件根目录，对应于 remoteRootPath，传 nil 的话，文件会被保存到缺省路径下，文件路径可以用 self.file.localPath 获取
        [LASPrivateFileManager downloadContentsOfFile:self.file toDirectory:nil block:^(NSString *filePath, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.description maskType:SVProgressHUDMaskTypeBlack];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"Done" maskType:SVProgressHUDMaskTypeBlack];
                displayFile();
            }
        } progressBlock:^(int percentDone) {
            NSLog(@"download progress: %d%%", percentDone);
            [SVProgressHUD showProgress:percentDone/100.f status:[NSString stringWithFormat:@"downloading %@", self.file.remotePath.lastPathComponent] maskType:SVProgressHUDMaskTypeBlack];
        }];
    }
}


//
//- (NSString *)mimeTypeForExtension:(NSString *)ext {
//    if (ext.length == 0) {
//        return @"";
//    }
//    
//    // Borrowed from http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
//    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
//                                                            (__bridge CFStringRef)ext,
//                                                            NULL);
//    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
//    CFRelease(UTI);
//    return CFBridgingRelease(MIMEType);
//}

- (void)hidesBars {
    BOOL hide = !self.navigationController.navigationBarHidden;
    
    if (!hide) {
        [self.navigationController setNavigationBarHidden:hide animated:NO];
    }
    
    [UIView transitionWithView: self.navigationController.view
                      duration: 0.2
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^{
                        [self.navigationController setNavigationBarHidden:hide animated:NO];
                    } completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:![UIApplication sharedApplication].statusBarHidden withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.webView stopLoading];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LASAnalytics beginLogPageView:@"FileDetail"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [LASAnalytics endLogPageView:@"FileDetail"];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.lastContentOffset.x < scrollView.contentOffset.x) {
        self.scrolDirection = ScrollDirectionLeft;
    } else if (self.lastContentOffset.x > scrollView.contentOffset.x) {
        self.scrolDirection = ScrollDirectionRight;
    } else {
        self.scrolDirection = ScrollDirectionNone;
    }
    
    if (self.lastContentOffset.y < scrollView.contentOffset.y) { // scrolling up, hide bars
        self.scrolDirection = self.scrolDirection | ScrollDirectionUp;
        if (scrollView.contentOffset.y > 0
            && !self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }
    } else if (self.lastContentOffset.y > scrollView.contentOffset.y) {
        self.scrolDirection = self.scrolDirection | ScrollDirectionDown;
    } else {
        self.scrolDirection = self.scrolDirection | ScrollDirectionNone;
    }
    
    self.lastContentOffset = scrollView.contentOffset;
    
    if (scrollView.contentOffset.y <= 0
        && self.scrolDirection & ScrollDirectionDown
        && self.navigationController.navigationBarHidden) {
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
    
    // do whatever you need to with scrollDirection here.
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        if (self.scrolDirection & ScrollDirectionDown) {
            if (self.navigationController.navigationBarHidden) {
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            }
        }
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:error.description maskType:SVProgressHUDMaskTypeBlack];
}

@end
