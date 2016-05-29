//
//  Book.h
//  ReactiveCocoa框架
//
//  Created by ChenWei on 16/5/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject
@property (strong, nonatomic) NSArray  *books;
@property (assign, nonatomic) NSUInteger count;
@property (assign, nonatomic) NSUInteger start;
@property (assign, nonatomic) NSUInteger total;
+ (instancetype)bookWithDict:(NSDictionary *)dict;
@end
