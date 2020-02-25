//
//  CustomTabBar.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "CustomTabBar.h"
#import "UIColor+_Hex.h"
@interface CustomTabBar ()
@property (nonatomic, strong) UIButton *plusBtn;
@end
@implementation CustomTabBar

- (UIButton *)plusBtn{
    if(!_plusBtn){
        
        _plusBtn = [[UIButton alloc]init];
        [_plusBtn setImage:UIImageWithFileName(@"Tabbar-3-select") forState:UIControlStateNormal];
        _plusBtn.backgroundColor = [UIColor whiteColor];
        [_plusBtn addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _plusBtn;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.bounds.size.width/(self.items.count +1);
    CGFloat btnH = self.bounds.size.height;
    
    int i =0;
    for (UIView *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i == 2) {
                i = 3;
            }
            btnX = i * btnW;
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i ++;
        }
    }
    
    CGFloat ySpace = 0;
    if (IS_IPHONEX) {
        ySpace = 12;
    }
    
    self.plusBtn.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - ySpace);
    
    self.plusBtn.bounds = CGRectMake(0, 0, 42, 42);
    [self addSubview:self.plusBtn];
    
    NSLog(@"%@",NSStringFromCGPoint(self.center));
    
    
    
}
-(void)plusBtnClick:(UIButton *)sender{
    self.clickBlock();
}
@end
