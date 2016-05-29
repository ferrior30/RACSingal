//
//  LoginView.m
//  RACSingal
//
//  Created by ChenWei on 16/5/28.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "LoginView.h"
#import <ReactiveCocoa/NSObject+RACKVOWrapper.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/UIButton+RACCommandSupport.h>


@implementation LoginView


- (void)awakeFromNib {
    // 文本框信号
    _loginEnableSignal = [RACSignal combineLatest:@[_accountTextField.rac_textSignal, _psdTextField.rac_textSignal]];
    
    [_loginEnableSignal subscribeNext:^(NSArray<NSString *> *x) {
        NSLog(@"%@",x);
        _loginBtn.enabled = (x[0].length > 0 && x[1].length > 0);
        
    }];
    
    // 登陆信号
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *btn) {
        
        NSLog(@"command命令开启，登陆AFN");
        NSString *logRestultString = @"可以登陆";
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:logRestultString];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
//    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
//        NSLog(@"订阅登陆信息  = %@", x);
//    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)login {
    
}

- (void)setupLoginBind {

}

- (IBAction)loginBtnDidClidk:(UIButton *)sender {
    [_loginCommand execute:sender];
}

@end
