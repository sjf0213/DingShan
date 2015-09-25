//
//  OSSData.h
//  OSSDemo
//
//  Created by 郭天 on 14/11/3.
//  Copyright (c) 2014年 郭 天. All rights reserved.
//
/*!
 @header OSSData.h
 @abstract 直接对NSData数据进行操作
 */
#import <Foundation/Foundation.h>
#import "OSSObject.h"

@class OSSBucket;
@class TaskHandler;

/*!
 @class
 @abstract 提供上传、下载、复制和删除接口
 */
@interface OSSData : OSSObject

/*!
 @property
 @abstract 当前网络请求连接
 */
@property (atomic, retain, strong)NSURLConnection *connection;

/*!
 @method
 @abstract 使用bucket和key初始化一个OSSData实例，bucket为数据所在的bucket，key为object key
 */
- (instancetype)initWithBucket:(OSSBucket *)bucket withKey:(NSString *)key;

/*!
 @property
 @abstract 标示是否开启了md5校验
 */
@property (nonatomic) BOOL isCheckMd5Open;

/*!
 @method
 @abstract 取消当前异步上传或下载操作
 */
- (void)cancel __attribute__ ((deprecated));

/*!
 @method
 @abstract 生成一个public资源的url
 */
- (NSString *)getResourceURL;

/*!
 @method
 @abstract 生成一个private资源的url，当前用户的accessKey，availablePeriodInSeconds是url可用时间
 */
- (NSString *)getResourceURL:(NSString *)accessKey
                   andExpire:(int)availablePeriodInSeconds;

/*!
 @method
 @abstract 在进行上传之前需要调用该函数设置待上传的数据，以及数据的content type属性
 */
- (void)setData:(NSData *)nsdata withType:(NSString *)type;

/*!
 @method
 @abstract 在要调用getRange方法之前需要调用该方法设置需要下载的字节数据范围
 */
- (void)setRangeFrom:(long)begin to:(long)end;

/*!
 @method
 @abstract 阻塞下载数据，error用来存放错误信息
 */
- (NSData *)get:(NSError **)error;

/*!
 @method
 @abstract 非阻塞下载数据，并实现progress来访问进度
 */
- (TaskHandler *)getWithDataCallback:(void (^)(NSData *, NSError *))onGetCompleted
                withProgressCallback:(void (^)(float))onProgress;
/*!
 @method
 @abstract 阻塞删除该object
 */
- (void)delete:(NSError **)error;

/*!
 @method
 @abstract 非阻塞删除该object
 */
- (void)deleteWithDeleteCallback:(void (^)(BOOL, NSError *))onDeleteCompleted;

/*!
 @method
 @abstract 上传时是否开启md5校验
 */
- (void)enableUploadCheckMd5sum:(BOOL)isOpen;

/*!
 @method
 @abstract 阻塞上传，并指定为contentType
 */
- (void)upload:(NSError **)error;

/*!
 @method
 @abstract 支持server回调的阻塞上传
 */
- (NSData *)uploadAndCallServer:(NSError **)error;

/*!
 @method
 @abstract 非阻塞上传，实现progressCallback来访问上传进度
 */
- (TaskHandler *)uploadWithUploadCallback:(void (^)(BOOL, NSError *))onUploadCompleted
                     withProgressCallback:(void (^)(float))onProgress;

/*!
 @method
 @abstract 支持server回调的非阻塞上传接口
 */
- (TaskHandler *)uploadAndCallServerWithUploadCallback:(void (^)(BOOL, NSData *, NSError *))onUploadCompleted
                                  withProgressCallback:(void (^)(float))onProgress;

/*!
 @method
 @abstract 阻塞从指定的object复制
 */
- (void)copyFromBucket:(NSString *)bucket
                   key:(NSString *)key
                 error:(NSError **)error;

/*!
 @method
 @abstract 非阻塞从指定的object复制
 */
- (void)copyFromWithBucket:(NSString *)bucket
                   withKey:(NSString *)key
          withCopyCallback:(void (^)(BOOL, NSError *))onCopyCompleted;

/*!
 @method
 @abstract 获取指定范围的数据
 */
- (NSData *)getRange:(OSSRange *)range withError:(NSError **)error;
@end
