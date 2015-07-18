//
//  FileHelp.m
//  CoreFramework
//
//  Created by xiong qi on 14-2-17.
//  Copyright (c) 2014年 appfactory. All rights reserved.
//

#import "FileHelp.h"

@implementation FileHelp
+(FileHelp*)shareInstance
{
    static FileHelp *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        fileManager = [NSFileManager new];
        appDirectoryDic = [NSMutableDictionary new];
        
        {
			NSArray* dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            if (dirArray.count > 0)
            {
                [appDirectoryDic setObject:[dirArray objectAtIndex:0]
                                    forKey:[NSNumber numberWithUnsignedInteger:NSDocumentDirectory]];
            }
        }
		{
            
            NSArray* dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
            if (dirArray.count > 0)
            {
                [appDirectoryDic setObject:[dirArray objectAtIndex:0]
                                    forKey:[NSNumber numberWithUnsignedInteger:NSCachesDirectory]];
            }
		}
    }
    return self;
}

-(NSString*)getAppDirectory:(NSSearchPathDirectory)directoryType
{
    return [appDirectoryDic objectForKey:[NSNumber numberWithUnsignedInteger:directoryType]];
}


-(NSArray*)getFilesInDirectory:(NSString*)directoryPath byType:(NSString*)fileType error:(NSError*)error;
{
	NSArray* files = [fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
	
    if(error != nil)
        return nil;
	
	NSMutableArray* resultArray = [NSMutableArray array];
	
	for (NSInteger index=0; index < [files count]; index++)
	{
		NSString* fileName = [files objectAtIndex:index];
		NSString* extType = [fileName pathExtension];
		if(fileType != nil && NO == [extType isEqualToString:fileType])
			continue;
		[resultArray addObject:fileName];
	}
	return resultArray;
}

-(NSDictionary*)getAttributeInFile:(NSString*)filePath error:(NSError*)error
{
    NSDictionary* result = [fileManager attributesOfItemAtPath:filePath
                                                         error:&error];
    if(error != nil)
        return nil;
    
    return result;
}

-(void)updateFileModifyTime:(NSString*)filePath
{
    NSDictionary* attribute = [NSDictionary dictionaryWithObject:[NSDate date]
                                                          forKey:NSFileModificationDate];
    NSError* error = nil;
    [self setFile:filePath attribute:attribute error:error];
}

-(void)setFile:(NSString*)filePath  attribute:(NSDictionary*)attribute error:(NSError*)error
{
    if(NO == [self isFileExist:filePath])
        return;
    
    [fileManager setAttributes:attribute ofItemAtPath:filePath error:&error];
}

-(BOOL)isFileExist:(NSString*)filePath
{
	BOOL isDirectory = NO;
	BOOL result = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
	return result&!isDirectory;
}

-(BOOL)isDirectoryExist:(NSString*)directoryPath
{
	BOOL isDirectory = NO;
	BOOL result = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
	return result&isDirectory;
}

-(void)createDirectory:(NSString*)directoryPath error:(NSError*)error
{
    [fileManager createDirectoryAtPath:directoryPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
}

-(void)deleteDirectory:(NSString*)directoryPath error:(NSError*)error
{
	if(NO == [self isDirectoryExist:directoryPath])
		return;
	
	[fileManager removeItemAtPath:directoryPath error:&error];
}

-(void)clearDirectory:(NSString*)directoryPath error:(NSError*)error
{
   	NSArray* files = [fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
	
    if(error != nil)
        return;
    for(NSString* file in files)
    {
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",directoryPath,file]
                                error:&error];
    }
}


-(void)deleteFile:(NSString*)filePath error:(NSError*)error
{
	if(NO == [self isFileExist:filePath])
        return;
    
	[fileManager removeItemAtPath:filePath error:&error];
}

-(void)copyItemFrom:(NSString*)sourcePath to:(NSString*)targetPath error:(NSError*)error
{
    if([self isFileExist:targetPath])
        [self deleteFile:targetPath error:error];
    [fileManager copyItemAtPath:sourcePath toPath:targetPath error:&error];
}
@end
