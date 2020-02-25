//
//  WWPublicMethod.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWPublicMethod.h"
#import "JXActionSheet.h"
#import "RequestSence.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import <objc/runtime.h>
#import "YHPhotoBrowser.h"
#import <CoreLocation/CoreLocation.h>


@implementation WWPublicMethod
#pragma mark - json 操作
/// obj 转jsonString
+ (NSString *)jsonTransFromObject:(id)obj
{
    if (obj == nil) {
        return nil;
    }
    NSString *jsonString = nil;
    
    if ([NSJSONSerialization isValidJSONObject:obj])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}
/// json 转 obj
+ (id)objectTransFromJson:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    id obj = nil;
    NSError *error;
    obj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    return obj;
}

+ (NSDictionary *) entityToDictionary:(id)entity
{
    
    Class clazz = [entity class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        
        //        const char* attributeName = property_getAttributes(prop);
        //        NSLog(@"%@",[NSString stringWithUTF8String:propertyName]);
        //        NSLog(@"%@",[NSString stringWithUTF8String:attributeName]);
        
        id value =  [entity performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
        if(value ==nil)
            [valueArray addObject:[NSNull null]];
        else {
            [valueArray addObject:value];
        }
        //        NSLog(@"%@",value);
    }
    
    free(properties);
    
    NSDictionary* returnDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    NSLog(@"%@", returnDic);
    
    return returnDic;
}

/// 是否是身份证，只进行了位数判断
+ (BOOL)isIDCardNumber:(NSString *)str
{
    if ([WWPublicMethod isNumberString:str] && str.length == 18) {
        return YES;
    } else {
        return NO;
    }
}
/// 将手机号转成中间前3位+*+后4位
+ (NSString *)getCodingPhoneNumber:(NSString *)phone
{
    if ([self isPhoneNumber:phone]) {
        NSString *numberString = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return numberString;
    }
    return phone;
}
/// 是否是手机号码
+ (BOOL)isPhoneNumber:(NSString *)str
{
    if ([WWPublicMethod isNumberString:str] && str.length == 11) {
        return YES;
    } else {
        return NO;
    }
}
/// 判断是否为数字
+ (BOOL)isNumberString:(NSString *)str
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}
/// 检查字符串是否为纯空，去掉空格后
+ (BOOL)isStringEmptyText:(NSString *)str
{
    NSString *theString = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (theString.length == 0 || theString == nil || theString == NULL || [theString isEqualToString:@""] || [@"(null)" isEqualToString:theString]) {
        return NO;
    }
    return YES;
}
/**
 *  计算文字长度
 */
+ (CGFloat )widthForLabel:(NSString *)text fontSize:(UIFont*)font
{
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    return size.width;
}

#pragma mark - 举报
/// 举报哪个文章
+ (void)reportArticle:(NSString *)aid
{
    NSArray *reportArr = @[@"广告或垃圾信息", @"色情、淫秽等内容", @"骚扰或人身攻击", @"激进等敏感内容", @"其他"];
    JXActionSheet *sheet = [[JXActionSheet alloc] initWithTitle:@"选择举报原因" cancelTitle:NSLocalizedString(@"cancel", nil) otherTitles:reportArr];
    [sheet showView];
    [sheet dismissForCompletionHandle:^(NSInteger clickedIndex, BOOL isCancel) {
        if (isCancel) {
            return ;
        }
        [WWPublicMethod sendReport:2 to:aid withContent:[reportArr objectAtIndex:clickedIndex]];
    }];
}
+ (void)sendReport:(int)reportType to:(NSString *)tid withContent:(NSString *)content
{
    RequestSence *sence = [[RequestSence alloc] init];
    sence.pathURL = @"User/report";
    sence.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(reportType),@"type",tid,@"tid",content,@"content", nil];
    [sence sendRequest];
}
/// 举报人?
+ (void)reportPerson:(NSString *)uid
{
    NSArray *reportArr = @[@"头像违规", @"昵称违规", @"发布内容违规", @"私信骚扰",@"其他"];
    JXActionSheet *sheet = [[JXActionSheet alloc] initWithTitle:@"选择举报原因" cancelTitle:NSLocalizedString(@"cancel", nil) otherTitles:reportArr];
    [sheet showView];
    [sheet dismissForCompletionHandle:^(NSInteger clickedIndex, BOOL isCancel) {
        if (isCancel) {
            return ;
        }
        [WWPublicMethod sendReport:1 to:uid withContent:[reportArr objectAtIndex:clickedIndex]];
    }];
}

