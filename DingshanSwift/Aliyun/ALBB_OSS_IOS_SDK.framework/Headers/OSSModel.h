//
//  OSSModel.h
//  OSS_IOS_SDK_Demo
//
//  Created by zhouzhuo on 7/10/15.
//  Copyright (c) 2015 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class
 @abstract 分块数据的最小单位
 */
@interface UploadPartResult : NSObject

/*!
 @property
 @abstract 记录块的编号
 */
@property (nonatomic, assign)int partNumber;

/*!
 @property
 @abstract 记录对应分块的etag值
 */
@property (nonatomic, strong)NSString *etag;
@end


@interface UploadPartInfo : NSObject
@property (nonatomic, assign)int partNumber;
@property (nonatomic, strong)NSString * etag;
@property (nonatomic, strong)NSString * lastModified;
@property (nonatomic, assign)unsigned long size;
- (NSString *)description;
@end


/*!
 @constant
 @abstract 特殊标示，视不同情况表示文件的开头或者结尾
 */
extern long const Range_INFINITE;

/*!
 @class
 @abstract 构建指定开始和结束的范围
 */
@interface OSSRange : NSObject

/*!
 @property
 @abstract 设置范围开始位置
 */
@property long begin;

/*!
 @property
 @abstract 设置范围结束位置
 */
@property long end;
@end



@interface ResourceToQuery : NSObject

@property (nonatomic) NSString *baseResource;

@property (nonatomic, strong) NSMutableArray *querys;

- (NSString *)toCanoResource;

@end


@interface CallbackBlockBundle : NSObject

@property (nonatomic, strong)void (^noDataRespCallback)(BOOL, NSError *);
@property (nonatomic, strong)void (^handleDataRespCallback)(NSData *, NSError *);
@property (nonatomic, strong)void (^progressCallback)(float);
@property (nonatomic, strong)void (^serverCallback)(BOOL, NSData *, NSError *);
@property (nonatomic)NSString *bucket;
@property (nonatomic)NSString *key;

- (instancetype)initWithNoDataRespCB:(void (^)(BOOL, NSError *))noDataRespCallback
                withHandleDataRespCB:(void (^)(NSData *, NSError *))handleDataRespCallback
                      withProgressCB:(void (^)(float))progressCallback
                        withServerCB:(void (^)(BOOL, NSData *, NSError *))serverCallback;

- (instancetype)initWithBucket:(NSString *)bucket
                       withKey:(NSString *)key
              withNoDataRespCB:(void (^)(BOOL, NSError *))errorCallback;

- (void)onGetDataCompletedWithData:(NSData *)data error:(NSError *)error;

- (void)onNoReturnDataRequestCompleted:(BOOL)isSuccess error:(NSError *)error;
@end



@interface OSSFederationToken : NSObject

@property (nonatomic, strong) NSString *ak;
@property (nonatomic, strong) NSString *sk;
@property (nonatomic, strong) NSString *tempToken;
@property (nonatomic, strong) NSNumber *expiration;

- (instancetype)initWithAk:(NSString *)ak
                        sk:(NSString *)sk
                 tempToken:(NSString *)tempToken
                expiration:(NSNumber *)expiration;

@end


@interface ListObjectOption : NSObject

@property (nonatomic) NSString *delimiter;

@property (nonatomic) NSString *marker;

@property (nonatomic) int maxKeys;

@property (nonatomic) NSString *prefix;

- (NSString *)genQueryString;

@end



@interface ListObjectResult : NSObject

@property (nonatomic) NSString *bucketName;

@property (nonatomic) NSString *prefix;

@property (nonatomic) NSString *marker;

@property (nonatomic) NSString *delimiter;

@property (nonatomic) int maxKeys;

@property (nonatomic) NSString *nextMarker;

@property (nonatomic) BOOL isTruckcated;

@property (nonatomic) NSMutableArray *objectList;

@property (nonatomic) NSMutableArray *commonPrefixList;

@end



@interface ObjectInfo : NSObject

@property (nonatomic) NSString *objectKey;

@property (nonatomic) NSString *lastModified;

@property (nonatomic) NSString *Etag;

@property (nonatomic) NSString *type;

@property (nonatomic) long long size;

@end



@class OSSData;

@interface TaskHandler : NSObject

@property(atomic, assign) BOOL isCancel;
@property(atomic, strong) OSSData* hostObject;

-(instancetype)initWithHostObject:(OSSData *)hostObject;

-(void)cancel;

@end