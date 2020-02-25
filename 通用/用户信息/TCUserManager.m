//
//  UserModel.m
//  TaoChongYouPin
//
//  Created by icash on 16/8/30.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "TCUserManager.h"

#import "LoginViewController.h"
#import "LGXNavigationController.h"
#import "LoginSence.h"
#import "SCLAlertView.h"
#import "UCenterListItem.h"
#import "JPUSHService.h"
#import "LEEAlert.h"
#import "VersionUpdateView.h"

@interface TCUserManager ()
{
    BOOL _isAlertShown;
}
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) LoginSence *loginSence;

@property (nonatomic, strong) SCLAlertView *versionAlert;

@end

@implementation TCUserManager
@synthesize isLogined = _isLogined;
@synthesize uid = _uid;
@synthesize avatar = _avatar;
@synthesize nickname = _nickname;
@synthesize loginAcount = _loginAcount;



+ (id)sharedInstance
{
    static TCUserManager *_user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[TCUserManager alloc] init];
    });
    return _user;
}
- (NSUserDefaults *)userDefaults
{
    _userDefaults = [NSUserDefaults standardUserDefaults];
    return _userDefaults;
}
/// 保存
- (void)saveObject:(id)obj toKey:(NSString *)key
{
    [self.userDefaults setObject:obj forKey:key];
    [self.userDefaults synchronize];
}
/// 保存bool
- (void)saveBOOL:(BOOL)obj toKey:(NSString *)key
{
    [self.userDefaults setBool:obj forKey:key];
    [self.userDefaults synchronize];
}
#pragma mark - 登录相关
- (BOOL)checkLoginStatus
{
    if (self.isLogined == NO) {
        
        [self showLoginView];
    }
    return self.isLogined;
}

/// 调登录界面
- (void)showLoginView
{
    UIWindow *_window = (UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
    LoginViewController *loginController = [[LoginViewController alloc] init];
    LGXNavigationController *nav = [[LGXNavigationController alloc] initWithRootViewController:loginController];
    [_window.rootViewController presentViewController:nav animated:YES completion:nil];
}

/// 隐藏登录界面
- (void)hideLoginViewWithBlock:(didLoginViewHideBlock)block
{
    NSArray *windowsArr = [UIApplication sharedApplication].windows;
    
    UIWindow *_window = (UIWindow *)[windowsArr objectAtIndex:0];
    
    [_window.rootViewController dismissViewControllerAnimated:YES completion:^{
        if (block) {
            block();
        }
    }];
    
    if (_kUserModel.userInfo.isClickLoginOut) {
        [TargetEngine controller:nil pushToController:PushTargetMyHomeView WithTargetId:nil];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isClickLoginOut"];
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"isClickLoginOut"];
    
}

- (LoginSence *)loginSence
{
    if (!_loginSence) {
        _loginSence = [[LoginSence alloc] init];
        __unsafe_unretained typeof(self) weak_self = self;
        _loginSence.successBlock = ^(id obj){
            [weak_self didLoginFinished:obj];
        };
        _loginSence.errorBlock = ^(NSError *error){
            [weak_self didLoginFailed:error];
        };
    }
    return _loginSence;
}
/// 普通登录方法
- (void)loginWithUser_id:(NSDictionary*)dict
{
    if (self.loginSence.isRunning) {
        return;
    }

    [_kHUDManager showActivityInView:nil withTitle:NSLocalizedString(@"logining", nil)];

    self.loginSence.user_id = [dict objectForKey:@"user_id"];
    self.loginSence.ec_salt = [dict objectForKey:@"ec_salt"];
    self.loginSence.passwd = [dict objectForKey:@"passwd"];
    self.loginSence.login_key = [dict objectForKey:@"login_key"];
    self.loginSence.region = [dict objectForKey:@"region"];
    self.loginSence.longitude = [dict objectForKey:@"longitude"];
    self.loginSence.latitude = [dict objectForKey:@"latitude"];


    [self.loginSence sendRequest];
}
- (void)setLoginAcount:(NSString *)loginAcount
{
    _loginAcount = loginAcount;
    [self saveObject:_loginAcount toKey:_kLoginAcountKey];
}
- (NSString *)loginAcount
{
    if (!_loginAcount) {
        _loginAcount = [self.userDefaults objectForKey:_kLoginAcountKey];
    }
    return _loginAcount;
}
#pragma mark - 登录请求返回后的两个回调
- (void)didLoginFinished:(id)obj
{
    /// 保存用户信息
    [self didLoginedInWithData:obj];
//    [self lastLoginUpDevices];
}
- (void)didLoginFailed:(NSError *)error
{
    NSString *msg = [error.userInfo objectForKey:@"msg"];
    if (msg) {
        [_kHUDManager showMsgInView:nil withTitle:msg isSuccess:NO];
    } else {
        [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"loginFailed", nil) isSuccess:NO];
    }
}