#pragma mark - 照片处理
/// 把某个view截图
+ (UIImage *)captureView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
// 保存新图片 到 相册名
+ (void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock
{
    [[GCDQueue globalQueue] queueAndAwaitBlock:^{
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
                              completionBlock:^(NSURL* assetURL, NSError* error) {
                                  if (error!=nil) {
                                      [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                          completionBlock(asset,error);
                                      } failureBlock:NULL];

                                      return;
                                  }
                                  // 先保存图片，再把这个图片保存到这个相册
                                  [self addAssetURL: assetURL
                                            toAlbum:albumName
                                withCompletionBlock:completionBlock];
                              }];
        
        
        // 保存相片到相机胶卷
//        NSError *error1 = nil;
//        __block PHObjectPlaceholder *createdAsset = nil;
//        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//            createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
//        } error:(NSError error1){
//        }];
        
        
        
    }];
}
// 保存相册中的某个图片 到 相册名
+ (void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock{
    
    if (albumName == Nil) {
        albumName = [WWPhoneInfo getAPPName];
    }
    [[GCDQueue globalQueue] queueAndAwaitBlock:^{
        __block BOOL albumWasFound = NO;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
         
                               usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                   // 如果存在相册名，就保存
                                   if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
                                       albumWasFound = YES;
                                       
                                       [library assetForURL: assetURL
                                                resultBlock:^(ALAsset *asset) {
                                                    
                                                    [group addAsset: asset];
                                                    completionBlock(asset,nil);
                                                    
                                                } failureBlock:^(NSError *error) {
                                                    
                                                    completionBlock(nil,error);
                                                    
                                                }];
                                       return;
                                   }
                                   
                                   if (group==nil && albumWasFound==NO) {
                                       __weak ALAssetsLibrary* weakSelf = library;
                                       [library addAssetsGroupAlbumWithName:albumName
                                                                resultBlock:^(ALAssetsGroup *group) {
                                                                    
                                                                    [weakSelf assetForURL: assetURL
                                                                              resultBlock:^(ALAsset *asset) {
                                                                                  
                                                                                  [group addAsset: asset];
                                                                                  completionBlock(asset,nil);
                                                                                  
                                                                              } failureBlock: ^(NSError *error) {
                                                                                  
                                                                                  completionBlock(nil,error);
                                                                                  
                                                                              }];
                                                                } failureBlock: ^(NSError *error) {
                                                                    completionBlock(nil,error);
                                                                }];
                                       return;
                                   }
                               } failureBlock: ^(NSError *error) {
                                   completionBlock(nil,error);
                               }];
    }];
}
#pragma mark - 获取当前屏幕的controller
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [window subviews].firstObject;
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

//查看大图self.scrollview_tops.subviews[i];
+(void)lookImage:(NSArray *)imageArrays index:(NSInteger )index imageViewArrays:(NSArray *)fromImageViewArray
{
//    int count = (int)imageArrays.count;
//    // 1.封装图片数据
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<count; i++) {
//        // 替换为中等尺寸图片
//        NSString *url = [[imageArrays objectAtIndex:i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:url]; // 图片路径
//        photo.srcImageView = [fromImageViewArray objectAtIndex:i];
//
//        [photos addObject:photo];
//    }
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex =index;
//    //    [browser.view setBackgroundColor:___RGBACOLOR(0, 0, 0, 0.8)];
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
    
 
    
    YHPhotoBrowser *photoView = [[YHPhotoBrowser alloc]init];
    photoView.urlImgArr = imageArrays;           //网络链接图片的数组
    photoView.indexTag = index;                      //初始化进去显示的图片下标
    [photoView show];
    
}

