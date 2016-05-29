//
//  ViewController.m
//  user_delegate_kvo
//
//  Created by ChenWei on 16/5/27.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/NSObject+RACKVOWrapper.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "GreenView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GreenView *greenView;

@property (strong, nonatomic) NSString *name;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.name = @"name";
    [self rac_liftSelector];
}

/** 信号的订阅者都接收到订阅的信号内容时才执行指定的方法 */
/**
 *  指定参数的个数根据信号个数来定。
 */
- (void)rac_liftSelector {
    RACSignal *signalOne = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"请求数据1");
        [subscriber sendNext:@"发送请求到的数据1"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"发送完成1");
        }];
    }];
    
    RACSignal *signalTwo = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"请求数据2");
        [subscriber sendNext:@"发送请求到的数据2"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"发送完成2");
        }];
    }];
    
    [self rac_liftSelector:@selector(updateUI: data2:) withSignals:signalOne, signalTwo, nil];
}

- (void)updateUI:(NSString *)data1 data2:(NSString *)data2 {
    NSLog(@"%@  ,   %@", data1, data2);
}

- (void)textFieldObseve {
    [[self.textField rac_textSignal] subscribeNext:^(NSString *x) {
        NSLog(@"text changing = %@", x);
    }];
}

- (void)notificaton {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"UIKeyboardWillShowNotification");
    }];
}

- (void)delegate {
    [[self.greenView rac_signalForSelector:@selector(btnDidClick:)] subscribeNext:^(id x) {
        NSLog(@"btnDeletate did clicked %@", x);
    }];
}

- (void)btnEvent {
    [[self.greenView.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"btn did clicked");
    }];
}

- (void)rac_kvo {
    [self rac_observeKeyPath:@"name" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"name changed");
    }];
    
    [[self rac_valuesForKeyPath:@"name" observer:self] subscribeNext:^(id x) {
        NSLog(@"name 改变了 %@", x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static int a = 0;
    a++;
    self.name = [NSString stringWithFormat:@"%@%zd", self.name , a];
}
@end
