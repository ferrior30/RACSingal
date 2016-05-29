//
//  ViewController.m
//  RACCommand
//
//  Created by ChenWei on 16/5/27.
//  Copyright © 2016年 cw. All rights reserved.
//

// RACCommand: 处理事件用的。
// 比如触摸是一个事件（信号）会触发一个方法（信号）。 RACCommand就是订阅这个方法调用的信号得到处理结果。就是所谓的信号中的信号
// 一定要调用 [subscriber sendCompleted];不然不会执行

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
//#import <ReactiveCocoa/RACCommand.h>

@interface ViewController ()
@property (strong, nonatomic) RACCommand *command;
@property (strong, nonatomic) RACSignal *signal;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACCommand *command =  [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           [subscriber sendNext:@"1"];
           [subscriber sendCompleted];
           return nil;
       }];
    }];
    
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"...%@", x);
    }];
  
//    [command execute:@2];
    _command = command;
    
//    [self commandONe];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     [_command execute:@23];
}

- (void)signalOfsignal {
    
//    RACSubject *signalOfsignal = [RACSubject subject];
//    
//    RACSubject *signalA = [RACSubject subject];
//    RACSubject *signalB = [RACSubject subject];
//    
//    // signalOfsignal.switchToLatest : 找到最后发送的信号
//    // 因为定义是的RACSubject，要先订阅再发
//    [signalOfsignal.switchToLatest subscribeNext:^(id x) {
//        NSLog(@"订阅信息 = %@", x);
//    }];
//    
//    [signalOfsignal sendNext:signalA];
//    [signalOfsignal sendNext:signalB];
//    
//    [signalB sendNext:@"B send Next"];
    
    RACSubject *signalOfsignal = [RACSubject subject];
    
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
//    [signalOfsignal subscribeNext:^(id x) {
//        NSLog(@"signalOfsignal subscribe signal = %@",x);
//    }];
//    [signalOfsignal sendNext:signalA];
//    [signalOfsignal sendNext:signalB];
//    [signalOfsignal sendNext:@"ff"];
//    [signalA sendNext:@"A send Next"];
    
    
    [signalOfsignal sendNext:signalA];
    [signalOfsignal sendNext:signalB];
//    [signalA sendNext:@"A send Next"];
     // signalOfsignal.switchToLatest : 找到最后发送的信号。
    [signalB sendNext:@"B send Next"];
    
        [signalOfsignal.switchToLatest subscribeNext:^(id x) {
            NSLog(@"订阅信息= %@", x);
        }];
    [signalB sendNext:@"B send Next"];
    [signalA sendNext:@"A send Next"];
    //
    //
//        [signalOfsignal.switchToLatest subscribeNext:^(id x) {
//            NSLog(@"订阅信息= %@", x);
//        }];
}

- (void)commandThree {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"input = %@", input);
        
        return _signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"请求网络数据");
            
            [subscriber sendNext:@"发送网络数据"];
            
            // 表示发送完成 注：一定要调用。不然命令一直处于执行状态。
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"发送订阅要求2，返回数据 ->%@", x);
    }];
    
     [command.executionSignals.switchToLatest subscribeNext:^(id x) {
         NSLog(@"");
     }];
    
    [command.executing subscribeNext:^(id x) {
        if (x) {
            NSLog(@"正在执行");
        }else {
            NSLog(@"执行中断/执行完成");
        }
    }];
    
    [command execute:@"执行"];
    
    

}
- (void)commandONe {
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"input = %@", input);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"发送信号"];
            
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"发送完毕");
            }];
        }];
    }];
    
    [command.executionSignals subscribeNext:^(id x) {
        NSLog(@"订阅信号 = %@",x);
    }];
    
    [command.executionSignals subscribeNext:^(id x) {
        NSLog(@"订阅信号 = %@",x);
    }];
    _command = command;
//    [_command execute:@2];
//    [command execute:@"刷新"];

}

- (void)commandTwo {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"input = %@", input);
        
//        return [RACSignal empty];
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSLog(@"didsubscribe");
            
            [subscriber sendNext:@"发送信号0"];
            // 如果不写上，上面的sendNext就会一直执行处于执行状态。不会触发下面“发送完成”block
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"发送完成");
            }];
        }];
    }];

    RACReplaySubject *replaySubject = (RACReplaySubject *)[command execute:@"刷新"];
    
  [replaySubject subscribeNext:^(id x) {
        NSLog(@"replaySubject = 订单信号 = %@", x);
    }];
    
    [replaySubject sendNext:@"发送信号1"];

    // 上面的sendNext就会一直执行处于执行状态。不会调用发送完成的block
//    [replaySubject sendCompleted];
    
    [replaySubject sendNext:@"发送信号2"];
}

@end
