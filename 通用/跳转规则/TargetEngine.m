//
//  TargetEngine.m
//  YaYaGongShe
//
//  Created by icash on 16-3-5.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "TargetEngine.h"
//#import "PYSearch.h"
//#import "LGXGifView.h"
#import "GeneralWebViewController.h" // 网页
#import "MainViewController.h"
#import "RequestSence.h"
//#import "LGXThirdEngine.h" // 第三方分享
#import "AppDelegate.h" //
#import "SharedClient.h"
#import "LGXThirdEngine.h"

@interface TargetEngine ()
//<LGXPhotoBrowserDelegate,UIWebViewDelegate>

//@property (nonatomic, strong) LGXPhotoBrowserController *photoBrowserView;
@property (nonatomic, strong) NSArray *photosArr;
@end

@implementation TargetEngine


/// 单例初始化
+ (instancetype)sharedInstance
{
    static TargetEngine *_target = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _target = [[TargetEngine alloc] init];
    });
    return _target;
}
+ (CGSize)sizeWithXSizeString:(NSString *)str
{
    NSString *screen = [NSString stringWithFormat:@"%@",str];
    screen = [screen uppercaseString];
    NSArray *sizearr = [screen componentsSeparatedByString:@"X"];
    CGSize contentSize;
    if ([sizearr count] !=2) {
        contentSize =  CGSizeZero;
    } else {
        contentSize = CGSizeMake([sizearr.firstObject floatValue], [sizearr.lastObject floatValue]);
    }
    return contentSize;
}
//获取当前屏幕显示的viewcontroller,可能是nav / tab / 等
+ (UIViewController *)getCurrentViewController
{
    UIViewController *result = [WWPublicMethod getCurrentViewController];
    
    return result;
}
/// 获取当前viewController
+ (UIViewController *)getRealViewController
{
    UIViewController *controller = [self getCurrentViewController];
    
    //
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabcontroller = (UITabBarController *)controller;
        controller = tabcontroller.selectedViewController;
    }
    if (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navcontroller = (UINavigationController *)controller;
        controller = navcontroller.topViewController;
    }
    return controller;
}
/// 关闭当前界面,这个界面肯定是第二层及以上的界面
+ (void)closeCurrentView
{
    UIViewController *controller = [self getCurrentViewController];
    
    //
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabcontroller = (UITabBarController *)controller;
        controller = tabcontroller.selectedViewController;
    }
    if (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navcontroller = (UINavigationController *)controller;
        controller = navcontroller.topViewController;
    }
    if (controller.presentingViewController) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    } else {
        /// 可能是推进来的
        [controller.navigationController popViewControllerAnimated:YES];
    }
}
/// 打分
+ (void)gotoScore
{
    NSString *url=[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",kAPPID];// ios 7.1上可以跳转商城打分，7.0貌似只能跳到商城的app界面
    NSURL *OPENURL = [NSURL URLWithString:url];
    BOOL succ =  [[UIApplication sharedApplication] canOpenURL:OPENURL];
    if (succ == NO) {
        [_kHUDManager showFailedInView:nil withTitle:NSLocalizedString(@"dkpgsdsb", nil) hideAfter:_kHUDDefaultHideTime onHide:nil];
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:[NSDictionary new] completionHandler:nil];

}
/// 显示弹窗广告
+ (void)showAdvAlertWith:(NSString *)tJson
{
    /*
    NSDictionary *dic = [WWPublicMethod objectTransFromJson:tJson];
    NSDictionary *params = [dic objectForKey:@"params"];
    NSString *url = [NSString stringWithFormat:@"%@",[params objectForKey:@"url"]];
    
    NSString *screen = [NSString stringWithFormat:@"%@",[params objectForKey:@"screen"]];
    CGSize contentSize = [TargetEngine sizeWithXSizeString:screen];
    
    NSString *str = [NSString stringWithFormat:@"%@",[params objectForKey:@"size"]];
    CGSize size = [TargetEngine sizeWithXSizeString:str];
    
    LGifModel *Lmodel = [[LGifModel alloc] init];
    Lmodel.url = url;
    Lmodel.photoSize = size;
    Lmodel.screenSize = contentSize;
    Lmodel.isADV = YES;
    Lmodel.event = [params objectForKey:@"event"];
    
    [LGXGifView showGifAtScreenWithModel:Lmodel];
     */
}
/** 请求
 {
 "type": "http",
 "cmd": "http://gutou.com/aa.php",
 "method": "POST",
 "params": "[{"key":"username","value":"tj"},{key value}]",
 "show_hud": "0"
 }
 */
+ (void)sendHttpRequestWithTarget:(NSString *)targetJson
{
    NSDictionary *dic = [WWPublicMethod objectTransFromJson:targetJson];
    NSString *url = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cmd"]];
    NSString *requestMethod = [NSString stringWithFormat:@"%@",[dic objectForKey:@"method"]];
    NSArray *params = [dic objectForKey:@"params"];
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionary];
    for (int i =0; i<params.count; i++) {
        NSDictionary *tmpDic = [params objectAtIndex:i];
        id key = [tmpDic objectForKey:@"key"];
        id value = [tmpDic objectForKey:@"value"];
        [finalParams setObject:value forKey:key];
    }
    NSString *show_hud = [NSString stringWithFormat:@"%@",[dic objectForKey:@"show_hud"]];
    BOOL shouldShowHud = [show_hud boolValue];
    if (shouldShowHud) {
        [_kHUDManager showActivityInView:nil withTitle:@"请求中"];
    }
    RequestSence *reqsence = [[RequestSence alloc] init];
    reqsence.pathURL = url;
    reqsence.requestMethod = requestMethod;
    reqsence.params = [NSMutableDictionary dictionaryWithDictionary:finalParams];
    reqsence.successBlock = ^(id obj) {
        if (shouldShowHud) {
            [_kHUDManager hideAfter:0 onHide:nil];
        }
    };
    reqsence.errorBlock = ^(NSError *error) {
        if (shouldShowHud) {
            [_kHUDManager hideAfter:0 onHide:nil];
        }
    };
    [reqsence sendRequest];
}
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
/**
 * 推送，如果fromController为nil，则会自动判断
 * target的格式 ： {"type":"push", "view":"goods_detail", "pushId":"123"}
 * 具体规则见：http://doc.epetbar.com:801/doku.php?id=target  或 实现方法
 */
