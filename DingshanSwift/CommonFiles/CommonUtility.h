//
//  CommonUtility.h
//  MangaBook
//
//  Created by Ryou Zhang on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define Dump_Chapter_Script  1
#define Dump_Page_Script     2
#import <UIKit/UIKit.h>

@interface CommonUtility : NSObject

+(NSString*)generateMD5Key:(NSString*)sourceText;
+(NSString*)urlEncodedString:(NSString*)sourceText;
+(NSString*)urlDecodingString:(NSString*)sourceText;
+(NSMutableDictionary*)parserQueryText:(NSString*)queryText;

+(NSString*)signatureURL:(NSString*)url Args:(NSMutableDictionary*)args With:(NSString*)secretKey;
+(NSString*)signatureArgs:(NSMutableDictionary*)args With:(NSString*)secretKey;
+(NSString*)signatureEParasWithArgs:(NSMutableDictionary*)args  With:(NSString*)secretKey Date:(int)date;

//DES加密

+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key;

+(NSString *) parseByteArray2HexString:(Byte[]) bytes;
+(NSData*) parseHexToByteArray:(NSString*) hexString;

+(UIColor*)parseColorByString:(NSString*)str;
@end
