//
//  VersionUpdateView.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/7/26.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersionUpdateView : UIView

@property(nonatomic,strong) UILabel *expireLabel;

@property (nonatomic,strong) UIView *btnView;
@property (nonatomic,strong) UIButton *updateBtn;



@property(nonatomic,strong) void(^closeBackCoverButton)();
@property(nonatomic,strong) void(^reviceBounsButton)();

@end
