//
//  LoginViewController.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-23.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "LoginViewController.h"

#import "AppAPIClient.h"

#import "SIAlertView.h"

#import "MBProgressHUD.h"




@interface LoginViewController () <UITextFieldDelegate>

@end




@implementation LoginViewController

@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIColor* darkColor = THEME_COLOR_DARK;
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = THEME_COLOR_FULL;
    
    self.usernameField.backgroundColor = [UIColor whiteColor];
    self.usernameField.layer.cornerRadius = 3.0f;
    self.usernameField.placeholder = @"Email Address";
    self.usernameField.font = [UIFont fontWithName:fontName size:16.0f];
    
    
    UIImageView* usernameIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 24, 24)];
    usernameIconImage.image = [UIImage imageNamed:@"mail"];
    UIView* usernameIconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
    usernameIconContainer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [usernameIconContainer addSubview:usernameIconImage];
    
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView = usernameIconContainer;
    
    
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.layer.cornerRadius = 3.0f;
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    self.passwordField.secureTextEntry = YES;
    
    
    UIImageView* passwordIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 24, 24)];
    passwordIconImage.image = [UIImage imageNamed:@"lock"];
    UIView* passwordIconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
    passwordIconContainer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [passwordIconContainer addSubview:passwordIconImage];
    
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = passwordIconContainer;
    
    self.loginButton.backgroundColor = darkColor;
    self.loginButton.layer.cornerRadius = 3.0f;
    self.loginButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.loginButton setTitle:@"SIGN UP HERE" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.forgotButton.backgroundColor = [UIColor clearColor];
    self.forgotButton.titleLabel.font = [UIFont fontWithName:fontName size:12.0f];
    [self.forgotButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:darkColor forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
    self.titleLabel.text = @"GOOD TO SEE YOU";
    
    self.subTitleLabel.textColor =  [UIColor whiteColor];
    self.subTitleLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.subTitleLabel.text = @"Welcome back, please login below";
    
    self.usernameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.passwordField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

- (IBAction)login:(id)sender
{
    if        (self.usernameField.text == nil ||
               self.usernameField.text.length == 0) {
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"错误" andMessage:@"请输入用户名"];
        [alertView addButtonWithTitle:@"Ok" type:SIAlertViewButtonTypeDefault handler:nil];
        [alertView show];
        
    } else if (self.passwordField.text == nil ||
               self.passwordField.text.length == 0) {
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"错误" andMessage:@"请输入密码"];
        [alertView addButtonWithTitle:@"Ok" type:SIAlertViewButtonTypeDefault handler:nil];
        [alertView show];
        
    } else {
        
        [self loginWithUserName:self.usernameField.text password:self.passwordField.text];
        
    }
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password {
    
    if ([AppAPIClient sharedClient].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ||
        [AppAPIClient sharedClient].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        
        [[AppAPIClient sharedClient] postPath:@"api/v1/login"
                                   parameters:[NSDictionary paramsWithUserName:userName password:password]
                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                          
                                          [JsonAnalyzer analyzeAccessInfo:JSON];
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          
                                          [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"username"];
                                          [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"password"];
                                          
                                          [self dismiss];
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          
                                          SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"错误"
                                                                                           andMessage:[error message]];
                                          [alertView addButtonWithTitle:@"Ok"
                                                                   type:SIAlertViewButtonTypeDefault
                                                                handler:^(SIAlertView *alertView) {
                                                                    NSLog(@"Ok Button Clicked");
                                                                }];
                                          [alertView show];
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          
                                      }];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessed)]) {
            [self.delegate loginSuccessed];
        }
    }];
}

- (void)viewWillLayoutSubviews
{/*
    self.titleLabel.frame       = CGRectMake(self.titleLabel.frame.origin.x,
                                             46,
                                             self.titleLabel.frame.size.width,
                                             self.titleLabel.frame.size.height);
    
    self.usernameField.frame    = CGRectMake(self.usernameField.frame.origin.x,
                                             (__IPHONE_5__ ? 235 : 205),
                                             self.usernameField.frame.size.width,
                                             self.usernameField.frame.size.height);
    
    self.subTitleLabel.frame    = CGRectMake(self.titleLabel.frame.origin.x,
                                             self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height -2,
                                             self.titleLabel.frame.size.width,
                                             self.titleLabel.frame.size.height);
    
    self.passwordField.frame    = CGRectMake(self.usernameField.frame.origin.x,
                                             self.usernameField.frame.origin.y + self.usernameField.frame.size.height + 10,
                                             self.passwordField.frame.size.width,
                                             self.passwordField.frame.size.height);
    
    self.loginButton.frame      = CGRectMake(self.passwordField.frame.origin.x,
                                             self.passwordField.frame.origin.y + self.usernameField.frame.size.height + 20,
                                             self.loginButton.frame.size.width,
                                             self.loginButton.frame.size.height);
    
    self.forgotButton.frame     = CGRectMake(self.loginButton.frame.origin.x,
                                             self.loginButton.frame.origin.y + self.loginButton.frame.size.height + 10,
                                             self.forgotButton.frame.size.width,
                                             self.forgotButton.frame.size.height);
    
    if (__IPHONE_4__) {
        self.usernameField.frame    = CGRectMake(self.usernameField.frame.origin.x,
                                                 205,
                                                 self.usernameField.frame.size.width,
                                                 self.usernameField.frame.size.height);
        self.passwordField.frame    = CGRectMake(self.usernameField.frame.origin.x,
                                                 self.usernameField.frame.origin.y + self.usernameField.frame.size.height + 10,
                                                 self.passwordField.frame.size.width,
                                                 self.passwordField.frame.size.height);
    }*/
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark -
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self login:nil];
    return NO;
}

@end
