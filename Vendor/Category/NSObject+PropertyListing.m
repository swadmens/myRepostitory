//
//  NSObject+PropertyListing.m
//  TaoChongYouPin
//
//  Created by icash on 16/8/30.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "NSObject+PropertyListing.h"
#import <objc/runtime.h>


@implementation NSObject (PropertyListing)

+ (NSAttributedString *)attstringWithContent:(NSString *)content
{
    NSAttributedString *attstr = nil;
    if ([content isKindOfClass:[NSString class]] == NO || content.length <= 0) {
        return attstr;
    }
    NSString *divStr = @"<div></div>";
    divStr = @"";
    if ([content rangeOfString:@"<meta charset=\"UTF-8\">"].location == NSNotFound) {
        content = [NSString stringWithFormat:@"<meta charset=\"UTF-8\">%@%@",content,divStr];
    } else {
        content = [NSString stringWithFormat:@"%@%@",content,divStr];
    }
    if (content && content.length >0) {
        @try {
            NSData *data = [content dataUsingEncoding:NSUnicodeStringEncoding];
            NSError *error = nil;
            attstr = [[NSAttributedString alloc]
                      initWithData:data //
                      options:@{
                                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                }
                      documentAttributes:nil error:&error];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    return attstr;
}

/* 获取对象的所有属性，不包括属性值 */
- (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

/* 获取对象的所有属性 以及属性值 */
- (NSDictionary *)getPropertiesValues
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

/* 获取对象的所有方法 */
-(void)printMothList
{
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++)
    {
        Method temp_f = mothList_f[i];
        IMP imp_f = method_getImplementation(temp_f);
        SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,[NSString stringWithUTF8String:encoding]);
    }
    free(mothList_f);
}
/* 获取属性值 */
- (id)getValueWithProperName:(NSString *)propertyName
{
    if (propertyName.length <= 0) {
        return @"";
    }
    NSDictionary *values = [self getPropertiesValues];
    id value = [values objectForKey:propertyName];
    return value;
}
#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
- (SEL)creatGetterWithPropertyName:(NSString *)propertyName
{
    //1.返回get方法: oc中的get方法就是属性的本身
    return NSSelectorFromString(propertyName);
}
#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
- (SEL)creatSetterWithPropertyName:(NSString *)propertyName
{
    /*
     propertyName.capitalizedString 会把a_b 都变成AB
     所以要单独使用
     */
    NSRange firstRange = NSMakeRange(0, 1);
    NSString *firstStr = [propertyName substringWithRange:firstRange];
    firstStr = firstStr.capitalizedString;
    NSString *finalStr = [propertyName stringByReplacingCharactersInRange:firstRange withString:firstStr];
    //1.首字母大写
    propertyName = finalStr;
    //2.拼接上set关键字
    propertyName = [NSString stringWithFormat:@"set%@:", propertyName];
    //3.返回set方法
    return NSSelectorFromString(propertyName);
}
@end





