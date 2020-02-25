//
//  UCenterListItem.m
//  TaoChongYouPin
//
//  Created by iCash on 2017/7/13.
//  Copyright © 2017年 FusionHK. All rights reserved.
//

#import "UCenterListItem.h"

@implementation UCenterSection

+ (NSArray *)getListByData:(NSArray *)list
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:list.count];
    for (NSArray *section in list) {
        UCenterSection *smodel = [[UCenterSection alloc] init];
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:section.count];
        for (NSDictionary *dic in section) {
            UCenterListItem *item = [UCenterListItem makeItemBy:dic];
            [sectionArray addObject:item];
        }
        smodel.sectionList = [NSArray arrayWithArray:sectionArray];
        [sectionArray removeAllObjects]; sectionArray = nil;
        [tempArray addObject:smodel];
    }
    return [NSArray arrayWithArray:tempArray];
}

@end

@implementation UCenterListItem
+ (UCenterListItem *)makeItemBy:(NSDictionary *)dic
{
    UCenterListItem *item = [[UCenterListItem alloc] init];
    
    item.icon = [dic objectForKey:@"icon"];
    item.name = [dic objectForKey:@"name"];
    item.tip = [dic objectForKey:@"tip"];
    item.target = [dic objectForKey:@"target"];
    item.corner = [NSString stringWithFormat:@"%@",[dic objectForKey:@"corner"]];
    item.is_more = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"is_more"]] boolValue];
    
    return item;
}
@end
