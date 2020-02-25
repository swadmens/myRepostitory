//
//  TCNewAlertView.m
//  TaoChongYouPin
//
//  Created by 汪伟 on 2017/8/12.
//  Copyright © 2017年 FusionHK. All rights reserved.
//

#import "TCNewAlertView.h"
#import "ColorDefines.h"
#define RootVC  [[UIApplication sharedApplication] keyWindow].rootViewController

@interface TCNewAlertView ()<UIAlertViewDelegate>

@property (nonatomic, copy) AlertViewBlock block;

@end


@implementation TCNewAlertView

#pragma mark - 对外方法
+ (TCNewAlertView *)shareInstance {
    static TCNewAlertView *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[self alloc] init];
    });
    return tools;
}


- (void)showAlert:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle viewController:(UIViewController *)vc confirm:(AlertViewBlock)confirm buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    
    // 读取可变参数里面的titles数组
    NSMutableArray *titleArray = [[NSMutableArray alloc] initWithCapacity:0];
    va_list list;
    if(buttonTitles) {
        //1.取得第一个参数的值(即是buttonTitles)
        [titleArray addObject:buttonTitles];
        //2.从第2个参数开始，依此取得所有参数的值
        NSString *otherTitle;
        va_start(list, buttonTitles);
        while ((otherTitle = va_arg(list, NSString*))) {
            [titleArray addObject:otherTitle];
        }
        va_end(list);
    }
    
    if (!vc) vc = RootVC;
    
    [self p_showAlertController:title message:message
                    cancelTitle:cancelTitle titleArray:titleArray
                 viewController:vc confirm:^(NSInteger buttonTag) {
                     if (confirm)confirm(buttonTag);
                 }];
    
}
- (void)p_showAlertController:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle titleArray:(NSArray *)titleArray viewController:(UIViewController *)vc confirm:(AlertViewBlock)confirm {
    
    UIAlertController  *alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    // 下面两行代码 是修改 title颜色和字体的代码
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName:[UIFont customFontWithSize:16.0f], NSForegroundColorAttributeName:kColorMainTextColor}];
    [alert setValue:attributedMessage forKey:@"attributedMessage"];
    
    
    if (cancelTitle) {
        // 取消
        UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:cancelTitle
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  if (confirm)confirm(cancelIndexs);
                                                                  
                                                              }];
        [cancelAction setValue:kColorMainTextColor forKey:@"titleTextColor"];
        [alert addAction:cancelAction];
    }
    // 确定操作
    if (!titleArray || titleArray.count == 0) {
        UIAlertAction  *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"sure", nil)
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   if (confirm)confirm(0);
                                                               }];
        
        [confirmAction setValue:kColorMainColor forKey:@"titleTextColor"];
        [alert addAction:confirmAction];
    } else {
        
        for (NSInteger i = 0; i<titleArray.count; i++) {
            UIAlertAction  *action = [UIAlertAction actionWithTitle:titleArray[i]
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                if (confirm)confirm(i);
                                                            }];
            [action setValue:kColorMainColor forKey:@"titleTextColor"]; // 此代码 可以修改按钮颜色
            [alert addAction:action];
        }
    }
    
    [vc presentViewController:alert animated:YES completion:nil];
}


@end
