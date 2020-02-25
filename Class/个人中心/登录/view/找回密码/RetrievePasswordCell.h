//
//  RetrievePasswordCell.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/21.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

@interface RetrievePasswordCell : WWTableViewCell

@property (nonatomic,strong) void(^textFieldText)(NSString*text);
@property (nonatomic,strong) void(^sendCodeButton)(void);


-(void)makeCellData:(NSString*)title withPlace:(NSString*)placeholder withTag:(NSInteger)tag withStyle:(NSString*)style;

@end
