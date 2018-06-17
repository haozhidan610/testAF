//
//  API.m
//  testAF
//
//  Created by 张小杨 on 2018/6/17.
//  Copyright © 2018年 liaolu. All rights reserved.
//

#import "API.h"
//以百度网址为准，改成公司的域名
static NSString *const baseUrl = @"http://www.baidu.com";

@implementation API

//获取个人界面的信息
+ (void)getEvaluateMeDataWithCB:(APIClientRequestResponse )cb
{
    NSString *url = [NSString stringWithFormat:@"%@/appr/user/personalInformation.do",baseUrl];
    [APIClient requestURL:url httpMethod:GET params:nil response:cb];
}


@end
