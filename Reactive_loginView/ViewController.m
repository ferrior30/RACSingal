//
//  ViewController.m
//  Reactive_loginView
//
//  Created by ChenWei on 16/5/28.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "ViewController.h"
#import "LoginView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LoginView *loginView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginView.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog( @"订阅command-> 可以登陆 %@", x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

@end
