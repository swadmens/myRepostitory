//
//  LoginButtonCell.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/19.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

@interface LoginButtonCell : WWTableViewCell

@property (nonatomic,strong) void(^loginButtonClick)(void);

-(void)makeCellData:(NSString*)title;

@end
