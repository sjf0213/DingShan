//
//  ApiBuilder.h
//  ServiceData
//
//  Created by winston on 12-12-24.
//
//

#import <Foundation/Foundation.h>

@interface ApiBuilder:NSObject

+(ApiBuilder*)shareInstance;

- (void)initApiData;

+(NSDictionary *)applyBizDataWrapperToDic:(id)bizData;
+(NSString *)signatureURL:(NSString*)url args:(NSDictionary *)args;
+(NSString *)signatureURL:(NSString*)url args:(NSDictionary *)args Key:(NSString *)keystring;

// 讨论区话题列表
+(NSString *)forum_get_topic_list:(NSDictionary*)dic;
+(NSString *)forum_get_floor_list:(NSDictionary*)dic;
+(NSString *)forum_get_reply_list:(NSDictionary*)dic;
+(NSString *)forum_create_topic:(NSDictionary*)dic;
// 图库列表
+(NSString *)gallery_get_galary_single_list:(NSDictionary*)dic;
+(NSString *)gallery_get_galary_multi_list:(NSDictionary*)dic;
@end