#pragma mark - 用户信息配置
- (void)didLoginedInWithData:(id)obj
{
    [self didLoginedInWithData:obj whenHideBlock:nil];
}
- (void)didLoginedInWithData:(id)obj whenHideBlock:(didLoginViewHideBlock)block
{
    [self setupInfoData:obj];
    
    self.isLogined = YES;
    self.needReIdentifier = YES;

    [self hideLoginViewWithBlock:block];
}
/// 处理登录、注册、完善资料的数据
- (void)setupInfoData:(id)obj
{
//    [_kHUDManager showActivityInView:nil withTitle:NSLocalizedString(@"dataProcessing", nil)];
    [_kHUDManager showActivityInView:nil withTitle:nil];

    
    /// 登录、注册、完善资料、第三方登录返回的是同一个
    NSDictionary *data = [obj objectForKey:@"data"];
    
    NSString *token=[data objectForKey:@"token"];
    NSString *session_id=[data objectForKey:@"session_id"];
    NSString *saveToken = [NSString stringWithFormat:@"yubei%@",token];
    
    //保存用户信息
    _kUserModel.userInfo.session_id = session_id;
    _kUserModel.userInfo.session_token = MD5(saveToken);
    
    //更新用户信息
    [self updateUserInfo];
    
    [_kHUDManager hideAfter:0 onHide:nil];
}
- (UserInfoModel *)userInfo
{
    if (!_userInfo) {
        _userInfo = [UserInfoModel read];
        if (_userInfo == nil) {
            _userInfo = [[UserInfoModel alloc] init];
        }
    }
    return _userInfo;
}
/// 处理用户信息
- (void)setupUserInfo:(NSDictionary *)uInfo
{
   
    

    NSDictionary *newPerData = [NSDictionary dictionaryWithDictionary:uInfo];
    if ([newPerData isEqualToDictionary:self.user_info_dic]) {
        return;
    }

    // 处理用户中心列表信息
    NSArray *item = [uInfo objectForKey:@"item"];
    [self takecareOfItemListForUserCenter:item];
    
    // 处理用户中心我的宠物信息
    NSArray *petInfo = [uInfo objectForKey:@"user_pet"];
    [self makeMinePetInfoWithData:petInfo];
    
    self.sns_qq = (NSDictionary*)[uInfo objectForKey:@"sns_qq"];
    self.sns_wechat = (NSDictionary*)[uInfo objectForKey:@"sns_wechat"];
    self.sns_weibo = (NSDictionary*)[uInfo objectForKey:@"sns_weibo"];

    
    // 处理用户信息
    [self.userInfo makeUserModelWithData:uInfo];
    self.user_info_dic = uInfo;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedHandle object:nil];
}
- (void)takecareOfItemListForUserCenter:(NSArray *)item
{
    if (![item isKindOfClass:[NSArray class]]) {
        return;
    }
//    self.userCenterList = [UCenterSection getListByData:item];
}
//处理个人中心我的宠物信息
-(void)makeMinePetInfoWithData:(NSArray*)array
{
    

}

//处理个人中心我的account_id信息
-(void)makeIm_accountWithData:(NSDictionary*)dict
{
    _kUserModel.userInfo.account_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"account_id"]];
    _kUserModel.userInfo.password = [NSString stringWithFormat:@"%@",[dict objectForKey:@"password"]];
    
//    [self loginTencent:_kUserModel.userInfo.account_id];
    
}