+ (void)pushViewController:(UIViewController *)toController fromController:(UIViewController *)fromController withTarget:(id)targetJson
{
    NSDictionary *target = nil;
    if ([targetJson isKindOfClass:[NSString class]]) {
        target = [TargetEngine objectTransFromJson:targetJson];
    } else {
        target = [NSDictionary dictionaryWithDictionary:targetJson];
        targetJson = [TargetEngine jsonTransFromObject:targetJson];
    }
    if (target == nil || [target isKindOfClass:[NSDictionary class]]==NO) {
        return;
    }
    NSString *type = [target objectForKey:@"type"];
    if (type == nil) {
        return;
    }
    // 分享
    if ([type isEqual:@"share"]) {
        [[LGXThirdEngine sharedInstance] share:targetJson];
        return;
    }
    // 复制
    if ([type isEqual:@"copy"]) {
        NSString *copy_content = [target objectForKey:@"copy_content"];
        [TargetEngine controller:nil pushToController:PushTargetCopy WithTargetId:copy_content];
        return;
    }
    // 网址请求
    if ([type isEqual:@"http"]) {
        
        [TargetEngine sendHttpRequestWithTarget:targetJson];
        
        return;
    }
    if ([type isEqual:@"toast"]) { // 吐司
        [_kHUDManager showToastInView:nil atPosition:JGProgressHUDPositionCenter withTitle:[target objectForKey:@"msg_content"] hideAfter:_kHUDDefaultHideTime onHide:nil];
        return;
    }
    // 弹窗广告
    if ([type isEqual:@"showpic"]) {
        [TargetEngine showAdvAlertWith:targetJson];
        return;
    }
    if ([type isEqual:@"close"]) {
        [TargetEngine closeCurrentView];
        return;
    }
    // 去评分
    if ([type isEqual:@"goscore"]) {
        [TargetEngine gotoScore];
        return;
    }
    
    if ([type isEqual:@"push"] == NO) {
        return;
    }
    id params = [target objectForKey:@"pushId"];
    NSString *pushId = nil;
    if (params == nil || [params isKindOfClass:[NSDictionary class]]) {
        pushId = @"";
    }  else {
        pushId = [NSString stringWithFormat:@"%@",params];
    }
    
    /// 推到哪里
    NSString *cmd = [target objectForKey:@"view"];
    
    PushTargetType targetType = PushTargetNone;
    
    if ([cmd isEqualToString:@"goods_detail"]) { // 详情页
    
        NSDictionary *goodDic;
        if ([params isKindOfClass:[NSString class]]) {
            id goods_id = params;
            goodDic=@{
                        @"goods_id":goods_id,
                        @"goodlist":@(YES),
                        @"goods_spec_id":@"0",
                        @"act_id":@"0",
                        @"wsid":@"0",
                        };
        }else{
            id goods_id = [params objectForKey:@"goods_id"];
            id goods_spec_id = [params objectForKey:@"goods_spec_id"];
            id act_id = [params objectForKey:@"act_id"];
            goodDic=@{
                        @"goods_id":goods_id,
                        @"goodlist":@(YES),
                        @"goods_spec_id":goods_spec_id,
                        @"act_id":act_id,
                        @"wsid":@"0",
                        };
        }
        
        pushId=[WWPublicMethod jsonTransFromObject:goodDic];
        targetType = PushTargetGoodsDetail;
        
    }else if ([cmd isEqualToString:@"web"]) { // webview 网页
        

        
//        targetType = PushTargetWebView;
        
    }else if ([cmd isEqualToString:@"webQQ"]) { // webview 外部QQ聊天
//        pushId=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",pushId];
//        targetType = PushTargetWebView;
        
        [WWPublicMethod openPhoneQQ:pushId];
  
    }
   
    else if ([cmd isEqualToString:@"gps_device"]){//我的相册
//        targetType = PushTargetBindEquipment;
    }
    
//    else if ([cmd isEqualToString:@"add_friend"]){//添加好友，发送验证
//
//        if ([params isKindOfClass:[NSDictionary class]]) {
//            NSString *user_id = [params objectForKey:@"user_id"];
//            NSString *resource = [params objectForKey:@"resource"];
//            pushId = [NSString stringWithFormat:@"%@&%@",user_id,resource];
//        }
//
//        targetType = PushTargetSendVerification;
//    }
   
//
//    else if ([cmd isEqualToString:@"notifications"]){
//        targetType = PushTargetMessageNotice;
//    }
//    else if ([cmd isEqualToString:@"usercontact_remark"]){
//
//
//        pushId = [WWPublicMethod jsonTransFromObject:params];
//        targetType = PushTargetModifyFriendRemark;
//    }
//    else if ([cmd isEqualToString:@"user_devices"]){
//        targetType = PushTargetBindEquiemenrList;
//    }
//    else if ([cmd isEqualToString:@"user_nearby"]){
//        //附近的人
//        targetType = PushTargetNearbyTheManView;
//    }
//    else if ([cmd isEqualToString:@"user_adopt"]){
//        //宠物领养
//        targetType = PushTargetMyPetsAdoptView;
//    }
//    else if ([cmd isEqualToString:@"store_preaudit_apply"]){
//        //门店入驻
//        targetType = PushTargetStoresInIndex;
//    }
//    else if ([cmd isEqualToString:@"store_preaudit"]){
//        //门店入驻详情
//        targetType = PushTargetStoresInIndexDetail;
//    }
//    else if ([cmd isEqualToString:@"store_franchisee"]){
//        //我的门店
//        targetType = PushTargetMineStoresView;
//    }
    
    [self controller:fromController pushToController:targetType WithTargetId:pushId];
}


