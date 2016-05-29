//
//  ViewController.m
//  exerciseONe
//
//  Created by ChenWei on 16/5/28.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(UIButton *)sender {
    ViewController2 *v2 = [[ViewController2 alloc] init];
    
    v2.view.backgroundColor = [UIColor lightGrayColor];
    
    [self presentViewController:v2 animated:YES completion:nil];
    
    // 订阅界面2按钮的点击事件
    __weak typeof(self) weakS = self;
    [v2.subject subscribeNext:^(UIButton *btn) {
        NSLog(@"接收到界面2的点击事件 ==%@",btn);
        weakS.view.backgroundColor = [UIColor greenColor];
    }];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
