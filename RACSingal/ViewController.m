//
//  ViewController.m
//  RACSingal
//
//  Created by ChenWei on 16/5/26.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "RedView.h"

@interface ViewController ()
//@property (strong, nonatomic) id subscriber;
//@property (strong, nonatomic) RACSignal *signal;
@property (weak, nonatomic) IBOutlet RedView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self signal];
    
//    [self disposable];

//    [self racSubject];
    
//    [self racReplaySignal];
    
//    [self.redView.subject subscribeNext:^(id x) {
//        NSLog(@"收到订单的信号 = %@", x);
//    }];
    
//    [self racReplaySignal];
//    [self signal];
    [self racSubject];
//    [self racReplaySignal];
    
    
}

- (void)signal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 创建信号内容
        //....
        //....
        NSLog(@"发送前准备工作");
        // 发送信号内容
        [subscriber sendNext:@"1"];
        NSLog(@"%@", subscriber);
//        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"清除订阅者");
        }];
    }];
    
    [signal subscribeNext:^(NSString *string) {
        NSLog(@"接收到信号==%@", string);
    }];
    
    
    [signal subscribeNext:^(id x) {
        NSLog(@"2");
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"3");
    }];
}

// disposable : 管理订阅(subscription)的相关必要信息。
- (void)disposable{
    __block id a;
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"发送信息"];
//        _subscriber = subscriber;
        a = subscriber;
        NSLog(@"===");

        // 信号发送完或者发送error会自动执行。
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"订阅被取消");
        }];
    }];
    
    // 订阅信号
    RACDisposable *disposable =  [signal subscribeNext:^(NSString *string) {
        NSLog(@"第一次订阅到的信号 = %@", string);
    }];
    
    //
    [disposable dispose];
    
    RACDisposable *disposable2 = [signal subscribeNext:^(NSString *string) {
         NSLog(@"第二次订阅到的信号 = %@", string);
    }];
    
    
    [disposable2 dispose];

}

/**
 *  可以创建信号、订阅信号、发送信号。
 *  发一个信号给每一个订阅者再发另一个信号。
 */
- (void)racSubject {
    RACSubject *subject = [RACSubject subject];
    
 [subject sendNext:@"10"];
    
//    [subject subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
//    
    [subject subscribeNext:^(id x) {
        NSLog(@"2 = %@",x);
    }];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"3 = %@",x);
    }];
    
    [subject sendNext:@"5"];
    [subject sendNext:@"6"];
    [subject sendNext:@"7"];
    
    [subject sendCompleted];

    [subject subscribeNext:^(id x) {
        NSLog(@"4 = %@",x);
    }];
    [subject sendNext:@"4"];
    [subject sendNext:@"9"];
}

/**
 *  可以先发送再订阅信号
 *  先把信号存起来，有订阅者就发送。
 *  当添加一个订阅者时就把存放起来的信号全部发一遍给他。
 *  在有订阅者的情况下发送一个信号，就把信号先存起来，再发给所有的订阅者。
 */
- (void)racReplaySignal {
//    RACReplaySubject *replaySignal = [RACReplaySubject replaySubjectWithCapacity:4];
    RACReplaySubject *replaySignal = [RACReplaySubject subject];
//    [replaySignal sendNext:@"1"];
//    [replaySignal sendNext:@"2"];
//    [replaySignal sendNext:@"3"];
//    [replaySignal sendCompleted];
//     [replaySignal sendNext:@"7"];
    [replaySignal sendNext:@"0"];
    
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"订信号 -> %@", x);
    } completed:^{
        NSLog(@"信号收取完成");
    }];
    [replaySignal sendNext:@"1"];
    [replaySignal sendNext:@"2"];
    [replaySignal sendNext:@"3"];
    
//    [replaySignal sendCompleted];
    
    [NSThread sleepForTimeInterval:4];
    [replaySignal sendNext:@"6"];
    
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"订信者1 -> %@", x);
    } completed:^{
        NSLog(@"信号1收取完成");
    }];
    
   
    
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"订信者2->%@", x);
    } completed:^{
        NSLog(@"信号2收取完成");
    }];
//    [replaySignal sendNext:@"4"];

    
    [replaySignal sendCompleted];
    
//    [replaySignal sendNext:@"7"];
//    
//    [replaySignal sendNext:@"5"];
//    
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"订信号3->%@", x);
    } completed:^{
        NSLog(@"信号收取完成");
    }];
    
    [replaySignal sendNext:@"4"];
    
    [replaySignal sendNext:@"5"];
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
@end
