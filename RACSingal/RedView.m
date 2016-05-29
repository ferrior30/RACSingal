//
//  RedView.m
//  RACSingal
//
//  Created by ChenWei on 16/5/26.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "RedView.h"

@implementation RedView
- (RACSubject *)subject {
    if (_subject == nil) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

- (IBAction)btnDidClick:(UIButton *)sender{
    [self.subject sendNext:@"按钮被点击了"];
}
@end
