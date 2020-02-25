//
//  UITabBar+badgeView.m
//  TaPinCaiXiaoAPP
//
//  Created by icash on 16/8/5.
//  Copyright © 2016年 iCash. All rights reserved.
//

#import "UITabBar+badgeView.h"
#import "LGXBadgeView.h"
#import <objc/runtime.h>

#define TabbarItemNums 4

@interface UITabBar ()

@property (nonatomic, strong) NSMutableDictionary *pointDict;

@end

@implementation UITabBar (badgeView)
- (NSMutableDictionary *)pointDict
{
    NSMutableDictionary *pointDict = objc_getAssociatedObject(self, _cmd);
    return pointDict;
}
- (void)setPointDict:(NSMutableDictionary *)pointDict
{
    SEL key = @selector(pointDict);
    objc_setAssociatedObject(self, key, pointDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (LGXBadgeView *)getBadgeViewAtItem:(int)index
{
    if (self.pointDict == nil) {
        self.pointDict = [NSMutableDictionary dictionary];
    }
    
    id key = @(index);
    
    LGXBadgeView *pointView = [self.pointDict objectForKey:key];
    if (pointView == nil) {
        CGRect tabFrame = self.frame;
        
        //确定小红点的位置
        
        NSString *imageName = [NSString stringWithFormat:@"tab_%d_nor",index+1];
        UIImage *image = [UIImage imageNamed:imageName];
        CGSize imageSize = image.size; //  图片大小
        
        CGFloat width = tabFrame.size.width/TabbarItemNums;
        CGSize itemSize = CGSizeMake(width, tabFrame.size.height); // item的大小
        
        CGFloat marg = 1.5;
        CGFloat itemWidth = (itemSize.width + imageSize.width)/2.0;
        CGFloat x = index * width + itemWidth - marg - 18;
        CGFloat y = 0;
        
        CGFloat itemHeight = tabFrame.size.height/2.0;
        
        
        UIView *badgeView = [[UIView alloc]init];
        badgeView.clipsToBounds = NO;
        
        badgeView.frame = CGRectMake(x, y, itemWidth, itemHeight);
        badgeView.backgroundColor = [UIColor clearColor];
        badgeView.userInteractionEnabled = NO;
        [self addSubview:badgeView];
        
        pointView = [[LGXBadgeView alloc] initWithSuperView:badgeView alignment:LGXBadgeViewAlignmentCenterLeft];
        
        [self.pointDict setObject:pointView forKey:key];
    }
    return pointView;
}
- (void)setBadgeString:(NSString *)string atItem:(int)index
{
    LGXBadgeView *pointView = [self getBadgeViewAtItem:index];
    pointView.badgeValue = string;
}




@end
