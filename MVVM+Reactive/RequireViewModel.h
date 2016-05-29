//
//  RequireViewModel.h
//  RACSingal
//
//  Created by ChenWei on 16/5/29.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AFNetworking.h"
#import "Book.h"


@interface RequireViewModel : NSObject
@property (strong, nonatomic) RACCommand *requestCommand;
@property (strong, nonatomic) Book *book;
@end
