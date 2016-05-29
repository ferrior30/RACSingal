//
//  LoginView.h
//  RACSingal
//
//  Created by ChenWei on 16/5/28.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginView : UIView
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

/** 信号 */
@property (strong, nonatomic) RACSignal *loginEnableSignal;
@property (strong, nonatomic) RACCommand *loginCommand;
@end
