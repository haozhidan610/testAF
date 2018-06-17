//
//  ViewController.m
//  testAF
//
//  Created by 张小杨 on 2018/6/17.
//  Copyright © 2018年 liaolu. All rights reserved.
//

#import "ViewController.h"
#import "API.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"封装AFNetworking";
}

- (void)requestData{
//    WS(weakSelf);
    //可以导入第三方MBProgressHUD
    if ([APIClient networkType] > 0){
        //获取个人界面的信息
        [API getEvaluateMeDataWithCB:^(ApiRequestStatusCode requestStatusCode, id JSON) {
            switch (requestStatusCode) {
                case ApiRequestOK: {
                    //正确处理JSON
                        break;
                    }
                case ApiRequestErr:
//                    [MBProgressHUD showError:kErrTip];
                    break;
                case ApiRequestNotReachable:
//                    [MBProgressHUD showError:kNotReachableTip];
                    break;
                default:
                    break;
            }
        }];
    }else{
//        [MBProgressHUD showError:kNotReachableTip];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
