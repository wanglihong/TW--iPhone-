//
//  LoginViewController.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-23.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "BaseLoginViewController.h"

@protocol LoginViewControllerDelegate <NSObject>

@optional
- (void)loginSuccessed;
- (void)loginFailed;

@end

@interface LoginViewController : BaseLoginViewController

@property (nonatomic, assign) id<LoginViewControllerDelegate> delegate;

@property (nonatomic, weak) IBOutlet UITextField * usernameField;

@property (nonatomic, weak) IBOutlet UITextField * passwordField;

@property (nonatomic, weak) IBOutlet UIButton * loginButton;

@property (nonatomic, weak) IBOutlet UIButton * forgotButton;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

@property (nonatomic, weak) IBOutlet UILabel * subTitleLabel;

@end
