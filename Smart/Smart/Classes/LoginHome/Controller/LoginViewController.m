//
//  LoginViewController.m
//  Smart
//
//  Created by orange on 16/3/19.
//  Copyright © 2016年 orange. All rights reserved.
//

//
//  LoginViewController.m
//  SmartTravelApp2
//
//  Created by whutlab5 on 15/1/22.
//  Copyright (c) 2015年 lgy. All rights reserved.
//

#import "LoginViewController.h"
#import "UIResponder+FirstResponder.h"
#import "UITextField+Shake.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "SSKeychain.h"
#import "HomeViewController.h"
#import "MessageBL.h"

typedef enum
{
    RememberUserPswYes = 100,
    RememberUserPswNo
}RememberUserPsw;

@interface LoginViewController () <UserDelegate>
{
    MBProgressHUD *_hud;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UIControl *rememberPswControl;
@property (weak, nonatomic) IBOutlet UIImageView *checkBox;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 默认记住密码
    [self.rememberPswControl setTag:RememberUserPswYes];
    [self.checkBox setImage:[UIImage imageNamed:@"login_checked"]];
    [User sharedUser].delegate = self;
    
    // 获取已记住的账号和密码
    NSString *username = [[[SSKeychain accountsForService:KCServiceName] lastObject] valueForKey:@"acct"];
    NSString *userpassword = [SSKeychain passwordForService:KCServiceName account:username];
    self.userName.text = username;
    self.userPassword.text = userpassword;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([User sharedUser].delegate != self) {
        [User sharedUser].delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapBlank:(id)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

#pragma mark - 是否记住用户密码
- (IBAction)toogleCheckBox:(UIControl *)sender {
    if (sender.tag == RememberUserPswYes) {
        [sender setTag:RememberUserPswNo];
        [self.checkBox setImage:[UIImage imageNamed:@"login_unchecked"]];
    } else
    {
        [sender setTag:RememberUserPswYes];
        [self.checkBox setImage:[UIImage imageNamed:@"login_checked"]];
    }
}

#pragma mark - 登录
- (IBAction)loginButtonClicked:(id)sender {
    if ([self checkTextfieldIsValid]) {
        [[UIResponder currentFirstResponder] resignFirstResponder];
        //显示等待进度条
        if (!_hud) {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.mode = MBProgressHUDModeText;
        }
        [_hud show:YES];
        _hud.labelText = @"正在登录...";
        //发起数据请求
        NSString *username = [self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *userpassword = self.userPassword.text;
        [[User sharedUser] userLogin:[NSDictionary dictionaryWithObjectsAndKeys:username,@"username",userpassword,@"userpsw", nil]];
    }
}

#pragma mark - 对textfield的输入内容进行合法性检查
- (BOOL)checkTextfieldIsValid
{
    NSString *userNameStr = [self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (userNameStr.length == 0) {
        [self shake:self.userName];
        return NO;
    }
    NSString *userPasswordStr = self.userPassword.text;
    if (userPasswordStr.length == 0) {
        [self shake:self.userPassword];
        return NO;
    }
    return YES;
}

#pragma mark - 当文本输入框输入不合法时产生抖动效果
- (void)shake:(UITextField *)textField
{
    [textField.layer setBorderWidth:1.0];
    [textField.layer setBorderColor:UIColorFromRGB(0x54bdae).CGColor];
    [textField shake:10 withDelta:3.0 andSpeed:0.08 shakeDirection:ShakeDirectionHorizontal];
    [self performSelector:@selector(hideAlarmTextfieldColor:) withObject:textField afterDelay:0.8];
}

- (void)hideAlarmTextfieldColor:(UITextField *)textField
{
    [textField.layer setBorderColor:0];
    [textField.layer setBorderColor:[UIColor clearColor].CGColor];
}


#pragma mark - UserDelegate
- (void)loginSucceededWithResult:(NSInteger)result
{
    if (result == 1) {
        // 登录成功
        [[GlobalVariables sharedGlobalVariables] setGuideId:[self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
        // 记录登录状态
        NSString *userLogin = [NSString stringWithFormat:@"%@_login",[self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
        [settings setObject:[NSNumber numberWithBool:YES] forKey:userLogin];
        [settings synchronize];
        
        if ([[self presentingViewController] isKindOfClass:[HomeViewController class]]) {
            // 说明是由homeVC跳转过来
            [self dismissViewControllerAnimated:YES completion:^{
                // 开启心跳包
                [[MessageBL sharedMessageBL] startHeartBeatPacket];
                
                if (self.rememberPswControl.tag == RememberUserPswYes)
                {
                    // 记住密码
                    [SSKeychain setPassword:self.userPassword.text forService:KCServiceName account:[self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                } else
                {
                    // 不记住密码
                    [SSKeychain setPassword:@"" forService:KCServiceName account:[self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                }
            }];
            
        } else
        {
            // 转到HomeViewController
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"] animated:YES completion:^{
                if (self.rememberPswControl.tag == RememberUserPswYes)
                {
                    // 记住密码
                    [SSKeychain setPassword:self.userPassword.text forService:KCServiceName account:[self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                } else
                {
                    // 不记住密码
                    [SSKeychain setPassword:@"" forService:KCServiceName account:[self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                }
            }];
        }
    } else if (result == 0)
    {
        _hud.labelText = @"账号或密码错误";
    } else if (result == 2)
    {
        _hud.labelText = @"账号已经在线";
    }
    [_hud hide:YES afterDelay:1.0];
}

- (void)loginFailedWithError:(NSError *)error
{
    _hud.labelText = @"登录异常";
    [_hud hide:YES afterDelay:1.0];
}

#pragma mark -
- (void)dealloc
{
    [_hud removeFromSuperview];
    _hud = nil;
}
@end

