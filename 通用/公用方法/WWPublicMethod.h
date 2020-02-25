//
//  WWPublicMethod.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

typedef void(^SaveImageCompletion)(ALAsset *asset,NSError* error);
//typedef void(^SaveImageCompletion)(PHAsset *asset,NSError* error);


@interface WWPublicMethod : NSObject
<UIWebViewDelegate>
#pragma mark - json 操作
/// obj 转jsonString
+ (NSString *)jsonTransFromObject:(id)obj;
/// json 转 obj
+ (id)objectTransFromJson:(NSString *)jsonString;

//实体对象转为字典对象
+ (NSDictionary *) entityToDictionary:(id)entity;

#pragma mark - 字符串相关处理
/// 是否是身份证，只进行了位数判断
+ (BOOL)isIDCardNumber:(NSString *)str;
/// 将手机号转成中间前3位+*+后4位
+ (NSString *)getCodingPhoneNumber:(NSString *)phone;
/// 是否是手机号码
+ (BOOL)isPhoneNumber:(NSString *)str;
/// 检查字符串是否为纯空，去掉空格后
+ (BOOL)isStringEmptyText:(NSString *)str;
/// 判断是否为数字
+ (BOOL)isNumberString:(NSString *)str;
/// base64编码
+ (NSString *)encodeBase64:(NSString *)string;
/// base64解码
+ (NSString *)dencodeBase64:(NSString *)string;
//只获取字符串中的数字
+ (NSString*)getStringInNumber:(NSString*)string;
//邮箱格式是否正确
+ (BOOL)isValidateEmail:(NSString *)email;
//当前语言是否是中文
+ (BOOL)isCurrentLanguageChina;



/**
 计算文字长度
 
 @param text 文字
 @param font 字体
 @return 长度
 */
+ (CGFloat )widthForLabel:(NSString *)text fontSize:(UIFont*)font;

#pragma mark - 举报
/// 举报哪个文章
+ (void)reportArticle:(NSString *)aid;
/// 举报人?
+ (void)reportPerson:(NSString *)uid;

+(void)openPhoneQQ:(NSString *)qqNumber;


#pragma mark - 照片处理
/// 把某个view截图
+ (UIImage *)captureView:(UIView *)view;
+ (void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
+ (void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
#pragma mark - 获取当前屏幕的controller
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentViewController;

//查看大图self.scrollview_tops.subviews[i]; 、、、、、
+(void)lookImage:(NSArray *)imageArrays index:(NSInteger )index imageViewArrays:(NSArray *)fromImageViewArray;


//改变图片的尺寸
+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
//指定比例缩放图片
+(UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale;
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size;



//字符串首字母排序
+ (NSString*)makeAlphabeticOrdering:(NSDictionary*)dict;

//获取聊天签名
+(NSString*)getChatUserSign:(NSString*)account_id;

//是否开启了定位功能
+(BOOL)openLocationServiceWithBlock;




@end
