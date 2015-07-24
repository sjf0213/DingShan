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
    
    self.apiData = @{
        @"aid" : @"Y+DdSNSNQnu9DNSKDr0xi5qMLeU=",
        @"appver" : @"3.2.1",
        @"clientid" : @21,
        @"device" : @"iPhone5,2",
        @"did": @"F0F843B8-B156-4763-BDB0-81DB11E21E39",
        @"iosver" : @"8.4",
        @"uid": @3126,
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
@end
