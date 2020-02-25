//
//  UserInfoModel.h
//  TaoChongYouPin
//
//  Created by icash on 16/8/30.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const _kUserInfoModelKey = @"ypet.user_info";

@interface UserInfoModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *session_id;
@property (nonatomic, strong) NSString *session_token;

@property (nonatomic, strong) NSString *language_lang;//语言选择

@property (nonatomic,assign) BOOL isTest;//是否是测试

@property (nonatomic,assign) BOOL isClickLoginOut;//是否点击了退出登录


@property (nonatomic, strong) NSString *pet_number;

@property (nonatomic, strong) NSString *notifys_number;

//及时通讯相关
@property(nonatomic,strong) NSString *account_id;
@property(nonatomic,strong) NSString *password;

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_avatar;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *service_phone;
@property (nonatomic, strong) NSString *user_code;
@property (nonatomic, strong) NSString *user_age;
@property (nonatomic, strong) NSString *user_remark;
@property (nonatomic, strong) NSString *user_region;//地区
@property (nonatomic, strong) NSString *user_qrcode;//二维码
@property (nonatomic, strong) NSString *message_num;//未读消息
@property (nonatomic, strong) NSString *zone_number;
@property (nonatomic, strong) NSString *email;//邮箱


@property (nonatomic, strong) NSString *sns_wechat;
@property (nonatomic, strong) NSString *sns_qq;
@property (nonatomic, strong) NSString *sns_weibo;
@property (nonatomic, assign) BOOL is_password;



@property (nonatomic, strong) NSString *chose_pet_id;
@property (nonatomic, strong) NSString *chose_pet_photo;
@property (nonatomic, strong) NSString *chose_pet_name;
@property (nonatomic, strong) NSString *chose_pet_phone;
@property (nonatomic, strong) NSString *chose_pet_lose_place;
@property (nonatomic, strong) NSString *chose_pet_longitude;
@property (nonatomic, strong) NSString *chose_pet_latitude;

@property (nonatomic, strong) NSString *chose_regionCoun;//选择的国家
@property (nonatomic, strong) NSString *chose_regionPro;//选择的地区
@property (nonatomic, strong) NSString *chose_regionCity;//选择的城市


@property (nonatomic,strong) NSString *chose_device_id;//选择的设备ID

/// 资源URL前缀
@property (nonatomic, strong) NSString *resource_url;

/// 用户认证状态 见 SellerStatusType
@property (nonatomic, strong) NSString *sellerStatus;

/// 状态提示语
@property (nonatomic, strong) NSString *user_tip;


/// 性别：0：女，1：男；2：保密
@property (nonatomic, strong) NSString *sex;
/// 消费积分
@property (nonatomic, strong) NSString *integration;
/// 帐号资金
@property (nonatomic, strong) NSString *user_money;
@property (nonatomic, strong) NSString *birthday;

//最终的充值金额
@property(nonatomic,strong) NSString *lastPreMoney;

#pragma mark - 以下都是数量
@property (nonatomic, strong) NSString *collect; // 2		//我的收藏
@property (nonatomic, strong) NSString *collect_word; // 2        //我的收藏


@property (nonatomic, strong) NSString *mine_num; // 0		// 我的


@property(nonatomic,strong) NSString *api_auth_cookie;
@property(nonatomic,assign) int indexShowNum;

/// 更新我的微标
- (void)updateMineBadge;

- (void)makeUserModelWithData:(NSDictionary *)uInfo;
/// 保存,数据会在初始化时自动读取
- (void)save;
+ (UserInfoModel *)read;
// tags 以,号为分割
- (void)setTags:(NSString *)tags andAlias:(NSString *)alias;
@end
