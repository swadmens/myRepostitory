//
//  TCNewAlertView.h
//  TaoChongYouPin
//
//  Created by 汪伟 on 2017/8/12.
//  Copyright © 2017年 FusionHK. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^AlertViewBlock)(NSInteger buttonTag);
@interface TCNewAlertView : NSObject
#define cancelIndexs    (-1)

+ (TCNewAlertView *)shareInstance;

/**
 *  创建提示框(可变参数版)
 *
 *  @param title        标题
 *  @param message      提示内容
 *  @param cancelTitle  取消按钮(无操作,为nil则只显示一个按钮)
 *  @param vc           VC iOS8及其以后会用到
 *  @param confirm      点击按钮的回调(取消按钮的Index是cancelIndex -1)
 *  @param buttonTitles 按钮(为nil,默认为"确定",传参数时必须以nil结尾，否则会崩溃)
 */
- (void)showAlert:(NSString *)title
          message:(NSString *)message
      cancelTitle:(NSString *)cancelTitle
   viewController:(UIViewController *)vc
          confirm:(AlertViewBlock)confirm
     buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
