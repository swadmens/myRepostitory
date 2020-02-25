//
//  P_Badge.h
//  GutouV3
//
//  Created by icash on 15-12-15.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface P_Badge : NSObject
/// 位置
@property (nonatomic) NSInteger badge_position;
@property (nonatomic, strong) NSString *badge_icon;
@property (nonatomic, strong) NSString *badge_text;

@end
