//
//  Flag.m
//  RACSingal
//
//  Created by ChenWei on 16/5/27.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "Flag.h"

@implementation Flag
+ (instancetype)flagWithDict:(NSDictionary *)dict {
    Flag *flag = [Flag new];
    
    [flag setValuesForKeysWithDictionary:dict];
    
    return flag;
}
@end
