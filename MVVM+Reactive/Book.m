//
//  Book.m
//  ReactiveCocoa框架
//
//  Created by ChenWei on 16/5/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "Book.h"

@implementation Book
+ (instancetype)bookWithDict:(NSDictionary *)dict {
    Book *book = [[self alloc] init];
    
    [book setValuesForKeysWithDictionary:dict];
    
    return book;
}
@end
