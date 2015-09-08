//
//  ApiBuilder.m
//  ServiceData
//
//  Created by winston on 12-12-24.
//
//

#import "ApiBuilder.h"
#import "CommonUtility.h"
#import "CocoaSecurity.h"

#define NSHELPDICEMPTY  [NSMutableDictionary dictionaryWithObjectsAndKeys:nil]
#define TracID @"B58A780D00044FC189AD79B8961FC269"
#define TracServer @"http://adtrack.app-sage.com/v2/trackkuai?tid=%@&e=%@&key=%@"

#define APICheckTimeInterval     60*5
#define APISECRECTKEY   @"kuaigame123"    //普通 api的加密key

@interface ApiBuilder ()
@property(strong,nonatomic)NSDictionary * apiData;
@end

@implementation ApiBuilder

static NSTimeInterval startDate = 0;

static ApiBuilder * m_Instance;

+(ApiBuilder*)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        m_Instance= [[ApiBuilder alloc] initSingleton];
    });
    return m_Instance;
}

-(id)init
{
    NSAssert(NO, @"Cannot create instance of Singleton");
    return nil;
}


-(id)initSingleton
{
    self = [super init];
    if(self)
    {
        [self initApiData];
    }
    return self;
}

- (void)initApiData
{
//    self.ClientTypeID = [ApiBuilder getCliendID];
//    
//    NSMutableDictionary * finalBizData = [NSMutableDictionary dictionaryWithCapacity:7];
//    [finalBizData setObject:@(self.ClientTypeID) forKey:@"clientid"];
//    [finalBizData setObject:[DeviceHelper shareInstance]->modelType forKey:@"device"];
//    [finalBizData setObject:[[UIDevice currentDevice] systemVersion] forKey:@"iosver"];
//    [finalBizData setObject:[DeviceHelper shareInstance]->appVersion forKey:@"appver"];
//    [finalBizData setObject:[DeviceHelper shareInstance]->deviceGuid forKey:@"did"];
//
//    if ([KGConfigManager shareInstance].IsUserConform)
//    {
//        [finalBizData setObject:[KGConfigManager shareInstance].AuthID forKey:@"aid"];
//        [finalBizData setObject:[KGConfigManager shareInstance].UserID forKey:@"uid"];
//    }
http://v3.kuaigame.com/topics/topiclist?iosver=8.4&uid=221188&device=iPhone5%2C2&pindex=0&psize=50&appver=3.3.0&key=xv0JOoDtfa2GqBwM3lAb0FpyeLc%3D&topicid=0&did=053F4F67-4445-4774-9060-B3CC0795EC7E&e=1438254601&clientid=21&aid=hypB2OIKaQ1jFyNWvljyE7HPV3E%3D&sorttype=1";
    
//    self.apiData = @{
//        @"aid" : @"hypB2OIKaQ1jFyNWvljyE7HPV3E%3D",
//        @"appver" : @"3.2.1",
//        @"clientid" : @21,
//        @"device" : @"iPhone5,2",
//        @"did": @"053F4F67-4445-4774-9060-B3CC0795EC7E",
//        @"iosver" : @"8.4",
//        @"uid": @221188,
//        };
    
    self.apiData = @{
                     @"aid" : @"asdf",
                     @"appver" : @"3.2.1",
                     @"clientid" : @21,
                     @"device" : @"iPhone5,2",
                     @"did": @"053F4F67-4445-4774-9060-B3CC0795EC7E",
                     @"iosver" : @"8.4",
                     @"uid": @1,
                     };
    startDate = [[NSDate date]timeIntervalSince1970];
}

-(void)dealloc
{
    self.apiData = nil;
}

+(NSDictionary *)applyBizDataWrapperToDic:(id)bizData
{
    NSMutableDictionary * finalBizData = [NSMutableDictionary dictionaryWithDictionary:[ApiBuilder shareInstance].apiData];
    id  data = (bizData==nil||[bizData count]==0)?@[]:bizData;
    [finalBizData setObject:data forKey:@"bizdata"];
    return finalBizData;
}

