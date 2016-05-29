//
//  RedView.h
//  RACSingal
//
//  Created by ChenWei on 16/5/26.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RedView : UIView
@property (strong, nonatomic) RACSubject *subject;
@end
