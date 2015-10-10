//
//  signinViewController.m
//  PrivateFile
//
//  Created by Sun Jin on 15/2/28.
//  Copyright (c) 2015年 MaxLeap. All rights reserved.
//

#import "SignInViewController.h"
#import <MaxLeap/MaxLeap.h>

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MLAnalytics beginLogPageView:@"SignIn"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MLAnalytics endLogPageView:@"SignIn"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signIn:(id)sender {
    [self.view endEditing:NO];
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    if (!username || !password) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"please enter username and password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [MLUser logInWithUsernameInBackground:username password:password block:^(MLUser *user, NSError *error) {
        if (user) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

@end
