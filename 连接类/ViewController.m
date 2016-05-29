//
//  ViewController.m
//  连接类 RACMulticastConnection
//
//  Created by ChenWei on 16/5/27.
//  Copyright © 2016年 cw. All rights reserved.
//

// RACMulticastConnection

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    RACSubject *subject = [RACSubject subject];
//   
//    [subject sendNext:@"发送信号内容"];
//    
//    [subject subscribeNext:^(id x) {
//        NSLog(@"订阅信号 = %@", x);
//    }];
//    
//    NSLog(@"制造信号内容2");
//    [subject sendNext:@"信号内容2"];
    
    [self connect];

}

// 本质是对信号RACSignal的发送者（遵守发送协议）的subjecter订阅信号, 等同于RACSubject类订阅信号，发送信号
// subjecter就是邮差，对邮差订阅，不需要知道邮件如何生成。
- (void)connect {
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"请求数据");
//        
//        [subscriber sendNext:@"发送数据"];
//        
//        [subscriber sendCompleted];
//        
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"发送完成");
//        }];
//    }];
//    
//    RACMulticastConnection *connection = [signal publish];
//    
//    // 在订阅前执行没用,信号发送的信号没有被
////    [connection connect];
//    
//    [connection.signal subscribeNext:^(id x) {
//        NSLog(@"订阅者1 = %@",x);
//    }];
//    
//    [connection.signal subscribeNext:^(id x) {
//        NSLog(@"订阅者2 = %@",x);
//    }];
//    [connection connect];
    
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    RACMulticastConnection *connetAB = [subjectA multicast:subjectB];
    
//    [subjectA sendNext:@"a"];
    [connetAB.signal subscribeNext:^(id x) {
        NSLog(@"connect = %@", x);
    }];
    
    [(RACSubject *)connetAB.signal sendNext:@"B1"];
    
    [subjectB sendNext:@"B"];
    
    
    [connetAB connect];
    [connetAB connect];
    
    
}

- (void)signal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"请求数据");
        
        [subscriber sendNext:@"发送数据"];
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"发送完成");
        }];
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅到的数据 = %@", x);
    }];
}

@end