#pragma mark - 资料
/*
/// 检测是否完善资料
- (BOOL)checkFileStatus
{
    if (self.isFinishedFile == NO) {
        [self showFileView];
    }
    return self.isFinishedFile;
}

- (void)showFileView
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_kHUDManager hideAfter:0 onHide:nil];
        UIWindow *_window = (UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
        FinishUserFileController *controller = [[FinishUserFileController alloc] init];
        LGXNavigationController *nav = [[LGXNavigationController alloc] initWithRootViewController:controller];
        [_window.rootViewController presentViewController:nav animated:YES completion:nil];
    });
}
*/

#pragma mark - 退出登录或注销
/// 退出登录
- (void)loginOutWhenSuccessed:(void(^)(void))finishedBlock
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
    RequestSence *_outSence = [[RequestSence alloc]init];
    _outSence.pathURL = @"users/logout";
    _outSence.params=[NSMutableDictionary dictionary];

    [_outSence.params setValue:[WWPublicMethod makeAlphabeticOrdering:nil] forKey:kSignKey];

    __weak typeof(self) weak_self = self;
    _outSence.successBlock = ^(id obj){
        [_kHUDManager showMsgInView:nil withTitle:[obj objectForKey:@"msg"] isSuccess:YES];
        if (finishedBlock) {
            finishedBlock();
        }
        [weak_self didLoginOut];
    };
    _outSence.errorBlock = ^(NSError *error){
        NSString *msg = [error.userInfo objectForKey:@"msg"];
        if (msg) {
            [_kHUDManager showMsgInView:nil withTitle:msg isSuccess:NO];
        } else {
            [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"outingFailed", nil) isSuccess:NO];
        }
    };
    [_outSence sendRequest];
}
/// 登出了
- (void)didLoginOut
{
    self.isLogined = NO;
    self.needReIdentifier = NO;
    
    /// 弹出登录
    [self checkLoginStatus];
    
    self.uid = @"";
    self.nickname = @"";
    self.avatar = @"";
    
    self.userInfo.session_id = @"";
    self.userInfo.session_token = @"";
    
    
//    /// 清除极光推送信息
//    [JPUSHService setTags:[NSSet set] alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
//        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
//    }];
    
}

/*
/// 是否完善了资料
- (void)setIsFinishedFile:(BOOL)isFinishedFile
{
    if (isFinishedFile == _isFinishedFile) {
        return;
    }
    _isFinishedFile = isFinishedFile;
    
    [self saveBOOL:_isFinishedFile toKey:_kFinishedFileKey];
    /// 如果完善了资料，继续发送登录状态改变了
    if (_isFinishedFile) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusChangedHandle object:nil];
    }
}
- (BOOL)isFinishedFile
{
    if (self.isLogined == NO) {
        return NO;
    }
    NSUserDefaults *defaults = self.userDefaults;
    _isFinishedFile = [defaults boolForKey:_kFinishedFileKey];
    return _isFinishedFile;
}
*/
/// 是否登录
- (void)setIsLogined:(BOOL)isLogined
{
    if (isLogined == _isLogined) {
        return;
    }
    _isLogined = isLogined;
    if (_isLogined == NO) {
        // 清除cookies
//        [RequestSence clearCookies];
    }
    [self saveBOOL:_isLogined toKey:_kUserIsLoginKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusChangedHandle object:nil];
//    [self registJPushAlias];
    
    /// 设置友盟帐号统计
//    [self setupUmengProgileSignStatus];
    
}
- (BOOL)isLogined
{
    NSUserDefaults *defaults = self.userDefaults;
    _isLogined = [defaults boolForKey:_kUserIsLoginKey];
    return _isLogined;
}
/// 用户id
- (NSString *)uid
{
    _uid = self.userInfo.user_id;
    return _uid;
}

///
- (NSString *)avatar
{
    _avatar = nil;
    return _avatar;
}


#pragma mark - 注册jpush
/*
- (void)registJPushAlias
{
    [JPUSHService setTags:nil alias:self.uid callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    ALog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
/// 设置友盟帐号统计
- (void)setupUmengProgileSignStatus
{
    if (self.isLogined) {
        if (self.isThirdLogin) {
            [LGXUmengManager profileSignInWithPUID:self.uid provider:UMThirdWeChat];
        } else {
            [LGXUmengManager profileSignInWithPUID:self.uid provider:UMThirdNone];
        }
        
    } else {
        [LGXUmengManager profileSignOff];
    }
}
*/

