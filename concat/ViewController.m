//
//  ViewController.m
//  concat
//
//  Created by ChenWei on 16/5/28.
//  Copyright © 2016年 cw. All rights reserved.
//

/**
  [...  sendCompleted] 
 * 大概作用如下：
 * 前面发的信息接收完后，会清空所有的订阅者对当前信号的订阅，并释放无用的相关资源。 只有重新订阅后才能收到后面发送的信号内容。
 */

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldA;
@property (weak, nonatomic) IBOutlet UITextField *textFieldB;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    RACSignal *combineLatest = [RACSignal combineLatest:RACTuplePack(_textFieldA.rac_textSignal, _textFieldB.rac_textSignal)];
//    
//    [combineLatest subscribeNext:^(id x) {
//        NSLog(@"combine = %@", x);
//    }];
    
//    [[RACSignal combineLatest:@[_textFieldA.rac_textSignal, _textFieldB.rac_textSignal] reduce:^id(NSString *str1, NSString *str2){
//        if ([str1 isEqualToString:_textFieldA.text]) {
//            str1 = @"";
//        }else if ([str2 isEqualToString:_textFieldA.text]) {
//            str2 = @"";
//        }
//        return [NSString stringWithFormat:@"%@ + %@", str1 , str2];
//    }] subscribeNext:^(id x) {
//        
//        _textFieldA.text = x;
//        NSLog(@"%@", x);
//    }];
    
//    [self concat];
    [self then];

}

/**
 *  combineLatest:
 *  订阅数组中所有的信号
 *  只要有一个发送信号发送，就拿到所有信号的最新内容。
 */
- (void)combineLatest {
    //    RACSignal *combineLatest = [RACSignal combineLatest:RACTuplePack(_textFieldA.rac_textSignal, _textFieldB.rac_textSignal)];
    //
    //    [combineLatest subscribeNext:^(id x) {
    //        NSLog(@"combine = %@", x);
    //    }];
    
    [[RACSignal combineLatest:@[_textFieldA.rac_textSignal, _textFieldB.rac_textSignal] reduce:^id(NSString *str1, NSString *str2){
        if ([str1 isEqualToString:_textFieldA.text]) {
            str1 = @"";
        }else if ([str2 isEqualToString:_textFieldA.text]) {
            str2 = @"";
        }
        return [NSString stringWithFormat:@"%@ + %@", str1 , str2];
    }] subscribeNext:^(id x) {
        
        _textFieldA.text = x;
        NSLog(@"%@", x);
    }];
}

/**
 *  RACSignal *zip =  [subjectA zipWith:subjectB];
 *  zip同时成为A和B的订阅者，但是只有当A和B对对应位置的信号内容都有值时才接收A和B对应位置的信号内容组合成的元组。
 *  zip接收的是成对的信号（由A和B组成）
 *  如果A发1条信号，会存在一个数组中，会看B数组中对应位置有没有对应的。没有zip就不接收，有就接收这2个信号组成的数组。 同样当B发信号时也是这样执行。
 */
- (void)zip {
    RACSubject *subjectA = [RACSubject subject];
    
    RACSubject *subjectB = [RACSubject subject];
    
    RACSignal *zip =  [subjectA zipWith:subjectB];
    
    [zip subscribeNext:^(NSArray *x) {
        NSLog(@"then %@ : %@ ", x[0], x[1]);
    }];
    
    [subjectA sendNext:@"aaaaa"];
    //    [subjectA sendCompleted];
    
    [subjectA sendNext:@"aaaaa2"];
    
    [subjectB sendNext:@"b"];
    [subjectB sendCompleted];

}


/**
 *  RACSignal *merge = [subjectA merge:subjectB];
 *  merge ： merge能同时订阅A 和 B ,
 *  [merge subscribeNext:^(id x)], 开始订阅。成为A 和 B 的订阅者，能收到 A 或者 B 的信号内容。
 */
- (void)merge {
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    
    RACSignal *merge = [subjectA merge:subjectB];
    
    [merge subscribeNext:^(id x) {
        NSLog(@"merge subscribeNext = %@", x);
    }];
    
    [subjectA subscribeNext:^(id x) {
        NSLog(@"subjectA subscribeNext = %@", x);
        
    }];
    //
    [subjectB subscribeNext:^(id x) {
        NSLog(@"subjectB subscribeNext = %@", x);
        
    }];
    [subjectB sendNext:@"B sendNext"];
    [subjectA sendNext:@"A sendNext"];
    
    [subjectB sendCompleted];
    [subjectB sendNext:@"B sendNext -》"];
    
    [subjectA sendNext:@"A sendNext"];
}

/**
 *  RACSignal *then =  [subjectA then:^RACSignal *{ return subjectB}]
 *  只有信号subjectA接收到sendComplete,then:参数的block才会执行. then才能创建B订阅，成为B的其中一个订阅者，就会收到B发送的信号内容。（并不会订阅subjectA的）
 */
- (void)then {
    RACSubject *subjectA = [RACSubject subject];
    
//    RACSubject *subjectB = [RACSubject subject];
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"signal");
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"2");
    }];

    RACSignal *then =  [subjectA then:^RACSignal *{
        NSLog(@"then请求");
        return signal;
    }];
    
    [then subscribeNext:^(id x) {
        NSLog(@"then %@", x);
    }];
    
    [subjectA sendNext:@"aaaaa"];
    [subjectA sendCompleted];
    
//    [subjectB sendNext:@"b"];
//    [subjectB sendCompleted];
//
}

/**
 *  RACSignal *concat = [signalOne concat:signalTwo];
 *  concat只能在signalOne执行sendCompleted，才能订阅signalTwo
 */
- (void)concat {
//        RACSignal *signalOne = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            [subscriber sendNext:@"sendNest 1"];
//            // 不加上，concat就无法订阅signalTwo
//                    [subscriber sendCompleted];
//            return [RACDisposable disposableWithBlock:^{
////                NSLog(@"disposable");
//            }];
//        }];
    
    RACSubject *subjectA = [RACSubject subject];
//    [subjectA subscribeNext:^(id x) {
//        NSLog(@"subscribeNext %@", x);
//    }];
    
    RACSubject *subjectB = [RACSubject subject];
    
//    RACSignal *signalTwo = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        NSLog(@"two准备");
//        [subscriber sendNext:@"sendNest 2"];
//        
//        return [RACDisposable disposableWithBlock:^{
//            //            NSLog(@"disposable");
//        }];
//    }];
    
    RACSignal *concat = [subjectA concat:subjectB];
    
    [subjectA sendNext:@"aaA"];

//    [subjectA sendNext:@"A"];
//    [subjectA sendCompleted];
    
    [concat subscribeNext:^(id x) {
        NSLog(@"concat  %@",x);
    }];
    
    [subjectB sendNext:@"b"];
    
    [subjectA sendNext:@"A"];
    
    [subjectA sendCompleted];
    [subjectB sendNext:@"b"];
    
    [subjectA sendNext:@"aA"];
}

@end
