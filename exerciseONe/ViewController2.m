//
//  ViewController2.m
//  RACSingal
//
//  Created by ChenWei on 16/5/28.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()
@property (weak, nonatomic) UIButton *btn;
@property (weak, nonatomic) UIButton *btnMiss;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] init];
    _btn = btn;
    _btn.frame = CGRectMake(50, 100, 200, 80);
    [_btn setTitle:@"界面2按钮" forState:UIControlStateNormal];
    [_btn sizeToFit];
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

- (RACSubject *)subject {
    if (_subject == nil) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

- (void)btnClick:(UIButton *)sender {
    [_subject sendNext:sender];
}
- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
