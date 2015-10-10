//
//  PasswordResetViewController.m
//  PrivateFile
//
//  Created by Sun Jin on 4/28/15.
//  Copyright (c) 2015 MaxLeap. All rights reserved.
//

#import "PasswordResetViewController.h"
#import <MaxLeap/MaxLeap.h>

@interface PasswordResetViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emialField;
@property (weak, nonatomic) IBOutlet UILabel *emptyEmailWarning;

@end

@implementation PasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendPasswordResetEmail:(id)sender {
    
    NSString *email = self.emialField.text;
    if (email.length == 0) {
        self.emptyEmailWarning.hidden = NO;
        return;
    }
    
    [MLUser requestPasswordResetForEmailInBackground:self.emialField.text block:^(BOOL succeeded, NSError *error) {
        NSLog(@"send password reset email success: %d, error: %@", succeeded, error);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.emptyEmailWarning.hidden = YES;
}

- (void)textFieldTextChange:(NSNotification *)notification {
    self.emptyEmailWarning.hidden = YES;
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
