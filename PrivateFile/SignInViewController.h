//
//  signinViewController.h
//  PrivateFile
//
//  Created by Sun Jin on 15/2/28.
//  Copyright (c) 2015年 MaxLeap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)signIn:(id)sender;

@end
