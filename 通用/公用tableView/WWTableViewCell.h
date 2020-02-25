//
//  WWTableViewCell.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWTableViewCell : UITableViewCell
/// 初始化
- (void)dosetup;
/**
 * 请关闭 tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
 * @param isTop : 是不是顶部，默认是底部
 * @param color : 默认不用管
 * @param left :  距左多少(默认0) right : 距右多少(默认0)
 */
- (void)showLineAtTop:(BOOL)isTop
            WithColor:(UIColor *)color
                 left:(CGFloat)leftPoint
             andRight:(CGFloat)rightPoint;
/// line的显示或隐藏属性
@property (nonatomic, assign) BOOL lineHidden;

+(NSString*)getCellIDStr;
@end
