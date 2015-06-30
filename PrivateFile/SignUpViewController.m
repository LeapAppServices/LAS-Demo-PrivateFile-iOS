//
//  SignUpViewController.m
//  PrivateFile
//
//  Created by Sun Jin on 15/2/28.
//  Copyright (c) 2015年 LAS. All rights reserved.
//

#import "SignUpViewController.h"
@import LAS;

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LASAnalytics beginLogPageView:@"SignUp"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [LASAnalytics endLogPageView:@"SignUp"];
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

- (IBAction)signUp:(id)sender {
    NSString *username = self.usernameField.text;
    if (!username) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"username cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSString *password = self.passwordField.text;
    if (!password) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"password cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSString *passwordVerify = self.passwordVerifyField.text;
    if (NO == [password isEqualToString:passwordVerify]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"password is not the same with password verify" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    LASUser *user = [LASUser user];
    user.username = username;
    user.password = password;
    user.email = self.emailField.text;
    [LASUserManager signUpInBackground:user block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

@end
