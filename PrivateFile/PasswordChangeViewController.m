//
//  PasswordChangeViewController.m
//  PrivateFile
//
//  Created by Sun Jin on 4/30/15.
//  Copyright (c) 2015 LAS. All rights reserved.
//

#import "PasswordChangeViewController.h"
@import LAS;

@interface PasswordChangeViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainField;

@end

@implementation PasswordChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.oldPasswordField.layer.borderWidth =
    self.passwordField.layer.borderWidth =
    self.passwordAgainField.layer.borderWidth = 1.f;
    
    self.oldPasswordField.layer.borderColor =
    self.passwordField.layer.borderColor =
    self.passwordAgainField.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePassword:(id)sender {
    
    NSString *oldPassword = self.oldPasswordField.text;
    NSString *newPassword = self.passwordField.text;
    NSString *newPassword2 = self.passwordAgainField.text;
    BOOL shouldContine = YES;
    
    if (oldPassword.length == 0
        || newPassword.length == 0
        || newPassword2.length == 0) {
        
        if (oldPassword.length == 0) {
            self.oldPasswordField.layer.borderColor = [UIColor redColor].CGColor;
        }
        if (newPassword.length == 0) {
            self.passwordField.layer.borderColor = [UIColor redColor].CGColor;
        }
        if (newPassword2.length == 0) {
            self.passwordAgainField.layer.borderColor = [UIColor redColor].CGColor;
        }
        
        shouldContine = NO;
        
    } else if (NO == [newPassword2 isEqualToString:newPassword]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"The two new passwords are not the same." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        shouldContine = NO;
    } else if ([newPassword isEqualToString:oldPassword]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"The new password is same as old password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        shouldContine = NO;
    }
    
    if (NO == shouldContine) {
        return;
    }
    
    [LASUserManager changePasswordWithNewPassword:newPassword oldPassword:oldPassword block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Change Success!" message:@"Please login using your new password." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            alert.tag = 888;
            [alert show];
            [LASUserManager logOut];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Change Failed" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 999;
            [alert show];
        }
    }];
}

- (void)onTextFieldTextChange:(NSNotification *)notification {
    UITextField *textField = notification.object;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 888) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
