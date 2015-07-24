//
//  CommonUtility.m
//  MangaBook
//
//  Created by Ryou Zhang on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonUtility.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h> 
#import "CocoaSecurity.h"

@implementation CommonUtility
+(NSString*)generateMD5Key:(NSString*)sourceText
{
    const char *cStr = [sourceText UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call

    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString*)urlEncodedString:(NSString*)sourceText
{
    @autoreleasepool
    {
        NSString *newString =
        CFBridgingRelease(
                          CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (__bridge CFStringRef)sourceText,
                                                                  NULL,
                                                                  CFSTR("/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                                  kCFStringEncodingUTF8));
        return newString;
    }
}

+(NSString*)urlDecodingString:(NSString*)sourceText
{
    @autoreleasepool
    {
	NSString *result = [sourceText stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
    }
}

+(NSMutableDictionary*)parserQueryText:(NSString*)queryText
{
    NSMutableDictionary* paramDic = [NSMutableDictionary new];
    const char* queryPtr = [queryText cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableString* name = nil;
    NSMutableString* value = nil;
    NSMutableString* temp = nil;
    for(NSInteger index = 0; index < [queryText length]; index++,queryPtr++)
    {
        switch ((*queryPtr))
        {
            case '=':
            {
                name = temp;
                temp = nil;
            }
                break;
            case '&':
            {
                value = temp;
                temp = nil;
                if (name) {
                    [paramDic setObject:[CommonUtility urlDecodingString:value] forKey:name];
                }
                
            }
                break;
            default:
            {
                if(temp == nil)
                    temp = [NSMutableString new];
                [temp appendFormat:@"%c",*queryPtr];
            }
                break;
        }
    }
    if(name != nil && temp != nil)
    {
        [paramDic setObject:[CommonUtility urlDecodingString:temp] forKey:name];
    }
    queryPtr = NULL;
    return paramDic;
}

+(NSString*)signatureURL:(NSString*)url Args:(NSMutableDictionary*)args With:(NSString*)secretKey
{
    NSMutableString* content = [NSMutableString stringWithString:@""];
    
//    [args setObject:[NSString stringWithFormat:@"%d",((int)[[NSDate date] timeIntervalSince1970])]
//             forKey:@"e"];
    
    for(NSString* key in [[args allKeys] sortedArrayUsingSelector:@selector(compare:)])
        [content appendString:[NSString stringWithFormat:@"%@", [args objectForKey:key]]];
    
    
    [args setObject:[CocoaSecurity hmacSha1:content hmacKey:secretKey].base64 forKey:@"key"];
    
    NSMutableString* result = [NSMutableString stringWithString:@""];
    [result appendString:url];
    for(NSInteger index=0; index < [[args allKeys] count]; index++)
    {
        NSString* key = [[args allKeys] objectAtIndex:index];
        if(index == 0)
            [result appendFormat:@"?%@=%@",key,[CommonUtility urlEncodedString:[NSString stringWithFormat:@"%@", [args objectForKey:key]]]];
        else
            [result appendFormat:@"&%@=%@",key,[CommonUtility urlEncodedString:[NSString stringWithFormat:@"%@", [args objectForKey:key]]]];
    }
    return result;
}

+(NSString*)signatureArgs:(NSMutableDictionary*)args With:(NSString*)secretKey
{
    
    NSMutableString* content = [NSMutableString stringWithString:@""];
    
    [args setObject:[NSString stringWithFormat:@"%d",((int)[[NSDate date] timeIntervalSince1970])/3600]
             forKey:@"e"];
    
    for(NSString* key in [[args allKeys] sortedArrayUsingSelector:@selector(compare:)])
            [content appendString:[NSString stringWithFormat:@"%@", [args objectForKey:key]]];
    
    [args setObject:[CocoaSecurity hmacSha1:content hmacKey:secretKey].base64 forKey:@"key"];
    
    NSMutableString* result = [NSMutableString stringWithString:@""];
    for(NSInteger index=0; index < [[args allKeys] count]; index++)
    {
        NSString* key = [[args allKeys] objectAtIndex:index];
        if(index == 0)
            [result appendFormat:@"%@=%@",key,[CommonUtility urlEncodedString:[NSString stringWithFormat:@"%@", [args objectForKey:key]]]];
        else
            [result appendFormat:@"&%@=%@",key,[CommonUtility urlEncodedString:[NSString stringWithFormat:@"%@", [args objectForKey:key]]]];
    }
    return result;
}

+(NSString*)signatureEParasWithArgs:(NSMutableDictionary*)args  With:(NSString*)secretKey Date:(int)date
{
    
    NSMutableString* content = [NSMutableString stringWithString:@""];
    
    [args setObject:[NSString stringWithFormat:@"%d",((int)date)] forKey:@"e"];
    
    for(NSString* key in [[args allKeys] sortedArrayUsingSelector:@selector(compare:)])
        [content appendString:[NSString stringWithFormat:@"%@", [args objectForKey:key]]];
    
    return [CocoaSecurity hmacSha1:content hmacKey:secretKey].base64;
}

//DES加密
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSUInteger dataLength = [data length];
    size_t dataAvailabel = (dataLength/1024)*1024+ (dataLength%1024==0?0:1024);
    
    char buffer[dataAvailabel];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          dataAvailabel,
                                          &numBytesEncrypted);

    if (cryptStatus == kCCSuccess)
    {
        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte* bb = (Byte*)[dataTemp bytes];
        return [CommonUtility parseByteArray2HexString:bb];
    }
    else
    {
        return nil;
    }
}

// DES解密
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSData *textData = [CommonUtility parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    size_t dataAvailabel = (dataLength/1024)*1024+ (dataLength%1024==0?0:1024);

    char buffer[dataAvailabel];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [textData bytes],
                                          dataLength,
                                          buffer,
                                          dataAvailabel,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSUInteger dataMoved = (NSUInteger)numBytesEncrypted;
        NSData *dataTemp = [NSData dataWithBytes:buffer length:dataMoved];
        NSString* decryptStr = [NSString stringWithUTF8String:[dataTemp bytes]];
        return decryptStr;
    }
    else
    {
        return nil;
    }
}


+(NSString *) parseByteArray2HexString:(Byte[]) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return [hexStr uppercaseString];
}


+(NSData*) parseHexToByteArray:(NSString*) hexString
{
    int j=0;
    Byte bytes[hexString.length/2];
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
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}

+(UIColor*)parseColorByString:(NSString*)str
{
     str = @"FAFBFC";
    NSString* prefix = @"0x";
    NSString* sub1 = [str substringWithRange:NSMakeRange(0, 2)];
    NSString* sub2 = [str substringWithRange:NSMakeRange(2, 2)];
    NSString* sub3 = [str substringWithRange:NSMakeRange(4, 2)];
//    DLog(@"===========sub1,2,3 = (%@, %@, %@)", sub1, sub2, sub3);
    NSInteger num1 = [[prefix stringByAppendingString:sub1] integerValue];
    NSInteger num2 = [[prefix stringByAppendingString:sub2] integerValue];
    NSInteger num3 = [[prefix stringByAppendingString:sub3] integerValue];
//    DLog(@"===========sub1,2,3 = (%zd, %zd, %zd)", num1, num2, num3);
    return [UIColor colorWithRed:num1/255.0 green:num2/255.0 blue:num3/255.0 alpha:1.0];
}
@end