/**
 * 跳转某个界面
 */
+ (void)controller:(UIViewController *)fromController pushToController:(PushTargetType)targetType WithTargetId:(NSString *)pushId
{
    if ([pushId isKindOfClass:[NSString class]] == NO) {
        pushId = [NSString stringWithFormat:@"%@",pushId];
    }
//    MainViewController *tabbarController = (MainViewController *)[[UIApplication sharedApplication].windows.firstObject rootViewController];
    
    //
    if (fromController == nil) {
        fromController = [self getCurrentViewController];
    }
    if ([fromController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabcontroller = (UITabBarController *)fromController;
        fromController = tabcontroller.selectedViewController;
    }
    if (fromController.presentedViewController) {
        fromController = fromController.presentedViewController;
    }

    if ([fromController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navcontroller = (UINavigationController *)fromController;
        fromController = navcontroller.topViewController;
    }
    
    /// 推到哪个界面
    UIViewController *toController;
    
    switch (targetType) {
//        case PushTargetWebView: // 网页
//        {
//            GeneralWebViewController *controller = [[GeneralWebViewController alloc] init];
//            controller.url = pushId;
//            toController = controller;
//        }
//            break;
//        case PushTargetDebugControl: //  测试
//        {
//            UIViewController *controller = [[NSClassFromString(@"DebugController") alloc] init];
//            toController = controller;
//        }
//            break;
//        case PushTargetCreateOrderView: // 申请订单
//        {
//            if ([_kUserModel checkLoginStatus]) {
//                NewCreateOrderController *controller = [[NewCreateOrderController alloc] init];
//                controller.requestParams = pushId;
//                LGXNavigationController *nav = [[LGXNavigationController alloc] initWithRootViewController:controller];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [fromController presentViewController:nav animated:YES completion:NULL];
//                });
//            }
//
//            return;
//        }
//
//        case PushTargetScore: // 打分
//        {
//            [TargetEngine gotoScore];
//            return;
//        }
//            break;

        case PushTargetMyHomeView: // 首页
        {
//            int aindex = 0;
//            tabbarController.selectedIndex = aindex;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                UINavigationController *nav = [tabbarController.viewControllers objectAtIndex:aindex];
//                [nav popToRootViewControllerAnimated:YES];
//            });
//            return;
        }
            break;
        case PushTargetRegistered: //  快速注册
        {
//            RegisteredViewController *controller = [[RegisteredViewController alloc] init];
//            controller.thirdId = pushId;
//            toController = controller;
        }
            break;
     
//        case PushTargetPetCategoryDetail: //  选择宠物品种
//        {
//            PetCategoryDetailController *controller = [[PetCategoryDetailController alloc] init];
//            controller.petId = pushId;
//            toController = controller;
//        }
//            break;
     
   
        default:
            break;
    }
    
    if (toController) {
        toController.hidesBottomBarWhenPushed = YES;
        [fromController.navigationController pushViewController:toController animated:YES];
    }
}
+ (void)showNoPhoneAlertWithPhone:(NSString *)pushId
{
    NSString *title = [NSString stringWithFormat:@"您当前设备不支持电话功能，您可以使用其他设备拨打下面的电话\n%@",pushId];
//    [TCAlertView showAlert:TCAlertViewInfo WithTitle:title closeButton:@"好的" andOthers:@[] onClicked:^(NSInteger index) {
//    }];
    
//    [[TCNewAlertView shareInstance] showAlert:nil message:title cancelTitle:nil viewController:nil confirm:^(NSInteger buttonTag) {
//    } buttonTitles:@"好的", nil];
    
}

+ (void)callPhoneWithPhone:(NSString *)pushId
{
    UIViewController * vc = [self getCurrentViewController];
    
    NSString *title = [NSString stringWithFormat:@"呼叫客服电话\n%@",pushId];

//    [[TCNewAlertView shareInstance] showAlert:nil message:title cancelTitle:NSLocalizedString(@"cancel", nil) viewController:nil confirm:^(NSInteger buttonTag) {
//        if (buttonTag==0) {
//
//            NSString *telURL = [NSString stringWithFormat:@"tel://%@",pushId]; // telprompt
//            BOOL canCall;
//            NSURL *openURL = [NSURL URLWithString:telURL];
//            if (IS_UNDER_IOS_10) {
//                canCall = [[UIApplication sharedApplication] openURL:openURL];
//                if (!canCall) {
//                    [_kHUDManager showMsgInView:vc.view withTitle:@"呼叫失败" isSuccess:YES];
//                }
//            } else {
//                [[UIApplication sharedApplication] openURL:openURL options:@{} completionHandler:^(BOOL success) {
//                    if (success == NO) {
//                        [_kHUDManager showMsgInView:vc.view withTitle:@"呼叫失败" isSuccess:YES];
//                    }
//                }];
//            }
//
//        }
//    } buttonTitles:@"呼叫", nil];
    
}

@end
