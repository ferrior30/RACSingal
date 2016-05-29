//
//  RequireViewModel.m
//  RACSingal
//
//  Created by ChenWei on 16/5/29.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "RequireViewModel.h"

@implementation RequireViewModel
- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

/**
 *  创建网络请求命令
 */
- (void)setup {
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // AFN请求
            NSLog(@"AFN请求");
            NSString *requestURLString = @"https://api.douban.com/v2/book/search";
            
            [[AFHTTPSessionManager manager] GET:requestURLString parameters:@{@"q":@"美女"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [responseObject writeToFile:@"/Users/cw/Desktop/1.plist" atomically:YES];
                
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"请求失败 %@", error);
            }];
            
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"%s", __func__);
            }];
        }];
        
        return [requestSignal map:^id(NSDictionary *value) {
            _book = [Book bookWithDict:value];
            NSLog(@"book = %@", _book);
            return value;
        }];
    }];
}
@end