+(NSString *)signatureURL:(NSString*)url args:(NSDictionary *)args
{
    NSMutableDictionary * finalDic = [NSMutableDictionary dictionaryWithDictionary:[ApiBuilder shareInstance].apiData];

    if(([[NSDate date] timeIntervalSince1970]-startDate)>APICheckTimeInterval)
    {
        startDate = [[NSDate date]timeIntervalSince1970];
    }
    
    [finalDic setObject:[NSString stringWithFormat:@"%d",((int)startDate)] forKey:@"e"];
    
    for(NSString * key in args.allKeys)
    {
        [finalDic setObject:[args objectForKey:key] forKey:key];
    }
    
    NSMutableString* content = [NSMutableString stringWithString:@""];
    
    for(NSString* key in [[finalDic allKeys] sortedArrayUsingSelector:@selector(compare:)])
        [content appendString:[NSString stringWithFormat:@"%@", [finalDic objectForKey:key]]];
    
    NSString *tkey = [CocoaSecurity hmacSha1:content hmacKey:APISECRECTKEY].base64;
    
    [finalDic setObject:tkey forKey:@"key"];
    
    NSMutableString* result = [NSMutableString stringWithString:@""];
    [result appendString:url];
    for(NSInteger index=0; index < [[finalDic allKeys] count]; index++)
    {
        NSString* key = [[finalDic allKeys] objectAtIndex:index];
        if(index == 0)
            [result appendFormat:@"?%@=%@",key,[CommonUtility urlEncodedString:[NSString stringWithFormat:@"%@", [finalDic objectForKey:key]]]];
        else
            [result appendFormat:@"&%@=%@",key,[CommonUtility urlEncodedString:[NSString stringWithFormat:@"%@", [finalDic objectForKey:key]]]];
    }
    return result;
}

+(NSString *)signatureURL:(NSString*)url args:(NSDictionary *)args Key:(NSString *)keystring
{
    NSMutableDictionary * finalDic = [NSMutableDictionary dictionaryWithDictionary:[ApiBuilder shareInstance].apiData];
    
    if(([[NSDate date] timeIntervalSince1970]-startDate)>APICheckTimeInterval)
    {
        startDate = [[NSDate date]timeIntervalSince1970];
    }
    
    [finalDic setObject:[NSString stringWithFormat:@"%d",((int)startDate)] forKey:@"e"];
    
    for(NSString * key in args.allKeys)
    {
        [finalDic setObject:[args objectForKey:key] forKey:key];
    }
    
    NSMutableString* content = [NSMutableString stringWithString:@""];
    
    for(NSString* key in [[finalDic allKeys] sortedArrayUsingSelector:@selector(compare:)])
        [content appendString:[NSString stringWithFormat:@"%@", [finalDic objectForKey:key]]];
    
    NSString *tkey = [CocoaSecurity hmacSha1:content hmacKey:keystring].base64;
    
    [finalDic setObject:tkey forKey:@"key"];
    
    NSMutableString* result = [NSMutableString stringWithString:@""];
    [result appendString:url];
    for(NSInteger index=0; index < [[finalDic allKeys] count]; index++)
    {
        NSString* key = [[finalDic allKeys] objectAtIndex:index];
        if(index == 0)
            [result appendFormat:@"?%@=%@",key,[CommonUtility urlEncodedString:[NSString stringWithFormat:@"%@", [finalDic objectForKey:key]]]];
        else
            [result appendFormat:@"&%@=%@",key,[CommonUtility urlEncodedString:[NSString stringWithFormat:@"%@", [finalDic objectForKey:key]]]];
    }
    return result;
}

//新闻，评测，攻略，美图列表
+(NSString *)article_get_list:(NSDictionary*)dic
{
    return [ApiBuilder signatureURL:@"http://v3.kuaigame.cn/app/getcategoryarticle" args:dic];
}
// 讨论区话题列表
+(NSString *)forum_get_topic_list:(NSDictionary*)dic
{
//    return [ApiBuilder signatureURL:@"http://v3.kuaigame.cn/topics/topiclist" args:dic];
    return [ApiBuilder signatureURL:@"http://www.kokoguo.com/dingshan/Topic/topiclist" args:dic];
}

+(NSString *)forum_get_floor_list:(NSDictionary*)dic
{
    return [ApiBuilder signatureURL:@"http://www.kokoguo.com/dingshan/Topic/floorlist" args:dic];
}

+(NSString *)forum_get_reply_list:(NSDictionary*)dic
{
    return [ApiBuilder signatureURL:@"http://www.kokoguo.com/dingshan/Topic/replylist" args:dic];
}
@end
