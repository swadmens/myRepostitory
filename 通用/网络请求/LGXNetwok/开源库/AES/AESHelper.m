//
//  AESHelper.m
//  MacauFirstBalloon
//
//  Created by user on 13-4-18.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "AESHelper.h"
#import "NSData+AES128.h"
#define AES_KEY @"f3e00ec14c4cecba" // 加密用的key
#define AES_IV  @"f3e00ec14c4cecba"  //偏移量
@implementation AESHelper
//解密字串
+ (NSString *)decryptionString:(NSString *)ciphertext
{
    //解密
    NSData *data=[[self hexStringToData:ciphertext] AES128DecryptWithKey:AES_KEY iv:AES_IV];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

//加密字符串
+ (NSString *)encryptString:(NSString *)plaintext
{
    //加密
    NSData *data=[[plaintext dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptWithKey:AES_KEY iv:AES_IV];
    return [self dataTohexString:data];
}
//将data转换为十六进制的字符串
+ (NSString *)dataTohexString:(NSData*)data
{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];//16进制数
        if([newHexStr length]==1)
            hexStr = [NSString  stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
//将十六进制的字符串转换为data
+ (NSData*)hexStringToData:(NSString*)hexString
{
    //NSString *hexString = @"3e435fab9c34891f"; //16进制字符串
    int j=0;
    Byte bytes[hexString.length];  ///3ds key的Byte 数组， 128位
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        //NSLog(@"int_ch=%x",int_ch);
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:j];
    //NSLog(@"newData=%@",newData);
    return newData;
}
@end
