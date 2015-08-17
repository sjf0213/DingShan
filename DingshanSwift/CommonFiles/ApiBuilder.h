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
//美图,新闻,攻略,测评,列表
+(NSString *)article_get_list:(NSDictionary*)dic;
//讨论区话题列表
+(NSString *)forum_get_topic_list:(NSDictionary*)dic;
+(NSString *)forum_get_galary_list:(NSDictionary*)dic;

@end
