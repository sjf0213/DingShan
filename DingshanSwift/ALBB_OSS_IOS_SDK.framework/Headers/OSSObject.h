//
//  OSSObject.h
//  OSSDemo
//
//  Created by 郭天 on 14/11/4.
//  Copyright (c) 2014年 郭 天. All rights reserved.
//

/*!
 @header OSSObject.h
 @abstract Created by 郭天 on 14/11/3.
 */
#import <Foundation/Foundation.h>

@class OSSBucket;
@class OSSRange;
@class ListObjectResult;
@class ListObjectOption;

typedef NS_ENUM(NSUInteger, TASK_STATUS) {
    OSS_INITIAL,
    OSS_CANCELED,
    OSS_COMPLETED
};
/*!
 @class
 @abstract 设定bucket和key
 */
@interface OSSObject : NSObject
/*!
 @property
 @abstract 存放content type
 */
@property (nonatomic, strong)NSMutableString *contentType;
/*!
 @property
 @abstract 设定下载范围
 */
@property (nonatomic, strong)OSSRange *range;
/*!
 @property
 @abstract 存放meta信息
 */
@property (nonatomic, strong)NSMutableDictionary *metaDictionary;
/*!
 @property
 @abstract 设置bucket
 */
@property (nonatomic, strong)OSSBucket *bucket;
/*!
 @property
 @abstract 设置object的key
 */
@property (nonatomic, strong)NSString *key;

/*!
 @property
 @abstract 任务状态：已取消、已完成
 */
@property (atomic, assign) BOOL status;

/*!
 @method
 @abstract 初始化bucket和key
 */
- (instancetype)initWithBucket:(OSSBucket *)bucket withKey:(NSString *)key;

/*!
 @method
 @abstract 设置自定义meta
 */
- (void)setMetaKey:(NSString *)key withMetaValue:(NSString *)value;

/*!
 @method
 @abstract 构建使用发往OSS服务器的请求
 */
- (NSMutableURLRequest *)constructRequestWithMethod:(NSString *)method
                                            withMd5:(NSString *)md
                                        withContype:(NSString *)contentType
                                        withXossDic:(NSDictionary *)xossHeaderDic
                                         withBucket:(NSString *)bucket
                                            withKey:(NSString *)objectKey
                                         withQuerys:(NSString *)querys
                                          withRange:(OSSRange *)range;
- (BOOL)checkIsCanceledAndReset;
@end
