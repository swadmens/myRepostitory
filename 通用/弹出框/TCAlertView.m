//
//  TCAlertView.m
//  TaoChongYouPin
//
//  Created by icash on 16/9/7.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "TCAlertView.h"
#import "SCLAlertView.h"

@implementation TCAlertView


+ (void)showAlert:(TCAlertViewStyle)alertStyle
        WithTitle:(NSString *)title
      closeButton:(NSString *)closeTitle
        andOthers:(NSArray *)others
        onClicked:(void(^)(NSInteger index))clickedBlock
{
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:(kMainScreenSize.width - 50*2)];
    for (int i =0; i<others.count; i++) {
        NSString *oTitle = [others objectAtIndex:i];
        [alert addButton:oTitle actionBlock:^(void) {
            if (clickedBlock) {
                clickedBlock(i);
            }
        }];
    }
    
    // 点外面是否可以隐藏
    alert.shouldDismissOnTapOutside = YES;
    // 隐藏的动画模式.
//    alert.hideAnimationType = SlideOutToBottom;
    
    // 显示的动画模式
//    alert.showAnimationType = SlideInFromLeft;
    
    // 背景样式
//    alert.backgroundType = Blur;
    
    // Buttons, top circle and borders colors
    alert.customViewColor = kColorMainColor;
    
    // 图标颜色
    alert.iconTintColor = kColorYellowTextColor;
    
    // Override top circle tint color with background color
//    alert.tintTopCircle = NO;
    
    // alert的圆角
    alert.cornerRadius = 13.0f;
    title = [NSString stringWithFormat:@"\n%@\n",title];
    // 背景色
    alert.backgroundViewColor = [UIColor whiteColor];
    switch (alertStyle) {
        case TCAlertViewSuccess:
        {
            [alert showSuccess:@" " subTitle:title closeButtonTitle:closeTitle duration:0.0f];
        }
            break;
        case TCAlertViewError:
        {
            [alert showError:@" " subTitle:title closeButtonTitle:closeTitle duration:0.0f];
        }
            break;
        case TCAlertViewInfo:
        {
//            [alert showCustom:nil image:UIImageWithFileName(@"alert_icon_info") color:nil title:@" " subTitle:title closeButtonTitle:closeTitle duration:0.0f];
            
            [alert showInfo:@" " subTitle:title closeButtonTitle:closeTitle duration:0.0f];
        }
            break;
        case TCAlertViewNotice:
        {
            [alert showNotice:@" " subTitle:title closeButtonTitle:closeTitle duration:0.0f];
        }
            break;
        case TCAlertViewWarning:
        {
            [alert showWarning:@" " subTitle:title closeButtonTitle:closeTitle duration:0.0f];
        }
            break;
        case TCAlertViewQuestion:
        {
            [alert showQuestion:@" " subTitle:title closeButtonTitle:closeTitle duration:0.0f];
        }
            break;
        default:
            break;
    }
    
    
}

@end
