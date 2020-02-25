//
//  TCAlertView.h
//  TaoChongYouPin
//
//  Created by icash on 16/9/7.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TCAlertViewStyle)
{
    TCAlertViewSuccess,
    TCAlertViewError,
    TCAlertViewNotice,
    TCAlertViewWarning,
    TCAlertViewInfo,
    TCAlertViewEdit,
    TCAlertViewWaiting,
    TCAlertViewQuestion,
    TCAlertViewCustom
};

@interface TCAlertView : NSObject

/**
 * 自定的alert
 * @param alertStyle 样式
 * @param title 标题
 * @param closeTitle 关闭按钮的标题
 * @param others 其他按钮标题的集合
 * @param clickedBlock 回调从下标0开始返回others的按钮点击。关闭按钮点了，不返回
 */
+ (void)showAlert:(TCAlertViewStyle)alertStyle
        WithTitle:(NSString *)title
      closeButton:(NSString *)closeTitle
        andOthers:(NSArray *)others
        onClicked:(void(^)(NSInteger index))clickedBlock;


@end
