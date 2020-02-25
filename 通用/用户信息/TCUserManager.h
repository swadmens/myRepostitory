//
//  UserModel.h
//  TaoChongYouPin
//
//  Created by icash on 16/8/30.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@class IMALoginParam;
/// 登录界面隐藏后返回
typedef void(^didLoginViewHideBlock)();

#define _kUserModel [TCUserManager sharedInstance]

@interface TCUserManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL isLogined;

/// 检测是否登录
- (BOOL)checkLoginStatus;
/// 调登录界面
- (void)showLoginView;
/// 隐藏登录界面
- (void)hideLoginViewWithBlock:(didLoginViewHideBlock)block;
/// 普通登录方法
- (void)loginWithUser_id:(NSDictionary*)dict;
/// 退出登录
- (void)loginOutWhenSuccessed:(void(^)(void))finishedBlock;
///登录腾讯云
-(void)makeIm_accountWithData:(NSDictionary*)dict;


/// 处理登录、注册、完善资料的数据
- (void)setupInfoData:(id)obj;

/// 用户最后登录帐号记录
@property (nonatomic, strong) NSString *loginAcount;
/// 用户信息
@property (nonatomic, strong) UserInfoModel *userInfo;

/// 申请重新认证了
@property (nonatomic, assign) BOOL needReIdentifier;

/// 处理用户信息
@property (nonatomic, strong) NSString *uid;
/// 头像
@property (nonatomic, strong) NSString *avatar;
/// 昵称
@property (nonatomic, strong) NSString *nickname;



#pragma mark - 个人中心列表数据
/// 个人中心列表数据
@property (nonatomic, strong) NSArray *userCenterList;
//个人中心我的宠物
@property(nonatomic,strong) NSMutableArray *user_pet;

//个人中心信息数据
@property(nonatomic,strong) NSDictionary *user_info_dic;

//SNS_QQ
@property(nonatomic,strong) NSDictionary *sns_qq;
//SNS_WECHAT
@property(nonatomic,strong) NSDictionary *sns_wechat;
//SNS_WEIBO
@property(nonatomic,strong) NSDictionary *sns_weibo;

//腾讯云登录
@property (nonatomic,strong) IMALoginParam *loginParam;


#pragma mark - 选货购物车
/// 选中的
@property (nonatomic, strong) NSMutableDictionary *selectedGoodsIdDic;
@property (nonatomic, strong) NSMutableArray *chosedData;
@property (nonatomic, assign) NSUInteger chosedGoodsCount;

#pragma mark - 全局需要的方法
/// 同步服务器用户信息
- (void)updateUserInfo;
/// 保存数据
- (void)saveDataWhenEnterBackground;

/// 版本更新
- (void)checkAppVersion;

@end

/// 登录状态改变了
static NSString *const kLoginStatusChangedHandle = @"tc.loginStatusChanged";
/// 头像改变了
static NSString *const kUserInfoChangedHandle = @"tc.userinfoChanged";
/// 是否登录的key
static NSString *const _kUserIsLoginKey = @"u.isLoginedInKey";
/// uid
static NSString *const _kUserIDKey = @"u.user_id";
/// 头像
static NSString *const _kAvatarKey = @"u.user_avatar";
/// 昵称
static NSString *const _kNicknameKey = @"u.user_nickname";
/// 登录帐号记录
static NSString *const _kLoginAcountKey = @"u.user_acount";



