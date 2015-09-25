//
//  OSSMultipart.h
//  OSSTestFrameWork
//
//  Created by zhouzhuo on 7/21/15.
//  Copyright (c) 2015 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSSObject.h"

@class UploadPartResult;

@interface OSSMultipart : OSSObject<NSXMLParserDelegate>

@property(nonatomic, strong)NSString * uploadId;
@property(nonatomic, assign)int partNumber;
@property(nonatomic, strong)NSData * partData;
@property(nonatomic, strong)NSMutableArray * partsList;

/*!
 @method
 @abstract 初始化分块上传，返回uploadId
 */
-(NSString *)initiateMultiPartUploadWithError:(NSError **)error;

/*!
 @method
 @abstract 为单个块的上传设置分块序号和分块内容
 */
-(void)setUploadPartWithNumber:(int)partNumber WithData:(NSData *)partData;

/*!
 @method
 @abstract 每次操作前，需要设置标识此次上传时间的uploadId
 */
-(void)selfSetUploadId:(NSString *)uploadId;

/*!
 @method
 @abstract 将单个分块上传
 */
-(UploadPartResult *)uploadPartWithError:(NSError **)error;

/*!
 @method
 @abstract 上传所有分块以后，可以通过此接口设置分块列表，完成该次分块上传
 */
-(void)selfSetPartList:(NSArray *)partList;

/*!
 @method
 @abstract 完成分块上传
 */
-(void)completeMultipartUploadWithError:(NSError **)error;

/*!
 @method
 @abstract 完成分块上传，回调指定server，返回结果
 */
-(NSData *)completeMultipartUploadAfterServerCallbackWithError:(NSError **)error;

/*!
 @method
 @abstract 取消该次分块上传
 */
-(void)abortMultipartUploadWithError:(NSError **)error;

/*!
 @method
 @abstract 罗列该次分块上传已经上传的所有分块
 */
-(NSArray *)listPartsWithError:(NSError **)error;
@end
