//
//  ViewController.m
//  bind
//
//  Created by ChenWei on 16/5/28.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACReturnSignal.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   [[_textField.rac_textSignal flattenMap:^RACStream *(id value) {
       // 信号内容处理
       value = [NSString stringWithFormat:@"value处理 + %@", value];
       return [RACReturnSignal return:value];
   }] subscribeNext:^(id x) {
       NSLog(@"订阅到的信息内容 %@", x);
   }];
}

- (void)flatten {
    // 创建信号中信号
    RACSubject *signalOfSignals = [RACSubject subject];
    
    // 创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 通过订阅signalOfSignals拿到signal发送值
    
    //    [[signalOfSignals flattenMap:^RACStream *(id value) {
    //        return value;
    //    }] subscribeNext:^(id x) {
    //
    //        NSLog(@"%@",x);
    //    }];
    
    [signalOfSignals.flatten subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
    // 信号中的信号发送信号
    [signalOfSignals sendNext:signal];
    
    [signal sendNext:@"123"];
    [signal sendNext:@"321"];
}

/**
 *  flattenMap : 一般用于发出 的信号是 信号。
 *  map : 一般用于发出 的信号是对象。
 *  二者的参数就能看出区别
 */
- (void)flattenMap {
    [[_textField.rac_textSignal flattenMap:^RACStream *(id value) {
        // 信号内容处理
        value = [NSString stringWithFormat:@"value处理 + %@", value];
        return [RACReturnSignal return:value];
    }] subscribeNext:^(id x) {
        NSLog(@"订阅到的信息内容 %@", x);
    }];
}

/**
 *  map : 一般用于发出 的信号是对象。
 */
- (void)map {
    [[ _textField.rac_textSignal map:^id(id value) {
        return [NSString stringWithFormat:@"map + %@", value];
    }] subscribeNext:^(id x) {
        NSLog(@"订阅到map后的value %@",  x);
    }];
}

/**
 *  bind 是底层方法
 *  bind:<#^RACStreamBindBlock(void)block#> : 用typedef定义的一种block类型，返回值是RACSteam *， 参数是（id, bool）
 *  所以要定义一个block(返回值是 RACSteam *， 参数是（id, bool）),
 */
- (void)bind {
    RACSignal *bindSignal = [self.textField.rac_textSignal bind:^RACStreamBindBlock{
        
        return  ^RACStream*(id value, BOOL *stop){

            // RACStreamBindBlock什么时候调用:每次源信号发出内容,就会调用这个block
            // value:源信号发出的内容
            NSLog(@"源信号发出的内容:%@",value);
            
            // RACStreamBindBlock作用:在这个block处理源信号的内容
            value = [NSString stringWithFormat:@"xmg%@",value];
            
            // block返回值:信号(把处理完的值包装成一个信号,返回出去)
            // 创建一个信号,并且这个信号的传递的值是我们处理完的值,value
            return [RACReturnSignal return:value];
        };
    }];
    [bindSignal subscribeNext:^(id x) {
        NSLog(@" 处理后的信号 %@", x);
    }];
}

@end
