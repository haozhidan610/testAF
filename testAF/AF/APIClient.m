//
//  APIClient.m
//  smartapc-ios
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 list. All rights reserved.
//

#import "APIClient.h"
#import "AFNetworking.h"

@interface APIClient()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation APIClient

// 定义单例
DEF_SINGLETON(APIClient);

// 获取当前的网络状态类型(返回:0-No wifi or cellular(无网络), 1-2G, 2-3G, 3-4G, 4-LTE, 5-wifi)
+ (int)networkType {
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    int ret = 0;
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue]) {
        case 0:
            ret = 0;
            break;
        case 1:
            ret = 1;
            break;
        case 2:
            ret = 2;
            break;
        case 3:
            ret = 3;
            break;
        case 4:
            ret = 4;
            break;
        case 5:
            ret = 5;
            break;
        default:
            break;
    }
    return ret;
}

// 网络状态监听，应用当前是否有网络
+ (void)networkReachableWithBlock:(void(^)(BOOL isReachable))block {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                if (block) {
                    block(YES);
                }
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: {
                if (block) {
                    block(NO);
                }
                break;
            }
            default:
                break;
        }
    }];
    
    //结束监听
    //[[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

// 发送请求，返回JSON格式的响应数据
+ (void)requestURL:(NSString *)urlString
        httpMethod:(HttpMethod)method
            params:(NSDictionary *)params
          response:(APIClientRequestResponse)response {
    if ([APIClient networkType] > 0) {
        APIClient *client = [APIClient sharedInstance];
        if (!client.manager) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer.timeoutInterval = 30;
            manager.requestSerializer     = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer    = [AFJSONResponseSerializer serializer];
            AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
            manager.responseSerializer = responseSerializer;
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"application/x-www-form-urlencodem", nil];
            
            
            client.manager = manager;
        }
        
        __weak typeof(self)weakSelf = self;
        switch (method) {
            case PATH_GET: {
                urlString = [APIClient pathGet:urlString params:params];
//                //LOG(@"PATH_GET http_url:%@",urlString);
                [client.manager GET:urlString
                         parameters:nil
                           progress:nil
                            success:^(NSURLSessionDataTask * __unused task, id JSON) {
                                __strong typeof(weakSelf)strongSelf = weakSelf;
                                if (strongSelf) {
                                    [strongSelf handleSuccessRequest:JSON cb:response];
                                }
                            }
                            failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                                if (response) {
                                    response(ApiRequestErr, nil);
                                }
                            }];
                break;
            }
            case QUERY_GET: {
                urlString = [APIClient queryGet:urlString params:params];
                //LOG(@"QUERY_GET http_url:%@",urlString);
                [client.manager GET:urlString
                         parameters:nil
                           progress:nil
                            success:^(NSURLSessionDataTask * __unused task, id JSON) {
                                __strong typeof(weakSelf)strongSelf = weakSelf;
                                if (strongSelf) {
                                    [strongSelf handleSuccessRequest:JSON cb:response];
                                }
                            }
                            failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                                if (response) {
                                    response(ApiRequestErr, nil);
                                }
                            }];
                break;
            }
            case GET: {
//                //LOG(@"GET http_url:%@",urlString);
                [client.manager GET:urlString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * __unused task, id JSON) {
                         __strong typeof(weakSelf)strongSelf = weakSelf;
                         if (strongSelf) {
                             [strongSelf handleSuccessRequest:JSON cb:response];
                         }
                     }
                     failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                         if (response) {
                             response(ApiRequestErr, nil);
                             //LOG(@"GET http_url:%@",urlString);
                         }
                     }];
                break;
            }
            case POST: {
//                //LOG(@"POST http_url:%@",urlString);
                [client.manager POST:urlString
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * __unused task, id JSON) {
                          __strong typeof(weakSelf)strongSelf = weakSelf;
                          if (strongSelf) {
                              [strongSelf handleSuccessRequest:JSON cb:response];
                          }
                      }
                      failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//                          //LOG(@"%@",error);
                          if (response) {
                              response(ApiRequestErr, nil);
                          }
                      }];
                break;
            }
            case DELETE: {
                //LOG(@"DELETE http_url:%@",urlString);
                [client.manager DELETE:urlString
                     parameters:nil
                        success:^(NSURLSessionDataTask * __unused task, id JSON) {
                            __strong typeof(weakSelf)strongSelf = weakSelf;
                            if (strongSelf) {
                                [strongSelf handleSuccessRequest:JSON cb:response];
                            }
                        }
                        failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                            if (response) {
                                response(ApiRequestErr, nil);
                            }
                        }];
                break;
            }
            case PUT: {
                //LOG(@"PUT http_url:%@",urlString);
                [client.manager PUT:urlString
                  parameters:params
                     success:^(NSURLSessionDataTask * __unused task, id JSON) {
                         __strong typeof(weakSelf)strongSelf = weakSelf;
                         if (strongSelf) {
                             [strongSelf handleSuccessRequest:JSON cb:response];
                         }
                     }
                     failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                         if (response) {
                             response(ApiRequestErr, nil);
                         }
                     }];
                break;
            }
        }
    } else { // 没有连接网络
        if (response)
            response(ApiRequestNotReachable, nil);
    }
}

// 统一处理响应数据
+ (void)handleSuccessRequest:(id)JSON cb:(void(^)(ApiRequestStatusCode requestStatusCode, id JSON))cb {
    APIClient *client = [APIClient sharedInstance];
    if (client.delegate && [client.delegate respondsToSelector:@selector(handleSuccessRequest:completion:)]) {
        [client.delegate handleSuccessRequest:JSON
                              completion:^(id aJSON) {
                                  if (cb) {
                                      cb(ApiRequestOK, aJSON);
                                  }
                              }];
    } else {
        if (cb) {
            cb(ApiRequestOK, JSON);
        }
    }
}

// 取消掉所有网络请求
+ (void)cancelAllRequest {
    APIClient *client = [APIClient sharedInstance];
    if (client.manager) {
        if (client.manager.operationQueue) {
            [client.manager.operationQueue cancelAllOperations];
        }
    }
}

// 填充参数到url上,处理@"user/account/check/{phone}",{phone}这种情况
+ (NSString *)pathGet:(NSString *)uri
               params:(NSDictionary *)params {
    if (nil == uri|| nil == params || params.count <= 0) {
        return  uri;
    }
    for (NSString *key in params) {
        NSString *key2 = [NSString stringWithFormat:@"{%@}",key];
        if ([uri rangeOfString:key2].location != NSNotFound) {
            uri = [uri stringByReplacingOccurrencesOfString:key2 withString:params[key]];
        }
    }
    return [uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// 填充query参数到url上,处理"?a=1&b=2"这种情况
+ (NSString *)queryGet:(NSString *)uri
                params:(NSDictionary *)params {
    if (nil == uri || nil == params || params.count <= 0) {
        return  uri;
    }
    NSMutableString *tmpUri = [NSMutableString stringWithString:uri];
    int i = 0;
    for (NSString *key in params) {
        if (i == 0) {
            [tmpUri appendFormat:@"?%@=%@",key, params[key]];
        } else {
            [tmpUri appendFormat:@"&%@=%@",key, params[key]];
        }
        i++;
    }
    return [tmpUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
}

@end
