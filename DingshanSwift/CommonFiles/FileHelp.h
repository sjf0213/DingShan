//
//  FileHelp.h
//  CoreFramework
//
//  Created by xiong qi on 14-2-17.
//  Copyright (c) 2014年 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelp : NSObject
{
    @package
    NSFileManager*          fileManager;
    NSMutableDictionary*    appDirectoryDic;
}
+(FileHelp*)shareInstance;
-(NSString*)getAppDirectory:(NSSearchPathDirectory)directoryType;

-(BOOL)isFileExist:(NSString*)filePath;
-(BOOL)isDirectoryExist:(NSString*)directoryPath;

-(NSArray*)getFilesInDirectory:(NSString*)directoryPath byType:(NSString*)fileType error:(NSError*)error;
-(NSDictionary*)getAttributeInFile:(NSString*)filePath error:(NSError*)error;

-(void)setFile:(NSString*)filePath  attribute:(NSDictionary*)attribute error:(NSError*)error;
-(void)createDirectory:(NSString*)directoryPath error:(NSError*)error;
-(void)deleteDirectory:(NSString*)directoryPath error:(NSError*)error;
-(void)deleteFile:(NSString*)filePath error:(NSError*)error;
-(void)copyItemFrom:(NSString*)sourcePath to:(NSString*)targetPath error:(NSError*)error;

-(void)clearDirectory:(NSString*)directoryPath error:(NSError*)error;
@end
