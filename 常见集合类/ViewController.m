//
//  ViewController.m
//  常见集合类
//
//  Created by ChenWei on 16/5/27.
//  Copyright © 2016年 cw. All rights reserved.
//
// RACSequence
// RACTuple

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Flag.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *flags;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 元组 -> 数组
- (void)RACTuple {
//     NSArray *array = @[@5,@7, @"9"];
    //    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:array];
    //
    //    NSLog(@"%@", tuple);
    
    // 数组转集合
    //    RACSequence *sequence = array.rac_sequence;
    //
    //    [sequence.signal subscribeNext:^(id x) {
    //        NSLog(@"%@",x);
    //    }];
}

// 有序的集合
- (void)rac_suquence {
    
    
    NSArray *flagsDirc = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil]];
    
    _flags = [NSMutableArray array];
    
    //    [flagsDirc.rac_sequence.signal subscribeNext:^(NSDictionary *x) {
    //        Flag *flag =  [Flag flagWithDict:x];
    //        [_flags addObject:flag];
    //    }];
    
    [[flagsDirc.rac_sequence map:^id(id value) {
        Flag *flag = [Flag flagWithDict:value];
        return flag;
    }] array];
    
    NSDictionary *dict = @{@"name": @"CW", @"age": @"19" ,@"score": @"100"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        RACTupleUnpack(id key, id value) = x;
        
        NSLog(@"%@ : %@", key, value);
    }];
}

@end
