//
//  NSObject+PropertyListing.h
//  TaoChongYouPin
//
//  Created by icash on 16/8/30.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 从NSDic中读取key对应的值
#define ReadDictionaryValue(dic,key) [NSString stringWithFormat:@"%@",[dic objectForKey:key]]

@interface NSObject (PropertyListing)

/* 获取对象的所有属性，不包括属性值 */
- (NSArray *)getAllProperties;

/* 获取对象的所有属性 以及属性值 */
- (NSDictionary *)getPropertiesValues;
/* 获取属性值 */
- (id)getValueWithProperName:(NSString *)propertyName;
#pragma mark -- 通过字符串来创建该字符串的Getter方法，并返回
- (SEL)creatGetterWithPropertyName:(NSString *)propertyName;
#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
- (SEL)creatSetterWithPropertyName:(NSString *)propertyName;
/* 获取对象的所有方法 */
-(void)printMothList;

+ (NSAttributedString *)attstringWithContent:(NSString *)content;


@end