#pragma mark - 全局需要的方法
/// 同步服务器用户信息
- (void)updateUserInfo
{
    RequestSence *baseSence = [[RequestSence alloc] init];
    baseSence.pathURL = @"users/baseinfo";
    baseSence.params=[NSMutableDictionary dictionary];
    [baseSence.params setValue:[WWPublicMethod makeAlphabeticOrdering:nil] forKey:kSignKey];
    __unsafe_unretained typeof(self) weak_self = self;
    baseSence.successBlock = ^(id obj) {
        [weak_self setupUserInfo:[obj objectForKey:@"data"]];
    };
    baseSence.errorBlock = ^(NSError *error) {
//        [weak_self didLoginOut];
    };

    if (baseSence.isRunning) {
        return;
    }
    [baseSence sendRequest];
}
/// 保存数据
- (void)saveDataWhenEnterBackground
{
    // 用户信息保存
    [self.userInfo save];
}

#pragma mark - 版本更新
/// 版本更新
- (void)checkAppVersion
{
    RequestSence *sence = [[RequestSence alloc] init];
    sence.pathURL = @"versionctrl/update";
    sence.params = [NSMutableDictionary dictionary];
    [sence.params setObject:APPVersion forKey:@"version"];
    [sence.params setObject:@"iOS" forKey:@"system"];

    sence.successBlock = ^(id obj) {

        [self finishedVersionUpdate:obj];
    };

    [sence sendRequest];
}
- (void)finishedVersionUpdate:(id)obj
{
    
    id data = [obj objectForKey:@"data"];
    NSString *new_version = [data objectForKey:@"version"];
    NSString *old_version = [WWPhoneInfo getAPPVersion];

    
    // 没有新版本
    if ([old_version compare:new_version options:NSNumericSearch] == NSOrderedDescending) {
        _isAlertShown = NO;
        return;
    }
    
    if (_isAlertShown) { // 如果显示了
        return;
    }
    
    NSString *update_detail = [data objectForKey:@"update_detail"];
    BOOL need_update = [[NSString stringWithFormat:@"%@",[data objectForKey:@"need_update"]] boolValue];
    NSString *download_url = [data objectForKey:@"download_url"];
    
    NSArray *buttons = @[NSLocalizedString(@"goUpdate", nil), NSLocalizedString(@"jump", nil)];
    if (need_update) {
        buttons = @[NSLocalizedString(@"updateVersion", nil)];
    }
    
    UIImage *image = UIImageWithFileName(@"version_update_image");
    CGSize imageSize = image.size;
    CGFloat width= imageSize.width;
    
    UILabel *expireLabel = [UILabel new];
    expireLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    expireLabel.text = update_detail;
    expireLabel.numberOfLines = 0;
    expireLabel.frame = CGRectMake(0, 0, width - 30, MAXFLOAT);
    // 计算size,sizeToFit会使用label的width来计算最佳的height
    [expireLabel sizeToFit];
    CGSize contentHeight = CGSizeFromString(NSStringFromCGSize(expireLabel.frame.size));
    
    
    CGFloat totalHeight = imageSize.height + contentHeight.height + 125;
    
    VersionUpdateView *view = [[VersionUpdateView alloc] initWithFrame:CGRectMake(0, 0, width, totalHeight)];
    if (buttons.count == 2) {
        view.updateBtn.hidden = YES;
    }else{
        view.btnView.hidden = YES;
    }
    view.expireLabel.text = update_detail;

    view.closeBackCoverButton = ^{
        [LEEAlert closeWithCompletionBlock:nil];
        _isAlertShown = YES;
    };
    view.reviceBounsButton  = ^{
        [LEEAlert closeWithCompletionBlock:nil];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:download_url] options:[NSDictionary new] completionHandler:^(BOOL success) {

        }];
        _isAlertShown = YES;

    };

    UIColor *color=UIColorFromRGB(0x333333, 0);
    [LEEAlert alert].config
    .LeeHeaderColor(color)
    .LeeCustomView(view)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeShow();
    _isAlertShown = YES;

}

@end