+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
//指定比例缩放图片
+(UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale
{
    //确定压缩后的size
    CGFloat scaleWidth = image.size.width * scale;
    CGFloat scaleHeight = image.size.height * scale;
    CGSize scaleSize = CGSizeMake(scaleWidth, scaleHeight);
    //开启图形上下文
    UIGraphicsBeginImageContext(scaleSize);
    UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);//抗锯齿
    //绘制图片
    [image drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}
/// base64编码
+ (NSString *)encodeBase64:(NSString *)string
{
    //先将string转换成data
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}
/// base64解码
+ (NSString *)dencodeBase64:(NSString *)base64String
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}
//只获取字符串中的数字
+ (NSString*)getStringInNumber:(NSString*)string
{
    NSString *pureNumbers = [[string componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    return pureNumbers;
}
////字符串首字母排序
//+ (NSString*)makeAlphabeticOrdering:(NSDictionary*)dict
//{
//    NSString *session=[NSString stringWithFormat:@"session_id=%@",_kUserModel.userInfo.session_id];
//    NSString *token=[NSString stringWithFormat:@"token=%@",_kUserModel.userInfo.session_token];
//
//
//    if (dict.count==0) {
//        NSString *comAlphs=[NSString stringWithFormat:@"%@&%@",session,token];
////        DLog(@"MD5之前的字符串   ===      %@",comAlphs);
//        return MD5(comAlphs);
//    }
//
//    NSArray *array = [dict allKeys];
//    NSMutableArray *alphArr=[NSMutableArray array];
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString *values=[dict objectForKey:obj];
//        NSString *sins=[NSString stringWithFormat:@"%@=%@",obj,values];
//        [alphArr addObject:sins];
//    }];
//
//    //添加session_id
//    [alphArr addObject:session];
//
//    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
//    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
//    NSComparator sort = ^(NSString *obj1,NSString *obj2){
//        NSRange range = NSMakeRange(0,obj1.length);
//        return [obj1 compare:obj2 options:comparisonOptions range:range];
//    };
//
//    NSArray *resultArray = [alphArr sortedArrayUsingComparator:sort];
//    NSString *alphabet = [resultArray componentsJoinedByString:@"&"];
//    NSString *comAlph=[NSString stringWithFormat:@"%@&%@",alphabet,token];
////    DLog(@"MD5之前的字符串   ===      %@",comAlph);
//
//    return MD5(comAlph);
//}

//获取聊天签名
+(NSString*)getChatUserSign:(NSString*)account_id
{
   static NSString *string;
    RequestSence *sence = [[RequestSence alloc] init];
    sence.pathURL = @"users/im_sign";
    sence.params=[NSMutableDictionary dictionary];
    [sence.params setObject:account_id forKey:@"account_id"];
    NSString *sign = [WWPublicMethod makeAlphabeticOrdering:sence.params];
    [sence.params setValue:sign forKey:kSignKey];
//    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
       string = [NSString stringWithFormat:@"%@",[obj objectForKey:@"data"]];
    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
    };
    [sence sendRequest];
    
    return string;
}
//是否开启了定位功能
+(BOOL)openLocationServiceWithBlock
{
    BOOL isOPen = NO;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        isOPen = YES;
    }
    
    return isOPen;
}
//邮箱格式是否正确
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
////当前语言是否是中文
//+ (BOOL)isCurrentLanguageChina
//{
//    BOOL isChina = YES;
//
//    if (![_kUserModel.userInfo.language_lang isEqualToString:@"0"]) {
//
//        if ([_kUserModel.userInfo.language_lang isEqualToString:@"zh_cn"]) {
//            isChina = YES;
//        }else{
//            isChina = NO;
//        }
//
//    }else{
//        
//        NSString *udfLanguageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
//        if ([udfLanguageCode isEqualToString:@"zh-Hans-CN"]) {
//            isChina = YES;
//        }else{
//            isChina = NO;
//        }
//    }
//
//
//    return isChina;
//}

//裁剪出的图片尺寸按照size的尺寸，但图片不拉伸，但多余部分会被裁减掉
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size
{
    
    CGSize originalsize = [originalImage size];
    
    //原图长宽均小于标准长宽的，不作处理返回原图
    
    if (originalsize.width<size.width && originalsize.height<size.height)
        
    {
        
        return originalImage;
        
    }
    
    
    
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    
    else if(originalsize.width>size.width && originalsize.height>size.height)
        
    {
        
        CGFloat rate = 1.0;
        
        CGFloat widthRate = originalsize.width/size.width;
        
        CGFloat heightRate = originalsize.height/size.height;
        
        
        
        rate = widthRate>heightRate?heightRate:widthRate;
        
        
        
        CGImageRef imageRef = nil;
        
        
        
        if (heightRate>widthRate)
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
            
        }
        
        else
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
            
        }
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        
        
        CGContextTranslateCTM(con, 0.0, size.height);
        
        CGContextScaleCTM(con, 1.0, -1.0);
        
        
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        
        
        
        UIGraphicsEndImageContext();
        
        CGImageRelease(imageRef);
        
        
        
        return standardImage;
        
    }
    
    
    
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    
    else if(originalsize.height>size.height || originalsize.width>size.width)
        
    {
        
        CGImageRef imageRef = nil;
        
        
        
        if(originalsize.height>size.height)
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
            
        }
        
        else if (originalsize.width>size.width)
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
            
        }
        
        
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        
        
        
        　 　　CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        
        CGContextScaleCTM(con, 1.0, -1.0);
        
        
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        
        
        UIGraphicsEndImageContext();
        
        CGImageRelease(imageRef);
        
        
        
        return standardImage;
        
    }
    
    
    
    //原图为标准长宽的，不做处理
    
    else
        
    {
        
        return originalImage;
        
    }
    
    
    
}






@end
