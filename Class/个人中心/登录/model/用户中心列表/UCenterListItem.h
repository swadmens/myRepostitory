//
//  UCenterListItem.h
//  TaoChongYouPin
//
//  Created by iCash on 2017/7/13.
//  Copyright © 2017年 FusionHK. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UCenterSection : NSObject

@property (nonatomic, strong) NSArray *sectionList;

+ (NSArray *)getListByData:(NSArray *)list;

@end

@interface UCenterListItem : NSObject

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) NSString *corner;


/// 右边箭头是否显示，同时表示不可点
@property (nonatomic, assign) BOOL is_more;
@property (nonatomic, strong) id target;

+ (UCenterListItem *)makeItemBy:(NSDictionary *)dic;

@end
