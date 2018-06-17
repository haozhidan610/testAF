//
//  API.h
//  testAF
//
//  Created by 张小杨 on 2018/6/17.
//  Copyright © 2018年 liaolu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIClient.h"

@interface API : NSObject
//获取个人界面的信息
+ (void)getEvaluateMeDataWithCB:(APIClientRequestResponse )cb;

@end
