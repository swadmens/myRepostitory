//
//  LoginTextfieldCell.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/19.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

@interface LoginTextfieldCell : WWTableViewCell

@property (nonatomic,strong) void(^textFieldLogin)(NSString*text);
@property (nonatomic,strong) void(^sendCodeButton)(void);


-(void)makeCellData:(NSString*)icon withPlace:(NSString*)placeholder withTag:(NSInteger)tag withStyle:(NSString*)style;

@end
