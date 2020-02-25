//
//  LGXBadgeRequestSence.m
//  GutouV3
//
//  Created by icash on 15-12-15.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import "LGXBadgeRequestSence.h"

@implementation LGXBadgeRequestSence

- (NSString *)keyType
{
    if (!_keyType) {
        _keyType = @"";
    }
    return _keyType;
}
- (void)doSetup
{
    [super doSetup];
    self.pathURL = @"common.html?do=redtips";
}
- (NSMutableDictionary *)params
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.keyType forKey:@"key_type"];
    return dic;
}
@end
